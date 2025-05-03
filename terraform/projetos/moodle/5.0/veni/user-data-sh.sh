#!/bin/bash
# Script para instalar e configurar o Moodle 5.0 em instâncias EC2

# Parâmetros passados pelo Terraform
DB_HOST="${db_host}"
DB_NAME="${db_name}"
DB_USER="${db_user}"
DB_PASSWORD="${db_password}"
REDIS_HOST="${redis_host}"
EFS_DNS="${efs_dns}"
S3_BUCKET="${s3_bucket}"
MOODLE_VERSION="${moodle_version}"
REGION="${region}"
ENVIRONMENT="${environment}"

# Atualizar o sistema
apt-get update
apt-get upgrade -y

# Instalar pacotes necessários
apt-get install -y apache2 php php-curl php-gd php-intl php-mbstring php-xml php-xmlrpc php-soap php-zip \
  php-mysql php-cli php-common php-json php-opcache php-readline php-ldap nfs-common awscli unzip git \
  php-redis php-imagick python3-certbot-apache

# Instalar módulo PHP para Redis
apt-get install -y php-redis

# Configurar timezone PHP
sed -i 's/;date.timezone =/date.timezone = America\/Sao_Paulo/' /etc/php/*/apache2/php.ini

# Configurar PHP para Moodle
cat > /etc/php/*/apache2/conf.d/99-moodle.ini << 'EOF'
max_input_vars = 5000
post_max_size = 128M
upload_max_filesize = 128M
max_execution_time = 300
memory_limit = 512M
opcache.enable = 1
opcache.memory_consumption = 128
opcache.max_accelerated_files = 10000
opcache.revalidate_freq = 60
EOF

# Reiniciar PHP para aplicar alterações
systemctl restart apache2

# Criar diretório para montagem do EFS
mkdir -p /mnt/efs/moodledata

# Montar o EFS
echo "${EFS_DNS}:/ /mnt/efs nfs4 nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,_netdev 0 0" >> /etc/fstab
mount -a

# Criar diretório para os dados do Moodle no EFS
mkdir -p /mnt/efs/moodledata
chown -R www-data:www-data /mnt/efs/moodledata
chmod -R 775 /mnt/efs/moodledata

# Baixar o Moodle
cd /var/www/html
rm -rf index.html
git clone -b MOODLE_500_STABLE https://github.com/moodle/moodle.git .

# Criar arquivo de configuração do Moodle
cat > config.php << EOF
<?php
unset(\$CFG);
global \$CFG;
\$CFG = new stdClass();

\$CFG->dbtype    = 'mysqli';
\$CFG->dblibrary = 'native';
\$CFG->dbhost    = '${DB_HOST}';
\$CFG->dbname    = '${DB_NAME}';
\$CFG->dbuser    = '${DB_USER}';
\$CFG->dbpass    = '${DB_PASSWORD}';
\$CFG->prefix    = 'mdl_';
\$CFG->dboptions = array(
    'dbpersist' => false,
    'dbsocket'  => false,
    'dbport'    => '',
    'dbhandlesoptions' => false,
);

\$CFG->wwwroot   = 'https://${domain_name}';
\$CFG->dataroot  = '/mnt/efs/moodledata';
\$CFG->directorypermissions = 02777;
\$CFG->admin     = 'admin';

// Redis cache store settings
\$CFG->session_handler_class = '\core\session\redis';
\$CFG->session_redis_host = '${REDIS_HOST}';
\$CFG->session_redis_port = 6379;
\$CFG->session_redis_auth = '';  // Password for Redis Auth se necessário
\$CFG->session_redis_prefix = 'moodle_session_';
\$CFG->session_redis_acquire_lock_timeout = 120;
\$CFG->session_redis_lock_expire = 7200;
\$CFG->session_redis_lock_retry = 100;

// Application cache settings
\$CFG->alternative_cache_factory_classes = array('cache_factory_redis');
\$CFG->cache_redis_servers = array(
    array(
        'host' => '${REDIS_HOST}',
        'port' => 6379,
        'password' => '',  // Senha se necessário
        'database' => 0,
        'prefix' => 'moodle_cache_',
    ),
);

// Configurações de performance
\$CFG->cachejs = true;
\$CFG->enablestats = false;
\$CFG->slasharguments = true;
\$CFG->themedesignermode = false;
\$CFG->perfdebug = 0;
\$CFG->debug = 0;
\$CFG->debugdisplay = 0;

// Necessário para instalação do Moodle
\$CFG->sslproxy = 1;

// Gerar chave de segurança aleatória para o Moodle
\$CFG->passwordsaltmain = '$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 40)';

// Timezone
date_default_timezone_set('America/Sao_Paulo');
\$CFG->forcetimezone = 'America/Sao_Paulo';

require_once(__DIR__ . '/lib/setup.php');
EOF

# Definir permissões corretas
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Configurar o Apache
cat > /etc/apache2/sites-available/moodle.conf << EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html
    
    <Directory /var/www/html>
        Options FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF

# Habilitar o site e módulos necessários
a2ensite moodle.conf
a2dissite 000-default.conf
a2enmod rewrite
a2enmod ssl

# Instalar Certbot e configurar HTTPS (opcional se já estiver usando HTTPS com ALB)
# certbot --apache -d ${domain_name} --non-interactive --agree-tos --email admin@example.com

# Reiniciar Apache
systemctl restart apache2

# Configurar cron job para o Moodle
echo "*/15 * * * * www-data /usr/bin/php /var/www/html/admin/cli/cron.php > /dev/null 2>&1" > /etc/cron.d/moodle

# Instalar o agente CloudWatch
wget https://s3.amazonaws.com/amazoncloudwatch-agent/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
dpkg -i amazon-cloudwatch-agent.deb
amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c ssm:AmazonCloudWatch-linux

# Configurar backup para o S3
cat > /etc/cron.daily/moodle-backup << EOF
#!/bin/bash
TIMESTAMP=\$(date +%Y%m%d%H%M%S)
BACKUP_DIR="/tmp/moodle-backup-\$TIMESTAMP"
MOODLE_DATA="/mnt/efs/moodledata"
MOODLE_CODE="/var/www/html"

# Criar diretório temporário
mkdir -p \$BACKUP_DIR

# Backup do código
tar -czf \$BACKUP_DIR/moodle-code.tar.gz -C \$MOODLE_CODE .

# Backup dos dados 
tar -czf \$BACKUP_DIR/moodle-data.tar.gz -C \$MOODLE_DATA .

# Enviar para S3
aws s3 cp \$BACKUP_DIR/moodle-code.tar.gz s3://${S3_BUCKET}/backups/code/moodle-code-\$TIMESTAMP.tar.gz
aws s3 cp \$BACKUP_DIR/moodle-data.tar.gz s3://${S3_BUCKET}/backups/data/moodle-data-\$TIMESTAMP.tar.gz

# Limpar
rm -rf \$BACKUP_DIR

# Manter apenas os últimos 7 backups diários
aws s3 ls s3://${S3_BUCKET}/backups/code/ | sort | head -n -7 | awk '{print \$4}' | xargs -I {} aws s3 rm s3://${S3_BUCKET}/backups/code/{}
aws s3 ls s3://${S3_BUCKET}/backups/data/ | sort | head -n -7 | awk '{print \$4}' | xargs -I {} aws s3 rm s3://${S3_BUCKET}/backups/data/{}
EOF

chmod +x /etc/cron.daily/moodle-backup

# Sinalizar que a instalação foi concluída
touch /var/www/html/installation_complete.txt

# Executar instalação do Moodle via CLI se for uma nova instância
if [ ! -f "/mnt/efs/moodledata/moodle_installation_complete.flag" ]; then
  # Executar instalação do Moodle
  cd /var/www/html
  php admin/cli/install.php --lang=pt_br --wwwroot=https://${domain_name} \
    --dataroot=/mnt/efs/moodledata --dbtype=mysqli --dbhost=${DB_HOST} \
    --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASSWORD} \
    --prefix=mdl_ --fullname="Moodle LMS" --shortname="Moodle" \
    --adminuser=admin --adminpass="Admin123!" --adminemail=admin@example.com \
    --non-interactive --agree-license
  
  # Criar flag para evitar reinstalação
  touch /mnt/efs/moodledata/moodle_installation_complete.flag
fi

# Notificar conclusão da instalação 
echo "Instalação do Moodle 5.0 concluída com sucesso!"

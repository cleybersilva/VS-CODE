const http = require('http');

http.createServer((req, res) => {
    res.end('<h1>Working</h1>');
}).listen(3000, () => console.log('server is running'));

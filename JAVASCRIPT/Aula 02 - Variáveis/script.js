// Variáveis "Tipos Primitivos"

// Boolean - Verdadeiro ou falso
var vOuF = False;
console.log(typeof(vOuf));

// Number - Números
var numeroQualquerer = 1;
console.log(typeof(numeroQualquerer));

// String - Caracter
var nome = 'Diana';
console.log(typeof(nome));

/* Como declarar a Variável
var variavel = 'Amanda';
variavel = 'Vanessa';
console.log(typeof(variavel)); */

/* let variavel2 = 'Priscila';
console.log(variavel2);

const variavel3 = 'Carla';
console.log(variavel3); */

var escopoGlobal = 'Global';
console.log(escopoGlobal);

function escopoGlobal() {
    let escopoLocalInterno = 'local';
    console.log(escopoLocalInterno);
}

escopoLocal();
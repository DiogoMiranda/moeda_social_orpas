# moeda_social_orpas
Codigo desenvolvido para o projeto da moeda social da ORPAS - SP

O sistema da moeda social utiliza o leitor de RFID para ler o número de  
série de cartões, envia como toques de teclado para um programa feito em
Processing (http://processing.org) que conversa com
o banco de dados onde ficam armazenadas as transações.

O Arduino usado deve ser baseado em ATMega32u4 ou ser capaz de emular 
teclado, como os modelos Leonardo, Pro Micro e Teensy.

O módulo leitor RFID é o RC522 e foi adquirido aqui: 
https://pandoralab.com.br/loja/modulo-rc522-rfid-com-cartao-e-chaveiro/

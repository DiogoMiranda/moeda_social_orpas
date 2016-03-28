
/*
   --------------------------------------------------------------------------------------------------------------------
    Programa Arduino para leitura de cartões RFID desenvolvido para a ORPAS
   --------------------------------------------------------------------------------------------------------------------

    Arduino IDE 1.68
    Biblioteca MFRC522 v 1.1.8
    Arduino Leonardo compatível

    2016/03/21
    Mauricio Jabur
    mau -AT- maumaker.com.br
    github.com/maujabur/moeda_social_orpas

    This work is licensed under a Creative Commons Attribution-ShareAlike 4.0 International License.

   Pinos Usados
   -----------------------------------------------------------------------------------------
               MFRC522      Arduino
               Reader/PCD   Leonardo/Micro
   Sinal      Pino         Pino
   -----------------------------------------------------------------------------------------
   RST/Reset   RST          RESET/ICSP-5
   SPI SS      SDA(SS)      10
   SPI MOSI    MOSI         ICSP-4
   SPI MISO    MISO         ICSP-1
   SPI SCK     SCK          ICSP-3
*/


#include <SPI.h>
#include <MFRC522.h>
#include "Keyboard.h"

#define SS_PIN 10
#define RST_PIN 9

MFRC522 rfid(SS_PIN, RST_PIN); // Para acessar o leitor de cartão

#define LED 13 // led do placa arduino

// variaveis usadas para evitar que o cartão seja digitado repetidamente
long ultima_vez;
long prazo = 500;


void setup() {

  pinMode(LED, OUTPUT);

  Keyboard.begin();

  SPI.begin(); // inicializa a comunicação com o cartão
  rfid.PCD_Init(); // inicializa o leitor de cartão

  digitalWrite(LED, HIGH); // acende o led da placa, tudo OK

  // está na hora de ler um novo cartão
  ultima_vez = millis() - prazo;
}


void loop() {

  // procura novos cartões
  if ( ! rfid.PICC_IsNewCardPresent()) {
    return;
  }

  // se o número de série não for lido, recomeça o processo
  if ( ! rfid.PICC_ReadCardSerial()) {
    return;
  }

  // está na hora de ler o cartão novamente?
  if (millis() - ultima_vez < prazo) {
    ultima_vez = millis();
    return;
  }

  ultima_vez = millis();

  // digita o numero de serie do cartão como um teclado USB
  String texto = "";
  for (byte i = 0; i < rfid.uid.size; i++) {
    String digito = String(rfid.uid.uidByte[i], HEX);
    // acrescenta 0 antes se necessário
    if (rfid.uid.uidByte[i] < 16) digito = String("0" + digito);
    texto = String (digito + texto);
  }
  Keyboard.print(texto);
}

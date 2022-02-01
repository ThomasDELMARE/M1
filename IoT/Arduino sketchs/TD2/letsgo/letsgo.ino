#define TRUE 1
#define FALSE 0
#include "OneWire.h"
#include "DallasTemperature.h"
#include "ArduinoJson.h"

OneWire oneWire(23);
DallasTemperature tempSensor(&oneWire);
char receivedChar;
String receivedStr;
int sensorValue;
int jour = FALSE;
float val = 0.0;
// Clim
const int ledPinGreen = 19;
int greenValue = 0;
// Chauffage
const int ledPinRed = 21;
int redValue = 0;
DynamicJsonDocument doc(1024);

void setup() {
  Serial.begin(9600);
  tempSensor.begin();
  pinMode(ledPinGreen, OUTPUT);
  pinMode(ledPinRed, OUTPUT);
}

void loop() {
  float t;
  int sensorValue;
  int jour;
  greenValue = 0;
  redValue = 0;
  jour = 0;
  
  // L ESP écrit sur le lien serial
  sensorValue = analogRead(A5);
  tempSensor.requestTemperaturesByIndex(0);
  t=tempSensor.getTempCByIndex(0);

  // On reinitialise les ampoules
  digitalWrite(ledPinGreen, LOW);
  digitalWrite(ledPinRed, LOW);

  // Determiner jour ou nuit
  // Cas où c'est le jour
  if(sensorValue > 2298){
    jour = 1;  

    if(t<23){
      redValue = 1; 
      digitalWrite(ledPinRed, HIGH);
    }
    else{
      greenValue = 1;
      digitalWrite(ledPinGreen, HIGH);
    }
  }

  // Cas où c'est la nuit
  else{
    if(t<18){
      redValue = 1;
      digitalWrite(ledPinRed, HIGH);
    }
    else{
      greenValue = 1;
      digitalWrite(ledPinGreen, HIGH);
    }
  }


  doc["temperature"] = t;
  doc["luminosite"] = sensorValue;
  doc["greenLed"] = greenValue;
  doc["redLed"] = redValue;

  serializeJson(doc, Serial);


  
  delay(1000);
}

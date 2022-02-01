#include "OneWire.h"
#include "DallasTemperature.h"

OneWire oneWire(23);
DallasTemperature tempSensor(&oneWire);
// Clim
const int ledPinGreen = 19;
// Chauffage
const int ledPinRed = 21;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  tempSensor.begin();
  pinMode(ledPinGreen, OUTPUT);
  pinMode(ledPinRed, OUTPUT);
}

void loop() {
  float t;
  int sensorValue;
  int jour;
  jour = 0;
    
  sensorValue = analogRead(A5);  
  tempSensor.requestTemperaturesByIndex(0);
  t=tempSensor.getTempCByIndex(0);
  
  // Determiner jour ou nuit
  // Cas où c'est le jour
  if(sensorValue > 2298){
    jour = 1;  

    if(t<23){
      digitalWrite(ledPinRed, HIGH);
      delay(1000);
      digitalWrite(ledPinRed, LOW);
      delay(1000);
    }
    else{
      digitalWrite(ledPinGreen, HIGH);
      delay(1000);
      digitalWrite(ledPinGreen, LOW);
      delay(1000);
    }
  }

  // Cas où c'est la nuit
  else{
    if(t<18){
      digitalWrite(ledPinRed, HIGH);
      delay(1000);
      digitalWrite(ledPinRed, LOW);
      delay(1000);
    }
    else{
      digitalWrite(ledPinGreen, HIGH);
      delay(1000);
      digitalWrite(ledPinGreen, LOW);
      delay(1000);
    }
  }

  Serial.print("Temperature : ");
  Serial.print(t);
  Serial.print(" C\n");
  Serial.println(sensorValue, DEC);

  delay(1000);
}

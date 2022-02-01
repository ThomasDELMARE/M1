#include "OneWire.h"
#include "DallasTemperature.h"
#include "ArduinoJson.h"

OneWire oneWire(23);
DallasTemperature tempSensor(&oneWire);
DynamicJsonDocument doc(1024);

const int ledGreen = 19;
const int ledRed = 5;

const int lightCheck = 150;

const int SHJ = 22;
const int SBJ = 21;

const int SHN = 22;
const int SBN = 21;

bool redOn = 0;
bool greenOn = 0;




void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  tempSensor.begin();
  pinMode(ledGreen, OUTPUT);
  pinMode(ledRed, OUTPUT);
}

void loop() {
  // put your main code here, to run repeatedly:
  float t;
  tempSensor.requestTemperaturesByIndex(0);
  t = tempSensor.getTempCByIndex(0);

  int sensorValue;

  sensorValue = analogRead(A5);
 /* Serial.println(sensorValue, DEC);
  Serial.print(t);
  Serial.print("\n");*/
  
  if(sensorValue > lightCheck){ //jour
    if(t < SBJ){
      digitalWrite(ledRed, HIGH);
      redOn = 1;
    } 
    else if(t > SHJ){
      digitalWrite(ledGreen, HIGH);
      greenOn = 1;
    }
    else {
      digitalWrite(ledRed, LOW);
      digitalWrite(ledGreen, LOW);
      redOn = 0;
      greenOn = 0;
    }
  }

    if(sensorValue < lightCheck){ //nuit
    if(t < SBN){
      digitalWrite(ledRed, HIGH);
      redOn = 1;
    } 
    else if(t > SHN){
      digitalWrite(ledGreen, HIGH);
      greenOn = 1;
    }
    else {
      digitalWrite(ledRed, LOW);
      digitalWrite(ledGreen, LOW);
      redOn = 0;
      greenOn = 0;
    }
  }
/*
  Serial.print("JSON \n");
  Serial.print("{\n \t \"temperature\": \"");
  Serial.print(t);
  Serial.print("\n \t \"light\": \"");
  Serial.print(sensorValue, DEC);
  Serial.print("\n \t \"red\": \"");
  Serial.print(redOn);
  Serial.print("\n \t \"green\": \"");
  Serial.print(greenOn);
  Serial.print("\n}\n");
*/

  doc["temperature"] = t;
  doc["light"]       = sensorValue;
  doc["redOn"]       = redOn;
  doc["greenOn"]     = greenOn;

  serializeJson(doc, Serial);
  delay(2000);
}

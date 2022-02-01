void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
}

void loop() {
  // put your main code here, to run repeatedly:
  int sensorValue;
  sensorValue = analogRead(A5);

  Serial.println(sensorValue, DEC);

  delay(1000);
}

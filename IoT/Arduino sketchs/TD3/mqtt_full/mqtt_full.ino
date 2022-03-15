/*********
 Based on Rui Santos work :
 https://randomnerdtutorials.com/esp32-mqtt-publish-subscribe-arduino-ide/
 Modified by GM
*********/
#include <WiFi.h>
#include <PubSubClient.h>
#include <Wire.h>
#include "classic_setup.h"
#include "OneWire.h"
#include "DallasTemperature.h"

/*===== MQTT broker/server ========*/
//const char* mqtt_server = "127.0.0.1"; 
//const char* mqtt_server = "public.cloud.shiftr.io"; // Failed in 2021
// need login and passwd (public,public) mqtt://public:public@public.cloud.shiftr.io
const char* mqtt_server = "broker.hivemq.com"; // anynomous Ok in 2021 
//const char* mqtt_server = "test.mosquitto.org"; // anynomous Ok in 2021
//const char* mqtt_server = "mqtt.eclipseprojects.io"; // anynomous Ok in 2021

/*===== MQTT TOPICS ===============*/
#define TOPIC_TEMP "my/sensors/temp"
#define TOPIC_LED  "my/sensors/led"

/*===== ESP is MQTT Client =======*/
WiFiClient espClient;           // Wifi 
PubSubClient client(espClient); // MQTT client

/*============= GPIO ==============*/
const int ledPin = 19; // LED Pin

/* ---- TEMP ---- */
OneWire oneWire(23); // Pour utiliser une entite oneWire sur le port 23
DallasTemperature tempSensor(&oneWire) ; // Cette entite est utilisee par le capteur de temperature

float temperature = 0;
float light = 0;

/*===== Arduino IDE paradigm : setup+loop =====*/
void setup() {
  Serial.begin(9600);
  while (!Serial); // wait for a serial connection. Needed for native USB port only
   
  connect_wifi(); // Connexion Wifi  
  print_network_status();
  
  // Initialize the output variables as outputs
  pinMode(ledPin, OUTPUT);
  digitalWrite(ledPin, LOW);// Set outputs to LOW
  
  // Init temperature sensor 
  tempSensor.begin();

  // set server of our client
  client.setServer(mqtt_server, 1883);
  // set callback when publishes arrive for the subscribed topic
  client.setCallback(mqtt_pubcallback); 
}

/*============= TO COMPLETE ===================*/
void set_LED(int v){
  
}

float get_Temperature(){
  return 22.5;
}

/*============== CALLBACK ===================*/
void mqtt_pubcallback(char* topic, 
                      byte* message, 
                      unsigned int length) {
  /* 
   * Callback if a message is published on this topic.
   */
  Serial.print("Message arrived on topic : ");
  Serial.println(topic);
  Serial.print("=> ");

  // Byte list to String and print to Serial
  String messageTemp;
  for (int i = 0; i < length; i++) {
    Serial.print((char)message[i]);
    messageTemp += (char)message[i];
  }
  Serial.println();

  // Feel free to add more if statements to control more GPIOs with MQTT

  // If a message is received on the topic,
  // you check if the message is either "on" or "off".
  // Changes the output state according to the message
  if (String(topic) == TOPIC_LED) {
    Serial.print("so ... changing output to ");
    if (messageTemp == "on") {
      Serial.println("on");
      set_LED(HIGH);
    }
    else if (messageTemp == "off") {
      Serial.println("off");
      set_LED(LOW);
    }
  }
}

/*============= SUBSCRIBE =====================*/
void mqtt_mysubscribe(char *topic) {
  /*
   * Subscribe to a MQTT topic 
   */
  while (!client.connected()) { // Loop until we're reconnected

    Serial.print("Attempting MQTT connection...");
    // Attempt to connect => https://pubsubclient.knolleary.net/api
    if (client.connect("esp32", /* Client Id when connecting to the server */
		                    NULL,    /* No credential */ 
		                    NULL)) {
      Serial.println("connected");
      // then Subscribe topic
      client.subscribe(topic);
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      
      Serial.println(" try again in 5 seconds");
      delay(5000); // Wait 5 seconds before retrying
    }
  }
}

/*================= LOOP ======================*/
void loop() {
  int32_t period = 5000; // 5 sec
  
  /*--- subscribe to TOPIC_LED if not yet ! */
  if (!client.connected()) { 
    mqtt_mysubscribe((char *)(TOPIC_LED));
  }

  /*--- Publish Temperature periodically   */
  delay(period);
  temperature = get_Temperature();
  // Convert the value to a char array
  char tempString[8];
  dtostrf(temperature, 1, 2, tempString);
  // Serial info
  Serial.print("Published Temperature : "); Serial.println(tempString);
  // MQTT Publish
  client.publish(TOPIC_TEMP, tempString);


  /* Process MQTT ... une fois par loop() ! */
  client.loop(); 
}

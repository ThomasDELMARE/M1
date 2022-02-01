#include <WiFi.h>
#include "classic_setup.h"

/* 
 * This sketch sends data via HTTP GET requests to host/url 
 * and returns the website in html format which is printed on the
 *  console 
 */
 
/*---- Arduino IDE paradigm : setup+loop -----*/
void setup(){
  Serial.begin(9600);
  while (!Serial); // wait for a serial connection
  connect_wifi();//connect wifi 
  print_network_status();
}

void loop() {
  WiFiClient client;
  // IPAddress server(216,58,205,195);  // Google.com IP
  
  //char host[100] = "http://worldtimeapi.org"; 
  char host[100] = "httpbin.org";
  const int httpPort = 80;
 
  Serial.print("connecting to ");
  Serial.println(host); // Use WiFiClient class to create TCP connections
  if (client.connect(host, httpPort) != 1) {
    Serial.println("connection failed");
    return;
  }
  else{
    Serial.println("connection succeeded");
  }
  // BOF BOF ... meme avec un reseau out ...
  // la demande de connexion avec l'host rend 1 => Bizarre !!

  // Now create a URI for the GET/HTTP request : 
  // this url contains the information we want to send 
  // to the server => GET style !!
  //String url = "/api/timezone/Europe/Paris"; 
  String url = "/ip";
  
  // Now create HTTP request header
  String req = String("GET ");
  req +=  url + " HTTP/1.1\r\n";
  req += "Host: " + String(host) + "\r\n";
  req += "User-Agent: esp-idf/1.0 esp32 \r\n";
  req += "Accept: */* \r\n";
  req += "Connection: close \r\n";
  req += "\r\n";  // empty line : separator header/body        
  
  Serial.println("Request Header : ");
  Serial.println(req);
  
  // Send request to host throught client socket
  Serial.println("Send request to URL : ");
  Serial.println(url); 
  client.print(req);  // Send !

  // https://www.arduino.cc/en/Reference/WiFiClientAvailable  
  unsigned long timeout = millis();
  while (client.available() == 0) { // no answer => timeout mechanism !
    if (millis() - timeout > 10000) {
      Serial.println(">>> Client Timeout !");
      client.stop();
      return;
    }
  }

  //Wait for server response
  //while (client.available() == 0);

  // Read response 
  Serial.println("Response : ");
  // all the lines of the reply from server and print them to Serial
  while (client.available()) { // Returns the number of bytes available for reading
    String line = client.readStringUntil('\r'); 
    Serial.print(line); // echo to console

    // en version car/car
    //char c = client.read(); 
    //Serial.print(c);    
  }
  
  Serial.println();
  Serial.println("closing connection");

  delay(10000); //ms
}

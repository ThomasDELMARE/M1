#include <WiFi.h>
#include "classic_setup.h"
#include <HTTPClient.h>

// the following variables are unsigned longs because the time , measured in
// milliseconds, will quickly become a bigger number than can be stored in an int. 
unsigned long lastTime = 0;
// Set timer
unsigned long loop_period = 10L*1000;

char host[100] = "http://httpbin.org"; // = "http://worldtimeapi.org/";
const int httpPort = 80;
String path = "/get";
String params = "?led1=""OFF""&led2=""ON""";

String httpGETRequest( const char* UrlServer ) {
    // return the response of the GET request to UrlServer
    HTTPClient http; // http protocol entity => client

    Serial.print("Requesting␣URL␣:␣");
    Serial.println(UrlServer);
    // Your IP address with path or Domain name with URL path
    http.begin(UrlServer);// Parse URL of the server 
    
    // Send HTTP request
    int httpResponseCode = http.GET() ;
    
    // Get the response => will f i l l payload String
    String payload = "{}" ;
    if(httpResponseCode>0) {
        Serial.print("HTTP␣Response␣code:␣");
        Serial.println(httpResponseCode);
        payload = http.getString();
    }
    else{
        Serial.print("Error␣code␣on␣HTTP␣GET␣Request␣:");
        Serial.println(httpResponseCode); 
    }

    // End connection and Free resources
    http.end();
    return payload;
}

void setup(){
    Serial.begin(9600);

    while(!Serial); // wait for a serial connection
    connect_wifi();//connect wifi
    print_network_status();
}

void loop() {
    String url = String(host) + path+params ;

    if ( (millis() - lastTime) > loop_period ){
        //Check WiFi connection status
        if (WiFi.status() == WL_CONNECTED){
            String ret = httpGETRequest(url.c_str());
            Serial.println(ret); 
        }
        else {
            Serial.println("WiFi␣Disconnected"); 
        }
        lastTime = millis();
    }
}

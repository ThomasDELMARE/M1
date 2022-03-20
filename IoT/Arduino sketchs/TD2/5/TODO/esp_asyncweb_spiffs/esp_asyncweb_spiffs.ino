  /* 
 * Auteur : G.Menez
 * Fichier : esp_asyncweb_spiffs.ino 
 * Many sources :
 => https://raw.githubusercontent.com/RuiSantosdotme/ESP32-Course/master/code/WiFi_Web_Server_DHT/WiFi_Web_Server_DHT.ino
 => https://randomnerdtutorials.com/esp32-dht11-dht22-temperature-humidity-web-server-arduino-ide/
 => Kevin Levy 
*/
/*====== Import required libraries ===========*/
#include <ArduinoOTA.h>
#include <HTTPClient.h>
#include "ArduinoJson.h"
#include <WiFi.h>
#include "ESPAsyncWebServer.h"
#include "classic_setup.h"
#include "sensors.h"
#include "OneWire.h"
#include "DallasTemperature.h"
#include "SPIFFS.h"
//#include <SimpleTimer.h>
#include "uptime.h" 

void setup_OTA(); // from ota.ino

/*===== ESP GPIO configuration ==============*/
/* ---- LED         ----*/
const int LEDpin = 19; // LED will use GPIO pin 19
/* ---- Light       ----*/
const int LightPin = A5; // Read analog input on ADC1_CHANNEL_5 (GPIO 33)
/* ---- Temperature ----*/
OneWire oneWire(23); // Pour utiliser une entite oneWire sur le port 23
DallasTemperature TempSensor(&oneWire) ; // Cette entite est utilisee par le capteur de temperature

//SimpleTimer timer;
int timerDelay = 2000;
int currentTimerValue=0;
int lastTime = 0;

/*====== ESP Statut =========================*/
// Ces variables permettent d'avoir une representation
// interne au programme du statut "electrique" de l'objet.
// Car on ne peut pas "interroger" une GPIO pour lui demander !
String LEDState = "off";
int light_threshold; 
int sbn  = 18;
int shn  = 19;
int sbj  = 23;
int shj  = 24;
DynamicJsonDocument dataToSend(1024);

/*====== Process configuration ==============*/
// Set timer 
unsigned long loop_period = 10L * 1000; /* =>  10000ms : 10 s */

// Create AsyncWebServer object on port 80
AsyncWebServer server(80);

// Thresholds
short int Light_threshold = 250; // Less => night, more => day

// Host for periodic data report
String target_ip = "192.168.166.158"; // Pour essayer sans avoir a remplir le formulaire
int target_port = 1880;
int target_sp = 2; // Remaining time before the ESP stops transmitting

/*====== Some functions =====================*/

String processor(const String& var){
  /* Replaces "placeholder" in  html file with sensors values */
  /* accessors functions get_... are in sensors.ino file   */
  //Serial.println(var);
  if(var == "TEMPERATURE"){
    return get_temperature(TempSensor);
  }
  else if(var == "LIGHT"){
    return get_light(LightPin);
  }
  else if(var == "LT"){
    return String(light_threshold);
  }
  else if(var == "UPTIME"){
    uptime::calculateUptime();
    return String(uptime::getSeconds());
  }
  else if(var == "WHERE"){
    return "43.599690; 7.091460";
  }
  else if(var == "SSID"){
    return return_wifi_status()["ssid"];
  }
  else if(var == "MAC"){
    return return_wifi_status()["mac"];
  }
  else if(var == "IP"){
    return return_wifi_status()["ip"];
  }
  else if(var == "COOLER"){
    if(getCooler() == 1){
      return "HIGH";
    }
    else{
      return "LOW";
    }
  }
  else if(var == "HEATER"){
    if(getHeater() == 1){
      return "HIGH";
    }
    else{
      return "LOW";
    }  
  }
  else if(var== "SBJ"){
    return String(sbj);
  }
  else if(var== "SHJ"){
    return String(shj);
  }
  else if(var== "SBN"){
    return String(sbn);
  }
  else if(var== "SHN"){
    return String(shn);
  }
            
  return String();
}

void setup_http_server() {
  /* Sets up AsyncWebServer and routes */
  
  // Declaring root handler, and action to be taken when root is requested
  // Sert à initialiser la page
    auto root_handler = server.on("/", HTTP_GET, [](AsyncWebServerRequest *request){
          /* This handler will download statut.html (SPIFFS file) and will send it back */
          request->send(SPIFFS, "/statut.html", String(), false, processor); 
          // cf "Respond with content coming from a File containing templates" section in manual !
          // https://github.com/me-no-dev/ESPAsyncWebServer
          // request->send_P(200, "text/html", page_html, processor); // if page_html was a string .
    });
      
    server.on("/temperature", HTTP_GET, [](AsyncWebServerRequest *request){
      /* The most simple route => hope a response with temperature value */ 
      char tmp[20];
      int last_temp = atoi(get_temperature(TempSensor).c_str());
      dtostrf(last_temp,10,2, tmp); //https://arduino.stackexchange.com/questions/16933/read-sensor-and-convert-reading-to-const-char
      request->send_P(200, "text/plain", tmp); //Surtout pas => get_temperature(tempSensor).c_str());
    }); 

    server.on("/value", HTTP_GET, [](AsyncWebServerRequest *request){
      /* The most simple route => hope a response with temperature value */ 
       DynamicJsonDocument paramsJson(1024);
       
       int params = request->params();
       Serial.println(params);
        
      if(params>0){
       for(int i=0;i<params;i++){
        AsyncWebParameter* param = request->getParam(i);
        String paramName = param->name().c_str();
        
        // Temperature
        if(paramName=="temperature"){
          paramsJson["temperature"] = get_temperature(TempSensor);
        }
        
        // Light
        if(paramName=="light"){
          paramsJson["light"] = get_light(LightPin);
        }
        
        // Cooler (led ou fan)
        if(paramName=="cooler"){
          if(getCooler() == 1){
            paramsJson["cooler"] = "HIGH";
          }
          else{
            paramsJson["cooler"] = "LOW";
          }
        } 
        
        // Heater (led ou radiateur)
        if(paramName=="heater"){
          if(getHeater() == 1){
            paramsJson["heater"] = "HIGH";
          }
          else{
            paramsJson["heater"] = "LOW";
          } 
        }
        
        // Ip
        if(paramName=="ip"){
          // TODO : Right ? 
          paramsJson["ip"] = return_wifi_status()["ip"];
        }
        
        // Port
        if(paramName=="port"){
          paramsJson["port"] = dataToSend["port"]; 
        }
        
        // Sp
        if(paramName=="sp"){
          paramsJson["sp"] = dataToSend["sp"]; 
        }
        
        // Light_threshold (seuil jour/nuit)
        if(paramName=="lighthresold"){
          paramsJson["lighthresold"] = String(light_threshold);
        }
        
        // Sbn (seuil bas nuit)
        if(paramName=="sbn"){
          paramsJson["sbn"] = String(sbn); 
        }
        
        // Shn (seuil haut nuit)
        if(paramName=="shn"){
          paramsJson["shn"] = String(shn);  
        }
        
        // Sbj (seuil bas jour)
        if(paramName=="sbj"){
          paramsJson["sbj"] = String(sbj);  
        }
        
        // Shj (seuil haut jour)
        if(paramName=="shj"){
          paramsJson["shj"] = String(shj); 
        }
        
        // Uptime
        if(paramName=="uptime"){
          uptime::calculateUptime();
          paramsJson["uptime"] = String(uptime::getSeconds());
        }
        
        // SSID
        if(paramName=="ssid"){
          paramsJson["ssid"] = return_wifi_status()["ssid"];
        }
        
        // Mac
        if(paramName=="mac"){
          paramsJson["mac"] = return_wifi_status()["mac"];
        }
        
        // Ip_esp
        if(paramName=="ipesp"){
          paramsJson["ipesp"] = return_wifi_status()["ip"];
        }
        
        // Where
        if(paramName=="where"){
          paramsJson["where"] = "43.599690; 7.091460";
        }
       }

       String payload;
       serializeJson(paramsJson, payload);
       Serial.println(payload);

       // Send the final request with the JSON
       request->send(200, "application/json", payload);
       }

       else{
        server.onNotFound([](AsyncWebServerRequest *request){
                   request->send(404);
                   });
       }
    }); 
  
    server.on("/light", HTTP_GET, [](AsyncWebServerRequest *request){
      /* The most simple route => hope a response with light value */ 
      request->send_P(200, "text/plain", get_light(LightPin).c_str());
    });
    
  // This route allows users to change thresholds values through GET params
  server.on("/set", HTTP_GET, [](AsyncWebServerRequest *request){
    /* A route with a side effect : this get request has a param and should     
     *  set a new light_threshold ... used for regulation !
     */
        if (request->hasArg("light_threshold")) {
            Light_threshold = atoi(request->arg("light_threshold").c_str());
            request->send_P(200, "text/plain", "Threshold Set !");
        }
  });

  server.on("/target", HTTP_POST, [](AsyncWebServerRequest *request){
    /* A route receiving a POST request with Internet coordinates 
     *  of the reporting target host.
     */
     Serial.println("Receive Request for a ""target"" route !"); 
      
        if (request->hasArg("ip") &&
        request->hasArg("port") &&
        request->arg("port")!=""&&
        request->arg("port")!= NULL &&
        request->hasArg("sp")&&
        request->arg("sp")!=""&&
        request->arg("sp")!=NULL&&
        request->arg("ip")!=""&&
        request->arg("ip")!=NULL
        ) {
            target_ip = request->arg("ip");
            target_port = atoi(request->arg("port").c_str());
            target_sp = atoi(request->arg("sp").c_str());
            timerDelay = atoi(request->arg("sp").c_str());
        }
        request->send(SPIFFS, "/statut.html", String(), false, processor);
    });
    
  // If request doesn't match any route, returns 404.
  server.onNotFound([](AsyncWebServerRequest *request){
                   request->send(404);
  });

  // Start server
  server.begin();
}

// DASHBOARD
void startEspPost(DynamicJsonDocument dataToSend){
  /*
  String adresseMac = return_wifi_status()["mac"];
  String finalAdress = "/esp?mac=" + adresseMac;
  Serial.println(finalAdress);
  String payload;
  serializeJson(dataToSend, payload);
  Serial.println(payload);  

  server.on("/esp", HTTP_POST, [payload](AsyncWebServerRequest *request){
      request->send(200, "applicaton/json", payload);
   });
   */
   HTTPClient http;
   WiFiClient client;
   
   String server;
   server = "http://" + target_ip + ":" + target_port + "/jauge ";
   Serial.println(server);
   http.begin(client, server);
   http.addHeader("Content-Type", "application/json");
   int httpResponseCode = http.POST("{\"temperature\":\"" + get_temperature(TempSensor)+"\"}");
   Serial.println(httpResponseCode);
   http.end();
}

/*---- Arduino IDE paradigm : setup+loop -----*/
void setup(){
  Serial.begin(9600);
  while (!Serial); // wait for a serial connection. Needed for native USB port only

  // Connexion Wifi   
  connect_wifi(); 
  print_network_status();

  // OTA
  setup_OTA();
    
  // Initialize the LED 
  setup_led(LEDpin, OUTPUT, LOW);
  
  // Init temperature sensor 
  TempSensor.begin();

  // Initialize SPIFFS
  SPIFFS.begin(true);

  setup_http_server();
}
 
void loop(){  
  int tempValue;
  light_threshold = 2298;
  
  ArduinoOTA.handle();
  
  tempValue = atoi(get_temperature(TempSensor).c_str());

  if (target_sp != 0 && (millis() - lastTime) > timerDelay) {
    startEspPost(dataToSend);
 
  lastTime = millis();
 }
  
  // Serial.println(tempValue);

  delay(1000);
}

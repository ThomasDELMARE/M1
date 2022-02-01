#include <SPI.h>
#include <WiFi.h>
/*#include <WiFiMulti.h>*/

/*WiFiMulti wifiMulti; // Creates an instance of the WiFiMulti class*/
#define SaveDisconnectTime 1000

const char ssid[]="YAPASDEWIFI";
const char password[]="Fromage2Chevre";
/*------------------------*/
String translateEncryptionType(byte encryptionType) {
   // cf https://www.arduino.cc/en/Reference/WiFiEncryptionType 
  switch (encryptionType) {
    case (WIFI_AUTH_OPEN):
      return "Open";
    case (WIFI_AUTH_WEP):
      return "WEP";
    case (WIFI_AUTH_WPA_PSK):
      return "WPA_PSK";
    case (WIFI_AUTH_WPA2_PSK):
      return "WPA2_PSK";
    case (WIFI_AUTH_WPA_WPA2_PSK):
      return "WPA_WPA2_PSK";
    case (WIFI_AUTH_WPA2_ENTERPRISE):
      return "WPA2_ENTERPRISE";
  }
}

/*------------------------*/
void print_network_status_light(){ // Utilisation de String !
  char s [256];
  sprintf(s,  "\tIP address :%s\n ", WiFi.localIP().toString().c_str());Serial.print(s); 
  sprintf(s,  "\tMAC address :%s\n ", WiFi.macAddress().c_str());Serial.print(s); 
  sprintf(s,  "\tWifi SSID : %s\n ",WiFi.SSID());Serial.print(s); 
  sprintf(s,  "\tWifi Signal Strength : %s\n ",WiFi.RSSI());Serial.print(s); 
  sprintf(s,  "\tWifi BSSID :  %s\n ",WiFi.BSSIDstr().c_str());Serial.print(s); 
  sprintf(s,   "\tWifi Encryption type : %s\n ",translateEncryptionType(WiFi.encryptionType(0)));Serial.print(s); 
  
  // a mon avis bug ! => manque WiFi.encryptionType() !
  Serial.print(s);
}
/*------------------------*/
void print_network_status(){ // Utilisation de String !
  String s = "";
  s += "\tIP address : " + WiFi.localIP().toString() + "\n"; // bizarre IPAddress
  s += "\tMAC address : " + String(WiFi.macAddress()) + "\n";
  s += "\tWifi SSID : " + String(WiFi.SSID()) + "\n";
  s += "\tWifi Signal Strength : " + String(WiFi.RSSI()) + "\n";
  s += "\tWifi BSSID : " + String(WiFi.BSSIDstr()) + "\n";
  s += "\tWifi Encryption type : " + translateEncryptionType(WiFi.encryptionType(0))+ "\n";
  // a mon avis bug ! => manque WiFi.encryptionType() !
  Serial.print(s);
}
/*------------------------*/
void connect_wifi(){
  #define WiFiMaxTry 10
  int i;
  String hostname = "Mon petit objet ESP32";
  WiFi.mode(WIFI_OFF);
  WiFi.mode(WIFI_STA);
  WiFi.disconnect(true);
  delay(100);
  WiFi.setHostname(hostname.c_str());
  Serial.println(String("\n Attempting to connect AP of SSID : ")+ssid);
  WiFi.begin(ssid, password);
  i=0;
  while(WiFi.status() != WL_CONNECTED && (i< WiFiMaxTry)){
    delay(SaveDisconnectTime);
    Serial.print(".");
    i++;
  }

 /*//  Set WiFi to station mode 
 WiFi.mode(WIFI_STA);
 // and disconnect from an AP if
 // it was previously connected
 WiFi.disconnect();
 delay(100); // ms

 Serial.println(String("\nAttempting to connect to SSIDs : "));
 wifiMulti.addAP("HUAWEI-6EC2", "FGY9MLBL");
 wifiMulti.addAP("HUAWEI-553A", "QTM06RTT");
 wifiMulti.addAP("GMAP", "vijx4705");
 while(wifiMulti.run() != WL_CONNECTED) {
   delay(1000);
   Serial.print(".");
 }

 if(wifiMulti.run() == WL_CONNECTED) {
   Serial.print("\nWiFi connected : \n");
  }*/
}
void setup(){
  Serial.begin(9600);
  while(!Serial);
  connect_wifi();

  if(WiFi.status()==WL_CONNECTED){
    Serial.print("\n WiFi connected : \n");
    print_network_status();
  }
}

void loop(){
  
}

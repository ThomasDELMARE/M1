#include <WiFi.h>
#include <WiFiMulti.h>
#include <ArduinoJson.h>

WiFiMulti wifiMulti; // Creates an instance of the WiFiMulti class

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

DynamicJsonDocument return_wifi_status(){
  DynamicJsonDocument doc(1024);

  doc["ssid"] = String(WiFi.SSID());
  doc["mac"] = WiFi.macAddress();
  doc["ip"] = WiFi.localIP().toString();

  return doc;
}

/*------------------------*/
void connect_wifi(){
 //  Set WiFi to station mode 
 WiFi.mode(WIFI_STA);
 // and disconnect from an AP if
 // it was previously connected
 WiFi.disconnect();
 delay(100); // ms

 // Serial.println(String("\nAttempting to connect to SSIDs : "));
 wifiMulti.addAP("YAPADEWIFI", "Fromage2Chevre");
 wifiMulti.addAP("OnePlus de Thomas", "Fromage2Chevre");
 while(wifiMulti.run() != WL_CONNECTED) {
   delay(1000);
   Serial.print(".");
 }

 if(wifiMulti.run() == WL_CONNECTED) {
   Serial.print("\nWiFi connected : \n");
  }
}

#include <WiFi.h>


String translateEncryptionType(wifi_auth_mode_t encryptionType) {
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

void print_network_status(int i){ // Utilisation de String !
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
void setup(){
  Serial.begin(8600);

  int N = WiFi.scanNetworks();

  if(N>0) {
    Serial.print("\n ---------- \n");
    Serial.print("Networks found :");
    Serial.print(N);
    Serial.print("\n");

    for(int i=0 ; i < N; i++){
      char s[100];
      sprintf(s, "SSID :", i);
      Serial.print(s);
      print_network_status(i);
      delay(1000);
    }

    #define GoodWiFiRSSI -90
    int thegoodone = -1;
    
    /*
    for(int i=0; i < N; i++){
      if((String(WiFi.SSSID(i)) = "HUAWEI-553A") && (WiFi.RSSI(i) > GoodWiFiRSSI)){
        thegoodone= i;
        break;
      }
    }
    */

    if(thegoodone != -1){
      Serial.print("The good one could be");
      Serial.print(thegoodone);
      WiFi.mode(WIFI_STA);
      WiFi.disconnect(true);

      String ssid = WiFi.SSID(thegoodone);
      String password = String("Fromage2Chevre");
      WiFi.begin(ssid.c_str(), password.c_str(), 0, WiFi.BSSID(thegoodone));

      while(WiFi.status() != WL_CONNECTED){
        delay(500);
        Serial.print(".");
      }
    }

    if(WiFi.status() == WL_CONNECTED){
      Serial.print("WiFi connected :");
      print_network_status(thegoodone);
    }
    
  }
}

void loop(){
  // no code
}

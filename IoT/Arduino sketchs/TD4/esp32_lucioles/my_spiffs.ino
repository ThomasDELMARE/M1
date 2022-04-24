/*============== SPIFFS ===================*/
String readFileFromSPIFFS(String path) {
  /* Reads a file from the SPIFFS as a String */
  String buffer = "";
  File file = SPIFFS.open(path, "r");
  while (file.available()) {
    buffer += file.readString();
  }
  file.close();
  return buffer;
}

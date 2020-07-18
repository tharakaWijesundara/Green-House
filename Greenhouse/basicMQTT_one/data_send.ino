void sendUpdates() {
  int readValue = analogRead(A0);
  String sendMsg;
  char msg[50];
  while (readValue > 200) {
    adc0 = map(ads.readADC_SingleEnded(0), 20, 26500, 0, 99); //light //2k
    adc1 = map(ads.readADC_SingleEnded(1), 0, 26500, 0, 99); //moisture //100k
    button = map(ads.readADC_SingleEnded(2), -14, 24781, 0, 99);

    readValue = analogRead(A0);

    lcd.setCursor(0, 1);
    sendMsg = String(adc0) + String(adc1);
    lcd.print(" M : " + String(adc0) + " T : " + String(adc1));
    delay(800);
  }
  //delay(1000);
  snprintf (msg, 75, "p%d", sendMsg.toInt());
  client_one.publish("plant_side", msg);
  Serial.println("msg sent");

}

void displayLCD(String data) {
  String temp, humid, light, moist;
  moist = data.substring(0, 2);
  temp = data.substring(2, 4);
  light = data.substring(4, 6);
  humid = data.substring(6, 8);

  String alarm = data.substring(9, 10);
  if (alarm.toInt() == 1) {
    alarmState = true;
  }

  String long_alarm = data.substring(8,9);
    if (long_alarm.toInt() == 1) {
    long_alarmState = true;
  }
  String disText = "M:" + moist + "T:" + temp + "L:" + light + "H:" + humid;
  //lcd.clear();
  lcd.setCursor(0, 0);
  lcd.print(disText);
  written = true;
  loadedData = "";
}

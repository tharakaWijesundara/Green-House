#include <ESP8266WiFi.h>
#include <PubSubClient.h>

#include <LiquidCrystal.h>

LiquidCrystal lcd(D0, D3, D4, D6, D7, D8);

#include <Wire.h>
#include <Adafruit_ADS1015.h>

Adafruit_ADS1115 ads;
int16_t adc0, adc1, button;

const char* ssid = "Dialog 4G";
const char* password = "E3344662904";
const char* mqtt_server = "broker.hivemq.com";

WiFiClient espClient;
PubSubClient client_one(espClient);
PubSubClient client_two(espClient);


String loadedData;
String loadedData_2;
boolean written = true;
boolean edittable = false;
//data format THLS

unsigned long butDecTime = 0;
boolean butDecState = false;
boolean butDeclastState = false;

boolean alarmState = false;
boolean long_alarmState = false;



void setup() {
  Serial.begin(115200);
  setup_wifi();
  client_one.setServer(mqtt_server, 1883);
  client_one.setCallback(callback);

  ads.setGain(GAIN_ONE);
  lcd.begin(16, 2);
  ads.begin();

  pinMode(A0, INPUT);
  pinMode(D5, OUTPUT);
}

void loop() {
  if (!client_one.connected()) {
    reconnect();
  }
  client_one.loop();
  int readValue = analogRead(A0);
  if (readValue > 200) {
    written = false;
    lcd.setCursor(15, 1);
    lcd.print("*");
    sendUpdates();
    lcd.setCursor(15, 1);
    lcd.print(" ");
  } else {
    if (written == false) {
      displayLCD(loadedData);
    }
  }

  if (long_alarmState == true) {
    Serial.println("long alarm on");
    digitalWrite(D5, HIGH);
    delay(1000);
    digitalWrite(D5, LOW);
    delay(1000);
    digitalWrite(D5, HIGH);
    delay(1000);
    digitalWrite(D5, LOW);
    delay(1000);
    digitalWrite(D5, HIGH);
    delay(1000);
    digitalWrite(D5, LOW);
    delay(1000);
    long_alarmState = false;;
  } else {
    if (alarmState == true) {
      Serial.println("Alarm On");
      digitalWrite(D5, HIGH);
      delay(50);
      digitalWrite(D5, LOW);
      delay(50);
      alarmState = false;
    }
  }
  delay(800);
}

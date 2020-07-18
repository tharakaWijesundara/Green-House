#include <ESP8266WiFi.h>
#include <PubSubClient.h>
#include <Adafruit_ADS1015.h>

Adafruit_ADS1115 ads;

const char* ssid = "Dialog 4G";
const char* password = "E3344662904";
const char* mqtt_server = "broker.hivemq.com";

int fan = D3;
int motor = D4;
int light = D5;
int lights = D6;

int adc0, adc1, adc2, adc3;

int C = 0;
int T = 0;

int t = 0;
int m = 0;

WiFiClient espClient;
PubSubClient client(espClient);
long lastMsg = 0;
char msg [50];
char msg1 [50];
int value = 0;
int value1_1 = 0;
int value1_2 = 0;

int val = 5025;
int val1 = 50;
int val2 = 25;
int val3 = 20;

long Time = 0;
int buzzer = 0;

boolean rec = false;
boolean buz_on = false;
boolean update_val = false;

void setup_wifi() {

  delay(10);
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);

  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }

  randomSeed(micros());

  Serial.println("");
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void callback(char* topic, byte* payload, unsigned int length) {
  char Value[length - 1];
  int Val = 0;
  rec = true;

  buz_on = true;

  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");

  for (int i = 1; i < length; i++) {
    Value[i - 1] = (char)payload[i];
  }
  sscanf(Value, "%d", &Val);
  val = Val;
  Serial.println(val);
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    String clientId = "ESP8266Client-";
    clientId += String(random(0xffff), HEX);
    if (client.connect(clientId.c_str())) {
      Serial.println("connected");
      client.subscribe("plant_side");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

int control() {

  //margines for errors
  int margine1 = 2;
  int margine2 = 10;

  String Val = String(val);
  val1 = (Val.substring(0, 2)).toInt();
  val2 = (Val.substring(2, 4)).toInt();
  Serial.print(val1);
  Serial.print(val2);
  Serial.println(val3);

  int desiredMoisture = val1;
  int desiredTemp = val2;
  int desiredLightlevel = val3;

  int Temprature = (ads.readADC_SingleEnded(0)) / 85.158;
  int Moisture = (99 - map(ads.readADC_SingleEnded(1), 0, 26400, 0, 89));
  int Lightlevel = map(ads.readADC_SingleEnded(2), 0, 24600, 10, 99);
  int Humidity = map(ads.readADC_SingleEnded(3), 0, 24600, 10, 99);

  if (Temprature <= desiredTemp) {
    digitalWrite(fan, LOW);
    T = 0;
  }

  if (Temprature <= (desiredTemp - margine1)) {
    digitalWrite(light, HIGH);
    digitalWrite(fan, LOW);
    T = 0;
  }

  if (Temprature > desiredTemp) {
    T = 1;
  }

  if (Temprature >= (desiredTemp + margine1)) {
    digitalWrite(light, LOW);
    digitalWrite(fan, HIGH);
    T = 1;
  }
  if ((Temprature > (desiredTemp - margine1)) && (Temprature < (desiredTemp + margine1))) {
    t = 1;
  }
  else {
    t = 0;
  }

  if (Moisture <= (desiredMoisture - margine2)) {
    digitalWrite(motor, HIGH);
  }

  if (Moisture >= desiredMoisture) {
    digitalWrite(motor, LOW);
  }

  if (Moisture > (desiredMoisture + margine2) && T == 1) {
    digitalWrite(motor, LOW);
    digitalWrite(fan, HIGH);
  }

  if ((Moisture > (desiredMoisture - margine2)) && (Moisture < (desiredMoisture + margine2))) {
    m = 1;
  }
  else {
    m = 0;
  }

  if (Lightlevel < desiredLightlevel) {
    digitalWrite(lights, HIGH);
  }

  if (Lightlevel >= desiredLightlevel) {
    digitalWrite(lights, LOW);
  }
  String Msg = (String)Moisture + (String)Temprature + (String)Lightlevel +  (String)Humidity;
  String Msg1_1 = (String)Moisture + (String)Temprature + (String)Lightlevel +  (String)Humidity ;
  String Msg1_2 = (String)val1 + (String)val2 + (String)buzzer;
  value1_1 = Msg1_1.toInt();
  value1_2 = Msg1_2.toInt();
  value = Msg.toInt();

  Serial.print("Moisture = ");
  Serial.print(Moisture);
  Serial.print(" , Temprature = ");
  Serial.print(Temprature);
  Serial.print(" , Lightlevel = ");
  Serial.print(Lightlevel);
  Serial.print(" , Humidity = ");
  Serial.println(Humidity);

  return value;
}

void setup() {
  pinMode(fan, OUTPUT);
  pinMode(motor, OUTPUT);
  pinMode(light, OUTPUT);
  pinMode(lights, OUTPUT);
  Serial.begin(115200);
  ads.setGain(GAIN_ONE);
  setup_wifi();
  ads.begin();
  client.setServer(mqtt_server, 1883);
  client.setCallback(callback);
  digitalWrite(motor, LOW);
  digitalWrite(fan, LOW);
  digitalWrite(lights, LOW);
  digitalWrite(light, LOW);
}

void loop() {

  if (!client.connected()) {
    reconnect();
  }
  client.loop();
  if (rec == true) {
    Time = millis();
    rec = false;
  }
  if (update_val == true) {
    control();
    update_val = false;
  } else {
    buzzer = 0;
    control();

  }

  long duration = millis() - Time;
  if ((duration > 10000) && t == 1 && m == 1 && buz_on == true) {
    buzzer = 0;
    Serial.println("buzzer off");
    Time = millis();
    buz_on = false;
    update_val = true;
  }
  else if ((duration > 10000) && t == 0 && m == 0 && buz_on == true) {
    buzzer = 1;
    Serial.println("buzzer on");
    Time = millis();
    buz_on = false;
    update_val = true;
  }
  snprintf (msg, 75, "%d", value);
  snprintf (msg1, 100, "%d%d", value1_1, value1_2);
  client.publish("node_rec_val", msg1);
  client.publish("app", msg);

  delay(2000);
}

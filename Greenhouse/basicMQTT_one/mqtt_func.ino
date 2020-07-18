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
  Serial.print("Message arrived [");
  Serial.print(topic);
  Serial.print("] ");
  for (int i = 0; i < length; i++) {
    loadedData += String((char)payload[i]);
    Serial.print(String((char)payload[i]));
  }
  written = false;
}

void reconnect() {
  while (!client_one.connected()) {
    Serial.print("Attempting MQTT connection...");
    String clientId = "ESP8266Client-";
    clientId += String(random(0xffff), HEX);
    // Attempt to connect
    if (client_one.connect(clientId.c_str()))  {
      Serial.println("connected");
      client_one.subscribe("node_red");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client_one.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

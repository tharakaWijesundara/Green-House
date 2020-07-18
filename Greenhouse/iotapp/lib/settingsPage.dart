import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iotapp/MQTTAppState.dart';
import 'package:iotapp/MQTTManager.dart';
import 'package:iotapp/configSettings.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  MQTTAppState currentAppState;
  MQTTManager manager;
  String hostName;
  String portName;
  String topic;




  void publishMessage(String text){
    final message =text;
    manager.publish(message);
  }

  Material field(String hint, String labelText) {
    return Material(
      child: new Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(4, 2, 0, 2),
              width: MediaQuery.of(context).size.width * 0.98,
              height: MediaQuery.of(context).size.height * 0.09,
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(18, 16, 0, 2),
                    width: MediaQuery.of(context).size.width * 0.28,
                    height: MediaQuery.of(context).size.height * 0.085,
                    color: Colors.transparent,
                    child: Text(
                      labelText,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.69,
                    height: MediaQuery.of(context).size.height * 0.085,
                    color: Colors.transparent,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new TextField(
                          decoration: new InputDecoration(
                            hintText: hint,
                          ),
                          onChanged: (String str) {
                            setState(() {
                              if (labelText == "Hostname : ") {
                                hostName = str;
                                config().hostName=str;
                              } else if (labelText == "Port : ") {
                                portName = str;
                                config().portName=str;
                              } else if (labelText == "Topic : ") {
                                topic = str;
                                config().topic=str;
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String prepareStateMessageFrom(MQTTAppConnectionState state) {
    String status;
    switch (state) {
      case MQTTAppConnectionState.connected:
        status = "Connected";
        break;
      case MQTTAppConnectionState.connecting:
        status = "Connecting";
        break;
      case MQTTAppConnectionState.disconnected:
        status = "Disconnected";
        break;
    }
    return status;
  }

  void _disconnect() {
    manager.disconnect();
  }

  void _configureAndConnect() {
    manager = MQTTManager(
        host: hostName,
        topic: topic,
        identifier: "ENTC",
        state: currentAppState);
    manager.initializeMQTTClient();
    manager.connect();
  }

  Widget buildConnectButtonFrom(MQTTAppConnectionState state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.07,
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                width: 180,
                height: 40,
                child: RaisedButton(
                  color: Colors.green,
                  child: Text(
                      'Connect',
                    style: TextStyle(
                      fontSize: 16
                    ),
                  ),
                  onPressed: state == MQTTAppConnectionState.disconnected
                      ? _configureAndConnect
                      : null,
                ),
              ),
              SizedBox(
                width: 180,
                height: 40,
                child: RaisedButton(
                    color: Colors.red,
                    child: Text(
                        'Disconnect',
                      style: TextStyle(
                        fontSize: 16
                      ),
                    ),
                    onPressed: state == MQTTAppConnectionState.connected
                        ?_disconnect
                        :null
                ),
              )
            ],
          ),

        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MQTTAppState>(context);
    currentAppState = appState;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text(
            "Settings",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.025,
              color: Colors.lightBlue,
              child: Text(
                prepareStateMessageFrom(currentAppState.getAppConnectionState),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            field("broker.hivemq.com", "Hostname : "),
            field("1883", "Port : "),
            field("ENTC", "Topic : "),
            buildConnectButtonFrom(currentAppState.getAppConnectionState),
          ],
        ));
  }
}
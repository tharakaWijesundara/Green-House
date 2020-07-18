import 'package:flutter/material.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:iotapp/MQTTAppState.dart';
import 'package:flutter/cupertino.dart';

class MQTTManager{

  //private instance of client
  MQTTAppState _currentState;
  MqttClient _client;
  String _identifier;
  String _host;
  String _topic;

  //constructor
  MQTTManager({@required String host,@required String topic,@required String identifier,@required MQTTAppState state}):
        _identifier=identifier, _host=host,_topic=topic,_currentState=state;

  void initializeMQTTClient(){
    _client=MqttClient(_host, _identifier);
    _client.port=1883;
    _client.keepAlivePeriod = 20;
    _client.onDisconnected = onDisconnected;
    _client.secure=false;
    _client.logging(on: true);

    //ADD the successful connection callback
    _client.onConnected=onConnected;
    _client.onSubscribed=onSubscribed;

    final MqttConnectMessage connMess =MqttConnectMessage()
        .withClientIdentifier(_identifier)
        .withWillTopic('willtopic')
        .withWillMessage('My will message')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);
    print('EAMPLE::Mosquitto client connecting.....');
    _client.connectionMessage = connMess;
  }

  void connect() async{
    assert(_client!=null);
    try{
      print('EXAMPLE:: Mosquitto start client connecting....');
      _currentState.setAppConnectionState(MQTTAppConnectionState.connecting);
      await _client.connect();
    }on Exception catch (e){
      print('EXAMPLE:: client exception - $e');
      disconnect();
    }
  }

  void disconnect(){
    print('Disconnected');
    _client.disconnect();
  }

  void publish(String message){
    final MqttClientPayloadBuilder builder = MqttClientPayloadBuilder();
    builder.addString(message);
    _client.publishMessage(_topic, MqttQos.exactlyOnce, builder.payload);
  }


  void onSubscribed(String topic){
    print('EXAMPLE::Subscription confirmed for topic $topic');
  }

  void onDisconnected(){
    print('EXAMPLE::onDisconnected client callback - client disconnection');
    if(_client.connectionStatus.returnCode==MqttConnectReturnCode.solicited){
      print('EXAMPLE::onDisconnected callback is solicited, this is correct');
    }
    _currentState.setAppConnectionState(MQTTAppConnectionState.disconnected);
  }

  void onConnected(){
    _currentState.setAppConnectionState(MQTTAppConnectionState.connected);
    print('EXAMPLE::Mosquito client connected...');
    _client.subscribe(_topic, MqttQos.atLeastOnce);
    _client.updates.listen((List<MqttReceivedMessage<MqttMessage>> c){
      final MqttPublishMessage recMess = c[0].payload;
      final String pt =
      MqttPublishPayload.bytesToStringAsString((recMess.payload.message));
      _currentState.setReceivedText(pt);
      print(
          ' EXAMPLE::change notification:: topic is <${c[0].topic}>, payliad is <--$pt-->');

      print('');

    });
    print(
        'EXAMPLE:: onConnected client callBack = Client connection was successful');
  }





}
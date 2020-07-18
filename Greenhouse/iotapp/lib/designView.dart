import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:iotapp/MQTTAppState.dart';
import 'package:iotapp/MQTTManager.dart';
import 'package:iotapp/settingsPage.dart';
import 'package:iotapp/configSettings.dart';


class Dashboard extends StatefulWidget {

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  double tempTreashold = 0.0;
  double moistTreashold = 0.0;

  String hostName="broker.hivemq.com";
  String topic="plant_side";

  MQTTManager manager_pub;
  MQTTAppState currentAppState;
  MQTTAppState currentAppState_pub;

  String humid, temp, light, mos;

  Widget send_button(MQTTAppConnectionState state){
    return RaisedButton(
      //onPressed: (){publishMessage("asas");},//(tempTreashold.toInt()).toString() + (moistTreashold.toInt()).toString()
      textColor: Colors.black,
      elevation: 8,
      color: Colors.teal,
      colorBrightness: Brightness.dark,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        "Set Values",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      onPressed: (){publishMessage("P"+(tempTreashold.toInt()).toString() + (moistTreashold.toInt()).toString());},
    );
  }

  void publishMessage(String text){
    final message = text;
    manager_pub.publish(message);
  }

  Widget containerS(String value, String symbol) {
    return (new Container(
      width: MediaQuery.of(context).size.width * 0.19,
      height: MediaQuery.of(context).size.height * 0.135,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.18,
            height: MediaQuery.of(context).size.height * 0.06,
            color: Colors.transparent,
            child: Center(
              child: Text(
                value,
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.normal,
                  fontSize: 40,
                ),
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.18,
            height: MediaQuery.of(context).size.height * 0.06,
            color: Colors.transparent,
            child: Center(
              child: Text(
                symbol,
                style: TextStyle(
                  color: Colors.teal,
                  fontWeight: FontWeight.normal,
                  fontSize: 35,
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
  void configureAndConnect() {
    manager_pub = MQTTManager(
        host: "broker.hivemq.com",
        topic: "plant_side",
        identifier: "ENTC1",
        state: currentAppState_pub
    );
    manager_pub.initializeMQTTClient();
    manager_pub.connect();
  }

  GestureDetector buildButtonS(
      String buttonText, String image, String value, String symbol) {
    return GestureDetector(
      onTap: () {
        print("Clicked");
      },
      child: new Container(
        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
        color: Colors.white12,
        width: MediaQuery.of(context).size.width * 0.46,
        height: MediaQuery.of(context).size.height * 0.19,
        child: Row(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(4, 1, 0, 0),
                    width: MediaQuery.of(context).size.width * 0.26,
                    height: MediaQuery.of(context).size.height * 0.035,
                    color: Colors.transparent,
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                    width: MediaQuery.of(context).size.width * 0.45,
                    height: MediaQuery.of(context).size.height * 0.145,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.24,
                          height: MediaQuery.of(context).size.height * 0.145,
                          color: Colors.transparent,
                          child: Image(
                            image: AssetImage(image),
                            fit: BoxFit.fill,
                          ),
                        ),
                        containerS(value, symbol),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  GestureDetector buildButtonL(String buttonText, String image) {
    return GestureDetector(
      onTap: () {
        print("Clicked");
      },
      child: new Container(
        padding: EdgeInsets.fromLTRB(2, 2, 2, 2),
        color: Colors.white12,
        width: MediaQuery.of(context).size.width * 0.96,
        height: MediaQuery.of(context).size.height * 0.19,
        child: Row(
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(4, 1, 0, 0),
                    width: MediaQuery.of(context).size.width * 0.60,
                    height: MediaQuery.of(context).size.height * 0.035,
                    color: Colors.transparent,
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.normal,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 4, 0),
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: MediaQuery.of(context).size.height * 0.145,
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: MediaQuery.of(context).size.height * 0.145,
                          color: Colors.transparent,
                          child: Image(
                            image: AssetImage(image),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.60,
                          height: MediaQuery.of(context).size.height * 0.135,
                          color: Colors.white10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget custom_slider_temp() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 8,
        overlayColor: Colors.white30,
        minThumbSeparation: 50,
        rangeThumbShape: RoundRangeSliderThumbShape(
            enabledThumbRadius: 10, disabledThumbRadius: 10),
      ),
      child: Slider(
        label: tempTreashold.abs().toString(),
        value: tempTreashold,
        min: 0,
        max: 99.0,
        onChanged: (val) {
          setState(() {
            tempTreashold = val;
          });
        },
      ),
    );
  }

  Widget custom_slider_moist() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 8,
        overlayColor: Colors.white30,
        minThumbSeparation: 50,
        rangeThumbShape: RoundRangeSliderThumbShape(
            enabledThumbRadius: 10, disabledThumbRadius: 10),
      ),
      child: Slider(
        label: moistTreashold.abs().toString(),
        value: moistTreashold,
        min: 0,
        max: 99.0,
        onChanged: (val) {
          setState(() {
            moistTreashold = val;
          });
        },
      ),
    );
  }



  Widget slider_row(Widget name, String text) {
    String value_of_slider;
    if (text == "Threshold for Soil-moisture") {
      value_of_slider = (moistTreashold.toInt()).toString();
    } else {
      value_of_slider = (tempTreashold.toInt()).toString();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              width: MediaQuery.of(context).size.width * 0.60,
              height: 25,
              color: Colors.transparent,
              child: Text(
                text,
                style: TextStyle(color: Colors.teal, fontSize: 18),
              ),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.78,
                  height: 35,
                  color: Colors.transparent,
                  child: name,
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(20, 3, 5, 5),
                  width: MediaQuery.of(context).size.width * 0.19,
                  height: 35,
                  color: Colors.transparent,
                  child: Text(
                    value_of_slider,
                    style: TextStyle(
                      fontSize: 25,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<MQTTAppState>(context);
    final appState_pub = Provider.of<MQTTAppState>(context);
    currentAppState = appState;
    currentAppState_pub = appState_pub;
    String recText = currentAppState.getReceivedText;

    //_configureAndConnect();

    if (recText != "") {
      if(recText.substring(0,1)=="P"){
        humid=humid;
        temp=temp;
        light=light;
        mos=mos;
      }else {
        humid = recText.substring(0, 2);
        temp = recText.substring(2, 4);
        light = recText.substring(4, 6);
        mos = recText.substring(6);
      }
//      if((double.parse(mos) < moistTreashold) || (double.parse(temp)<tempTreashold)){
//        player.play(alarmAudioPath);
//      }
    } else {
      humid = "??";
      temp = "??";
      mos = "??";
      light = "??";
    }
    //print(recText);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.white10,
        title: Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              buildButtonS("Moisture", 'assets/tap.png', humid, "%"),
              buildButtonS("Temperature", 'assets/temp.png', temp, "C"),
            ],
          ),
          //buildButtonL("Humidity Temperature Plots", 'assets/plot.png'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              buildButtonS("Light", 'assets/light.png', light, "%"),
              buildButtonS("Humidity", 'assets/humidity.png', mos, "%"),//
            ],
          ),
          slider_row(custom_slider_temp(), "Threshold for Temperature"),
          slider_row(custom_slider_moist(), "Threshold for Soil-moisture"),
          SizedBox(
            width: 150,
            height: 40,
            child: send_button(currentAppState_pub.getAppConnectionState),
          ),
          SizedBox(
            width: 50,
            height: 50,
            child: RaisedButton(
              //onPressed: (){_configureAndConnect();}
              onPressed : (){configureAndConnect();}
               ),
          )

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Settings(),
          ),
        ),
        backgroundColor: Colors.white30,
        child: Icon(Icons.settings),
      ),
    );
  }
}

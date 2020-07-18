import 'package:flutter/material.dart';
import 'package:iotapp/MQTTAppState.dart';
import 'package:iotapp/designView.dart';
import 'package:iotapp/settingsPage.dart';
import 'package:iotapp/MQTTManager.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

//class MyApp extends StatelessWidget {
//  @override
//  Widget build(BuildContext context) {
//    return MaterialApp(
//      debugShowCheckedModeBanner: false,
//      title: "Flutter_view",
//      theme: ThemeData(
//        //primaryColor: new Color(0xff622F74),
//        primaryColor: Colors.blue,
//      ),
//
//      home : ChangeNotifierProvider<MQTTAppState>(
//        create: (_) => MQTTAppState(),
//        child: Dashboard(),
//      ),
////      routes: <String, WidgetBuilder>{
////        "/gotoSettings": (BuildContext context) => new Settings()
////      },
//    );
//  }
//}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=>MQTTAppState(),
      child:MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Flutter_view",
        home: Dashboard(),
      ),

    );
  }
}

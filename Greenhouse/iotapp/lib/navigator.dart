import 'package:flutter/material.dart';
import 'package:iotapp/designView.dart';
import 'package:provider/provider.dart';
import 'package:iotapp/settingsPage.dart';

class NavigationProvider with ChangeNotifier {
  String currentNavigation = "Dashboard";

  Widget get getNavigation {
    if (currentNavigation == "Settings") {
      return Settings();
    } else {
      return Dashboard();
    }
  }

  void updateNavigation(String navigation) {
    currentNavigation=navigation;
    notifyListeners();
  }
}
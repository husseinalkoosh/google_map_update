import 'dart:async';
import 'package:location/location.dart';
import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'Home_screen.dart';

class Splash_Screen extends StatefulWidget {
  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {

  String error;
  double lat;
  double lon;
  Location location = new Location();
  Map<String, dynamic> currentlocation = new Map();
  starttime() async {
    var _duration = Duration(seconds: 1);
    return Timer(_duration, splash_screen);
  }

  void splash_screen() {
    initplatrformstate();

  }
  void openLocationSetting() async {
    final AndroidIntent intent = new AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );
    await intent.launch();
  }
  void initplatrformstate() async {
    var my_location;
    try {
      my_location = await location.getLocation().then((dd){
        print('${dd.latitude}');
        print('${dd.longitude}');
        lat = dd.latitude;
        lon = dd.longitude;
      });
      error = "";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = "permession denied";
      } else if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
        error = "permession denied for ever";
      }
      my_location = null;
    }
    if (currentlocation == null) {
      openLocationSetting();
    } else {
      print('${lat}wdwqd');
      print('${lon}sdww');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Home_screen(
              lat, lon),
        ),
      );
    }
    print('${currentlocation['latitude']}');
    print('${currentlocation['longitude']}');
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    starttime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.blue,
      child: Center(
        child: Text('Google Map Task',style: TextStyle(fontSize: 30,color: Colors.white),),
      ),
      ));
  }
}

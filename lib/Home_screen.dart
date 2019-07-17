import 'dart:async';
import 'dart:typed_data';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:convert';
import 'dart:ui' as ui;
import 'Drawer_Widget.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;

const CameraPosition _kInitialPosition =
    CameraPosition(target: LatLng(30.0605898, 31.3446248), zoom: 11.0);

class Home_screen extends StatefulWidget {
  var lat;

  var lan;

  Home_screen(this.lat, this.lan);

  @override
  _Home_screenState createState() => _Home_screenState();
}

class _Home_screenState extends State<Home_screen> {
  LatLng _lastTap;

  Map<String, dynamic> currentlocation = new Map();
  String error;
  double lat;
  double lon;
  Location location = new Location();
  GoogleMapController mapController;
  LatLng currentLatLng;
  List<LatLng> positions_list = List();
  var marker_id;
  Marker _marker;
  var map = <String, String>{};
  Set<Marker> markers = Set();

  degreesToRadians(degrees) {
    return degrees * math.pi / 180;
  }

  distanceInKmBetweenEarthCoordinates(lat1, lon1, lat2, lon2) {
    var lat_pure = lat2;
    var lan_pure = lon2;

    var earthRadiusKm = 6371;

    var dLat = degreesToRadians(lat2 - lat1);
    var dLon = degreesToRadians(lon2 - lon1);

    lat1 = degreesToRadians(lat1);
    lat2 = degreesToRadians(lat2);

    var a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.sin(dLon / 2) *
            math.sin(dLon / 2) *
            math.cos(lat1) *
            math.cos(lat2);
    var c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    print('distnace is :- ${earthRadiusKm * c}');

    if (earthRadiusKm * c >= 0.5) {
      show_alert(lat_pure, lan_pure, earthRadiusKm * c);
    }

    return earthRadiusKm * c;
  }

  void _settingModalBottomSheet(String position_data) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: new Wrap(
              children: <Widget>[
                Center(child: Text("")),
                new ListTile(
                  title: new Text('position is : ${position_data}'),
                ),
              ],
            ),
          );
        });
  }

  void _onMarkerTapped(String latlan) {
    _settingModalBottomSheet(latlan);
  }

  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });
//
//     positions_list.add(LatLng(30.0605898, 31.3446248));
//    positions_list.add(LatLng(30.0647336, 31.3454536));
//    positions_list.add(LatLng(30.0363436, 31.3427256));
//    positions_list.add(LatLng(30.0390511, 31.3461457));
    for (int x = 0; x < positions_list.length; x++) {
      Marker resultMarker = Marker(
          markerId: MarkerId('${positions_list[x]}'),
          infoWindow:
              InfoWindow(title: "${positions_list[x]}}", snippet: "48484"),
          position: positions_list[x],
          onTap: () {
            _onMarkerTapped('${positions_list[x]}');
          });

      markers.add(resultMarker);
    }
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
      my_location = await location.getLocation();
      error = "";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        error = "permession denied";
      } else if (e.code == "PERMISSION_DENIED_NEVER_ASK") {
        error = "permession denied for ever";
      }
      my_location = null;
    }
    my_location = await location.getLocation().then((dd) {
//        print('${dd.latitude}');
//        print('${dd.longitude}');
      lat = dd.latitude;
      lon = dd.longitude;
    });
  }

  Future<bool> show_alert(var lat, var lan, double distance) {
    return showDialog(
      context: context,
      child: new AlertDialog(
        title: new Text('distance between two points is ${distance * 100}'),
        content: new Text('this is position ${lat} \n ${lan}.'),
        actions: <Widget>[
          new FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('Okay'),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    positions_list.add(LatLng(30.057126, 31.3427256));
    positions_list.add(LatLng(30.0605898, 31.3446248));
    positions_list.add(LatLng(30.0647336, 31.3454536));
    positions_list.add(LatLng(30.0363436, 31.3427256));
    positions_list.add(LatLng(30.0390511, 31.3461457));
    initplatrformstate();
  }

  void _add(LatLng pos) {
    for (int x = 0; x < positions_list.length; x++) {
      distanceInKmBetweenEarthCoordinates(pos.latitude, pos.longitude,
          positions_list[x].latitude, positions_list[x].longitude);
    }

    final Marker marker = Marker(
      markerId: MarkerId('${pos}'),
      position: pos,
      infoWindow: InfoWindow(title: '${pos}', snippet: '*'),
      onTap: () {
        _onMarkerTapped('${pos}');
      },
    );
    markers.add(marker);

//    setState(() {
//      markers = marker;
//    });
  }

  @override
  Widget build(BuildContext context) {
    final GoogleMap googleMap = GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: _kInitialPosition,
      onTap: (LatLng pos) {
        setState(() {
          _lastTap = pos;
          _add(pos);
        });
      },
      markers: markers,
    );
    return Stack(
      children: <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          tiltGesturesEnabled: true,
          mapType: MapType.normal,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.lat, widget.lan),
            zoom: 16,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: new AppBar(
            iconTheme: new IconThemeData(color: Colors.black),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          drawer: new Drawer_Widget(),
          body: Stack(
            children: <Widget>[
              googleMap,

              // this code refere to open location serveces  ui
              /*
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30.0),
                    child: Align(
                        alignment: FractionalOffset.bottomCenter,
                        child:  Padding(
                            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Container(
                              decoration: new BoxDecoration(
                                  color: Colors.purple,
                                  borderRadius: new BorderRadius.all(
                                    const Radius.circular(10.0),
                                  )),
                              height: MediaQuery.of(context).size.height /
                                  2, // height of the button
                              // width of the button
                              child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Location Services are turned off ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, right: 10),
                                      child: Text(
                                        'if you want it on , we will help you find the perfect pick up for you ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 100.0),
                                      child: Container(
                                          decoration: new BoxDecoration(
                                              color: Colors.purple[700],
                                              borderRadius: new BorderRadius.all(
                                                const Radius.circular(24.0),
                                              )),
                                          child: FlatButton(
                                            child: Text(
                                              'Turn Location Services on',
                                              style: TextStyle(color: Colors.white),
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                  ),
              Padding(
                padding: const EdgeInsets.only(bottom: 125,right: 10,left: 10),
                child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child:   Container(
                      color: Colors.white,
                      height: 50,
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: '     Where to ?',
                          fillColor: Colors.white,
                        ),
                        onSaved: (String value) {},
                      ),
                    ),),
              )
              */
            ],
          ),
        ),
      ],
    );
  }
}

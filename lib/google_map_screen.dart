import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

String text = "";

class _MainScreenState extends State<MainScreen> {




  LatLng _latLng = LatLng(24.015870, 90.422398);
  late CameraPosition _initialCameraPosition;
  late var _mapMarkerIcon;
  late Marker _marker;
  late GoogleMapController _googleMapController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  void dispose() {
    // TODO: implement dispose
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    init();
    getVal();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GoogleMap(
          myLocationButtonEnabled: false,
          zoomControlsEnabled: true,
          initialCameraPosition: _initialCameraPosition,
          markers: {_marker},
          onMapCreated: (controller) {
            _googleMapController = controller;
          },
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black,
          onPressed: () {
            _googleMapController.animateCamera(
                CameraUpdate.newCameraPosition(_initialCameraPosition));
          },
          child: const Icon(Icons.center_focus_strong),
        ),
      ),
    );
  }

  init() async{
    _mapMarkerIcon= await BitmapDescriptor.fromAssetImage(ImageConfiguration(), "assets/iss.png");
    _marker = Marker(
        markerId: const MarkerId("main"),
        infoWindow: const InfoWindow(title: "Main"),
        icon: _mapMarkerIcon,
        position: _latLng);
    _initialCameraPosition=CameraPosition(target: _latLng, zoom: 11.5);
  }

  Future<void> getVal() async {
    final response =
        await http.get(Uri.parse('http://api.open-notify.org/iss-now.json'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      text = jsonDecode(response.body).toString();
      setState(() {
        var decode=json.decode(response.body);
        var data=decode["data"];
        print(decode["iss_position"]["longitude"]);
        _latLng=LatLng(double.parse(decode["iss_position"]["latitude"]), double.parse(decode["iss_position"]["longitude"]));

        //_googleMapController.moveCamera(CameraUpdate.newLatLng(_latLng),);
      //  print(text);
       // response.request;
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      text = "Hi";
    }
  }
}

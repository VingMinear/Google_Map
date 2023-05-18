import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:google_map/controller/map_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../components/button.dart';

class MyGoogleMap extends StatefulWidget {
  const MyGoogleMap({
    super.key,
  });

  @override
  State<MyGoogleMap> createState() => _MyGoogleMapState();
}

class _MyGoogleMapState extends State<MyGoogleMap> {
  var con = Get.put(MapController());
  late CameraPosition cameraPosition;
  @override
  void initState() {
    con.marker.clear();
    con.marker.add(
      Marker(
        markerId: const MarkerId("marker"),
        position: con.latLng,
      ),
    );
    cameraPosition = CameraPosition(
      target: con.latLng,
      zoom: 15,
    );
    super.initState();
  }

  var padding = const EdgeInsets.all(20);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: con,
        builder: (controller) {
          return GoogleMap(
            padding: padding,
            mapToolbarEnabled: false,
            markers: con.marker,
            liteModeEnabled: false,
            initialCameraPosition: cameraPosition,
            onTap: (argument) {
              con.setMarker(argument);
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: padding,
        child: Button(
          text: "Set",
          onPressed: () {
            getLocation(
              context: context,
              con: con,
            );
          },
        ),
      ),
    );
  }

  void getLocation({
    required context,
    required MapController con,
  }) async {
    var latitude = con.latLng.latitude;
    var longitude = con.latLng.longitude;
    List<Placemark> placemarks = await placemarkFromCoordinates(
      latitude,
      longitude,
    );
    var place = placemarks[0];
    var locationDetail =
        "${place.street},${place.administrativeArea},${place.name},${place.country}";
    con.txtLocationDetail.value.text = locationDetail;
    debugPrint(
        "place --->${place.street},${place.administrativeArea},${place.name},${place.country}");
    con.moveCamera(con.latLng);
    con.update();
    Navigator.pop(context);
  }
}

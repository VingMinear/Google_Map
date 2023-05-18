import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_map/model/location.dart';
import 'package:google_map/screens/location_detail.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  Set<Marker> marker = <Marker>{}.obs;
  LatLng latLng = const LatLng(11.585510, 104.900509);
  GoogleMapController? googleMapController;
  Icon selectedIcon = Icon(listIcons[0]);
  var selected = 0.obs;
  var txtName = TextEditingController().obs;
  var txtLocationDetail = TextEditingController().obs;
  var txtDescription = TextEditingController().obs;
  var listLocation = <Location>[].obs;

  void clear() {
    txtLocationDetail.value.text = "";
    txtDescription.value.text = "";
    txtName.value.text = "";
    selectedIcon = Icon(listIcons[0]);
    selected(0);
  }

  void clearMarker() {
    marker.clear();
    update();
  }

  void currentLocaton() async {
    final position = await determinePosition();
    latLng = LatLng(position.latitude, position.longitude);
    marker.add(
      Marker(
        markerId: const MarkerId("marker"),
        position: latLng,
      ),
    );
    moveCamera(latLng);
    update();
  }

  void setMarker(LatLng postion) {
    marker.clear();
    marker.add(
      Marker(
        position: postion,
        markerId: const MarkerId("marker"),
      ),
    );
    latLng = postion;
    update();
  }

  void moveCamera(LatLng position) {
    googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 14.8,
        ),
      ),
    );
    debugPrint("move");
  }

  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }
}

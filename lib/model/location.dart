import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Location {
  Icon? icon;
  LatLng? latLng;
  String? locationName;
  String? locationDetails;
  String? locationDescription;
  Location({
    this.latLng,
    this.icon,
    this.locationName,
    this.locationDetails,
    this.locationDescription,
  });
}

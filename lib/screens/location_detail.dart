import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/components/app_bar.dart';
import 'package:google_map/components/text_field.dart';
import 'package:google_map/controller/map_controller.dart';
import 'package:google_map/model/location.dart';
import 'package:google_map/screens/google_map.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../components/button.dart';

class LocationDetail extends StatelessWidget {
  const LocationDetail({
    super.key,
    required this.latLng,
    required this.btnTitle,
    this.index,
  });
  final LatLng latLng;
  final int? index;
  final String btnTitle;
  @override
  Widget build(BuildContext context) {
    var con = Get.put(MapController());
    con.setMarker(latLng);
    return Scaffold(
      appBar: MyAppBar(title: "Location Detail"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            GetBuilder(
              init: con,
              builder: (controller) => Stack(
                children: [
                  Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12,
                          color: Colors.grey.shade300,
                        ),
                      ],
                      border: Border.all(
                        width: 2,
                        color: Colors.white,
                      ),
                    ),
                    width: double.infinity,
                    height: Get.height * 0.25,
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 40,
                        sigmaY: 40,
                      ),
                      child: ClipRRect(
                        clipBehavior: Clip.antiAlias,
                        borderRadius: BorderRadius.circular(15),
                        child: GoogleMap(
                          markers: con.marker,
                          zoomGesturesEnabled: false,
                          indoorViewEnabled: false,
                          rotateGesturesEnabled: false,
                          scrollGesturesEnabled: false,
                          trafficEnabled: false,
                          onMapCreated: (controller) {
                            con.googleMapController = controller;
                          },
                          // mapToolbarEnabled: false,
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          padding: const EdgeInsets.all(10),
                          initialCameraPosition: CameraPosition(
                            target: latLng,
                            zoom: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: GestureDetector(
                      onTap: () {
                        debugPrint("route");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyGoogleMap(),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
            Column(
              children: [
                const SizedBox(height: 10),
                MyTextField(
                  title: "Location Name",
                  inputController: con.txtName.value,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  title: "Location Details",
                  readOnly: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyGoogleMap(),
                      ),
                    );
                  },
                  inputController: con.txtLocationDetail.value,
                ),
                const SizedBox(height: 10),
                MyTextField(
                  title: "Description",
                  inputController: con.txtDescription.value,
                ),
                const SizedBox(height: 30),
                Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      listIcons.length,
                      (index) {
                        return Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                con.selectedIcon = Icon(listIcons[index]);
                                con.selected.value = index;
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  shape: BoxShape.circle,
                                  border: con.selected.value == index
                                      ? Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        )
                                      : null,
                                ),
                                child: Icon(
                                  listIcons[index],
                                  color: con.selected.value == index
                                      ? Colors.white
                                      : color,
                                  size: size,
                                ),
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(listTxt[index]),
                          ],
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Button(
          text: btnTitle,
          onPressed: () {
            var name = con.txtName.value.text;
            var locaDetail = con.txtLocationDetail.value.text;
            var desc = con.txtDescription.value.text;
            if (name.isEmpty && locaDetail.isEmpty && desc.isEmpty) {
              Get.snackbar(
                "Please",
                "Input value",
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            } else {
              var item = Location(
                latLng: con.latLng,
                icon: con.selectedIcon,
                locationDetails: locaDetail,
                locationName: name,
                locationDescription: desc,
              );

              if (btnTitle.toLowerCase() == "save") {
                con.listLocation[index!] = item;
              } else {
                con.listLocation.add(item);
              }
              Navigator.pop(context);
            }
          },
        ),
      ),
    );
  }
}

var size = 25.0;
var color = Colors.green.shade400;
var listIcons = [
  Icons.home_sharp,
  Icons.work_rounded,
  Icons.hotel_rounded,
];
var listTxt = [
  "Home",
  "Work",
  "Hotel",
];

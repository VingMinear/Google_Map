import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_map/components/bg.dart';
import 'package:google_map/components/card.dart';
import 'package:google_map/screens/empty.dart';

import '../components/app_bar.dart';
import '../components/button.dart';
import '../controller/map_controller.dart';
import 'location_detail.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var con = Get.put(MapController());
  @override
  void initState() {
    con.currentLocaton();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    con.clearMarker();

    return Scaffold(
      appBar: MyAppBar(
        title: "Google Map",
      ),
      body: Background(
        imageUrl:
            "https://e1.pxfuel.com/desktop-wallpaper/521/910/desktop-wallpaper-pin-on-bts-korean-aesthetic-iphone.jpg",
        child: Obx(
          () => con.listLocation.isEmpty
              ? const Empty()
              : ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: con.listLocation.length,
                  itemBuilder: (context, index) {
                    var location = con.listLocation[index];
                    return CardLocation(
                      text: location.locationName.toString(),
                      subtitle: location.locationDetails.toString(),
                      icon: location.icon,
                      onPressed: () {
                        con.selected.value = index;
                        con.txtDescription.value.text =
                            location.locationDescription.toString();
                        con.txtLocationDetail.value.text =
                            location.locationDetails.toString();
                        con.txtName.value.text =
                            location.locationName.toString();
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return LocationDetail(
                              btnTitle: "Save",
                              index: index,
                              latLng: location.latLng!,
                            );
                          },
                        ));
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const SizedBox(height: 10);
                  },
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Button(
        text: "Add",
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              log(con.latLng.toString());
              con.currentLocaton();
              con.clear();

              return LocationDetail(
                btnTitle: "Add",
                latLng: con.latLng,
              );
            },
          ));
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Empty extends StatelessWidget {
  const Empty({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Lottie.asset("asset/empty.json"),
            Positioned(
              bottom: 30,
              child: Text(
                "No Locations Saveds",
                style: Theme.of(context).textTheme.headline5,
              ),
            )
          ],
        ),
      ),
    );
  }
}

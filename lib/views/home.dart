import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_firebase/controllers/homeController.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class Home extends StatelessWidget {
  homeController homeC = Get.put(homeController());

  @override
  Widget build(BuildContext context) {
    final hp = MediaQuery.of(context).size.height;
    final wp = MediaQuery.of(context).size.width;

    homeC.connectMQTT();

    return Scaffold(
      body: Container(
        width: wp,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/background.jpg"),
                fit: BoxFit.cover)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: hp * 0.1),
            Text(
              "Temperature",
              style: TextStyle(
                  fontSize: wp * 0.09,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  letterSpacing: 3),
            ),
            SizedBox(height: hp * 0.02),
            Obx(() => Text(
                  "${homeC.homeM.suhu.value}°",
                  style: TextStyle(
                      fontSize: hp * 0.1,
                      fontWeight: FontWeight.w300,
                      color: Colors.white),
                )),
            Obx(
              () => Text(
                "Humidity: ${homeC.homeM.kelembapan.value}",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: wp * 0.05),
              ),
            ),
            Spacer(),
            Stack(
              children: [
                Container(
                  height: hp * 0.46,
                  width: wp * 1,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/House.png"),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Stack(
                  children: [
                    // Blurred image container
                    Container(
                      margin: EdgeInsets.only(top: hp * 0.37),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(50),
                          topRight: Radius.circular(50),
                        ),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                          child: Container(
                            height: hp * 0.25,
                            width: wp * 1,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/images/bottom1.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: hp * 0.52,
                      width: wp * 1,
                      child: Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Color.fromRGBO(50, 51, 94, 90).withOpacity(0.5),
                            padding: EdgeInsets.symmetric(
                                horizontal: wp * 0.3, vertical: 15),
                          ),
                          onPressed: () => homeC.ledControl(),
                          child: Obx(() => Icon(
                                homeC.homeM.ledStatus.value == '1'
                                    ? Icons.lightbulb
                                    : Icons.lightbulb_outline,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

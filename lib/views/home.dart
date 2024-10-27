import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iot_firebase/controllers/homeController.dart';
import 'package:iot_firebase/firebase_options.dart';

class home extends StatelessWidget {
  final homeC = Get.put(homeController());
  // home({super.key});

  @override
  Widget build(BuildContext context) {
    final hp = MediaQuery.of(context).size.height;
    final wp = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: wp * 1,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/background.jpg"),
                  fit: BoxFit.cover)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: hp * 0.1),
                child: Text(
                  "Temperature",
                  style: TextStyle(
                      fontFamily: "SFProDisplay",
                      fontSize: wp * 0.09,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      wordSpacing: 6,
                      letterSpacing: 3),
                ),
              ),
              Container(
                height: hp * 0.12,
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: (Text(
                          "${homeC.homeM.suhu.value}",
                          style: TextStyle(
                              fontFamily: "SFProDisplay",
                              fontSize: hp * 0.1,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        )),
                      ),
                      Container(
                        height: hp,
                        child: Text(
                          "°",
                          style: TextStyle(
                              fontFamily: "SFProDisplay",
                              fontSize: hp * 0.07,
                              fontWeight: FontWeight.w300,
                              color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 4,
              ),
              Container(
                child: Text(
                  "Mostly Clear",
                  style: TextStyle(
                      color: Color.fromRGBO(205, 200, 222, 1),
                      fontFamily: "SFProDisplay",
                      fontSize: wp * 0.043,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'H : ${homeC.homeM.kelembapan.value}°',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "SFProDisplay",
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        "  |  ",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "SFProDisplay",
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        'L : ${homeC.homeM.led.value}',
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "SFProDisplay",
                            fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
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
                        margin: EdgeInsets.only(top: 327),
                        child: ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: Container(
                              height: hp * 0.25,
                              width: wp * 1,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image:
                                      AssetImage("assets/images/bottom1.png"),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 450,
                        width: wp * 1,
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 2,
                              fixedSize: Size(wp * 0.8, 70),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              backgroundColor: Color.fromRGBO(50, 51, 94, 90)
                                  .withOpacity(0.5),
                            ),
                            onPressed: () => homeC.ledControl(),
                            child: Obx(
                              () => Icon(
                                homeC.homeM.led.value == "1"
                                    ? Icons.lightbulb
                                    : Icons.lightbulb_outline,
                                size: hp * 0.04,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

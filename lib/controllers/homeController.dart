import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_firebase/models/homeModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iot_firebase/models/homeModel.dart';

class homeController extends GetxController {
  final homeM = homeModel();

  final DatabaseReference databaseRef = FirebaseDatabase.instance.ref();

  @override
  void onInit() {
    super.onInit();
    _getDataFromDatabase();
  }

  void _getDataFromDatabase() {
    databaseRef.child('esiot-db').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      homeM.kelembapan.value = data['kelembapan'].toString();
      homeM.led.value = data['led'].toString();
      homeM.suhu.value = data['suhu'].toInt().toString();
    });
  }

  void ledControl() {
    homeM.valueLed.value = !homeM.valueLed.value;
    updateLedValueInFirebase();
  }

  void updateLedValueInFirebase() {
    // Mengubah nilai 'led' di Firebase
    databaseRef.child('esiot-db').update({
      'led': homeM.valueLed.value ? '1' : '0' // 1 untuk true, 0 untuk false
    });
  }
}

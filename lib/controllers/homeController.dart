import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_firebase/models/homeModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iot_firebase/models/homeModel.dart';

class homecontroller extends GetxController {
  final homeM = homeModel();

  final DatabaseReference databaseRef =
      FirebaseDatabase.instance.ref(); // Tambahkan referensi database

  void ledControl() {
    homeM.valueLed.value = !homeM.valueLed.value; // Mengubah nilai lokal
    updateLedValueInFirebase(); // Memperbarui nilai di Firebase
  }

  void updateLedValueInFirebase() {
    // Mengubah nilai 'led' di Firebase
    databaseRef.child('esiot-db').update({
      'led': homeM.valueLed.value ? '1' : '0' // 1 untuk true, 0 untuk false
    });
  }
}

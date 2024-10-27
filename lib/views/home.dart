import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';
import 'package:iot_firebase/controllers/homeController.dart';
import 'package:iot_firebase/firebase_options.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  final homeC = Get.put(homecontroller());
  final databaseRef = FirebaseDatabase.instance.ref(); // Referensi database
  String kelembapan = '';
  String led = '';
  String suhu = '';

  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }

  void _getDataFromDatabase() {
    databaseRef.child('esiot-db').onValue.listen((event) {
      final data = event.snapshot.value as Map<dynamic, dynamic>;
      setState(() {
        kelembapan = data['kelembapan'].toString();
        led = data['led'].toString();
        suhu = data['suhu'].toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('IoT Data Viewer'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kelembapan: $kelembapan'),
              Text('LED Status: $led'),
              Text('Suhu: $suhu'),
              ElevatedButton(
                onPressed: () =>
                    homeC.ledControl(), // Memanggil ledControl dari controller
                child: Text('Ganti LED'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

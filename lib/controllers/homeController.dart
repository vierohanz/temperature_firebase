import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iot_firebase/models/homeModel.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:iot_firebase/models/homeModel.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class homeController extends GetxController {
  late homeModel homeM;
  late MqttServerClient client;

  @override
  void onInit() {
    super.onInit();
    homeM = homeModel();
    // Listener saat suhu berubah
    ever(homeM.suhu, (value) {
      print("Suhu berubah: $value");
    });

    // Listener saat kelembapan berubah
    ever(homeM.kelembapan, (value) {
      print("Kelembapan berubah: $value");
    });

    // Listener dengan interval untuk LED Status
    interval(homeM.ledStatus, (value) {
      print("LED Status diperbarui: $value");
    }, time: Duration(seconds: 1));

    connectMQTT();
  }

  void connectMQTT() async {
    client = MqttServerClient('192.168.144.78', '');
    client.logging(on: false);
    client.onDisconnected = onDisconnected;
    client.onConnected = onConnected;
    client.onSubscribed = onSubscribed;

    final connMessage = MqttConnectMessage()
        .withClientIdentifier('Flutter_Client')
        .authenticateAs('uas24_hannan', 'uas24_hannan')
        .withWillTopic('UAS24-IOT/Status')
        .withWillMessage('0')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client.connectionMessage = connMessage;

    try {
      await client.connect();
    } catch (e) {
      print('Exception: $e');
      client.disconnect();
    }

    if (client.connectionStatus!.state == MqttConnectionState.connected) {
      print('Connected to MQTT');
      client.subscribe('UAS24-IOT/43322121/SUHU', MqttQos.atLeastOnce);
      client.subscribe('UAS24-IOT/43322121/KELEMBAPAN', MqttQos.atLeastOnce);
      client.subscribe('UAS24-IOT/Status', MqttQos.atLeastOnce);

      client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {
        final recMess = c[0].payload as MqttPublishMessage;
        final payload =
            MqttPublishPayload.bytesToStringAsString(recMess.payload.message);

        print("Data diterima pada topik ${c[0].topic}: $payload");

        if (c[0].topic == 'UAS24-IOT/43322121/SUHU') {
          var data = payload.split(',');
          homeM.suhu.value = data[0];
        } else if (c[0].topic == 'UAS24-IOT/Status') {
          homeM.ledStatus.value = payload;
        } else if (c[0].topic == 'UAS24-IOT/43322121/KELEMBAPAN') {
          var data = payload.split(',');
          homeM.kelembapan.value = data[0];
        }
      });
    } else {
      print('Connection failed - status is ${client.connectionStatus}');
    }
  }

  void ledControl() {
    String message = homeM.ledStatus.value == '1' ? '0' : '1';
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(
        'UAS24-IOT/Status', MqttQos.atLeastOnce, builder.payload!);
  }

  void onDisconnected() {
    print('Disconnected from MQTT');
  }

  void onConnected() {
    print('Connected to MQTT');
  }

  void onSubscribed(String topic) {
    print('Subscribed to $topic');
  }
}

import 'package:get/get.dart';

// homeModel.dart
class homeModel {
  RxString suhu = '0'.obs;
  RxString kelembapan = '0'.obs;
  RxString ledStatus = '0'.obs;

  homeModel({
    String? suhu,
    String? kelembapan,
    String? ledStatus,
  }) {
    this.suhu = (suhu ?? '0').obs;
    this.kelembapan = (kelembapan ?? '0').obs;
    this.ledStatus = (ledStatus ?? '0').obs;
  }
}

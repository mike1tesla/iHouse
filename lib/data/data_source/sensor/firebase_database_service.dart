import 'package:firebase_database/firebase_database.dart';

import '../../models/sensor/DHT.dart';

class FirebaseDatabaseService {
  Future<void> setDataLedAnalog(double analog) async {
    DatabaseReference ledRef = FirebaseDatabase.instance.ref("Led");
    await ledRef.update({
      "analog": analog,
    });
  }

  Future<void> setDataLedDigital(bool digital) async {
    DatabaseReference ledRef = FirebaseDatabase.instance.ref("Led");
    await ledRef.update({
      "digital": digital,
    });
  }

  Future<void> getDataSensor() async {
    DatabaseReference sensorRef = FirebaseDatabase.instance.ref('Sensor');
    sensorRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
    });

    // DatabaseReference dhtRef = FirebaseDatabase.instance.ref('Sensor/DHT');
    // dhtRef.onValue.listen((DatabaseEvent event) {
    //   final data = event.snapshot.value as Map<dynamic, dynamic>;
    //   print(data);
    // });
  }

  Future<DHT?> getDataDHT() async {
    DatabaseReference dhtRef = FirebaseDatabase.instance.ref('Sensor/DHT');
    final snapshot = await dhtRef.get();

    if (snapshot.exists) {
      final dhtData = snapshot.value as Map<dynamic, dynamic>;
      return DHT.fromJson(dhtData); // Tạo và trả về object DHT
    } else {
      print('No data available.');
    }
    return null; // Trả về null nếu không có dữ liệu
  }
}

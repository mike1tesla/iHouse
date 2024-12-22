import 'package:firebase_database/firebase_database.dart';

abstract class LedFirebaseDatabaseService {
  Future<void> setDataLedAnalog({required double analog});
  Future<void> setDataLedDigital({required bool digital});
  Future<void> setDataLedAirCondition({required bool digitalAir});
}

class LedFirebaseDatabaseServiceImpl extends LedFirebaseDatabaseService {
  @override
  Future<void> setDataLedAnalog({required double analog}) async {
    DatabaseReference ledRef = FirebaseDatabase.instance.ref("Led");
    await ledRef.update({
      "analog": analog,
    });
  }

  @override
  Future<void> setDataLedDigital({required bool digital}) async {
    DatabaseReference ledRef = FirebaseDatabase.instance.ref("Led");
    await ledRef.update({
      "digital": digital,
    });
  }

  @override
  Future<void> setDataLedAirCondition({required bool digitalAir}) async {
    DatabaseReference ledRef = FirebaseDatabase.instance.ref("Led");
    await ledRef.update({
      "air": digitalAir,
    });
  }
}

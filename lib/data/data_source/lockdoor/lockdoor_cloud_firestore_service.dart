import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';

import '../../models/lockdoor/lockdoor.dart';

abstract class LockdoorCloudFirestoreService {
  Future<List<LockdoorEntity>> fetchLockdoors();

  Future<void> saveLockdoors(List<LockdoorEntity> lockdoors);

  Future<List<LockdoorEntity>> getHistoryLockdoors();
}

class LockdoorCloudFirestoreServiceImpl extends LockdoorCloudFirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<LockdoorEntity>> fetchLockdoors() async {
    QuerySnapshot snapshot = await firestore.collection('lockdoor').get();
    return snapshot.docs.map((doc) {
      return LockdoorModel.fromFirestore(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  @override
  Future<void> saveLockdoors(List<LockdoorEntity> lockdoors) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(
      lockdoors.map((e) => (e as LockdoorModel).toJson()).toList(),
    );
    await prefs.setString('historyLockdoor', jsonString);
  }

  @override
  Future<List<LockdoorEntity>> getHistoryLockdoors() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('historyLockdoor');
    if (jsonString != null) {
      List<dynamic> jsonData = jsonDecode(jsonString);
      return jsonData.map((e) => LockdoorModel.fromJson(e)).toList();
    }
    return [];
  }
}

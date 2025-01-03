import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';

import '../../models/lockdoor/lockdoor.dart';

abstract class LockdoorCloudFirestoreService {
  Future<List<LockdoorEntity>> fetchLockdoors();

  Future<LockdoorEntity?> getLatestLockdoor();
}

class LockdoorCloudFirestoreServiceImpl extends LockdoorCloudFirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<LockdoorEntity>> fetchLockdoors() async {
    QuerySnapshot snapshot = await firestore.collection('lockdoor').orderBy('unlock_time', descending: true).get();
    return snapshot.docs.map((doc) {
      return LockdoorModel.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  @override
  Future<LockdoorEntity?> getLatestLockdoor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('historyLockdoor');
    if (jsonString != null) {
      List<dynamic> jsonData = jsonDecode(jsonString);
      List<LockdoorModel> lockdoors = jsonData.map((e) => LockdoorModel.fromJson(e)).toList();
      return lockdoors.isNotEmpty ? lockdoors.first : null;
    }
    return null;
  }
}

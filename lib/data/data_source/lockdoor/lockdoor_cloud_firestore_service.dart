import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';

import '../../models/lockdoor/lockdoor.dart';

abstract class LockdoorCloudFirestoreService {
  Future<List<LockdoorEntity>> fetchLockdoors();
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
}

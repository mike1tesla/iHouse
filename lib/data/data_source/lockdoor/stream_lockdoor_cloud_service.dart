import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:smart_iot/data/models/lockdoor/lockdoor.dart';
import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';

abstract class StreamLockdoorCloudService {
  Stream<Either<Exception, List<LockdoorEntity>>> streamLockdoor();
}

class StreamLockdoorCloudServiceImpl extends StreamLockdoorCloudService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Stream<Either<Exception, List<LockdoorEntity>>> streamLockdoor() async* {
    try {
      final stream = firestore.collection('lockdoor').orderBy('unlock_time', descending: true).snapshots();

      yield* stream.map((snapshot) {
        final lockdoors = snapshot.docs.map((doc) {
          return LockdoorModel.fromJson(doc.data());
        }).toList();
        return Right(lockdoors);
      });
    } catch (e) {
      yield Left(Exception('Lỗi khi lấy dữ liệu: $e'));
    }
  }
}

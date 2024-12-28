import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';

class LockdoorModel extends LockdoorEntity {
  LockdoorModel({
    required super.tags,
    required super.unlockTime,
    required super.unlockState,
  });

  factory LockdoorModel.fromJson(Map<String, dynamic> json) {
    return LockdoorModel(
      tags: json['tags'],
      unlockTime: json['unlockTime'],
      unlockState: json['unlockState'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tags': tags,
      'unlockTime': unlockTime,
      'unlockState': unlockState,
    };
  }

  factory LockdoorModel.fromFirestore(Map<String, dynamic> data) {
    return LockdoorModel.fromJson(data);
  }
}

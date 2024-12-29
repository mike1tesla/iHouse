import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';

class LockdoorModel extends LockdoorEntity {
  LockdoorModel({
    required super.tags,
    required super.unlockTime,
    required super.unlockState,
  });

  factory LockdoorModel.fromJson(Map<String, dynamic> json) {
    return LockdoorModel(
      tags: json['tags'] ?? 'Unknown', // Giá trị mặc định nếu null
      unlockTime: json['unlock_time'] ?? 'N/A', // Giá trị mặc định nếu null
      unlockState: json['unlock_state'] ?? false, // Giá trị mặc định nếu null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tags': tags,
      'unlockTime': unlockTime,
      'unlockState': unlockState,
    };
  }
}

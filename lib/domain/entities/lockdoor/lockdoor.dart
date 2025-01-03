class LockdoorEntity {
  final String tags;
  final String unlockTime;
  final bool unlockState;

  LockdoorEntity({
    required this.tags,
    required this.unlockTime,
    required this.unlockState,
  });

  // Factory constructor to parse from Firestore data
  factory LockdoorEntity.fromFirestore(Map<String, dynamic> data) {
    return LockdoorEntity(
      tags: data['tags'] ?? 'Unknown',
      unlockTime: data['unlock_time'] ?? 'Unknown',
      unlockState: data['unlock_state'] ?? false,
    );
  }
}

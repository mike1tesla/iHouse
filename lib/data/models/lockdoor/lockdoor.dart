class Lockdoor {
  final String tags;
  final String unlockTime;
  final bool unlockState;

  const Lockdoor({
    required this.tags,
    required this.unlockTime,
    required this.unlockState,
  });

  Map<String, dynamic> toJson() {
    return {
      'tags': this.tags,
      'unlockTime': this.unlockTime,
      'unlockState': this.unlockState,
    };
  }

  factory Lockdoor.fromJson(Map<String, dynamic> json) {
    return Lockdoor(
      tags: json['tags'] as String,
      unlockTime: json['unlockTime'] as String,
      unlockState: json['unlockState'] as bool,
    );
  }
}
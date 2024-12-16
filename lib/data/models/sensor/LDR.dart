class LDR {
  final int ldrData;
  final double voltage;

  const LDR({
    required this.ldrData,
    required this.voltage,
  });

  Map<String, dynamic> toJson() {
    return {
      'ldrData': this.ldrData,
      'voltage': this.voltage,
    };
  }

  factory LDR.fromJson(Map<String, dynamic> json) {
    return LDR(
      ldrData: json['ldrData'] as int,
      voltage: json['voltage'] as double,
    );
  }
}
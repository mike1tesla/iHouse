class DHT {
  double humi;
  double temp;

  DHT({required this.humi, required this.temp});

  Map<String, dynamic> toJson() {
    return {
      'humi': this.humi,
      'temp': this.temp,

    };
  }
  factory DHT.fromJson(Map<dynamic, dynamic> json) {
    return DHT(
      temp: (json['temp'] is int) ? (json['temp'] as int).toDouble() : json['temp'] as double,
      humi: (json['humi'] is int) ? (json['humi'] as int).toDouble() : json['humi'] as double,
    );
  }
}
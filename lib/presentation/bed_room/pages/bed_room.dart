import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_iot/common/widgets/appbar/app_bar.dart';

import '../../../common/widgets/my_sensor_card/my_sensor_card.dart';
import '../../../data/models/sensor/DHT.dart';
import '../../../data/models/sensor/LDR.dart';

class BedRoomPage extends StatefulWidget {
  const BedRoomPage({super.key});

  @override
  State<BedRoomPage> createState() => _BedRoomPageState();
}

class _BedRoomPageState extends State<BedRoomPage> {
  double humi = 24.1, temp = 62.3;
  List<double> listTemp = [24.1, 24.3, 24.4, 24.0, 23.9, 24.5, 24.3],
      listHumi = [64.1, 64.4, 64.3, 64.4, 63.8, 64.7, 64.4];
  LDR lightSensor = const LDR(ldrData: 3700, voltage: 2.978);
  bool isSwitched = false;
  double _currentValue = 50;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        backgroundColor: Colors.green.shade100,
        title: const Text(
          "Bed Room",
          style: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 25,
            color: Colors.green,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildChartDHT(),
              const SizedBox(height: 30),
              _buildSensorLDR(),
              const SizedBox(height: 30),
              _buildAirCondition(),
              const SizedBox(height: 30),
              _buildLedAnalog(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChartDHT() {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref('Sensor/DHT').onValue,
      builder: (context, snapshot) {
        if (snapshot.hasData && !snapshot.hasError && snapshot.data?.snapshot.value != null) {
          // print(snapshot.data?.snapshot.value.toString());
          var dht = DHT.fromJson(snapshot.data!.snapshot.value as Map<dynamic, dynamic>);
          humi = dht.humi;
          temp = dht.temp;
          listHumi.add(dht.humi);
          listTemp.add(dht.temp);
          // print('DHT: humi -> ${dht.humi}, temp -> ${dht.temp}');
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.3,
                child: MySensorCard(
                  value: humi,
                  unit: '%',
                  name: 'Humidity',
                  trendData: listHumi,
                  linePoint: Colors.blueAccent,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: AspectRatio(
                aspectRatio: 1.3,
                child: MySensorCard(
                  value: temp,
                  unit: '\'C',
                  name: 'Temperature',
                  trendData: listTemp,
                  linePoint: Colors.redAccent,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  Widget _buildSensorLDR() {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: Colors.green.shade300,
          boxShadow: const [BoxShadow(offset: Offset(3, 3), color: Colors.grey, blurRadius: 5)],
          border: Border.all()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Light Sensor", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "LDR Data: ${lightSensor.ldrData}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              Text(
                "Voltage: ${lightSensor.voltage}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAirCondition() {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Colors.green, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: const [BoxShadow(offset: Offset(3, 3), color: Colors.grey, blurRadius: 5)],
          border: Border.all()),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Expanded(
            child: Text(
              "Air Conditioner Control",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
            ),
          ),
          Expanded(
            child: SwitchListTile(
              title: Text(isSwitched ? 'ON' : 'OFF', style: const TextStyle(fontWeight: FontWeight.w500),),
              value: isSwitched,
              onChanged: (bool value) {
                setState(() {
                  isSwitched = value;
                });
              },
              activeTrackColor: Colors.green, // Màu của track khi ON
              activeColor: Colors.white, // Màu của thumb khi ON
              inactiveTrackColor: Colors.red, // Màu của track khi OFF
              inactiveThumbColor: Colors.white, // Màu của thumb khi OFF
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLedAnalog() {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Colors.white, Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: const [BoxShadow(offset: Offset(3, 3), color: Colors.grey, blurRadius: 5)],
          border: Border.all()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Slider(
            value: _currentValue, // Giá trị hiện tại của Slider
            min: 0, // Giá trị nhỏ nhất
            max: 100, // Giá trị lớn nhất
            divisions: 100, // Chia thanh trượt thành 100 đơn vị
            label: _currentValue.toInt().toString(), // Hiển thị giá trị khi kéo
            onChanged: (double value) {
              setState(() {
                _currentValue = value; // Cập nhật giá trị khi kéo thanh trượt
              });
            },
            activeColor: Colors.blue, // Màu thanh trượt đã kéo
            inactiveColor: Colors.grey, // Màu thanh trượt chưa kéo
          ),
          const Text("Led Analog Control", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
        ],
      ),
    );
  }
}

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_iot/common/widgets/appbar/app_bar.dart';
import 'package:smart_iot/presentation/bed_room/bloc/bed_room_cubit.dart';

import '../../../common/widgets/my_sensor_card/my_sensor_card.dart';
import '../../../data/models/sensor/DHT.dart';
import '../../../data/models/sensor/LDR.dart';

class BedRoomPage extends StatefulWidget {
  const BedRoomPage({super.key});

  @override
  State<BedRoomPage> createState() => _BedRoomPageState();
}

class _BedRoomPageState extends State<BedRoomPage> {
  double humi = 0, temp = 0;
  List<double> listTemp = [], listHumi = [];
  LDR lightSensor = const LDR(ldrData: 3700, voltage: 2.978);

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
      body: Builder(builder: (context) {
        return BlocBuilder<BedRoomCubit, BedRoomState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildChartDHT(),
                    const SizedBox(height: 30),
                    _buildSensorLDR(),
                    const SizedBox(height: 30),
                    _buildAirCondition(state, context),
                    const SizedBox(height: 30),
                    _buildLedAnalog(state, context),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildChartDHT() {
    return StreamBuilder(
      stream: FirebaseDatabase.instance.ref('Sensor/DHT11').onValue,
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

  Widget _buildAirCondition(BedRoomState state, BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [Colors.green, Colors.grey.shade300],
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
              title: Text(
                state.isAirSwitched ? 'ON' : 'OFF',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              value: state.isAirSwitched,
              onChanged: (bool value) => context.read<BedRoomCubit>().setDataLedAirCondition(digitalAir: value),
              activeTrackColor: Colors.green,
              // Màu của track khi ON
              activeColor: Colors.white,
              // Màu của thumb khi ON
              inactiveTrackColor: Colors.red,
              // Màu của track khi OFF
              inactiveThumbColor: Colors.white, // Màu của thumb khi OFF
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLedAnalog(BedRoomState state, BuildContext context) {
    return Container(
      height: 150,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.green],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: const [BoxShadow(offset: Offset(3, 3), color: Colors.grey, blurRadius: 5)],
          border: Border.all()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Slider(
            value: state.currentValueAnalog,
            // Giá trị hiện tại của Slider
            min: 0,
            // Giá trị nhỏ nhất
            max: 100,
            // Giá trị lớn nhất
            divisions: 100,
            // Chia thanh trượt thành 100 đơn vị
            label: state.currentValueAnalog.toInt().toString(),
            // Hiển thị giá trị khi kéo
            onChanged: (double value) => context.read<BedRoomCubit>().setDataLedAnalog(analog: value),
            activeColor: Colors.blue,
            // Màu thanh trượt đã kéo
            inactiveColor: Colors.grey, // Màu thanh trượt chưa kéo
          ),
          const Text("Led Analog Control", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
        ],
      ),
    );
  }
}

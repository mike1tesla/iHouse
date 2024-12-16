import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_iot/data/models/lockdoor/lockdoor.dart';
import 'package:smart_iot/data/models/sensor/DHT.dart';
import 'package:smart_iot/presentation/bed_room/pages/bed_room.dart';
import 'package:smart_iot/presentation/living_room/pages/living_room.dart';

import '../../../common/widgets/appbar/app_bar.dart';
import '../../../common/widgets/my_sensor_card/my_sensor_card.dart';
import '../../../core/configs/assets/app_vectors.dart';
import '../../profile/pages/profile.dart';

class HousePage extends StatefulWidget {
  const HousePage({super.key});

  @override
  State<HousePage> createState() => _HousePageState();
}

class _HousePageState extends State<HousePage> {
  double humi = 24.1, temp = 62.3;
  List<double> listTemp = [24.1, 24.3, 24.4, 24.0, 23.9, 24.5, 24.3],
      listHumi = [64.1, 64.4, 64.3, 64.4, 63.8, 64.7, 64.4];
  final Lockdoor lockdoor = const Lockdoor(tags: "A29AF621", unlockTime: "2024-12-13 00:14:56", unlockState: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        hideBack: true,
        backgroundColor: Colors.green.shade100,
        action: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ProfilePage(),
              ),
            );
          },
          icon: const Icon(Icons.person, size: 35,),
        ),
        title: SvgPicture.asset(
          AppVectors.logo,
          height: 110,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildChartDHT(),
              const SizedBox(height: 30),
              _buildLockDoorControl(),
              const SizedBox(height: 20),
              _buildTextRoomControl(),
              const SizedBox(height: 20),
              _buildSelectRoom(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildChartDHT() {
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

  Widget _buildLockDoorControl() {
    return Container(
      height: 160,
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: lockdoor.unlockState ? Colors.green.shade300 : Colors.red.shade300,
          boxShadow: const [BoxShadow(offset: Offset(3, 3), color: Colors.grey, blurRadius: 5)],
          border: Border.all()),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Look Door Control", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              lockdoor.unlockState
                  ? const Icon(FontAwesomeIcons.lockOpen, color: Colors.black54, size: 40)
                  : const Icon(FontAwesomeIcons.lock, color: Colors.black54, size: 40),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ID Tag: ${lockdoor.tags}", style: Theme.of(context).textTheme.titleMedium),
                  Text("Time:: ${lockdoor.unlockTime}", style: Theme.of(context).textTheme.titleMedium),
                  Text("Status:: ${lockdoor.unlockState}", style: Theme.of(context).textTheme.titleMedium),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextRoomControl() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.green.shade300, width: 3)),
      ),
      child: const Text(
        "Room Control",
        textAlign: TextAlign.start,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
      ),
    );
  }

  Widget _buildSelectRoom() {
    return Row(
      children: [
        Expanded(
          child: _buildRoom(
            title: "Living Room",
            icon: FontAwesomeIcons.couch,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LivingRoomPage(),));
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildRoom(
            title: "Bed Room",
            icon: FontAwesomeIcons.bed,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BedRoomPage(),));

            },
          ),
        ),
      ],
    );
  }

  Widget _buildRoom({required VoidCallback onPressed, required String title, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 160,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.grey], // Danh sách màu
          begin: Alignment.topLeft, // Điểm bắt đầu gradient
          end: Alignment.bottomRight, // Điểm kết thúc gradient
        ),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon, size: 40),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onPressed,
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

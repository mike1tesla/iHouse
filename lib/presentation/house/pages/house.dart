import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_iot/data/models/sensor/DHT.dart';
import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';
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
  double humi = 0,
      temp = 0;
  List<double> listTemp = [],
      listHumi = [];
  LockdoorEntity? lockdoor;

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
          icon: const Icon(
            Icons.person,
            size: 35,
          ),
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
              const SizedBox(height: 30),
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
      stream: FirebaseDatabase.instance
          .ref('Sensor/DHT')
          .onValue,
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
    const String collectionName = 'lockdoor';
    final lockdoorStream = FirebaseFirestore.instance
        .collection(collectionName)
        .orderBy('unlock_time', descending: true) // Sắp xếp theo thời gian gần nhất
        .snapshots();

    return StreamBuilder<QuerySnapshot>(
      stream: lockdoorStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator(color: Colors.green,));
        }

        final docs = snapshot.data!.docs;
        if (docs.isEmpty) {
          return const Center(
            child: Text('No data available'),
          );
        }

        // Lấy tài liệu gần nhất và chuyển thành đối tượng LockdoorEntity
        final lockdoorData = docs.first.data() as Map<String, dynamic>;
        final lockdoor = LockdoorEntity.fromFirestore(lockdoorData);

        return Container(
          height: 160,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: lockdoor.unlockState
                ? Colors.green.shade300
                : Colors.red.shade300,
            boxShadow: const [
              BoxShadow(
                offset: Offset(3, 3),
                color: Colors.grey,
                blurRadius: 5,
              )
            ],
            border: Border.all(),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Text(
                "Lock Door Control",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  lockdoor.unlockState
                      ? const Icon(
                    FontAwesomeIcons.lockOpen,
                    color: Colors.black54,
                    size: 40,
                  )
                      : const Icon(
                    FontAwesomeIcons.lock,
                    color: Colors.black54,
                    size: 40,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "ID Tag: ${lockdoor.tags}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "Time: ${lockdoor.unlockTime}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        "Status: ${lockdoor.unlockState ? 'Unlocked' : 'Locked'}",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        );
      },
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
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LivingRoomPage(),
              ));
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildRoom(
            title: "Bed Room",
            icon: FontAwesomeIcons.bed,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const BedRoomPage(),
              ));
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
        gradient: LinearGradient(
          colors: [Colors.green, Colors.grey.shade400], // Danh sách màu
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

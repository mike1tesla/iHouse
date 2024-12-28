import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_iot/common/widgets/appbar/app_bar.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> historyStream = FirebaseFirestore.instance.collection('users').snapshots();
    return Scaffold(
      appBar: BasicAppBar(
        backgroundColor: Colors.green.shade100,
        hideBack: true,
        title: const Text(
          "History",
          style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 25,
              color: Colors.green,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
        child: buildHistory(listHistory),
      ),
    );
  }

  Widget buildHistory(List<dynamic> listHistory) {
    return ListView.separated(
        itemCount: listHistory.length,
        itemBuilder: (context, index) {
          return Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: listHistory[index].unlockState ? Colors.green.shade300 : Colors.red.shade300,
                boxShadow: const [BoxShadow(offset: Offset(3, 3), color: Colors.grey, blurRadius: 5)],
                border: Border.all()),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                listHistory[index].unlockState
                    ? const Icon(FontAwesomeIcons.lockOpen, color: Colors.black54, size: 40)
                    : const Icon(FontAwesomeIcons.lock, color: Colors.black54, size: 40),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("ID Tag: ${listHistory[index].tags}", style: Theme.of(context).textTheme.titleMedium),
                    Text("Time:: ${listHistory[index].unlockTime}", style: Theme.of(context).textTheme.titleMedium),
                    Text("Status:: ${listHistory[index].unlockState}",
                        style: Theme.of(context).textTheme.titleMedium),
                  ],
                )
              ],
            ),
          );
        },
        separatorBuilder: (BuildContext context, int index) {
          return const SizedBox(height: 25);
        },
      );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_iot/common/widgets/appbar/app_bar.dart';
import 'package:smart_iot/domain/entities/lockdoor/lockdoor.dart';
import 'package:smart_iot/presentation/history/bloc/lockdoor_cubit.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LockdoorCubit()..showLockdoors(),
      child: Scaffold(
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
        body: BlocBuilder<LockdoorCubit, LockdoorState>(
          builder: (context, state) {
            if (state is LockdoorLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is LockdoorLoaded) {
              return Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
                child: buildHistory(state),
              );
            }
            else if (state is LockdoorError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return const Center(child: Text('No data available.', style: TextStyle(fontSize: 25),));
          },
        ),
      ),
    );
  }

  Widget buildHistory(LockdoorLoaded state) {
    final List<LockdoorEntity> listHistory = state.lockdoors;
    print("build History: ${state.lockdoors}");
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
                  Text("Status:: ${listHistory[index].unlockState}", style: Theme.of(context).textTheme.titleMedium),
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

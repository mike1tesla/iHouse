import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:smart_iot/presentation/chatbox/pages/chatbox.dart';
import 'package:smart_iot/presentation/history/pages/history.dart';
import 'package:smart_iot/presentation/home/bloc/start_cubit.dart';
import 'package:smart_iot/presentation/home/bloc/start_state.dart';
import 'package:smart_iot/presentation/house/pages/house.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
      StartCubit()
        ..fetchStarts(),
      child: Builder(
          builder: (context) {
            return BlocBuilder<StartCubit, StartState>(
              builder: (context, state) {
                if (state is StartLoading) {
                  return const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(color:  Colors.green,),
                    ),
                  );
                } else if (state is StartLoaded) {
                  return const HomePage();
                }
                return const Scaffold(
                  body: Center(
                    child: Text('Initial...'),
                  ),
                );
              }
            );
          }
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 1;

  // List of screens for each tab
  final List<Widget> _widgetOptions = <Widget>[
    const HistoryPage(),
    const HousePage(),
    ChatBoxPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.green,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.clockRotateLeft),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.message),
            label: 'Chatbox AI',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

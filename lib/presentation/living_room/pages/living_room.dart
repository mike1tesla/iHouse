import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_iot/common/widgets/appbar/app_bar.dart';
import 'package:smart_iot/common/widgets/button/basic_app_button.dart';

class LivingRoomPage extends StatefulWidget {
  const LivingRoomPage({super.key});

  @override
  State<LivingRoomPage> createState() => _LivingRoomPageState();
}

class _LivingRoomPageState extends State<LivingRoomPage> {
  bool isSwitched = false;
  double brightness = 0;
  double numbersLed = 0;
  double red = 0;
  double green = 0;
  double blue = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppBar(
        backgroundColor: Colors.green.shade100,
        title: const Text(
          "Living Room",
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
            children: [_buildLedDigital(), const SizedBox(height: 30), _buildLedRGBControl()],
          ),
        ),
      ),
    );
  }

  Widget _buildLedDigital() {
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
              "Led Digital Control",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
            ),
          ),
          Expanded(
            child: SwitchListTile(
              title: Text(
                isSwitched ? 'ON' : 'OFF',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              value: isSwitched,
              onChanged: (bool value) {
                setState(() {
                  isSwitched = value;
                });
              },
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

  Widget _buildLedRGBControl() {
    return Container(
      height: 550,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Text("Led RGB Control", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26)),
          setupValueSlider(
            title: "Brightness",
            currentValue: brightness,
            max: 100,
            divisions: 100,
            activeColor: Colors.deepPurple,
            onChanged: (double value) {
              setState(() {
                brightness = value; // Cập nhật giá trị khi kéo thanh trượt
              });
            },
          ),
          setupValueSlider(
            title: "Numbers Led",
            currentValue: numbersLed,
            divisions: 8,
            max: 8,
            activeColor: Colors.deepPurple,
            onChanged: (double value) {
              setState(() {
                numbersLed = value; // Cập nhật giá trị khi kéo thanh trượt
              });
            },
          ),
          setupValueSlider(
            title: "Red Color",
            currentValue: red,
            divisions: 255,
            max: 255,
            activeColor: Colors.red,
            onChanged: (double value) {
              setState(() {
                red = value; // Cập nhật giá trị khi kéo thanh trượt
              });
            },
          ),
          setupValueSlider(
            title: "Green Color",
            currentValue: green,
            divisions: 255,
            max: 255,
            activeColor: Colors.green,
            onChanged: (double value) {
              setState(() {
                green = value; // Cập nhật giá trị khi kéo thanh trượt
              });
            },
          ),
          setupValueSlider(
            title: "Red Color",
            currentValue: blue,
            divisions: 255,
            max: 255,
            activeColor: Colors.blue,
            onChanged: (double value) {
              setState(() {
                blue = value; // Cập nhật giá trị khi kéo thanh trượt
              });
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50!),
              ),
              child: const Text("SET Led RGB",style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          )
        ],
      ),
    );
  }

  Widget setupValueSlider({
    required String title,
    required double currentValue,
    required int divisions,
    required double max,
    required Color activeColor,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Slider(
          value: currentValue,
          min: 0,
          max: max,
          divisions: divisions,
          // Chia thanh trượt thành d đơn vị
          label: currentValue.toInt().toString(),
          onChanged: onChanged,
          activeColor: activeColor,
          inactiveColor: Colors.grey, // Màu thanh trượt chưa kéo
        ),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
      ],
    );
  }
}

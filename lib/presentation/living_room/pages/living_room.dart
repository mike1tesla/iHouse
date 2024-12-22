import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_iot/common/widgets/appbar/app_bar.dart';
import 'package:smart_iot/domain/entities/led/RGB.dart';
import 'package:smart_iot/presentation/living_room/bloc/set_led_living_cubit.dart';

class LivingRoomPage extends StatelessWidget {
  const LivingRoomPage({super.key});

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
      body: Builder(builder: (context) {
        return BlocBuilder<SetLedLivingCubit, SetLedLivingState>(
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 30, left: 16, right: 16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildLedDigital(state, context),
                    const SizedBox(height: 30),
                    _buildLedRGBControl(state, context),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildLedDigital(SetLedLivingState state, BuildContext context) {
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
                state.isSwitched ? 'ON' : 'OFF',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              value: state.isSwitched,
              onChanged: (bool value) {
                context.read<SetLedLivingCubit>().setDataLedDigital(digital: value);
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

  Widget _buildLedRGBControl(SetLedLivingState state, BuildContext context) {
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
            currentValue: state.brightness,
            max: 100,
            divisions: 100,
            activeColor: Colors.deepPurple,
            onChanged: (double value) => context.read<SetLedLivingCubit>().updateBrightness(value),
          ),
          setupValueSlider(
            title: "Numbers Led",
            currentValue: state.numbersLed,
            divisions: 8,
            max: 8,
            activeColor: Colors.deepPurple,
            onChanged: (double value) => context.read<SetLedLivingCubit>().updateNumbersLed(value),
          ),
          setupValueSlider(
            title: "Red Color",
            currentValue: state.red,
            divisions: 255,
            max: 255,
            activeColor: Colors.red,
            onChanged: (double value) => context.read<SetLedLivingCubit>().updateColors(red: value),
          ),
          setupValueSlider(
            title: "Green Color",
            currentValue: state.green,
            divisions: 255,
            max: 255,
            activeColor: Colors.green,
            onChanged: (double value) => context.read<SetLedLivingCubit>().updateColors(green: value),
          ),
          setupValueSlider(
            title: "Red Color",
            currentValue: state.blue,
            divisions: 255,
            max: 255,
            activeColor: Colors.blue,
            onChanged: (double value) => context.read<SetLedLivingCubit>().updateColors(blue: value),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ElevatedButton(
              onPressed: () {
                context.read<SetLedLivingCubit>().setDataLedRGB(
                      rgb: RGBEntity(
                        brightness: state.brightness,
                        numbersLed: state.numbersLed,
                        red: state.red,
                        green: state.green,
                        blue: state.blue,
                      ),
                    );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: const Text("SET Led RGB",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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

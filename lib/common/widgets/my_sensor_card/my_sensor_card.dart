import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:flutter/material.dart';

class MySensorCard extends StatelessWidget {
  const MySensorCard(
      {super.key,
      required this.value,
      required this.name,
      // this.assetImage,
      required this.unit,
      required this.trendData,
      required this.linePoint});

  final double value;
  final String name;
  final String unit;
  final List<double> trendData;
  final Color linePoint;

  // final AssetImage? assetImage;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width *0.8,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Colors.green, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [BoxShadow(offset: Offset(3, 3), color: Colors.grey, blurRadius: 5)],
        border: Border.all(),
      ),
      height: 200,
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$name: $value$unit',
                  style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w500
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              child: Sparkline(
                data: trendData,
                lineWidth: 3.0,
                lineColor: Colors.white60,
                fillColor: Colors.transparent,
                averageLine: true,
                averageLineColor: Colors.white,
                fillMode: FillMode.above,
                sharpCorners: false,
                pointsMode: PointsMode.last,
                pointSize: 20,
                pointColor: linePoint,
                useCubicSmoothing: true,
                lineGradient: LinearGradient(colors: [Colors.white, linePoint]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

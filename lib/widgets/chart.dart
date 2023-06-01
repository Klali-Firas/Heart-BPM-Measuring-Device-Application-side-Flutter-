import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart({
    super.key,
    required this.spots,
    required this.min,
    required this.max,
  });
  final List<FlSpot> spots;
  final double max;
  final double min;

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
            getTouchLineStart: (data, index) => data.spots[index].y,
            touchTooltipData: LineTouchTooltipData(
                getTooltipItems: (touchedSpots) {
                  var val = touchedSpots[0].y;
                  return [
                    LineTooltipItem(
                      "$val",
                      const TextStyle(color: Colors.pink),
                    )
                  ];
                },
                tooltipBgColor: Colors.white,
                tooltipBorder: const BorderSide(color: Colors.pink))),
        clipData: FlClipData.all(),
        titlesData: FlTitlesData(
          topTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
                interval: 2,
                showTitles: true,
                reservedSize: 30,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt() % 2 == 0 ? value.toInt().toString() : "",
                    style: const TextStyle(color: Colors.grey),
                  );
                }),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              interval: 2,
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                String text = "";
                if (value.toInt() % 20 == 0) {
                  text = value.toInt().toString();
                  if (value.toInt() / 100 < 1) {
                    text = "  $text";
                  }
                  if (value.toInt() == 0) {
                    text = "  $text";
                  }
                }
                return Text(
                  text,
                  style: const TextStyle(color: Colors.grey),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
            show: true, drawHorizontalLine: true, drawVerticalLine: false),
        borderData: FlBorderData(
            show: false,
            border: Border.all(
              width: 1,
              style: BorderStyle.solid,
            )),
        lineBarsData: [
          LineChartBarData(
            shadow: const Shadow(
                color: Color.fromARGB(100, 158, 158, 158),
                offset: Offset(0, 15),
                blurRadius: 1),
            gradient: const LinearGradient(colors: [Colors.red, Colors.pink]),
            isCurved: true,
            curveSmoothness: 0.35,
            preventCurveOverShooting: false,
            barWidth: 3,
            dotData: FlDotData(
              show: false,
            ),
            spots: spots,
          )
        ],
        backgroundColor: const Color.fromARGB(255, 255, 247, 247),
        minX: spots.length <= 12 ? 0 : (spots.length - 13).toDouble(),
        maxX: spots.length <= 12 ? 12 : spots.length - 1.toDouble(),
        minY: min - 20,
        maxY: max + 20,
      ),
    );
  }
}

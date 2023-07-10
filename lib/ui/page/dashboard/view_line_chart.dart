import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class ViewLineChart extends StatefulWidget {
  const ViewLineChart({Key? key}) : super(key: key);

  @override
  State<ViewLineChart> createState() => _ViewLineChartState();
}

class _ViewLineChartState extends State<ViewLineChart> {
  List<Color> gradientColorsBlue = [
    Colors.cyan,
    Colors.blue,
  ];

  List<Color> gradientColorsRed = [
    Colors.redAccent,
    Colors.red,
  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          child: Stack(
            children: <Widget>[
               Padding(
                  padding: const EdgeInsets.only(
                    right: 0,
                    left: 12,
                    top: 24,
                    bottom: 12,
                  ),
                  child: LineChart(
                    showAvg ? avgData() : mainData(),
                  ),
                ),
              
              SizedBox(
                width: 60,
                height: 34,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      showAvg = !showAvg;
                    });
                  },
                  child: Text(
                    'avg',
                    style: TextStyle(
                      fontSize: 12,
                      color: showAvg ? const Color.fromARGB(255, 18, 12, 12).withOpacity(0.5) : const Color.fromARGB(255, 166, 14, 14),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      case 9:
        text = const Text('OCT',style:style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.white,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color.fromARGB(255, 21, 169, 26)),
      ),
      minX: 0,
      maxX: 18,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
            FlSpot(12, 3.1),
            FlSpot(14, 4),
            FlSpot(16, 3),
            FlSpot(17, 4),
          ],
          isCurved: true,
 gradient: const LinearGradient(
            colors: [Colors.blue,Colors.blueAccent],
          ),          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [Colors.blue,Colors.blueAccent]
                  .map((color) => color.withOpacity(0.1))
                  .toList(),
            ),
          ),
        ),
        LineChartBarData(
          spots: const [
            FlSpot(1, 2),
            FlSpot(2, 3),
            FlSpot(3, 2),
            FlSpot(5, 4),
            FlSpot(6, 5),
            FlSpot(8, 6),
            FlSpot(10, 5),
            FlSpot(11, 4),
          ],
          isCurved: true,
 gradient: const LinearGradient(
            colors: [Colors.red,Colors.redAccent],
          ),          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [Colors.red,Colors.redAccent]
                  .map((color) => color.withOpacity(0.1))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color.fromARGB(255, 11, 118, 206),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color.fromARGB(255, 11, 123, 214),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(
          color: const Color.fromARGB(255, 21, 169, 26),
          width: 1,
        ),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.1),
            FlSpot(2.6, 3),
            FlSpot(4.9, 2.8),
            FlSpot(6.8, 3.5),
            FlSpot(8, 4.5),
            FlSpot(9.5, 3.5),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: const LinearGradient(
            colors: [Colors.blue,Colors.blueAccent],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
             gradient: LinearGradient(
              colors: [Colors.blue,Colors.blueAccent]
                  .map((color) => color.withOpacity(0.1))
                  .toList(),
            ),
          ),
        ),
        LineChartBarData(
          spots: const [
            FlSpot(1, 1.5),
            FlSpot(2, 2.5),
            FlSpot(3, 1.8),
            FlSpot(5, 3),
            FlSpot(6, 4),
            FlSpot(8, 5.5),
            FlSpot(10, 4.5),
            FlSpot(11, 3.5),
          ],
          isCurved: true,
          gradient:  const LinearGradient(
          colors: [Colors.red,Colors.redAccent]
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
            colors: [Colors.red,Colors.red[200]]
                .map((color) => color!.withOpacity(0.3))
                .toList(),
          ),
          ),
        ),
      ],
    );
  }
}

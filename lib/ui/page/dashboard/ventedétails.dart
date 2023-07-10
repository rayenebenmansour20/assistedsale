import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_datamaster/state/product_provider.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';

class _BarChart extends StatefulWidget {
  const _BarChart();

  @override
  State<_BarChart> createState() => _BarChartState();
}

class _BarChartState extends State<_BarChart> {
  late ProductProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<ProductProvider>(context, listen: true);
    return Container(
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: BarChart(
        BarChartData(
          barTouchData: barTouchData,
          titlesData: titlesData,
          borderData: borderData,
          barGroups: barGroups,
          gridData: FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY: 400,
        ),
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: lightTextColor,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );

    String text;
    if (provider.topsold.isNotEmpty) {
      switch (value.toInt()) {
        case 0:
          text = provider.topsold[0].libelle;
          break;
        case 1:
          text = provider.topsold[1].libelle;
          break;
        case 2:
          text = provider.topsold[2].libelle;
          break;
        case 3:
          text = provider.topsold[3].libelle;
          break;
        case 4:
          text = provider.topsold[4].libelle;
          break;
        case 5:
          text = provider.topsold[5].libelle;
          break;
        case 6:
          text = provider.topsold[6].libelle;
          break;
        default:
          text = '';
          break;
      }
    } else {
      text = '';
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          Color(0xFF2196F3),
          Color(0xFF50E4FF),
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get barGroups => [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(
              toY: provider.topsold[0].nbrVendu,
              gradient: _barsGradient,
              width: 24,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [
            BarChartRodData(
              toY: provider.topsold[1].nbrVendu,
              gradient: _barsGradient,
              width: 24,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [
            BarChartRodData(
              toY: provider.topsold[2].nbrVendu,
              gradient: _barsGradient,
              width: 24,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 3,
          barRods: [
            BarChartRodData(
              toY: provider.topsold[3].nbrVendu,
              gradient: _barsGradient,
              width: 24,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 4,
          barRods: [
            BarChartRodData(
              toY: provider.topsold[4].nbrVendu,
              gradient: _barsGradient,
              width: 24,
            )
          ],
          showingTooltipIndicators: [0],
        ),
        BarChartGroupData(
          x: 5,
          barRods: [
            BarChartRodData(
              toY: provider.topsold[5].nbrVendu,
              gradient: _barsGradient,
              width: 24,
            )
          ],
          showingTooltipIndicators: [0],
        ),
      ];
}

class BarChartSample3 extends StatefulWidget {
  const BarChartSample3({super.key});

  @override
  State<StatefulWidget> createState() => BarChartSample3State();
}

class BarChartSample3State extends State<BarChartSample3> {
  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 3.6,
      child: _BarChart(),
    );
  }
}

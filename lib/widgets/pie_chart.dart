import 'package:covid19app/constants.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class BuildPiechart extends StatefulWidget {
  final Map data;

  const BuildPiechart({Key key, this.data}) : super(key: key);

  @override
  _BuildPiechartState createState() => _BuildPiechartState(data);
}

class _BuildPiechartState extends State<BuildPiechart> {
  int touchedIndex;
  final Map data;

  _BuildPiechartState(this.data);
  double activepercent;
  double recoveredpercent;
  double deathpercent;
  double total;

  @override
  void initState() {
    total = (data['cases']).toDouble();
    activepercent = ((data['active']).toDouble() / total) * 100;
    recoveredpercent = ((data['recovered']).toDouble() / total) * 100;
    deathpercent = ((data['deaths']).toDouble() / total) * 100;
    // print(deathpercent);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        pieTouchData: PieTouchData(
          touchCallback: (pieTouchResponse) {
            setState(() {
              if (pieTouchResponse.touchInput is FlLongPressEnd ||
                  pieTouchResponse.touchInput is FlPanEnd) {
                touchedIndex = -1;
              } else {
                touchedIndex = pieTouchResponse.touchedSectionIndex;
              }
            });
          },
        ),
        borderData: FlBorderData(
          show: false,
        ),
        startDegreeOffset: 0,
        sectionsSpace: 0,
        centerSpaceRadius: 40,
        sections: showingSections(),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final double fontSize = isTouched ? 22 : 14;
      final double radius = isTouched ? 70 : 60;
      switch (i) {
        case 2:
          return PieChartSectionData(
            color: Color(0xFFFF2D55),
            value: deathpercent,
            title: deathpercent.toStringAsFixed(2) + "%\nDeaceased",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Color(0xFF50E3C2),
            value: recoveredpercent,
            title: recoveredpercent.toStringAsFixed(2) + "%\n" + "Recovered",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
          );

        case 0:
          return PieChartSectionData(
            color: Color(0xFF5856D6),
            value: activepercent,
            title: activepercent.toStringAsFixed(2) + "%\nActive",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: kTextColor,
            ),
          );
        default:
          return null;
      }
    });
  }
}

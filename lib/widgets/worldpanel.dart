import 'package:covid19app/constants.dart';
import 'package:covid19app/details_screen.dart';
import 'package:covid19app/widgets/pie_chart.dart';
import 'package:covid19app/widgets/info_card.dart';
import 'package:flutter/material.dart';

class WorldPanel extends StatelessWidget {
  final Map worldData;
  const WorldPanel({
    Key key,
    this.worldData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: kPrimaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Wrap(
        runSpacing: 20,
        spacing: 20,
        children: <Widget>[
          InfoCard(
            title: "Confirmed Cases",
            effectedNum: worldData['cases'],
            iconColor: Color(0xFFFF8C00),
            press: () {},
          ),
          InfoCard(
            title: "Total Deaths",
            effectedNum: worldData['deaths'],
            iconColor: Color(0xFFFF2D55),
            press: () {},
          ),
          worldData == null
              ? Container()
              : Center(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).brightness == Brightness.light
                            ? kTextColor.withOpacity(0.1)
                            : kTextColor.withOpacity(0.7),
                        boxShadow:
                            Theme.of(context).brightness == Brightness.light
                                ? [
                                    BoxShadow(
                                        color: Colors.white,
                                        spreadRadius: -3,
                                        blurRadius: 3,
                                        offset: Offset(-5, -5)),
                                    BoxShadow(
                                        blurRadius: 3,
                                        color: kTextColor.withOpacity(0.1),
                                        spreadRadius: 1,
                                        offset: Offset(7, 7))
                                  ]
                                : [
                                    BoxShadow(
                                        color: Colors.white,
                                        spreadRadius: 3,
                                        blurRadius: 3)
                                  ],
                        borderRadius: BorderRadius.circular(20)),
                    child: BuildPiechart(
                      data: worldData,
                    ),
                  ),
                ),
          InfoCard(
            title: "Total Recovered",
            effectedNum: worldData['recovered'],
            iconColor: Color(0xFF50E3C2),
            press: () {},
          ),
          InfoCard(
            title: "Active Cases",
            effectedNum: worldData['active'],
            iconColor: Color(0xFF5856D6),
            press: () {},
          ),
        ],
      ),
    );
  }
}

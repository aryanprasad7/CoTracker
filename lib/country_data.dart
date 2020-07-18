import 'dart:convert';

import 'package:covid19app/constants.dart';
import 'package:covid19app/pages/country_search_page.dart';
import 'package:covid19app/widgets/pie_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/pie_chart.dart';
import 'package:http/http.dart' as http;

class CountryData extends StatefulWidget {
  @override
  _CountryDataState createState() => _CountryDataState();
}

class _CountryDataState extends State<CountryData> {
  List countryData;

  fetchCountryData() async {
    http.Response response =
        await http.get("https://corona.lmao.ninja/v2/countries?sort=cases");
    setState(() {
      countryData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    fetchCountryData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBarCountryData(),
      body: countryData == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                  child: GestureDetector(
                    onTap: () {
                      _modalBottomSheet(context, index);
                    },
                    child: Container(
                      height: 130,
                      margin:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  countryData[index]['country'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                Image.network(
                                  countryData[index]['countryInfo']['flag'],
                                  height: 50,
                                  width: 60,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "CONFIRMED: " +
                                        countryData[index]['cases'].toString() +
                                        " (+" +
                                        countryData[index]['todayCases']
                                            .toString() +
                                        ")",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).brightness ==
                                                Brightness.dark
                                            ? Colors.white
                                            : kTextColor),
                                  ),
                                  Text(
                                    "ACTIVE: " +
                                        countryData[index]['active'].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  Text(
                                    "RECOVERED: " +
                                        countryData[index]['recovered']
                                            .toString() +
                                        " (+" +
                                        countryData[index]['todayRecovered']
                                            .toString() +
                                        ")",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green),
                                  ),
                                  Text(
                                    "DEATHS: " +
                                        countryData[index]['deaths']
                                            .toString() +
                                        " (+" +
                                        countryData[index]['todayDeaths']
                                            .toString() +
                                        ")",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: countryData == null ? 0 : countryData.length,
            ),
    );
  }

  AppBar buildAppBarCountryData() {
    return AppBar(
      backgroundColor: kTextColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: kPrimaryColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: Text(
        "Country Wise Data",
        style: TextStyle(
          letterSpacing: 0.5,
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset("assets/icons/search.svg"),
          color: kPrimaryColor,
          onPressed: () {
            showSearch(
                context: context,
                delegate: countryData == null
                    ? Center(child: CircularProgressIndicator())
                    : Search(countryData));
          },
        )
      ],
    );
  }

  void _modalBottomSheet(BuildContext context, index) {
    showModalBottomSheet(
        context: context,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        builder: (BuildContext bc) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10.0),
              child: Column(
                children: <Widget>[
                  Text(
                    countryData[index]['country'],
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      textBaseline: TextBaseline.alphabetic,
                    ),
                  ),
                  Image.network(
                    countryData[index]['countryInfo']['flag'],
                    height: 40,
                    width: 60,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.65,
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
                      data: countryData[index],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}

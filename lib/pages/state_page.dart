import 'dart:convert';

import 'package:covid19app/constants.dart';
import 'package:covid19app/widgets/pie_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'search_states.dart';

class StatePage extends StatefulWidget {
  @override
  _StatePageState createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> {
  Map stateData;

  fetchStateData() async {
    http.Response response =
        await http.get("https://api.rootnet.in/covid19-in/stats/latest");
    setState(() {
      stateData = json.decode(response.body);
    });
  }

  @override
  void initState() {
    fetchStateData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kTextColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kPrimaryColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text("State Stats"),
        actions: <Widget>[
          IconButton(
            icon: SvgPicture.asset("assets/icons/search.svg"),
            color: kPrimaryColor,
            onPressed: () {
              showSearch(
                context: context,
                delegate: stateData == null
                    ? Center(child: CircularProgressIndicator())
                    : Search(
                        stateData['data']['regional'],
                      ),
              );
            },
          )
        ],
      ),
      body: stateData == null
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
                  child: Container(
                    height: 130,
                    margin:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  stateData["data"]["regional"][index]['loc'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "CONFIRMED: " +
                                      stateData["data"]["regional"][index]
                                              ['totalConfirmed']
                                          .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.white
                                          : kTextColor),
                                ),
                                Text(
                                  "RECOVERED: " +
                                      stateData["data"]["regional"][index]
                                              ['discharged']
                                          .toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green),
                                ),
                                Text(
                                  "DEATHS: " +
                                      stateData["data"]["regional"][index]
                                              ['deaths']
                                          .toString(),
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
                );
              },
              itemCount:
                  stateData == null ? 0 : stateData["data"]["regional"].length,
            ),
    );
  }
}

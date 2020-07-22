import 'package:covid19app/constants.dart';
import 'package:covid19app/widgets/pie_chart.dart';
import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';

class Search extends SearchDelegate {
  final List countryList;

  Search(this.countryList);

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      primaryColor: kTextColor,
      brightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.dark
          : Brightness.light,
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(
            Icons.clear,
            color: kPrimaryColor,
          ),
          onPressed: () {
            query = '';
          }),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.arrow_back_ios,
        color: kPrimaryColor,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsList = query.isEmpty
        ? countryList
        : countryList
            .where((element) =>
                element['country'].toString().toLowerCase().startsWith(query.toLowerCase()))
            .toList();

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
                    suggestionsList[index]['country'],
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      textBaseline: TextBaseline.alphabetic,
                    ),
                  ),
                  Image.network(
                    suggestionsList[index]['countryInfo']['flag'],
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
                      data: suggestionsList[index],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }

    return ListView.builder(
      itemCount: suggestionsList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _modalBottomSheet(context, index);
          },
          child: Card(
            shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(40.0)),
            child: GestureDetector(
              onTap: () {
                _modalBottomSheet(context, index);
              },
              child: Container(
                height: 130,
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            suggestionsList[index]['country'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Image.network(
                            suggestionsList[index]['countryInfo']['flag'],
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
                                  suggestionsList[index]['cases'].toString() +
                                  " (+" +
                                  suggestionsList[index]['todayCases']
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
                                  suggestionsList[index]['active'].toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue),
                            ),
                            Text(
                              "RECOVERED: " +
                                  suggestionsList[index]['recovered'].toString() +
                                  " (+" +
                                  suggestionsList[index]['todayRecovered']
                                      .toString() +
                                  ")",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green),
                            ),
                            Text(
                              "DEATHS: " +
                                  suggestionsList[index]['deaths'].toString() +
                                  " (+" +
                                  suggestionsList[index]['todayDeaths']
                                      .toString() +
                                  ")",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

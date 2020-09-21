import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../api/DailyCases.dart' as dailycases;

class CovidChart extends StatefulWidget {
  @override
  _CovidChartState createState() => _CovidChartState();
}

class _CovidChartState extends State<CovidChart> {
  Future<dailycases.DailyCaseDataModel> futureNationalData;
  var dateString;
  DateFormat format = DateFormat("dd MMMM");
  List<FlSpot> datalist = [];
  DateTime currentDate;

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  void initState() {
    futureNationalData = dailycases.fetchCaseData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dailycases.DailyCaseDataModel>(
      future: futureNationalData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          currentDate = format.parse(snapshot.data.casesTimeSeries.last.date);
          snapshot.data.casesTimeSeries.forEach((element) {
            if (double.parse(
                    DateFormat('MM').format(format.parse(element.date))) >
                double.parse(DateFormat('MM').format(currentDate)) - 3) {
              datalist.add(
                FlSpot(
                  double.parse(
                          DateFormat('MM').format(format.parse(element.date))) +
                      double.parse(DateFormat('dd')
                              .format(format.parse(element.date))) *
                          0.033,
                  double.parse(element.dailyconfirmed),
                ),
              );
            }
          });
          return Container(
            // height: 100.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(20.0),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Daily New Cases',
                        style: const TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '(Nationally)',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: LineChart(
                        covidData(datalist),
                        swapAnimationDuration: Duration(milliseconds: 150),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error has occured!');
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

LineChartData covidData(List<FlSpot> datalist) {
  return LineChartData(
    gridData: FlGridData(
      horizontalInterval: 10000,
    ),
    titlesData: FlTitlesData(
      show: true,
      bottomTitles: SideTitles(
        showTitles: true,
        textStyle: TextStyle(
          color: Color(0xFFa37eba),
          fontSize: 16,
        ),
        getTitles: (value) {
          switch (value.toInt()) {
            case 1:
              return 'Jan';
            case 2:
              return 'Feb';
            case 3:
              return 'Mar';
            case 4:
              return 'Apr';
            case 5:
              return 'May';
            case 6:
              return 'Jun';
            case 7:
              return 'Jul';
            case 8:
              return 'Aug';
            case 9:
              return 'Sep';
            case 10:
              return 'Oct';
            case 11:
              return 'Nov';
            case 12:
              return 'Dec';
          }
          return '';
        },
        margin: 8,
      ),
      leftTitles: SideTitles(
        showTitles: true,
        interval: 10000,
        reservedSize: 22,
        textStyle: const TextStyle(
          color: Color(0xFFa37eba),
          fontSize: 11,
        ),
        margin: 10,
      ),
    ),
    borderData: FlBorderData(
      show: false,
    ),
    lineBarsData: [
      LineChartBarData(
        spots: datalist,
        isCurved: true,
        colors: [Color(0xFF473F97)],
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
          show: true,
          colors: [Color(0xFFa37eba).withOpacity(0.3)],
        ),
      ),
    ],
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'dart:convert';
class StepsChartPanel extends StatefulWidget {
  @override
  _StepsChartPanelState createState() => _StepsChartPanelState();
}

class _StepsChartPanelState extends State<StepsChartPanel> {
  // List<double> cdata = [];
  // List<double> cdata2 = [];
  Future<List<CircularStackEntry>> loadCalsStepsData() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/data_repo/cals_step.json');
    final jsonResponse = json.decode(jsonString);
    var tagsJson = jsonResponse['activities'];
    double s = 0.0;

    for (Map j in tagsJson) {
      s = j['steps'].toDouble();
      //c += j['steps'].toDouble();
    }
    // We create the corresponding data to be shown on the chart and return it in the snapshot
    List<CircularStackEntry> dataEntry = [
      new CircularStackEntry([
        new CircularSegmentEntry(s, Colors.orange, rankKey: "Steps"),
        new CircularSegmentEntry((8000 - s), Colors.grey,
            rankKey: "Calories"),
      ]),
    ];

    return dataEntry;
  }


  Widget myCircularItems(
      String title, List<CircularStackEntry> circularData) {
        return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Colors.purple[200],
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(2.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 130,
                        height: 240,
                        child: AnimatedCircularChart(
                          //το widget που μας δινει το package flutter_circular_chart.dart
                          size: Size(100.0, 100.0),
                          initialChartData: circularData,
                          chartType: CircularChartType.Pie,
                          holeRadius: 50,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
      }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadCalsStepsData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text("Loading data"),
          );
        } else {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error you son of a bitch"),
            );
          }
          return myCircularItems("Steps", snapshot.data);
        }
      },
    );
  }
}

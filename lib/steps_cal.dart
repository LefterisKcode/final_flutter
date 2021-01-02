import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/sleeps.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'about.dart';
import 'hearts.dart';
import 'homepage.dart';
import 'profile.dart';

class Steps extends StatefulWidget {
  @override
  _StepsPageState createState() => _StepsPageState();
}

class _StepsPageState extends State<Steps> {
  List<charts.Series<StepsCals, String>> stepsCData = [];
  List<StepsCals> tmp = [];
  var myStepcData;

  Future<List> loadCalsStepsData() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/data_repo/cals_step.json');
    final jsonResponse = json.decode(jsonString);
    var tagsJson = jsonResponse['activities'];
    setState(() {
      for (Map i in tagsJson) {
        tmp.add(StepsCals(i['startDate'], i['steps'], i['calories']));
      }
    });
    return tmp;
  }

  void initData() async {
    this.tmp = await this.loadCalsStepsData();
    stepsCData = _createMyData();
    this.scChart();
  }

  scChart() {
    return charts.BarChart(
      stepsCData,
      animate: true,
      barGroupingType: charts.BarGroupingType.grouped,
      behaviors: [
        new charts.ChartTitle('Steps/Calories', innerPadding: 20),
        new charts.SeriesLegend(position: charts.BehaviorPosition.end, outsideJustification: charts.OutsideJustification.middleDrawArea),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    this.initData();
  }

  List<charts.Series<StepsCals, String>> _createMyData() {
    final data = tmp;
    return [
      charts.Series<StepsCals, String>(
          id: 'Steps',
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault,
          domainFn: (StepsCals date, _) => date.dates,
          measureFn: (StepsCals step, _) => step.steps,
          data: data),
      charts.Series<StepsCals, String>(
        id: 'Calories',
        colorFn: (_, __) => charts.MaterialPalette.deepOrange.shadeDefault,
        domainFn: (StepsCals date, _) => date.dates,
        measureFn: (StepsCals cals, _) => cals.calories,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Steps"),
        backgroundColor: Colors.green[600], // AppBar Color
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey[400],
              ),
              child: Text(
                'Health',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.redAccent),
              title: Text('Heart Rate'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Heart()));
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.directions_run_rounded, color: Colors.green[600]),
              title: Text('Steps'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.airline_seat_individual_suite_rounded,
                  color: Colors.purple[300]),
              title: Text('Sleep'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Sleep()));
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.account_circle_rounded, color: Colors.blueAccent),
              title: Text('Demographics'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            ListTile(
              leading: Icon(Icons.info, color: Colors.black),
              title: Text('About Us'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => About()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: scChart(),
      ),
    );
  }
}

class StepsCals {
  String dates;
  int steps;
  int calories;

  StepsCals(this.dates, this.steps, this.calories);
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/steps_cal.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'about.dart';
import 'hearts.dart';
import 'homepage.dart';
import 'profile.dart';

class Sleep1 extends StatefulWidget {
  @override
  _SleepPageState1 createState() => _SleepPageState1();
}

class _SleepPageState1 extends State<Sleep1> {
  List<charts.Series<Sleeps, num>> sleepData = [];
  List<Sleeps> tmp = [];
  Future<List> loadSleepData() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/data_repo/slept1.json');
    final jsonResponse = json.decode(jsonString);
    var tagsJson = jsonResponse['sleep'];
    setState(() {
      for (Map i in tagsJson) {
        tmp.add(Sleeps(i['dateOfSleep'], i['minutes']));
      }
    });
    return tmp;
  }

  void initData() async {
    this.tmp = await this.loadSleepData();
    sleepData = _createMyData();
    this.sleepChart();
  }

  sleepChart() {
    return charts.LineChart(
      sleepData,
      defaultRenderer:
          new charts.LineRendererConfig(includeArea: true, stacked: true),
      animate: true,
      behaviors: [
        new charts.ChartTitle('Sleep',
            behaviorPosition: charts.BehaviorPosition.top,
            titleOutsideJustification: charts.OutsideJustification.middle,
            innerPadding: 20),
        new charts.ChartTitle('Date',
            behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    this.initData();
  }

  List<charts.Series<Sleeps, num>> _createMyData() {
    final data = tmp;
    return [
      charts.Series<Sleeps, num>(
        id: 'Sleep Rates',
        colorFn: (_, __) => charts.MaterialPalette.purple.shadeDefault,
        domainFn: (Sleeps date, _) => date.dates,
        measureFn: (Sleeps min, _) => min.minutes,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sleep"),
        backgroundColor: Colors.purple[300], // AppBar Color
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
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Steps1()));
              },
            ),
            ListTile(
              leading: Icon(Icons.airline_seat_individual_suite_rounded,
                  color: Colors.purple[300]),
              title: Text('Sleep'),
              onTap: () {
                Navigator.pop(context);
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
        child: sleepChart(),
      ),
    );
  }
}

class Sleeps {
  int dates;
  int minutes;

  Sleeps(this.dates, this.minutes);
}

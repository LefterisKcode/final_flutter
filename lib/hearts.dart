import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:project/sleeps.dart';
import 'package:project/steps_cal.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'homepage.dart';
import 'profile.dart';

class Heart extends StatefulWidget {
  @override
  _HeartPageState createState() => _HeartPageState();
}

class _HeartPageState extends State<Heart> {
  List<charts.Series<Hearts, String>> heartData =
      []; // Arxikopoihsh mias listas tupou List<Series<Hearts, String>>
  List<Hearts> tmp = []; // Arxikopoihsi listas tupou <Hearts>

  // Dimiourgias mias future sunartisis h opoia tha epistrefei mia lista tupou <Hearts>
  Future<List<Hearts>> loadHeartData() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/data_repo/heart_rate.json');
    final jsonResponse = json.decode(jsonString);
    var tagsJson = jsonResponse['activities-heart'];
    setState(() {
      for (Map i in tagsJson) {
        tmp.add(Hearts(i['dateTime'],
            i['heartRate'])); // Bazw ta stoixeia apo to json mesa stin lista tmp
      }
    });
    return tmp; // Epistrosfi tis listas tmp pou einai tupou <Hearts> gia na tin xrisimopoihsw sto chart mou meta
  }

  // Dimiourgia mias void sunartisis h opoia einai async kai xrisimopoieitai wste to programma na perimenei na parei ola ta dedomena kai meta na emfanisei kati
  void initData() async {
    this.tmp = await this.loadHeartData();
    heartData = _createMyData();
    this.barChart();
  }

  // Dimiourgia mias dynamic synartisis h opoia periexei to eidos tou chart kai kapoia dedomena (eidos data, animate, behavior ,etc.)
  barChart() {
    return charts.BarChart(
      heartData,
      animate: true,
      vertical: true,
      behaviors: [
        new charts.ChartTitle('Heart Rate', innerPadding: 20),
      ],
    );
  }

  // Dimiourgia tis void sunartisis InitState pou xreiazetai gia to programma na treksei swsta
  @override
  void initState() {
    super.initState();
    this.initData();
  }

  // Dimiourgia mias sunartisis eidous List<charts.Series<Hearts, String>> pou tha periexei ta dedomena tou grafimatos (auta pou pirame apo grammi 32), ti tha mpei ston kathe aksona , etc.
  List<charts.Series<Hearts, String>> _createMyData() {
    final data = tmp;
    return [
      charts.Series<Hearts, String>(
        id: 'Heart Rates',
        colorFn: (_, __) => charts.MaterialPalette.red.shadeDefault,
        domainFn: (Hearts date, _) => date.date,
        measureFn: (Hearts value, _) => value.values,
        data: data,
      )
    ];
  }

  // Dimiourgia enos build widget to opoio periexei ton drawer, to titlo tis selidas
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Heart Rate"),
        backgroundColor: Colors.redAccent, // AppBar Color
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
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.directions_run_rounded, color: Colors.green[600]),
              title: Text('Steps'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Steps()));
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
          ],
        ),
      ),
      body: Container(
        // Sto body tha kalesw tin sunartisi (dynamic) pou eftiaksa prin , wste na emfanistei to chart mou
        child: barChart(),
      ),
    );
  }
}

// Dimiourgia mias klasis me onoma Hearts tin opoia tha tin xrisimopoihsw gia to chart, ta data mou (string date / orizontios aksonas sto chart) (int value / katakorufos aksonas sto chart)
class Hearts {
  final String date;
  final int values;

  Hearts(this.date, this.values);
}

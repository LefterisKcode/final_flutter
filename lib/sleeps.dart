import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/steps_cal.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'about.dart';
import 'hearts.dart';
import 'homepage.dart';
import 'profile.dart';

class Sleep extends StatefulWidget {
  @override
  _SleepPageState createState() => _SleepPageState();
}

class _SleepPageState extends State<Sleep> {
  List<charts.Series<Sleeps, num>> sleepData =
      []; // Αρχικοποίηση μιας λίστας τύπου <charts.Series<Sleeps, num>>
  List<Sleeps> tmp =
      []; // Αρχικοποίηση μιας λίστας τύπου <Sleeps> που μετέπειτα θα 'χει τα δεδομένα απο το json

  // Δημιουργία μιας future συνάρτησης που θα επιστρέφει πίσω μια λίστα τύπου <Sleeps>
  Future<List<Sleeps>> loadSleepData() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/data_repo/slept1.json');
    final jsonResponse = json.decode(jsonString);
    var tagsJson = jsonResponse['sleep'];
    setState(() {
      for (Map i in tagsJson) {
        tmp.add(Sleeps(i['dateOfSleep'],
            i['minutes'])); // Περνάω μέσα στην λίστα μου τα δεδομένα που πήρα απο το json
      }
    });
    return tmp; // Επιστρέφω την λίστα tmp για να την χρησιμοποιήσω μέσα στα chart
  }

  // Δημιουργία μιας void συνάρτησης η οποία είναι ασύγχρονη και χρησιμοποιείται ώστε το πρόγραμμα μου να περιμένει πρώτα να πάρει όλα τα δεδομένα και έπειτα να εμφανίσει ότι είναι
  void initData() async {
    this.tmp = await this.loadSleepData();
    sleepData = _createMyData();
    this.sleepChart();
  }

  // Δημιουργία μιας dynamic συνάρτησης που έχει πληροφορίες όπως τι γράφημα θα χρησιμοποιήσω, τι δεδομένα θα 'χει, τι τίτλο, κλπ.
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
        new charts.ChartTitle('Days', behaviorPosition: charts.BehaviorPosition.bottom,
            titleOutsideJustification:
                charts.OutsideJustification.middleDrawArea),
      ],
    );
  }

  // Βασική συνάρητηση ώστε να λειτουργήσει το πρόγραμμα μου σωστά μέσα στον ασύγχρονο κώδικα
  @override
  void initState() {
    super.initState();
    this.initData();
  }

  // Συνάρτηση είδους List<charts.Series<Sleeps, num>> που θα παίρνει σαν δεδομένα την λίστα που επέστρεψε η συνάρτηση μας στην γραμμη 33
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

  // Widget είδους build που περιέχει βασικά μου components όπως appbar, drawer , title
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sleep"),
        backgroundColor: Colors.blueGrey[400], // AppBar χρώμα
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
                    context, MaterialPageRoute(builder: (context) => Steps()));
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

// Δημιουργία κλάσης η οποία θα περιέχει είδη δεδομένων βάσει των στοιχείων που θέλω να πάρω απο το json (int dates / οριζόντιος άξονας 1-7 τιμές) (int minutes / κατακόρυφος άξονας)
class Sleeps {
  int dates;
  int minutes;

  Sleeps(this.dates, this.minutes);
}

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
      []; // Αρχικοποίηση μιας λίστας τύπου List<Series<Hearts, String>>
  List<Hearts> tmp = []; // Αρχικοποίηση λίστας τύπου <Hearts>

  // Δημιουργία μιας future συνάρτησης η οποία θα επιστρέφει πίσω μια λίστα τύπου <Hearts>
  Future<List<Hearts>> loadHeartData() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/data_repo/heart_rate.json');
    final jsonResponse = json.decode(jsonString);
    var tagsJson = jsonResponse['activities-heart'];
    setState(() {
      for (Map i in tagsJson) {
        tmp.add(Hearts(i['dateTime'],
            i['heartRate'])); // Βάζω στοιχεία απο το json μέσα στην λίστα tmp
      }
    });
    return tmp; // Επιστροφή της λίστας tmp που είναι τύπου <Hearts> για να την χρησιμοποιήσω μέσα στο chart μου μετά
  }

  // Δημιουργία μιας void συνάρτησης η οποία είναι ασύγχρονη και χρησιμοποιείται ώστε το πρόγραμμα μου να περιμένει πρώτα να πάρει όλα τα δεδομένα και έπειτα να εμφανίσει ότι είναι
  void initData() async {
    this.tmp = await this.loadHeartData();
    heartData = _createMyData();
    this.barChart();
  }

  // Δημιουργία μιας dynamic συνάρτησης η οποία περιέχει το είδος του chart και κάποια δεδομένα (όπως είδος data, animate, behavior)
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

  // Συνάρτηση InitState, παριέχει βασικές συναρτήσεις μέσα που χρειάζονται για να τρέξει ορθά το πρόγραμμα μου
  @override
  void initState() {
    super.initState();
    this.initData();
  }

  // Δημιουργία μιας συνάρτησης του είδους List<charts.Series<Hearts, String>> που θα περιέχει τα δεδομένα του γραφήματος (αυτά που πήραμε απο γραμμή 32), όπως και τι θα μπεί στον κάθε άξονα
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

  // Δημιουργία ενός build widget το οποίο περιέχει τον drawer, τον τίτλο της σελίδας , κλπ.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Heart Rate"),
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
        // Στο body θα καλέσω την συνάρτηση (την dynamic) που έφτιαξα πριν, ώστε να εμφανιστεί το chart μου
        child: barChart(),
      ),
    );
  }
}

// Δημιουργία μιας κλάσης Hearts την οποία θα την χρησιμοποιήσω για το chart, για να περάσω τα data μου (string date / οριζόντιος άξονας στο chart) (int value / κατακόρυφος άξονας στο chart)
class Hearts {
  final String date;
  final int values;

  Hearts(this.date, this.values);
}

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:project/profile.dart';
import 'package:project/sleeps.dart';
import 'package:project/steps_cal.dart';
import 'about.dart';
import 'charts.dart';
import 'hearts.dart';
import 'help.dart';
import 'steps_chart_panel.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0; // Proti thesi pinaka pou paei sto homepage
  void _onItemTapped(int index) {
    // Gia na allazei to bottom navigation bar otan pataw se ena ap ta 3 options
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        // 2h epilogi tou pinaka pou paei sto page me ta charts
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChartsPage()));
      } else if (_selectedIndex == 2) {
        // 3h epilogi tou pinaka pou paei sto page me to help
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HelpPage()));
      }
    });
  }

  // Arxikopoihsh metablitwn pou tha xrisimopoihsw sta heart rate kai steps charts pou exw sto homepage
  double s = 0;
  double c = 0;
  List<double> cdata = [];
  List<double> cdata2 = [];

  List<double> heartRateValues = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0];

  // Dimiourgia mias future sunartisis pou tha pairnei to json (tis times autou) gia to heart rate
  Future loadHeartRateData() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/data_repo/heart_rate.json');
    final jsonResponse = json.decode(jsonString);
    var tagsJson = jsonResponse['activities-heart'];
    List<double> tmp = [];
    for (Map i in tagsJson) {
      int value = i['heartRate'];
      tmp.add(value.toDouble());
    }
    setState(() {
      // Pernaw kai allazw tis times pou eixa dwsei prin (stin arxikopoihsh) me tis swstes times tou Json
      this.heartRateValues = tmp;
    });
  }

  // Dimiourgia mias future sunartisis pou tha pairnei to json (tis times autou) gia ta steps
  Future loadStepsData() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/data_repo/cals_step.json');
    final jsonResponse = json.decode(jsonString);
    var tagsJson = jsonResponse['activities'];
    List<double> tmp2 = [];
    List<double> tmp3 = [];
    for (Map j in tagsJson) {
      s = j['steps'].toDouble();
      c += j['steps'].toDouble();
    }
    tmp2.add(
        s); // To value ap to portokali kommati tou pie chart me ta bimata tis teleutaias hmeras
    tmp3.add(8000.0 -
        s); // To value ap to gkri kommati tou pie chart me ta bimata pou apomenoun gia na ftasoyme sta 8000 (hmerisios stoxos)
    setState(() {
      // Bazw tis times mesa sta 2 lists pou eixa ftiaksei
      this.cdata = [s];
      this.cdata2 = [8000.0 - s];
    });
  }

  // Void sunartisi me tin opoia perimenw na sumplirothoun oi times kai meta tis dinw sto programma
  void initData() async {
    await this.loadStepsData();
    await this.loadHeartRateData();
  }

  // Void sunartisi pou periexei tin InitState h opoia einai aparaititi gia to programma
  @override
  void initState() {
    super.initState();
    this.initData();
  }

  // Widget eidous myItems to opoio periexei tin ulopoihsh twn Sleep kai Me poy fainontai sto homepage
  Widget myItems(IconData icon, String heading, Color color) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Colors.purple[200],
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    child: Text(heading,
                        style:
                            TextStyle(color: Colors.blueGrey, fontSize: 18.0)),
                  ),
                  Material(
                    color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(30.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(icon, color: Colors.white, size: 30.0),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

// Widget eidous myHeartChart to opoio periexei tin ulopoihsh kai oti allo xreiazetai gia na emfanisw to diagramma me tous palmous se grammi
  Widget myHeartChart(String title, List<double> heartRateData) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      borderRadius: BorderRadius.circular(24.0),
      shadowColor: Colors.purple[200],
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        title,
                        style: TextStyle(
                          fontSize: 21.0,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(25.0),
                      height: 210,
                      child: new Sparkline(
                        fallbackHeight: 1,
                        sharpCorners: true,
                        //ta dedomena tou grafimatos
                        data:
                            heartRateData, // ta double data pou pairnoume apo tin entoli stin grammi 59
                        lineColor: Colors.red,
                        pointsMode: PointsMode
                            .all, // gia na emfanizei koukida se ola ta simeia pou exei value apo heart rate
                        pointSize: 7.0,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget eidous build pou periexei ta basika kommatia , opws ulopoihsh Dashboard
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Dimiourgia tou AppBar pou periexei to drawer kai to titlo tis selidas
        backgroundColor: Colors.blueGrey[400],
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: StaggeredGridView.count(
        crossAxisCount:
            2, //ο αριθμος των στηλων που θελουμε να καλυπτει το grid
        crossAxisSpacing:
            12.0, //η αποσταση μεταξυ των κουτιων στον οριζοντιο αξονα
        mainAxisSpacing: 23.0, //η αποσταση μεταξυ των κουτιων στον καθετο αξονα
        padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
        children: <Widget>[
          InkWell(
            // Kartela me to chart tou heart rate
            child: myHeartChart("Heart Rate", this.heartRateValues),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Heart()));
            },
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
          InkWell(
            // Kartela me to pie chart twn steps
            child: StepsChartPanel(),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Steps()));
            },
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
          InkWell(
            // Kartela me to 'Me' to opoio mas paei sto profile
            child: myItems(Icons.account_box_rounded, "Me", Colors.blueGrey),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
          InkWell(
            // Kartela me to 'Sleep' to opoio mas paei sto chart me ta sleep values
            child: myItems(Icons.airline_seat_individual_suite_rounded, "Sleep",
                Colors.blueGrey),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Sleep()));
            },
            customBorder: RoundedRectangleBorder(
                // Gia na stroggulepsw tis gwnies twn kartelwn
                borderRadius: BorderRadius.circular(25.0)),
          ),
        ],
        staggeredTiles: [
          //οσα αντικειμενα βαλαμε στο children τοσα πρεπει να βαλουμε και εδω
          StaggeredTile.extent(2,
              250.0), //η πρωτη παραμετρος λεει ποσες στηλες να καλυπτει το tile/κουτι (heartRate chart)
          StaggeredTile.extent(1,
              350.0), //δευτερη παραμετρος λεει το υψος τους tile/κουτιου  (Steps chart)
          StaggeredTile.extent(1, 163.0), // (Me chart)
          StaggeredTile.extent(1, 163.0), // (Sleep chart)
        ],
      ),
      drawer: Drawer(
        // Dimiourgia tou drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              // Dimiourgia tou drawer header
              decoration: BoxDecoration(
                color: Colors.blueGrey[400],
              ),
              child: Text(
                // Titlos sto drawer
                'Health',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              // 1o item mesa ston drawer (home)
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              // 2o item mesa ston drawer (heart rate)
              leading: Icon(Icons.favorite, color: Colors.redAccent),
              title: Text('Heart Rate'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Heart()));
              },
            ),
            ListTile(
              // 3o item mesa ston drawer (steps)
              leading:
                  Icon(Icons.directions_run_rounded, color: Colors.green[600]),
              title: Text('Steps'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Steps()));
              },
            ),
            ListTile(
              // 4o item mesa ston drawer (sleep)
              leading: Icon(Icons.airline_seat_individual_suite_rounded,
                  color: Colors.purple[300]),
              title: Text('Sleep'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Sleep()));
              },
            ),
            ListTile(
              // 5o item mesa ston drawer (demographics)
              leading:
                  Icon(Icons.account_circle_rounded, color: Colors.blueAccent),
              title: Text('Demographics'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            ListTile(
              // 6o item mesa ston drawer (about us)
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
      bottomNavigationBar: BottomNavigationBar(
        // Dimiourgia tou bottom navigation bar (to opoio periexei ta Home / Charts / Help)
        backgroundColor: Colors.blueGrey[50],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_outlined),
            label: 'Charts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.help),
            label: 'Help',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[900],
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

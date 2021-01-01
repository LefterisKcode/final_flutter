import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:flutter_sparkline/flutter_sparkline.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:project/profile.dart';
import 'package:project/sleeps.dart';
import 'package:project/steps_cal.dart';
import 'about.dart';
import 'charts.dart';
import 'hearts.dart';
import 'help.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChartsPage()));
      } else if (_selectedIndex == 2) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HelpPage()));
      }
    });
  }

  double s = 0;
  double c = 0;
  List<double> cdata = [];
  List<double> cdata2 = [];

  List<double> heartRateValues = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0];

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
      this.heartRateValues = tmp;
    });
  }

  Future loadCalsStepsData() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/data_repo/cals_step.json');
    final jsonResponse = json.decode(jsonString);
    var tagsJson = jsonResponse['activities'];
    // ignore: unused_local_variable
    List<double> tmp2 = [];
    List<double> tmp3 = [];
    for (Map j in tagsJson) {
      s += j['steps'];
      c += j['calories'];
    }
    tmp2.add(s);
    tmp3.add(c);
    setState(() {
      this.cdata = tmp2;
      this.cdata2 = tmp3;
    });
  }

  void initData() async {
    await this.loadCalsStepsData();
    await this.loadHeartRateData();
  }

  @override
  void initState() {
    super.initState();
    this.initData();
  }

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

//το widgets για να φτιαξουμε το πρωτο γραφημα σε μορφη γραμμης
  Widget mychart1Items(String title, List<double> heartRateData) {
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
                        //το γραφημε σε μορφη γραμμης
                        data:
                            heartRateData, // τα double δεδομενα που εχουμε δηλωσει στην αρχη
                        lineColor: Colors.red,
                        pointsMode: PointsMode
                            .all, //δειχνει τα σημεια με τις τιμες σαν βουλες/points
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

   Widget myCircularItems(
      String title, List<double> cdata, List<double> cdata2) {
    // var first = new CircularSegmentEntry(s.toDouble(), Colors.orange, rankKey: 'Steps');
    List<CircularStackEntry> circularData = <CircularStackEntry>[
      new CircularStackEntry(
        <CircularSegmentEntry>[
          new CircularSegmentEntry(cdata[0], Colors.orange, rankKey: 'Steps'),
          new CircularSegmentEntry(cdata2[0], Colors.grey[500],
              rankKey: 'Calories'),
        ],
      ),
    ];
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
    return Scaffold(
      appBar: AppBar(
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
            child: mychart1Items("Heart Rate", this.heartRateValues),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Heart()));
            },
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
          InkWell(
            child: myCircularItems("Steps", this.cdata, this.cdata2),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Steps()));
            },
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
          InkWell(
            child: myItems(Icons.account_box_rounded, "Me", Colors.blueGrey),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
          InkWell(
            child: myItems(Icons.airline_seat_individual_suite_rounded, "Sleep",
                Colors.blueGrey),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Sleep()));
            },
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
        ],
        staggeredTiles: [
          //οσα αντικειμενα βαλαμε στο children τοσα πρεπει να βαλουμε και εδω
          StaggeredTile.extent(2,
              250.0), //η πρωτη παραμετρος λεει ποσες στηλες να καλυπτει το tile/κουτι (orange)
          StaggeredTile.extent(1,
              350.0), //δευτερη παραμετρος λεει το υψος τους tile/κουτιου  (purple)
          StaggeredTile.extent(1, 163.0),
          StaggeredTile.extent(1, 163.0),
        ],
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
                Navigator.pop(context);
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
      bottomNavigationBar: BottomNavigationBar(
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

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
  int _selectedIndex = 0; // 1η θέση του πίνακα που πάει στο homepage
  void _onItemTapped(int index) {
    // Για να αλλάζει το bottom navigation bar όταν πατάω σε ένα απ' τα 3 options
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        // 2η επιλογή του πίνακα που πάει στο page με τα πολλά charts
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChartsPage()));
      } else if (_selectedIndex == 2) {
        // 3η επιλογή του πίνακα που πάει στο page με το help
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HelpPage()));
      }
    });
  }

  // Αρχικοποίηση μεταβλητών (λίστας) που θα χρησιμοποιήσω στα heart rate που έχω στο homepage
  List<double> heartRateValues = [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 2.0];

  // Δημιουργία μιας future συνάρτησης που θα παίρνει το json (τις τιμές αυτού) για το heart rate
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
      // Αλλάζω τις τιμές που είχα δώσει πριν (στην αρχικοποίηση) με τις σωστές τιμές του Json
      this.heartRateValues = tmp;
    });
  }

  // Δημιουργία μιας void συνάρτησης η οποία είναι ασύγχρονη και χρησιμοποιείται ώστε το πρόγραμμα μου να περιμένει πρώτα να πάρει όλα τα δεδομένα και έπειτα να εμφανίσει ότι είναι
  void initData() async {
    await this.loadHeartRateData();
  }

  // Void συνάρτηση που περιέχει την InitState η οποία είναι απαραίτητη για το πρόγραμμα
  @override
  void initState() {
    super.initState();
    this.initData();
  }

  // Widget είδους myItems το οποίο περιέχει την υλοποίηση των Sleep και Me που φαίνονται στο homepage
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

// Widget είδους myHeartChart το οποίο περιέχει την υλοποίηση και ότι άλλο χρειάζεται για να εμφανίσω του παλμούς σε chart γραμμής
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
                        // Τα δεδομένα του γραφήματος
                        data:
                            heartRateData, // Τα double data που παίρνουμε απο την εντολή στην γραμμή 59
                        lineColor: Colors.red,
                        pointsMode: PointsMode
                            .all, // Για να εμφανίζει κουκίδα σε κάθε σημείο που έχει πάρει value απο το heart rate
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

  // Widget είδους build που περιέχει τα βασικά κομμάτια , όπως υλοποίηση του Dashboard
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Δημιουργία του AppBar που περιέχει τον drawer και τον τίτλο της σελίδας
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
            // Καρτέλα με το chart του heart rate
            child: myHeartChart("Heart Rate", this.heartRateValues),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Heart()));
            },
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
          InkWell(
            // Καρτέλα με το pie chart των steps
            child: StepsChartPanel(),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Steps()));
            },
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
          InkWell(
            // Καρτέλα με το 'Me' το οποίο μας πάει στο προφίλ
            child: myItems(Icons.account_box_rounded, "Me", Colors.blueGrey),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Profile()));
            },
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
          InkWell(
            // Καρτέλα με το 'Sleep' το οποίο μας πάει στο chart με τα sleep values
            child: myItems(Icons.airline_seat_individual_suite_rounded, "Sleep",
                Colors.blueGrey),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Sleep()));
            },
            customBorder: RoundedRectangleBorder(
                // Για να στρογγυλέψω τις γωνίες των καρτελών μου
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
        // Δημιουργία του drawer
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              // Δημιουργία του drawer header
              decoration: BoxDecoration(
                color: Colors.blueGrey[400],
              ),
              child: Text(
                // Τίτλος του drawer
                'Health',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              // 1o item μέσα στον drawer (home)
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              // 2o item μέσα στον drawer (heart rate)
              leading: Icon(Icons.favorite, color: Colors.redAccent),
              title: Text('Heart Rate'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Heart()));
              },
            ),
            ListTile(
              // 3o item μέσα στον drawer (steps)
              leading:
                  Icon(Icons.directions_run_rounded, color: Colors.green[600]),
              title: Text('Steps'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Steps()));
              },
            ),
            ListTile(
              // 4o item μέσα στον drawer (sleep)
              leading: Icon(Icons.airline_seat_individual_suite_rounded,
                  color: Colors.purple[300]),
              title: Text('Sleep'),
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Sleep()));
              },
            ),
            ListTile(
              // 5o item μέσα στον drawer (demographics)
              leading:
                  Icon(Icons.account_circle_rounded, color: Colors.blueAccent),
              title: Text('Demographics'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Profile()));
              },
            ),
            ListTile(
              // 6o item μέσα στον drawer (about us)
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
        // Δημιουργία του bottom navigation bar (το οποίο περιέχει τις επιλογές Home / Charts / Help)
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

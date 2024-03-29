import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:project/profile.dart';
import 'package:project/sleeps.dart';
import 'package:project/steps_cal.dart';
import 'about.dart';
import 'hearts.dart';
import 'help.dart';
import 'homepage.dart';

class ChartsPage extends StatefulWidget {
  @override
  _ChartsPageState createState() => _ChartsPageState();
}

class _ChartsPageState extends State<ChartsPage> {
  int _selectedIndex =
      1; // Επιλεγμένο εξ' αρχής το 2ο στοιχείο του bottom navigation bar (με τα charts)
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        // Αν η θέση πάει στο 0 τότε πάμε στο home page
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
      if (_selectedIndex == 2) {
        // Αν η θέση πάει στο 2 τοε πάμε στο help page
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HelpPage()));
      }
    });
  }

  // Widget είδους myItems το οποίο περιέχει τον σκελετό που θα βάλω μέσα τα charts μου (τις εικόνες με τις καρτέλες για να επιλέξει ο χρήστης γράφημα)
  Widget myItems(Image image, String heading, Color color) {
    return Material(
      color: Colors.white,
      elevation: 14.0,
      shadowColor: Colors.orangeAccent[100],
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
                    // color: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(30.0),
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: image,
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

  // Δημιουργία του build widget που περιέχει μέσα τα βασικά components appbar ,  drawer, title , etc.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Charts",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.orange, // AppBar χρώμα
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: StaggeredGridView.count(
        crossAxisCount:
            2, //ο αριθμος των στηλων που θελουμε να καλυπτει το grid
        crossAxisSpacing:
            15.0, //η αποσταση μεταξυ των κουτιων στον οριζοντιο αξονα
        mainAxisSpacing: 23.0, //η αποσταση μεταξυ των κουτιων στον καθετο αξονα
        padding: EdgeInsets.symmetric(horizontal: 17.0, vertical: 10.0),
        children: <Widget>[
          InkWell(
            child: myItems(
                Image.asset('assets/images/hearts.png',
                    width: 200, height: 150),
                "HR Chart",
                Colors.blueGrey),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Heart()));
            },
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
          InkWell(
            child: myItems(
                Image.asset('assets/images/steps_calories.png',
                    width: 200, height: 150),
                "S/C Chart",
                Colors.blueGrey),
            onTap: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Steps()));
            },
            customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0)),
          ),
          InkWell(
            child: myItems(
                Image.asset('assets/images/sleep.png', width: 200, height: 150),
                "Sleep Chart",
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
              250.0), // 1η καρτέλα στην λίστα με τα charts (το heart rate chart)
          StaggeredTile.extent(2,
              250.0), // 2η καρτέλα στην λίστα με τα charts (το steps/calories chart)
          StaggeredTile.extent(
              2, 250.0), // 3η καρτέλα στα charts μου (το sleep chart)
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
        // To bottom navigation bar μου
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

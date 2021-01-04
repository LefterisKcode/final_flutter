import 'package:flutter/material.dart';
import 'package:project/sleeps.dart';
import 'package:project/steps_cal.dart';
import 'package:project/profile.dart';
import 'about.dart';
import 'charts.dart';
import 'hearts.dart';
import 'homepage.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  int _selectedIndex = 2; // Επιλογή 3η στο bottom navigation bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) { // Αν η θέση του πίνακα είναι η 0 τότε πάμε στην homepage
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      }
      else if (_selectedIndex == 1) { // Αν η θέση του πίνακα ειναι η 1 τότε πάμε στα charts
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChartsPage()));
      }
    });
  }

  // Δημιουργία του build widget το οποίο περιέχει τα βασικά components όπως appbar, title, drawer, κλπ.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Help",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.orange, // AppBar Color
        iconTheme: IconThemeData(color: Colors.black),
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
      body: SingleChildScrollView(
        // Για να μπορουμε να κανουμε scroll προς τα κατω ή πανω οταν το κειμενο δεν χωραει στην οθονη
        scrollDirection: Axis.vertical,
        child: Column(children: <Widget>[
          Center(
            child: Text(
                "\nThis is the help section. For any question feel free to contact us :\n\n{ Email: help@gmail.com }\n\n{ Telephone: +1-202-555-0148 }\n\n\nFor more information about us and the app hit the 'About Us' in menu",
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ]),
      ),
      bottomNavigationBar: BottomNavigationBar( // Δημιουργία του bottom navigation bar
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

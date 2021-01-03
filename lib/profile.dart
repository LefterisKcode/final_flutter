import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:project/sleeps.dart';
import 'package:project/steps_cal.dart';
import 'about.dart';
import 'hearts.dart';
import 'homepage.dart';

class Profile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demographics"),
        backgroundColor: Colors.blueAccent, // AppBar Color
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite, color: Colors.redAccent),
              title: Text('Heart Rate'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Heart()));
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.directions_run_rounded, color: Colors.green[600]),
              title: Text('Steps'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Steps()));
              },
            ),
            ListTile(
              leading: Icon(Icons.airline_seat_individual_suite_rounded,
                  color: Colors.purple[300]),
              title: Text('Sleep'),
              onTap: () {
               Navigator.push(context, MaterialPageRoute(builder: (context) => Sleep()));
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.account_circle_rounded, color: Colors.blueAccent),
              title: Text('Demographics'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.info, color: Colors.black),
              title: Text('About Us'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => About()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(10.0),
        child: Center(
          child: FutureBuilder(
            future: DefaultAssetBundle.of(context).loadString('assets/data_repo/profil.json'),
            builder: (context, snapshot) {
              if(!snapshot.hasData) {
                return CircularProgressIndicator();
              }
              var myData = json.decode(snapshot.data.toString());
              var tagsJson = myData['user'];//επιλεγουμε το συγκεκριμενο στοιχειο που θελουμε βαση του key
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    elevation: 15.0,
                    shadowColor: Colors.blueAccent[200],
                    margin: EdgeInsets.all(20.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                          //  child:Image.network((tagsJson[index]['avatar'])),
                            child: Image.network('https://media-exp1.licdn.com/dms/image/C5603AQH6ZJagsJ9o9A/profile-displayphoto-shrink_200_200/0/1597740930018?e=1613001600&v=beta&t=KgpNEDukbdZzf_n3KdIzjzJkJHBshCAhSNZowypkMb4', height: 100),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child:Text("Name : " + (tagsJson[index]['displayName'])),
                        ),
                        Padding(
                          padding: EdgeInsets.all(20.0),
                          child:Text("Date of birth : " +(tagsJson[index]['dateOfBirth']).toString()),
                        )

                      ],
                    ),
                  );
                },
                itemCount: tagsJson == null ? 0 : tagsJson.length,
              );
            },
          ),
        ),
      ),
    );
  }
}
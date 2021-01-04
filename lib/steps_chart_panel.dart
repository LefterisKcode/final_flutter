import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'dart:convert';

class StepsChartPanel extends StatefulWidget {
  @override
  _StepsChartPanelState createState() => _StepsChartPanelState();
}

class _StepsChartPanelState extends State<StepsChartPanel> {
  // Δημιουργία μιας future συνάρτησης που θα επιστρέφει πίσω λίστα του είδους <CircularStackEntry>
  Future<List<CircularStackEntry>> loadStepsData() async {
    String jsonString = await DefaultAssetBundle.of(context)
        .loadString('assets/data_repo/cals_step.json');
    final jsonResponse = json.decode(jsonString);
    var tagsJson = jsonResponse['activities'];
    double s = 0.0;
    s = (tagsJson.last)['steps']
        .toDouble(); // Για να πάρω το τελευταίο στοιχείο απο την λίστα activities και πεδίο steps

    // Δημιουργία της λίστας dataEntry που θα περιέχει μέσα τις τιμές για το pie chart μου
    List<CircularStackEntry> dataEntry = [
      new CircularStackEntry([
        new CircularSegmentEntry(s, Colors.orange, rankKey: "Steps"),
        new CircularSegmentEntry((8000 - s), Colors.grey,
            rankKey: "Total Steps"),
      ]),
    ];

    return dataEntry; // Κάνω return την λίστα ώστε να την χρησιμοποιήσω αργότερα
  }

  // Widget του είδους createPieChart που παίρνει σαν ορίσματα τον τίτλο και μια λίστα απο CircularStackEntries και φτιάχνει το γράφημα πάνω στην καρτέλα
  Widget createPieChart(String title, List<CircularStackEntry> circularData) {
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
    return FutureBuilder(
      future:
          loadStepsData(), // Για να πώ απο ποια συνάρτηση θα πάρω τα δεδομένα για να φτιάξω τα widgets που χρειάζομαι
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        // Είναι η συνάρτηση που παίρνει στιγμιότυπα απο το future (γραμμή 87) και αναλόγως σε τι κατάσταση βρίσκεται θα φτιάξει το ανάλογο widget
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Έλεγχος για το αν έχει ολοκληρώσει την διαδικασία που παίρνει τα δεδομένα ή όχι
          return Center(
            child: Text("Loading data..."),
          );
        } else {
          if (snapshot.hasError) {
            // Ελέγχουμε αν τα δεδομένα που πήραμε είναι άδεια
            return Center(
              child: Text(
                  "Error! Empty snapshot"), // Αν είναι άδεια τότε εμφανίζω πάνω στην καρτέλα το μήνυμα που είναι στο Text
            );
          }
          return createPieChart(
              "Steps",
              snapshot
                  .data); // Αν δεν είναι άδεια τα δεδομέναν τότε θα επιστρέψει το widget με το γράφημα
        }
      },
    );
  }
}

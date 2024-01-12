import 'package:feel_da_beats_app/pages/dashboard.dart';
import 'package:flutter/material.dart';

class adminOnlyPage extends StatefulWidget {
  const adminOnlyPage({super.key});

  @override
  State<adminOnlyPage> createState() => _adminOnlyPageState();
}

class _adminOnlyPageState extends State<adminOnlyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Admin Only')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: "Enter tittle song",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: "Enter the artist",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: "Enter audio url",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {},
                  decoration: InputDecoration(
                    hintText: "Enter url album photo",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: null,
                  child:
                      Text("Add song", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    fixedSize: Size(200, 50),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyHomePage()));
                  },
                  child: Text("Go to homepage",
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    fixedSize: Size(200, 50),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

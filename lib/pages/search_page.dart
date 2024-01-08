import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyan[300],
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('Search for a Music',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                )),
            SizedBox(height: 20),
            TextField(
                decoration: InputDecoration(
              filled: true,
              fillColor: Color.fromARGB(255, 235, 235, 235),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide.none,
              ),
              hintText: 'Enter song name',
              prefixIcon: Icon(Icons.search),
            ))
          ],
        ),
      ),
    );
  }
}

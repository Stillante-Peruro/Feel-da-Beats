import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_da_beats_app/pages/song_page.dart';
// import 'package:feel_da_beats_app/models/music_model.dart';
import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List _allResults = [];
  List _resultList = [];
  final TextEditingController _searchController = TextEditingController();

  // Future<void> audioUploadAndSaveURLs(List<String> filePaths) async {
  //   for (String path in filePaths) {
  //     Reference storageRef = FirebaseStorage.instance.ref(path);
  //     String audioURL = await storageRef.getDownloadURL();
  //     print(audioURL);
  //     // Simpan URL ke Firestore
  //     await FirebaseFirestore.instance.collection('songs').add({
  //       'audioPath': audioURL,
  //     });
  //   }
  //   print('all urls added');
  // }

  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
    });

    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  getSongsScream() async {
    var data = await FirebaseFirestore.instance
        .collection('songs')
        .orderBy('title')
        .get();

    setState(() {
      _allResults = data.docs;
    });
    searchResultList();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getSongsScream();
    super.didChangeDependencies();
  }

  _onSearchChanged() {
    print(_searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResults = [];
    if (_searchController.text != "") {
      for (var songsSnapshot in _allResults) {
        var title = songsSnapshot['title'].toString().toLowerCase();
        if (title.contains(_searchController.text.toLowerCase())) {
          showResults.add(songsSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }

    setState(() {
      _resultList = showResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search',
        ),
        backgroundColor: Colors.cyan,
      ),
      // backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Container(
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
                ),
                controller: _searchController,
              ),
              SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('songs')
                      .snapshots(),
                  builder: (context, snapshots) {
                    return (snapshots.connectionState ==
                            ConnectionState.waiting)
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: _resultList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_resultList[index]['title'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(_resultList[index]['artist'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 16)),
                                leading: Image.network(
                                    _resultList[index]["albumImgUrl"]),
                                onTap: () {
                                  print('clicked');
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SongPage(
                                                title: _resultList[index]
                                                    ['title'],
                                                artist: _resultList[index]
                                                    ['artist'],
                                                albumImgUrl: _resultList[index]
                                                    ["albumImgUrl"],
                                                audioPath: _resultList[index]["audioPath"],
                                              )));
                                },
                              );
                            });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

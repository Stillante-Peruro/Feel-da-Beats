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

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp().whenComplete(() {
      print("completed");
    });

    _searchController.addListener(_onSearchChanged);
    print(_allResults);
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: GestureDetector(
                  child: const Icon(Icons.arrow_back),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Color.fromRGBO(62, 182, 236, 1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Enter song name',
                  prefixIcon: Icon(Icons.search),
                ),
                controller: _searchController,
              ),
              const SizedBox(height: 20),
              const Text('For you',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 20,
                    color: Color.fromRGBO(66, 87, 154, 1),
                    shadows: [
                      Shadow(
                          offset: Offset(0, 4),
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                          blurRadius: 4)
                    ],
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 5),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('songs')
                      .snapshots(),
                  builder: (context, snapshots) {
                    return (snapshots.connectionState ==
                            ConnectionState.waiting)
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            itemCount: _resultList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(_resultList[index]['title'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        color: Color.fromRGBO(99, 124, 178, 1),
                                        shadows: [
                                          Shadow(
                                              offset: Offset(0, 3),
                                              color:
                                                  Color.fromRGBO(0, 0, 0, 0.4),
                                              blurRadius: 4)
                                        ],
                                        fontWeight: FontWeight.bold)),
                                subtitle: Text(_resultList[index]['artist'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                    )),
                                leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: SizedBox(
                                      width: 57,
                                      height: 57,
                                      child: Image.network(
                                        _resultList[index]["albumImgUrl"],
                                        fit: BoxFit.cover,
                                      ),
                                    )),
                                trailing: GestureDetector(
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
                                                  albumImgUrl:
                                                      _resultList[index]
                                                          ["albumImgUrl"],
                                                  audioPath: _resultList[index]
                                                      ["audioPath"],
                                                )));
                                  },
                                  child: const Icon(
                                    Icons.play_circle_fill_rounded,
                                    color: Color.fromRGBO(62, 182, 236, 1),
                                  ),
                                ),
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

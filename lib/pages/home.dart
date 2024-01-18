// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:feel_da_beats_app/pages/expressionrecomendation.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feel_da_beats_app/pages/expression.dart';
import 'package:feel_da_beats_app/pages/hum_to_search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _allResults = [];
  // List _resultList = [];
  final TextEditingController _searchController = TextEditingController();
  bool keyboardOpen = false;

  getSongsScream() async {
    var data = await FirebaseFirestore.instance
        .collection('songs')
        .orderBy('title')
        .get();

    setState(() {
      _allResults = data.docs;
    });
    // searchResultList();
  }

  // addData() async {
  //   for (var element in songData) {
  //     FirebaseFirestore.instance.collection('songs').add(element);
  //   }
  //   print('all songs added');
  // }
  List trendingHeader = [
    {"id": 1, "image_path": "assets/images/th(1).png"},
    {"id": 2, "image_path": "assets/images/th(2).png"},
    {"id": 3, "image_path": "assets/images/th(3).png"},
    {"id": 4, "image_path": "assets/images/th(4).png"}
  ];

  String _getHeaderText() {
    switch (_currentIndex) {
      case 1:
        return 'Feel da Beats';
      case 2:
        return 'Text 1';
      case 3:
        return 'Text 2';
      case 4:
        return 'Text 3';
      default:
        return 'Feel da Beats';
    }
  }

  final CarouselController carouselController = CarouselController();
  int _currentIndex = 0;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    Firebase.initializeApp().whenComplete(() {});

    getSongsScream();

    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   getSongsScream();
  //   super.didChangeDependencies();
  // }

  _onSearchChanged() {
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

    // setState(() {
    //   _resultList = showResults;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 56,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFF3EB6EC)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 26, right: 12),
                        child: TextField(
                          decoration: const InputDecoration(
                            filled: true,
                            fillColor: Color.fromRGBO(62, 182, 236, 1),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Search',
                            suffixIcon: Icon(Icons.search),
                          ),
                          controller: _searchController,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ExpressionSearchPage(
                                    gagalIdentifikasi: false,
                                  )),
                        );
                      },
                      child: Container(
                        height: 125,
                        width: 180,
                        decoration: BoxDecoration(
                            color: const Color(0xFFC7EBFB),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                "Feel Your Expression",
                                style: TextStyle(
                                    color: Color(0XFF42579A),
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4,
                                        offset: Offset(0, 3),
                                        color: Color.fromRGBO(0, 0, 0, 0.4),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Scan ekspresi kamu disini! Yuk, cari tau moodmu hari ini",
                                style: TextStyle(
                                    color: Color(0xFF847B7B),
                                    fontFamily: 'Poppins',
                                    fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MusicPage()),
                        );
                      },
                      child: Container(
                        height: 125,
                        width: 180,
                        decoration: BoxDecoration(
                            color: const Color(0xFFC7EBFB),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                "Feel Your Tone",
                                style: TextStyle(
                                    color: Color(0XFF42579A),
                                    fontFamily: 'Poppins',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        blurRadius: 4,
                                        offset: Offset(0, 3),
                                        color: Color.fromRGBO(0, 0, 0, 0.4),
                                      ),
                                    ]),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Lupa judul lagu tapi ingat nadanya? Scan di sini aja.",
                                style: TextStyle(
                                    color: Color(0xFF847B7B),
                                    fontFamily: 'Poppins',
                                    fontSize: 12),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Center(
                    child: Container(
                        height: 193,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: const Color(0xFFC7EBFB),
                            borderRadius: BorderRadius.circular(16)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 159,
                              width: MediaQuery.of(context).size.width,
                              child: Stack(
                                children: [
                                  CarouselSlider(
                                    items: trendingHeader
                                        .map(
                                          (item) => Image.asset(
                                            item['image_path'],
                                            fit: BoxFit.fill,
                                            width: double.infinity,
                                          ),
                                        )
                                        .toList(),
                                    carouselController: carouselController,
                                    options: CarouselOptions(
                                      scrollPhysics:
                                          const BouncingScrollPhysics(),
                                      autoPlay: true,
                                      aspectRatio: 2.4,
                                      viewportFraction: 1,
                                      onPageChanged: (index, reason) {
                                        setState(() {
                                          _currentIndex = index;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, top: 15),
                                    child: Text(
                                      _getHeaderText(),
                                      style: const TextStyle(
                                          fontSize: 18,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Positioned(
                                      bottom: 16,
                                      left: 0,
                                      right: 0,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: trendingHeader
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          return GestureDetector(
                                            onTap: () => carouselController
                                                .animateToPage(entry.key),
                                            child: Container(
                                              width: 12,
                                              height: 12,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.white,
                                                      width: 2),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color:
                                                      _currentIndex == entry.key
                                                          ? Colors.white
                                                          : Colors.black),
                                            ),
                                          );
                                        }).toList(),
                                      )),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 20),
                              child: Text(
                                'Music Today',
                                style: TextStyle(
                                  color: Color(0XFF42579A),
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 4,
                                      offset: Offset(0, 3),
                                      color: Color.fromRGBO(0, 0, 0, 0.4),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    "New Songs",
                    style: TextStyle(
                      color: Color(0XFF42579A),
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          offset: Offset(0, 3),
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      ],
                    ),
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 14, bottom: 10, left: 10, right: 10),
                    child: Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(_allResults.length, (index) {
                            return SizedBox(
                              width: 100,
                              child: Column(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: SizedBox(
                                        width: 80,
                                        height: 80,
                                        child: Image.network(
                                          _allResults[index]["albumImgUrl"],
                                          fit: BoxFit.cover,
                                        ),
                                      )),
                                  Text(
                                    _allResults[index]['title'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Color(0XFF637CB2),
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 4,
                                          offset: Offset(0, 3),
                                          color: Color.fromRGBO(0, 0, 0, 0.4),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    _allResults[index]['artist'],
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        color: Color(0xFF847B7B),
                                        fontFamily: 'Roboto',
                                        fontSize: 10),
                                  ),
                                ],
                              ),
                            );
                          })),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    "Your Playlist",
                    style: TextStyle(
                      color: Color(0XFF42579A),
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          offset: Offset(0, 3),
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 56,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFFC7EBFB)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              "Make your own playlist",
                              style: TextStyle(
                                  color: Color(0xFF42579A),
                                  fontFamily: 'Roboto',
                                  fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                                icon: const Icon(Icons.add), onPressed: () {}),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 16),
                  child: Text(
                    "Your Music",
                    style: TextStyle(
                      color: Color(0XFF42579A),
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          blurRadius: 4,
                          offset: Offset(0, 3),
                          color: Color.fromRGBO(0, 0, 0, 0.4),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 56,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xFFC7EBFB)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 30),
                            child: Text(
                              "Download your music",
                              style: TextStyle(
                                  color: Color(0xFF42579A),
                                  fontFamily: 'Roboto',
                                  fontSize: 16),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: IconButton(
                                icon: const Icon(Icons.add), onPressed: () {}),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                )
              ]),
        ),
      ),
    );
  }
}

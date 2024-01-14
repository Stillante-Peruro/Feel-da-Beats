import 'package:flutter/material.dart';
import 'package:feel_da_beats_app/pages/search_page.dart';
import 'package:feel_da_beats_app/pages/home.dart';
import 'package:feel_da_beats_app/pages/expression.dart';
import 'package:feel_da_beats_app/pages/profile.dart';
import 'package:feel_da_beats_app/pages/hum_to_search.dart';

class MyHomePage extends StatefulWidget {
  static String id = "dashboard";
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  bool _isSearchActive = false;
  double _quickBallPositionY = 30;

  double _iconStartPositionX = 0;
  double _lastDragPositionX = 0;
  double _iconStartPositionY = 0;
  double _lastDragPositionY = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feel da Beats'),
      ),
      body: _getTabContent(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isSearchActive ? 115 : 30,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              width: MediaQuery.of(context).size.width, // Full width container
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: _isSearchActive ? 50 : 25,
                      width: _isSearchActive ? 50 : 25,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff3EECE1),
                      ),
                      child: IconButton(
                        icon: Icon(Icons.emoji_emotions, color: Colors.white),
                        iconSize: _isSearchActive ? 30 : 15,
                        onPressed: () {
                          // Handle action for search icon
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const ExpressionSearchPage(
                                      gagalIdentifikasi: false,
                                    )),
                          );
                          setState(() {
                            _isSearchActive = !_isSearchActive;
                          });
                        },
                      ),
                    ),
                  ]),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isSearchActive ? 65 : 45,
            left: 0,
            right: _isSearchActive ? 160 : 30,
            child: AnimatedSize(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: Container(
                height: 50,
                width:
                    MediaQuery.of(context).size.width, // Full width container
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        height: _isSearchActive ? 50 : 25,
                        width: _isSearchActive ? 50 : 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xff3EECE1),
                        ),
                        child: IconButton(
                          icon: Icon(Icons.search, color: Colors.white),
                          iconSize: _isSearchActive ? 30 : 15,
                          onPressed: () {
                            // Handle action for search icon
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchPage()),
                            );
                            setState(() {
                              _isSearchActive = !_isSearchActive;
                            });
                          },
                        ),
                      ),
                    ]),
              ),
            ),
          ),
          AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              bottom: _isSearchActive ? 65 : 45,
              left: _isSearchActive ? 160 : 30,
              right: 0,
              child: Container(
                  height: 50,
                  width:
                      MediaQuery.of(context).size.width, // Full width container
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: _isSearchActive ? 50 : 25,
                          width: _isSearchActive ? 50 : 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff3EECE1),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.music_note, color: Colors.white),
                            iconSize: _isSearchActive ? 30 : 15,
                            onPressed: () {
                              // Handle action for search icon
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MusicPage()),
                              );
                              setState(() {
                                _isSearchActive = !_isSearchActive;
                              });
                            },
                          ),
                        ),
                      ]))),
          Positioned(
            bottom: _quickBallPositionY,
            left: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _isSearchActive = !_isSearchActive;
                });
              },
              onPanStart: (details) {
                setState(() {
                  _isSearchActive = true;
                  _iconStartPositionX = details.localPosition.dx;
                  _iconStartPositionY = details.localPosition.dy;
                });
              },
              onPanUpdate: (details) {
                _lastDragPositionX = details.localPosition.dx;
                _lastDragPositionY = details.localPosition.dy;
                setState(() {});
              },
              onPanEnd: (details) {
                setState(() {
                  _isSearchActive = false;
                  _quickBallPositionY = 30;

                  double distanceX = _lastDragPositionX - _iconStartPositionX;
                  double distanceY = _lastDragPositionY - _iconStartPositionY;

                  if (distanceX.abs() > 30 || distanceY.abs() > 20) {
                    if (_lastDragPositionX < _iconStartPositionX - 35 &&
                        _lastDragPositionY < _iconStartPositionY &&
                        _lastDragPositionY < _iconStartPositionY) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SearchPage()),
                      );
                    } else if (_lastDragPositionY < _iconStartPositionY - 50 &&
                        _lastDragPositionX - 50 < _iconStartPositionX &&
                        _lastDragPositionX + 50 > _iconStartPositionX) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ExpressionSearchPage(
                                  gagalIdentifikasi: false,
                                )),
                      );
                    } else if (_lastDragPositionX > _iconStartPositionX + 35 &&
                        _lastDragPositionY < _iconStartPositionY &&
                        _lastDragPositionY < _iconStartPositionY - 10) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MusicPage()),
                      );
                    }
                  }
                });
              },
              child: Container(
                height: 65,
                width: 65,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff3EB6EC),
                ),
                child: const Center(
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _getTabContent(int index) {
    switch (index) {
      case 0:
        return HomeScreen(); // Widget untuk konten halaman Home
      case 1:
        return ProfileScreen(); // Widget untuk konten halaman Profile
      default:
        return HomeScreen();
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _isSearchActive = false;
    });
  }
}

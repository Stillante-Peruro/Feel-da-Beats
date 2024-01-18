import 'package:flutter/material.dart';
import 'package:feel_da_beats_app/pages/search_page.dart';
import 'package:feel_da_beats_app/pages/home.dart';
import 'package:feel_da_beats_app/pages/expression.dart';
import 'package:feel_da_beats_app/pages/profile.dart';
import 'package:feel_da_beats_app/pages/hum_to_search.dart';
import 'package:flutter/services.dart';

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
  bool _isMusic = false;
  bool _isSearch = false;
  bool _isEmoji = false;
  double _iconStartPositionX = 0;
  double _lastDragPositionX = 0;
  double _iconStartPositionY = 0;
  double _lastDragPositionY = 0;
  bool? resizeToAvoidBottomInset;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(
        preferredSize: Size.zero,
        child: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.white,
            // statusBarIconBrightness: Brightness.dark,
            // statusBarBrightness: Brightness.light,
          ),
        ),
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
            child: CircleAvatar(
              radius: _isSearchActive ? (_isEmoji ? 30 : 25) : 5,
              backgroundColor: const Color(0xff3EECE1),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                child: IconButton(
                  icon: const Icon(Icons.emoji_emotions, color: Colors.white),
                  iconSize: _isSearchActive ? (_isEmoji ? 35 : 30) : 1,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExpressionSearchPage(
                          gagalIdentifikasi: false,
                        ),
                      ),
                    );
                    setState(() {
                      _isSearchActive = !_isSearchActive;
                    });
                  },
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isSearchActive ? 65 : 45,
            left: 0,
            right: _isSearchActive ? 160 : 30,
            child: CircleAvatar(
              radius: _isSearchActive ? (_isSearch ? 30 : 25) : 5,
              backgroundColor: const Color(0xff3EECE1),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                child: IconButton(
                  icon: const Icon(Icons.search, color: Colors.white),
                  iconSize: _isSearchActive ? (_isSearch ? 35 : 30) : 15,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchPage(),
                      ),
                    );
                    setState(() {
                      _isSearchActive = !_isSearchActive;
                    });
                  },
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: _isSearchActive ? 65 : 45,
            left: _isSearchActive ? 160 : 30,
            right: 0,
            child: CircleAvatar(
              radius: _isSearchActive ? (_isMusic ? 30 : 25) : 5,
              backgroundColor: const Color(0xff3EECE1),
              child: AnimatedSize(
                duration: const Duration(milliseconds: 100),
                curve: Curves.easeInOut,
                child: IconButton(
                  icon: const Icon(Icons.music_note, color: Colors.white),
                  iconSize: _isSearchActive ? (_isMusic ? 35 : 30) : 15,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MusicPage(),
                      ),
                    );
                    setState(() {
                      _isSearchActive = !_isSearchActive;
                    });
                  },
                ),
              ),
            ),
          ),
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
                setState(() {
                  double distanceX = _lastDragPositionX - _iconStartPositionX;
                  double distanceY = _lastDragPositionY - _iconStartPositionY;

                  if (distanceX.abs() > 30 || distanceY.abs() > 20) {
                    if (_lastDragPositionX < _iconStartPositionX - 35 &&
                        _lastDragPositionY < _iconStartPositionY &&
                        _lastDragPositionY < _iconStartPositionY) {
                      _isEmoji = false;
                      _isMusic = false;
                      _isSearch = true;
                    } else if (_lastDragPositionY < _iconStartPositionY - 50 &&
                        _lastDragPositionX - 50 < _iconStartPositionX &&
                        _lastDragPositionX + 50 > _iconStartPositionX) {
                      _isEmoji = true;
                      _isMusic = false;
                      _isSearch = false;
                    } else if (_lastDragPositionX > _iconStartPositionX + 35 &&
                        _lastDragPositionY < _iconStartPositionY &&
                        _lastDragPositionY < _iconStartPositionY - 10) {
                      _isEmoji = false;
                      _isMusic = true;
                      _isSearch = false;
                    }
                  } else {
                    _isEmoji = false;
                    _isMusic = false;
                    _isSearch = false;
                  }
                });
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
                        MaterialPageRoute(
                            builder: (context) => const SearchPage()),
                      );
                    } else if (_lastDragPositionY < _iconStartPositionY - 50 &&
                        _lastDragPositionX - 50 < _iconStartPositionX &&
                        _lastDragPositionX + 50 > _iconStartPositionX) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ExpressionSearchPage(
                                  gagalIdentifikasi: false,
                                )),
                      );
                    } else if (_lastDragPositionX > _iconStartPositionX + 35 &&
                        _lastDragPositionY < _iconStartPositionY &&
                        _lastDragPositionY < _iconStartPositionY - 10) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MusicPage()),
                      );
                    }
                  }
                  _isEmoji = false;
                  _isMusic = false;
                  _isSearch = false;
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
        return const HomeScreen(); // Widget untuk konten halaman Home
      case 1:
        return const ProfileScreen(); // Widget untuk konten halaman Profile
      default:
        return const HomeScreen();
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _isSearchActive = false;
    });
  }
}

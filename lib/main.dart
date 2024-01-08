import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feel da Beats',
      theme: ThemeData(
        primarySwatch: Colors.cyan,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  bool _isSearchActive = false;
  double _quickBallPositionY = 30; // Y position of Quick Ball

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
                        MaterialPageRoute(builder: (context) => EmojiPage()),
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
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue,
                ),
                child: const Center(
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 35,
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            bottom: _isSearchActive ? 60 : -100,
            left: 0,
            right: 0,
            child: Container(
              height: 100,
              width: MediaQuery.of(context).size.width, // Full width container
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.cyan,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.emoji_emotions, color: Colors.white),
                      onPressed: () {
                        // Handle action for search icon
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EmojiPage()),
                        );
                      },
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.cyan,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.search, color: Colors.white),
                            onPressed: () {
                              // Handle action for search icon
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage()),
                              );
                            },
                          ),
                        ),
                        Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.cyan,
                          ),
                          child: IconButton(
                            icon: Icon(Icons.music_note, color: Colors.white),
                            onPressed: () {
                              // Handle action for search icon
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MusicPage()),
                              );
                            },
                          ),
                        ),
                      ]),
                ],
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
        return Container(); // Atau widget default jika indeks tidak ditemukan
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Update indeks saat tab lainnya dipilih
      _isSearchActive =
          false; // Nonaktifkan ikon tambahan saat tab lainnya dipilih
    });
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Home Page'),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Profile Page'),
      ),
    );
  }
}

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Page'),
      ),
      body: Center(
        child: Text('Search Page'),
      ),
    );
  }
}

class EmojiPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emoji Page'),
      ),
      body: Center(
        child: Text('Emoji Page'),
      ),
    );
  }
}

class MusicPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Music Page'),
      ),
      body: Center(
        child: Text('Music Page'),
      ),
    );
  }
}

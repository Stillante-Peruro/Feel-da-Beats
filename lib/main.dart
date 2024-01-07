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
          if (_isSearchActive) _buildSearchIcons(),
          _buildSearchButton(),
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

  Widget _buildSearchButton() {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _isSearchActive = !_isSearchActive;
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
    );
  }

  Widget _buildSearchIcons() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 6000),
      curve: Curves.easeInOut,
      bottom: _isSearchActive ? 80 : 0,
      left: 0,
      right: 0,
      child: Container(
        height: 100,
        width: 100,
        child: Row(
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
                    MaterialPageRoute(builder: (context) => SearchPage()),
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
                    MaterialPageRoute(builder: (context) => MusicPage()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
    return Center(
      child: Text('Home Screen'),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Profile Screen'),
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

## About Us
Nama Aplikasi: Feel Da Beats,
Nama Tim: Stillante Peruro,
Nama Anggota:
1. M. Ilham Syafik (Hustler + PIC)
2. Aulia Salsabella (Hipster)
3. Muhammad Arief Pratama (Hacker)
4. RA. Nur Afifah Widyadhana (Hacker)

<h2>Introduction</h2>
Welcome to Feel da Beats app, an music application that has unique features that can make it easier for us to search for songs such as scan by expression, hum to search, and other unique features.

<h2>Problem Statement</h2>
Difficulty in finding songs that match the emotions a person is feeling can have a negative impact on a person's mental health.

<h2>Proposed Solution</h2>
Helps users find songs that match the emotions they are feeling, thereby making users feel better mentally.

## Overview
UI Scheme 1            | UI Scheme 2
:-------------------------:|:-------------------------:|
![UI1](https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/ui1.png?raw=true)|![UI2](https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/ui2.png?raw=true)|

## Features
1. Music Player, to play music, pause music, jump to a certain minute in the music, repeat the music, play the previous song, and play the next song.
2. Lyrics, feature to display the lyrics of the song being played.
3. Romanization, changing lyrics that were originally non-Latin to Latin or vice versa.
4. Download Music, to enable users to listen to music continuously without needing to use internet quota.
5. Offline Mode, allows users to listen to downloaded music without needing to connect to the internet.
6. Emotion Searching, displays song recommendations based on the emotions being felt by the user.
7. Hum To Search, search for songs through the tune of the song being played, through singing or humming.
8. Manual Searching, search for songs using the keyword song title and name of the singer or artist.

## Application Screenshots
### Login Page
<div style="display:flex;">
   <img src="https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/login.jpg" alt="screen_5" width="200"/>
</div>
### Register Page
<div style="display:flex;">
   <img src="https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/register.jpg" alt="screen_5" width="200"/>
</div>
### Homepage
<div style="display:flex;">
   <img src="https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/home.jpg" alt="screen_5" width="200"/>
</div>
### Search Page
<div style="display:flex;">
   <img src="https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/search.jpg" alt="screen_5" width="200"/>
</div>
### Emotion Search Page
<div style="display:flex;">
  <img src="https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/emotionsearch.jpg" alt="screen_5" width="200"/>
  <img src="https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/emotionsearch2.png" alt="screen_5" width="200"/>
  <img src="https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/angrymood.jpg" alt="screen_5" width="200"/>
  <img src="https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/sadmood.jpg" alt="screen_5" width="200"/>
  <img src="https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/happymood.jpg" alt="screen_5" width="200"/>
  <img src="https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/neutralmood.jpg" alt="screen_5" width="200"/>
</div>
### Hum To Search Page
<div style="display:flex;">
  <img src="https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/hum.jpg" alt="screen_5" width="200"/>
  <img src="https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/hum2.jpg" alt="screen_5" width="200"/>
</div>
### Music Player
<div style="display:flex;">
   <img src="https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/musicplayer.jpg" alt="screen_5" width="200"/>
</div>

- The rest of pages can be seen by installing our Feel da Beats app.

## How to Compile & Run
1. Install Java JDK (add to PATH), Android Studio, VS Code (or any preferred IDE), Flutter SDK, etc. to install all needed tools (SDK, NDK, extra tools) for Android development toolchain, please refer to this [link](https://docs.flutter.dev/get-started/install/windows/mobile).
2. Clone this repository.
3. Run `flutter pub get` to get rid of problems of missing dependencies.
4. Using your browser, navigate to [Firebase Console](https://console.firebase.google.com/) to setup the Firebase integration.
5. Click add project then proceed with the steps shown in Firebase Console web (setup Authentication, Firestore DB, and Storage).
6. Download `google-services.json` and place it to app-level Android folder (android/app/).
7. Edit `.env.example` name to `.env`, then edit value of each environment variables according to your API (check [Firebase Console](https://console.firebase.google.com/) for all Firebase-related API, [ACRCloud Console](https://console.acrcloud.com/)).
8. Run `flutter build apk --release --split-per-abi --obfuscate --split-debug-info=/debug_info/` for splitted APK (each architecture) or `flutter build apk --release --obfuscate --split-debug-info=/debug_info/` for FAT APK (contains all ABIs)
9. Your build should be at `build/app/outputs/flutter-apk`
Facing problems? Kindly open an issue.

## Tech Stack
- Flutter
- Firebase (Firestore DB, Storage)
- Tensorflow
- Google ML Kit
- Android (Platform)
- ACRCloud

## System Design 
We used Use Case Diagram and Sequence Diagram to design & plan our NeuroParenting app precisely. 

### Use Case Diagram
[Use Case Diagram](https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/UseCaseDiagram.pdf) (Download in PDF)

### Sequence Diagram of Each Use Case
[System Analysis & Design of NeuroParenting](https://github.com/Stillante-Peruro/Feel-da-Beats/blob/main/screenshot/SequenceDiagram.pdf) (Download in PDF)

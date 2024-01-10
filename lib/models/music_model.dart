  //List lagu yg sudah ditambahkan
  
  List<Map<String, dynamic>> songData = [
    // {
    //   "title": "No Way",
    //   "artist": "BIMINI (with Avi Snow)",
    //   "audioPath": "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/songs%2Fsad_playlist%2FBIMINI%20-%20No%20Way%20(with%20Avi%20Snow)%20%5BNCS%20Release%5D.mp3?alt=media&token=f6c0449e-dd95-4b50-8f67-52f2c2badad5",
    //   "albumImgUrl":
    //       "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/album_covers%2FNo%20Way%20(ncs-sad).jpg?alt=media&token=8190beb2-1a9e-4cf9-af65-792ed045002d",
    //   "emotionPlaylistType": "Sad"
    // },
    // {
    //   "title": "Lies",
    //   "artist": "Diamond Eyes",
    //   "audioPath": "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/songs%2Fsad_playlist%2FDiamond%20Eyes%20-%20Lies%20%5BNCS%20Release%5D.mp3?alt=media&token=f07f624b-9470-4f3c-bc40-c96731a847ed",
    //   "albumImgUrl":
    //       "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/album_covers%2FLies%20(ncs-sad).jpg?alt=media&token=a97bda64-f6b9-46a8-a076-e2be2bd9fba1",
    //   "emotionPlaylistType": "Sad"
    // },
    // {
    //   "title": "feel",
    //   "artist": "JB Hain",
    //   "audioPath": "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/songs%2Fsad_playlist%2FJB%20Hain%20-%20feel%20%5BNCS%20Release%5D.mp3?alt=media&token=ae6d9606-f0a6-4453-86ea-6d9da9e34b17",
    //   "albumImgUrl":
    //       "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/album_covers%2Ffeel%20(ncs-sad).jpg?alt=media&token=5ec8e71a-4af0-41f0-9aed-eb6504538c70",
    //   "emotionPlaylistType": "Sad"
    // },
    // {
    //   "title": "Hold You",
    //   "artist": "Low Mileage",
    //   "audioPath": "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/songs%2Fhappy_playlist%2FLow%20Mileage%20-%20Hold%20You%20%5BNCS%20Release%5D.mp3?alt=media&token=a771b0fb-f088-423e-a2e8-e0e0645ff003",
    //   "albumImgUrl":
    //       "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/album_covers%2FHold%20You%20(ncs-happy).jpg?alt=media&token=a739972e-8a66-4a6f-80ce-557a3952f90a",
    //   "emotionPlaylistType": "Happy"
    // },
    // {
    //   "title": "For You",
    //   "artist": "T & Sugah (ft. Snnr)",
    //   "audioPath": "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/songs%2Fhappy_playlist%2FT%20%26%20Sugah%20-%20For%20You%20(ft.%20Snnr)%20%5BNCS%20Release%5D.mp3?alt=media&token=a07bf386-9d00-422a-b878-07bfac23b46f",
    //   "albumImgUrl":
    //       "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/album_covers%2FFor%20You%20(ncs-happy).jpg?alt=media&token=4ff5afce-21c6-40a1-bd13-f966fc95530d",
    //   "emotionPlaylistType": "Happy"
    // },
    // {
    //   "title": "Time With You",
    //   "artist": "Tollef (feat. RVLE)",
    //   "audioPath": "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/songs%2Fhappy_playlist%2FTollef%20-%20Time%20With%20You%20(feat.%20RVLE)%20%5BNCS%20Release%5D.mp3?alt=media&token=09cc0196-fe08-4149-9d13-da389a6f3f2c",
    //   "albumImgUrl":
    //       "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/album_covers%2FTime%20With%20You%20(ncs-happy).jpg?alt=media&token=4ea1b11a-961f-4ad6-9ba4-050f04c54b7b",
    //   "emotionPlaylistType": "Happy"
    // },
    // {
    //   "title": "Vienna",
    //   "artist": "James Mercy (feat. PhiloSofie)",
    //   "audioPath": "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/songs%2Fangry_playlist%2FJames%20Mercy%20-%20Vienna%20(feat.%20PhiloSofie)%20%5BNCS%20Release%5D.mp3?alt=media&token=20d1af71-94ff-4f3e-8827-7976616692a7",
    //   "albumImgUrl":
    //       "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/album_covers%2FVienna%20(ncs-angry).jpg?alt=media&token=a5bbb3a7-1ef8-4f5d-b220-b33f85b65df3",
    //   "emotionPlaylistType": "Angry"
    // },
    // {
    //   "title": "Desperate",
    //   "artist": "NEFFEX",
    //   "audioPath": "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/songs%2Fangry_playlist%2FNEFFEX%20-%20Desperate%20%5BNCS%20Release%5D.mp3?alt=media&token=953f0f56-7802-45ae-858c-26f987df54df",
    //   "albumImgUrl":"https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/album_covers%2FDesperate%20(ncs-angry).jpg?alt=media&token=c7e91bbe-6f01-4a71-93ff-d7afead572c5",
    //   "emotionPlaylistType": "Angry"
    // },
    // {
    //   "title": "World on Fire ",
    //   "artist": "Outlandr",
    //   "audioPath": "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/songs%2Fangry_playlist%2FOutlandr%20-%20World%20on%20Fire%20%5BNCS%20Release%5D.mp3?alt=media&token=866c51a2-7f95-4ab8-b1ae-d9e0f01a1d4c",
    //   "albumImgUrl":
    //       "https://firebasestorage.googleapis.com/v0/b/feel-da-beats.appspot.com/o/album_covers%2FWorld%20on%20Fire%20(ncs-angry).jpg?alt=media&token=e8ec568b-9b9b-4907-aa48-4da213ef7405",
    //   "emotionPlaylistType": "Angry"
    // },
  ];

import 'package:flutter/material.dart';

String getMoodText(int moodNumber) {
  switch (moodNumber) {
    case 1:
      return 'HAPPY';
      break;
    case 2:
      return 'EXCITED';
      break;
    case 3:
      return 'ANGRY';
      break;
    case 4:
      return 'SAD';
      break;
    case 5:
      return 'DEPRESSED';
      break;
    default:
      return 'NEUTRAL';
  }
}

String getRoleText(int userRole) {
  switch (userRole) {
    case 1:
      return 'Admin';
      break;
    case 2:
      return 'Admin';
      break;
    case 3:
      return 'Selector';
      break;
    case 4:
      return 'Volunteer';
      break;
    case 5:
      return 'User';
      break;
    default:
      return 'User';
  }
}

Color getMoodColor(String mood) {
  switch (mood) {
    case 'HAPPY':
      return Color(0xFFD4860B);
      break;
    case 'EXCITED':
      return Color(0xFF149A80);
      break;
    case 'ANGRY':
      return Color(0xFFE12E1C);
      break;
    case 'SAD':
      return Color(0xFF1E2B37);
      break;
    case 'DEPRESSED':
      return Color(0xFF809395);
      break;
    case 'NEUTRAL':
      return Colors.blue;
      break;
    default:
      return Colors.blue;
  }
}

int getMoodNumber(String mood) {
  switch (mood) {
    case 'HAPPY':
      return 1;
      break;
    case 'EXCITED':
      return 2;
      break;
    case 'ANGRY':
      return 3;
      break;
    case 'SAD':
      return 4;
      break;
    case 'DEPRESSED':
      return 5;
      break;
    case 'NEUTRAL':
      return 6;
      break;
    default:
      return 6;
  }
}

Color getMoodColorFromNumber(int mood) {
  switch (mood) {
    case 1:
      return Color(0xFFD4860B);
      break;
    case 2:
      return Color(0xFF149A80);
      break;
    case 3:
      return Color(0xFFE12E1C);
      break;
    case 4:
      return Color(0xFF1E2B37);
      break;
    case 5:
      return Color(0xFF809395);
      break;
    case 6:
      return Colors.blue;
      break;
    default:
      return Colors.blue;
  }
}

AppBar MainAppBar() {
  return AppBar(
    // backgroundColor: const Color(0xFFf8fefe),
    backgroundColor: const Color(0xFF2C3E50),
    elevation: 3.0,
    centerTitle: true,
    backwardsCompatibility: false,
    title: Text(
      'Allay',
      style: TextStyle(
          color: Colors.white, fontSize: 26, fontFamily: 'Permanent Marker'),
    ),
  );
}

List<String> tagList = [
  'Relationship',
  'Family',
  'Finance',
  'Disease',
  'Love',
  'Emotions',
  'Stress',
  'Hygiene'
];

List<String> volunteerQuestions = [
  "https://firebasestorage.googleapis.com/v0/b/allay-convo.appspot.com/o/VolunteerApplicationQuestion%2FPicsArt_05-31-01.39.25.jpg?alt=media&token=cef3213c-1a8d-404c-85ad-2ef98029683b",
  "https://firebasestorage.googleapis.com/v0/b/allay-convo.appspot.com/o/VolunteerApplicationQuestion%2FPicsArt_06-11-04.09.12.jpg?alt=media&token=871e9aa2-c97f-44a0-907a-4d0dca98e024",
  "https://firebasestorage.googleapis.com/v0/b/allay-convo.appspot.com/o/VolunteerApplicationQuestion%2FPicsArt_06-11-04.00.28.jpg?alt=media&token=a6200756-a854-4b5f-a722-575862a56429",
  "https://firebasestorage.googleapis.com/v0/b/allay-convo.appspot.com/o/VolunteerApplicationQuestion%2FPicsArt_06-11-04.18.34.jpg?alt=media&token=19811c89-e2b2-4bfe-8302-c15c086521af",
  "https://firebasestorage.googleapis.com/v0/b/allay-convo.appspot.com/o/VolunteerApplicationQuestion%2FPicsArt_06-11-03.56.26.jpg?alt=media&token=b6942ad3-9915-4cc5-b40a-a475b6831f30",
  "https://firebasestorage.googleapis.com/v0/b/allay-convo.appspot.com/o/VolunteerApplicationQuestion%2FIMG_20210611_175852.jpg?alt=media&token=799b345e-feb5-43ef-a3c1-8c5c1b29e2a2",
  "https://firebasestorage.googleapis.com/v0/b/allay-convo.appspot.com/o/VolunteerApplicationQuestion%2FIMG_20210611_175947.jpg?alt=media&token=74270bf4-0970-41f6-81f1-2f7b177c04b3",
  "https://firebasestorage.googleapis.com/v0/b/allay-convo.appspot.com/o/VolunteerApplicationQuestion%2FIMG_20210611_180247.jpg?alt=media&token=6af3af74-2afd-4ec2-8cd7-0026b4990166"
];

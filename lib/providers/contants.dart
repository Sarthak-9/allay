import 'package:flutter/material.dart';

String getMoodText(int moodNumber){
  switch(moodNumber){
    case 1:
      return 'Happy';
      break;
    case 2:
      return 'Excited';
      break;
      case 3:
    return 'Angry';
    break;
    case 4:
    return 'Sad';
    break;
    case 5:
    return 'Depressed';
    break;
    default :
      return 'Neutral';
  }
}

Color getMoodColor(String mood){
  switch(mood){
    case 'Happy':
      return Color(0xFFD4860B);
      break;
    case 'Excited':
      return Color(0xFF149A80);
      break;
    case 'Angry':
      return Color(0xFFE12E1C);
      break;
    case 'Sad':
      return Color(0xFF1E2B37);
      break;
    case 'Depressed':
      return Color(0xFF809395);
      break;
    case 'Neutral':
      return Colors.blue;
      break;
    default :
      return Colors.blue;
  }
}

  int getMoodNumber(String mood){
  switch(mood){
    case 'Happy':
      return 1;
      break;
    case 'Excited':
      return 2;
      break;
    case 'Angry':
      return 3;
      break;
    case 'Sad':
      return 4;
      break;
    case 'Depressed':
      return 5;
      break;
    case 'Neutral':
      return 6;
      break;
    default :
      return 6;
  }
}

Color getMoodColorFromNumber(int mood){
  switch(mood){
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
    default :
      return Colors.blue;
  }
}

AppBar mainAppBar(){
  return AppBar(
    backgroundColor: const Color(0xFFf8fefe),
    elevation:3.0,
    centerTitle: true,
    backwardsCompatibility: false,
    title: Text('Allay',style: TextStyle(
        color: const Color(0xFF2C3E50),
        fontSize: 26,
        fontFamily: 'Permanent Marker'
    ),),
  );
}
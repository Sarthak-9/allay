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
    default :
      return Color(0xFF809395);
  }
}

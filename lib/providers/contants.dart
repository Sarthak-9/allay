import 'package:flutter/material.dart';

String getMoodText(int moodNumber){
  switch(moodNumber){
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
    default :
      return 'NEUTRAL';
  }
}

Color getMoodColor(String mood){
  switch(mood){
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
    default :
      return Colors.blue;
  }
}

  int getMoodNumber(String mood){
  switch(mood){
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

AppBar MainAppBar(){
  return AppBar(
    // backgroundColor: const Color(0xFFf8fefe),
    backgroundColor: const Color(0xFF2C3E50),
    elevation:3.0,
    centerTitle: true,
    backwardsCompatibility: false,
    title: Text('Allay',style: TextStyle(
        color: Colors.white,
        fontSize: 26,
        fontFamily: 'Permanent Marker'
    ),),
  );
}

List<String> tagList = [
  'Relationship','Family','Finance','Disease','Love','Emotions','Stress','Hygiene'
];

List<String> volunteerQuestions = [
  'https://resources.workable.com/wp-content/uploads/2016/12/shutterstock_367503539_EI.jpg',
  'https://resources.workable.com/wp-content/uploads/2016/12/shutterstock_367503539_EI.jpg',
  'https://resources.workable.com/wp-content/uploads/2016/12/shutterstock_367503539_EI.jpg',
  'https://resources.workable.com/wp-content/uploads/2016/12/shutterstock_367503539_EI.jpg',
  'https://resources.workable.com/wp-content/uploads/2016/12/shutterstock_367503539_EI.jpg',
  'https://resources.workable.com/wp-content/uploads/2016/12/shutterstock_367503539_EI.jpg',
  'https://resources.workable.com/wp-content/uploads/2016/12/shutterstock_367503539_EI.jpg',
  'https://resources.workable.com/wp-content/uploads/2016/12/shutterstock_367503539_EI.jpg',
];
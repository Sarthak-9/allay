import 'dart:io';

import 'package:flutter/material.dart';

class UserDataModel with ChangeNotifier {
  // final String userFId;
  // final String userId;
  final String userEmail;
  final String userBio;
  final String userName;
  final int userRole;
  final DateTime userDateOfBirth;
  final String profilePhotoLink;
  final File userProfileImage;
  int averageHappinessIndex;
  UserDataModel(
      {
        // this.userId,
        @required this.userEmail,
        @required this.userBio,
        @required this.userName,
        @required this.userDateOfBirth,
        this.userRole,
        this.profilePhotoLink,
        this.userProfileImage,
        this.averageHappinessIndex});
}
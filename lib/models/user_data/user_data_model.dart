import 'dart:io';

import 'package:flutter/material.dart';

class UserDataModel with ChangeNotifier {
  // final String userFId;
  final String userEmail;
  final String userPhone;
  final String userName;
  final int userRole;
  final int userAge;
  final String profilePhotoLink;
  final File userProfileImage;
  int averageHappinessIndex;
  UserDataModel(
      {
        // this.userFId,
        @required this.userEmail,
        @required this.userPhone,
        @required this.userName,
        @required this.userAge,
        this.userRole,
        this.profilePhotoLink,
        this.userProfileImage,
        this.averageHappinessIndex});
}
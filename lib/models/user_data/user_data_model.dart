import 'dart:io';

import 'package:flutter/material.dart';

class UserDataModel with ChangeNotifier {
  final String userFId;
  final String userEmail;
  final String userPhone;
  final String userName;
  final String userRole;
  final DateTime dateofBirth;
  final String profilePhotoLink;
  final File userProfileImage;
  int averageHappinessIndex;
  UserDataModel(
      {this.userFId,
        @required this.userEmail,
        @required this.userPhone,
        @required this.userName,
        @required this.dateofBirth,
        this.userRole,
        this.profilePhotoLink,
        this.userProfileImage,
        this.averageHappinessIndex});
}
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class UserDataModel with ChangeNotifier {
  final String userFId;
  final String userEmail;
  final String userPhone;
  final String userName;
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
      this.profilePhotoLink,
        this.userProfileImage,
      this.averageHappinessIndex});
}

class UserData with ChangeNotifier {
  UserDataModel _userData;
  final firestoreInstance = FirebaseFirestore.instance;

  UserDataModel get userData => _userData;

  Future<void> addUser(UserDataModel newUser) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    var _userID = _auth.currentUser.uid;
    print(_userID);
    try {
      // final databaseRef = FirebaseDatabase.instance
      //     .reference()
      //     .child('user')
      //     .child(_userID); //database reference object
      // await databaseRef.push().set({
      //   'userEmail': newUser.userEmail,
      //   'userName': newUser.userName,
      //   'userPhone': newUser.userPhone,
      //   'userDOB': newUser.dateofBirth != null
      //       ? newUser.dateofBirth.toIso8601String()
      //       : null,
      // });
      var userDataId;
      var photoUrl;
      // FirebaseStorage storage = FirebaseStorage.instance;
      // Reference ref =
      // storage.ref().child("userblogs").child(DateTime.now().toString());
      // UploadTask uploadTask = ref.putFile(newUser.userProfileImage);
      // await uploadTask.whenComplete(() async {
      //   photoUrl = await ref.getDownloadURL();
      // }).catchError((onError) {
      //   throw onError;
      // });
      firestoreInstance.collection("userdata").add({
        'userEmail': newUser.userEmail,
        'userName': newUser.userName,
        'userPhone': newUser.userPhone,
        'userDOB': newUser.dateofBirth != null
            ? newUser.dateofBirth.toIso8601String()
            : null,
      }).then((value) {
        // blogFirestoreId = value.id;
      });
      print('done');
      final user = UserDataModel(
          userFId: _userID,
          userEmail: newUser.userEmail,
          userPhone: newUser.userPhone,
          userName: newUser.userName,
          dateofBirth: newUser.dateofBirth);
      _userData = user;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateUser(UserDataModel updateUser) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    var _userID = _auth.currentUser.uid;
    var userFid = _userData.userFId;

    // var url = Uri.parse('https://yourday-306218-default-rtdb.firebaseio.com/user/$_userID/$userFid.json');
    try {
      final databaseRef = FirebaseDatabase.instance
          .reference()
          .child('user')
          .child(_userID)
          .child(userFid); //database reference object
      await databaseRef.update({
        'userEmail': updateUser.userEmail,
        'userName': updateUser.userName,
        'userPhone': updateUser.userPhone,
        'userDOB': updateUser.dateofBirth != null
            ? updateUser.dateofBirth.toIso8601String()
            : null,
        'profilePhotoLink': updateUser.profilePhotoLink
      });

      final user = UserDataModel(
          userFId: userFid,
          userEmail: updateUser.userEmail,
          userPhone: updateUser.userPhone,
          userName: updateUser.userName,
          dateofBirth: updateUser.dateofBirth);
      _userData = user;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> fetchUser() async {
    print('21');
    FirebaseAuth _auth = FirebaseAuth.instance;
    print('22');
    if (_auth == null || _auth.currentUser == null) {
      print('23');
      return false;
    }
    print('24');
    _auth.currentUser.refreshToken;
    print('25');
    var _userID = _auth.currentUser.uid;
    print('26');
    var url = Uri.parse(
        'https://yourday-306218-default-rtdb.firebaseio.com/user/$_userID.json');
    try {
      final response = await http.get(url);
      print(response);
      if (response == null) {
        print('27');
        return false;
      }
      print('28');
      UserDataModel _loadedUser;
      final extractedUser = json.decode(response.body) as Map<String, dynamic>;
      extractedUser.forEach((key, userdata) {
        _loadedUser = UserDataModel(
          userFId: key,
          userEmail: userdata['userEmail'],
          userPhone: userdata['userPhone'],
          userName: userdata['userName'],
          dateofBirth: userdata['userDOB'] != null
              ? DateTime.parse(userdata['userDOB'])
              : null,
          profilePhotoLink: userdata['profilePhotoLink'],
        );
      });
      _userData = _loadedUser;
      return true;
    } catch (error) {
      return false;
      print(error);
      throw error;
    }
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:allay/models/user_data/user_data_model.dart';
import 'package:flutter/foundation.dart';

class UserData with ChangeNotifier {
  UserDataModel _userData;
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String imgUrl =
      'https://firebasestorage.googleapis.com/v0/b/allay-convo.appspot.com/o/userdata%2FE2esVpFqZwSq25ufeyE3boPP7k222021-05-30T18%3A05%3A38.477107?alt=media&token=07406990-77dd-4b7a-8a88-1e1d33bd9eed';

  UserDataModel get userData => _userData;

  Future<void> addUser(UserDataModel newUser) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    String _userID = _auth.currentUser.uid;
    // print(_userID);
    try {
      var querySnapshot =
          await firestoreInstance.collection("userdata").doc(_userID).set({
        'userEmail': newUser.userEmail,
        'userName': newUser.userName,
        'userBio': newUser.userBio,
        'userDateOfBirth': newUser.userDateOfBirth.toIso8601String(),
        // != null
        // ? newUser.dateofBirth.toIso8601String()
        // : null,
        'userRole': 5,
        "profilePhotoLink": imgUrl, //newUser.profilePhotoLink,
      }).then((value) {
        // blogFirestoreId = value.id;
      });
      final user = UserDataModel(
          // userId: _userID,
          userEmail: newUser.userEmail,
          userBio: newUser.userBio,
          userName: newUser.userName,
          userRole: 5,
          userDateOfBirth: newUser.userDateOfBirth,
          profilePhotoLink: null);
      _userData = user;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateUser(UserDataModel updateUser) async {
    String photoUrl = imgUrl;
    var _userID = _auth.currentUser.uid;
    // var userFid = _userData.userFId;
    try {
      if (updateUser.userProfileImage != null) {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage
            .ref()
            .child("userdata")
            .child(_userID + DateTime.now().toIso8601String());
        UploadTask uploadTask = ref.putFile(updateUser.userProfileImage);
        await uploadTask.whenComplete(() async {
          photoUrl = await ref.getDownloadURL();
        }).catchError((onError) {
          throw onError;
        });
      } else {
        photoUrl = _userData.profilePhotoLink;
      }
      await firestoreInstance.collection("userdata").doc(_userID).update({
        'userBio': updateUser.userBio,
        // 'userDateOfBirth': updateUser.userAge,
        // != null
        //       ? updateUser.dateofBirth.toIso8601String()
        //       : null,
        "profilePhotoLink": photoUrl,
      }).then((value) {
        // blogFirestoreId = value.id;
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> fetchUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth == null || _auth.currentUser == null) {
      return false;
    }
    _auth.currentUser.refreshToken;
    var _userID = _auth.currentUser.uid;

    final querySnapshot = await firestoreInstance
        .collection("userdata")
        .doc(_userID)
        .get(); //.then((querySnapshot) {
    if (!querySnapshot.exists) {
      return false;
    }
    // querySnapshot.docs
    //     .forEach((result) {
    UserDataModel _loadedUser = UserDataModel(
      // userId: querySnapshot.id,
      userEmail: querySnapshot.data()["userEmail"],
      userBio: querySnapshot.data()["userBio"],
      userName: querySnapshot.data()["userName"],
      userDateOfBirth: querySnapshot.data()["userDateOfBirth"] != null
          ? DateTime.parse(querySnapshot.data()["userDateOfBirth"].toString())
          : null,
      userRole: querySnapshot.data()[
          "userRole"], //!=null? int.parse(result.data()["userRole"].toString()):null,
      // != null
      //   ? DateTime.parse(result.data()["userDOB"])
      //   : null,
      profilePhotoLink: querySnapshot.data()["profilePhotoLink"],
    );
    // print(_loadedUser.userRole);
    // _loadedUser = user;
    // }
    // );
    _userData = _loadedUser;
    return true;
  }

  Future<void> updateUserRole(int userRole) async {
    var _userID = _auth.currentUser.uid;
    // var userFid = _userData.userFId;
    try {
      await firestoreInstance.collection("userdata").doc(_userID).update({
        'userRole': userRole,
      }).then((value) {
        // blogFirestoreId = value.id;
      });
    } catch (error) {}
  }
}

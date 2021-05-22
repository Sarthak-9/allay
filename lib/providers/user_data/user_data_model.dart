import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:allay/models/user_data/user_data_model.dart';

class UserData with ChangeNotifier {
  UserDataModel _userData;
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  UserDataModel get userData => _userData;

  Future<void> addUser(UserDataModel newUser) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    var _userID = _auth.currentUser.uid;
    print(_userID);
    try {
      firestoreInstance.collection("userdata").doc(_userID).collection('userdetails').add({
        'userEmail': newUser.userEmail,
        'userName': newUser.userName,
        'userPhone': newUser.userPhone,
        'userDOB': newUser.dateofBirth != null
            ? newUser.dateofBirth.toIso8601String()
            : null,
        'userRole': 'user',
        "profilePhotoLink": newUser.profilePhotoLink,
      }).then((value) {
        // blogFirestoreId = value.id;
      });
      final user = UserDataModel(
          userFId: _userID,
          userEmail: newUser.userEmail,
          userPhone: newUser.userPhone,
          userName: newUser.userName,
          userRole: 'user',
          dateofBirth: newUser.dateofBirth,
        profilePhotoLink: null
      );
      _userData = user;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateUser(UserDataModel updateUser) async {
    String photoUrl;
    var _userID = _auth.currentUser.uid;
    var userFid = _userData.userFId;
    try {
      if(updateUser.userProfileImage!=null){
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref =
        storage.ref().child("userdata").child(DateTime.now().toIso8601String());
        UploadTask uploadTask = ref.putFile(updateUser.userProfileImage);
        await uploadTask.whenComplete(() async {
          photoUrl = await ref.getDownloadURL();
        }).catchError((onError) {
          throw onError;
        });
      }else{
        photoUrl = _userData.profilePhotoLink;
      }
      await firestoreInstance.collection("userdata").doc(_userID).collection('userdetails').doc(userFid).update({
        'userPhone': updateUser.userPhone,
        'userDOB': updateUser.dateofBirth != null
            ? updateUser.dateofBirth.toIso8601String()
            : null,
        "profilePhotoLink": photoUrl,
      }).then((value) {
        // blogFirestoreId = value.id;
      });
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth == null || _auth.currentUser == null) {
      return;
    }
    _auth.currentUser.refreshToken;
    var _userID = _auth.currentUser.uid;
    UserDataModel _loadedUser;
    final querySnapshot = await firestoreInstance.collection("userdata").doc(_userID).collection('userdetails')
        .get(); //.then((querySnapshot) {
    querySnapshot.docs
        .forEach((result) {
          var user = UserDataModel(
            userFId: result.id,
            userEmail: result.data()["userEmail"],
            userPhone: result.data()["userPhone"],
            userName: result.data()["userName"],
            dateofBirth: result.data()["userDOB"] != null
                ? DateTime.parse(result.data()["userDOB"])
                : null,
            profilePhotoLink: result.data()["profilePhotoLink"],
      );
          _loadedUser = user;
    });
      _userData = _loadedUser;
  }

  Future<void> updateUserRole(String userRole)async{
    var _userID = _auth.currentUser.uid;
    var userFid = _userData.userFId;
    try{
      await firestoreInstance.collection("userdata").doc(_userID).collection('userdetails').doc(userFid).update({
        'userRole':userRole,
      }).then((value) {
        // blogFirestoreId = value.id;
      });
    }catch(error){

    }
  }

}

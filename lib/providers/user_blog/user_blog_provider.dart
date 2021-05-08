import 'dart:ffi';

import 'package:allay/models/user_blog/user_blog_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserBlogs with ChangeNotifier{
  List<UserBlog> _userBlogList = [];
  List<UserBlog> _recentUserBlogs = [];
  final firestoreInstance = FirebaseFirestore.instance;

  List<UserBlog> get userBlogList => _userBlogList;
  List<UserBlog> get recentUserBlogs => _recentUserBlogs;

  void addUserBlog(UserBlog newUserBlog)async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    var _userID = _auth.currentUser.uid;
    var blogFirestoreId;
    var photoUrl=null;
    if(newUserBlog.userBlogImage!=null){
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
      storage.ref().child("userblogs").child(DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(newUserBlog.userBlogImage);
      await uploadTask.whenComplete(() async {
        photoUrl = await ref.getDownloadURL();
      }).catchError((onError) {
        throw onError;
      });
    }
    firestoreInstance.collection("userblogs").doc(_userID).collection('myprivateblogs').add(
        {
          "userBlogTitle": newUserBlog.userBlogTitle,
          "userBlogText": newUserBlog.userBlogText,
          "userBlogDate": newUserBlog.userBlogDate.toIso8601String(),
          "userBlogMood": newUserBlog.userBlogMood,
          "userBlogAnalysisReport": newUserBlog.userBlogAnalysisReport,
          "userBlogImageUrl": photoUrl,
        }).then((value){
      blogFirestoreId = value.id;
    });
    UserBlog newBlog = UserBlog(
      userBlogId: blogFirestoreId,
      userBlogTitle: newUserBlog.userBlogTitle,
      userBlogText: newUserBlog.userBlogText,
      userBlogDate: newUserBlog.userBlogDate,
      userBlogMood: newUserBlog.userBlogMood,
      userBlogAnalysisReport: newUserBlog.userBlogAnalysisReport,
      userBlogImageUrl: photoUrl,
      userBlogImage: newUserBlog.userBlogImage,
    );
    _userBlogList.add(newBlog);
    notifyListeners();
  }

  Future<void> fetchUserBlog()async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    var _userID = _auth.currentUser.uid;
    List<UserBlog> loadedBlogs = [];
    try{
      final querySnapshot = await firestoreInstance.collection("userblogs").doc(_userID).collection('myprivateblogs')
          .get();
      querySnapshot.docs
          .forEach((result) {
        UserBlog loadedBlog = UserBlog(
          userBlogId: result.id,
          userBlogTitle: result.data()["userBlogTitle"],
          userBlogText: result.data()["userBlogText"],
          userBlogDate: DateTime.parse(result.data()["userBlogDate"]),
          userBlogMood: result.data()["userBlogMood"],
          userBlogAnalysisReport:result.data()["userBlogAnalysisReport"],
          userBlogImageUrl: result.data()["userBlogImageUrl"],
        );
        loadedBlogs.add(loadedBlog);
      });
      // });
    }catch(error){
      print(error);
    }
    loadedBlogs.sort((a,b)=>b.userBlogDate.compareTo(a.userBlogDate));
    _userBlogList = loadedBlogs;
    notifyListeners();
  }
  void fetchRecentBlogs(){
    if(_userBlogList.length>7){
    for(int i=0;i<7;i++){
      _recentUserBlogs.add(_userBlogList[i]);
    }}
    else{
      _recentUserBlogs = _userBlogList;
    }
    notifyListeners();
  }

  UserBlog findUserBlogById(String userBlogId){
    return _userBlogList.firstWhere((userBlog) => userBlog.userBlogId == userBlogId);
  }

  Future<void> deleteBlog(String userBlogId)async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    var _userID = _auth.currentUser.uid;
   await firestoreInstance.collection("userblogs").doc(_userID).collection('myprivateblogs').doc(userBlogId).delete();
  }

  List<UserBlog> sortByMood(String mood){
    List<UserBlog> sortMood = [];
    _userBlogList.forEach((blog) {
      if(blog.userBlogMood == mood) {
        sortMood.add(blog);
      }
    });
    // _moodSortedPublicBlogList = sortMood;
    return sortMood;
  }
}
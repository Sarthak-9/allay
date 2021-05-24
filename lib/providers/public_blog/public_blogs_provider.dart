import 'package:flutter/material.dart';
import 'package:allay/models/public_blog/public_blog_model.dart';
import 'package:allay/models/user_data/user_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class PublicBlogs with ChangeNotifier {
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  List<PublicBlog> _publicBlogList = [];
  List<PublicBlog> _userPublicBlogList = [];
  List<PublicBlog> _userSavedBlogList = [];
  List<PublicBlog> _moodSortedPublicBlogList = [];
  List<String> _userSavedBlogIdList = [];
  List<String> _userLikedPost = [];
  List<String> _likedPostId = [];
  List<String> _userPublicBlogIdList = [];
  UserDataModel authorDetails;

  List<PublicBlog> get publicBlogList => _publicBlogList;
  List<PublicBlog> get userPublicBlogList => _userPublicBlogList;
  List<PublicBlog> get userSavedBlogList => _userSavedBlogList;
  List<String> get userLikedPost => _userLikedPost;
  List<PublicBlog> get moodSortedPublicBlogList => _moodSortedPublicBlogList;

  void addPublicBlog(PublicBlog newPublicBlog)async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    var _userID = _auth.currentUser.uid;
    var blogFirestoreId;
    await firestoreInstance.collection("publicblogs").add(
        {
          "publicBlogTitle" : newPublicBlog.publicBlogTitle,
          // "authorUserName" : newPublicBlog.authorUserName,
          "publicBlogDate" : newPublicBlog.publicBlogDate.toIso8601String(),
          "publicBlogText": newPublicBlog.publicBlogText,
          // "publicBlogCurrentUserLiked": newPublicBlog.publicBlogCurrentUserLiked,
          // "authorImageUrl": newPublicBlog.authorImageUrl,
          "authorUserId": newPublicBlog.authorUserId,
          "publicBlogLikes":
          newPublicBlog.publicBlogLikes.map((like) => {
            "userid" : null,
        })
            .toList(),
          "publicBlogMood": newPublicBlog.publicBlogMood,

        }).then((value){
      blogFirestoreId = value.id;
    });
    var userPublicBlogRef = FirebaseDatabase.instance.reference().child(_userID).child('userpublicblogs').child(blogFirestoreId);
    var userPublicBlogPushRef = userPublicBlogRef.push();
    await userPublicBlogPushRef.set({
      'blogId' : blogFirestoreId
    });
    PublicBlog newblog = PublicBlog(
      publicBlogId: blogFirestoreId,
      publicBlogTitle: newPublicBlog.publicBlogTitle,
      authorUserName: newPublicBlog.authorUserName,
      publicBlogDate: newPublicBlog.publicBlogDate,
      publicBlogText: newPublicBlog.publicBlogText,
      authorUserId: newPublicBlog.authorUserId,
      publicBlogCurrentUserLiked: newPublicBlog.publicBlogCurrentUserLiked,
      authorImageUrl: newPublicBlog.authorImageUrl,
      publicBlogLikes: newPublicBlog.publicBlogLikes,
      publicBlogMood: newPublicBlog.publicBlogMood,
    );
    _publicBlogList.add(newblog);
    notifyListeners();
  }

  Future<void> editPublicBlog(PublicBlog newPublicBlog) async{
    var blogFirestoreId = newPublicBlog.publicBlogId;
    await firestoreInstance.collection("publicblogs").doc(blogFirestoreId).update(
        {
          "publicBlogTitle" : newPublicBlog.publicBlogTitle,
          "publicBlogText": newPublicBlog.publicBlogText,
          "publicBlogMood": newPublicBlog.publicBlogMood,
        });
    notifyListeners();
  }

  Future<void> fetchBlogs()async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    var _userID = _auth.currentUser.uid;
    List<PublicBlog> loadedBlogs = [];
    try{
      await FirebaseDatabase.instance.reference().child(_userID).child('userlikedpost').once().then((DataSnapshot snapshot)async {
        var ref = await snapshot.value;
        if(ref!=null){
              ref.forEach((key,values){
            _likedPostId.add(key);
          });
        }
      });
      final querySnapshot = await firestoreInstance.collection("publicblogs").get();
        await Future.forEach(querySnapshot.docs,(result)async{
        bool likeStatus = _likedPostId.contains(result.id);
          final UserDataModel author =  await fetchAuthorDetails(result.data()["authorUserId"]);
          // print(author.profilePhotoLink);
          PublicBlog loadedBlog = PublicBlog(
            publicBlogId: result.id,
            publicBlogTitle: result.data()["publicBlogTitle"],
            authorUserName: author.userName,
            authorUserId: result.data()["authorUserId"],
            publicBlogDate: DateTime.parse(result.data()["publicBlogDate"]),
            publicBlogText: result.data()["publicBlogText"],
            publicBlogCurrentUserLiked: likeStatus,
            authorImageUrl: author.profilePhotoLink,
            publicBlogLikes: (result.data()["publicBlogLikes"] as List<dynamic>)
                .map((userid) =>
            userid.toString())
                .toList(),
            publicBlogMood: result.data()["publicBlogMood"],
            isAuthor: _userID == result.data()["authorUserId"],
            authorDetails: author
          );
          loadedBlogs.add(loadedBlog);
        });
      }catch(error){
      print(error);
    }
    loadedBlogs.sort((a,b)=>b.publicBlogDate.compareTo(a.publicBlogDate));
    _publicBlogList = loadedBlogs;
    notifyListeners();
  }

  Future<UserDataModel> fetchAuthorDetails(String authorId) async {
    final querySnapshot = await firestoreInstance.collection("userdata").doc(authorId).get(); //.then((querySnapshot) {
    // querySnapshot.docs
    //     .forEach((result) {
    UserDataModel _loadedUser = UserDataModel(
      // userFId: querySnapshot.id,
      userEmail: querySnapshot.data()["userEmail"],
      userPhone: querySnapshot.data()["userPhone"],
      userName: querySnapshot.data()["userName"],
      // userAge: querySnapshot.data()["userAge"]!=null? int.parse(querySnapshot.data()["userAge"].toString()):null,
      // userRole:querySnapshot.data()["userRole"],//!=null? int.parse(result.data()["userRole"].toString()):null,
      // != null
      //   ? DateTime.parse(result.data()["userDOB"])
      //   : null,
      profilePhotoLink: querySnapshot.data()["profilePhotoLink"],
    );
    // print(_loadedUser.userRole);
    // _loadedUser = user;
    // }
    // );
    // _userData = _loadedUser;
    // authorDetails = _loadedUser;
    return _loadedUser;
  }

  void saveBlog(String blogId)async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    var _userID = _auth.currentUser.uid;
    _userSavedBlogIdList.add(blogId);
    var saveBlogRef = FirebaseDatabase.instance.reference().child(_userID).child('savedblogs').child(blogId);
    var tr = await saveBlogRef.once();
    if(tr.value==null){
      var saveBlogPushRef = saveBlogRef.push();
      await saveBlogPushRef.set({'blogId': blogId});
    }
    await fetchSavedBlogs();
  }

  Future<void> fetchSavedBlogs()async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    var _userID = _auth.currentUser.uid;
    List<PublicBlog> loadedBlogs = [];
    _userSavedBlogIdList.clear();
    _userSavedBlogList.clear();
    var snapshot = await FirebaseDatabase.instance.reference().child(_userID).child('savedblogs').once();
      var ref = await snapshot.value;
      if(ref!=null){
        await ref.forEach((key,values){
          _userSavedBlogIdList.add(key);
        });
      }
    await Future.forEach(_userSavedBlogIdList, (savedblogId)async {
      var result = await firestoreInstance.collection("publicblogs").doc(savedblogId).get(); //.then((querySnapshot) {
        if(result.exists)  {
        PublicBlog loadedBlog = PublicBlog(
          publicBlogId: result.id,
          publicBlogTitle: result.data()["publicBlogTitle"],
          authorUserName: result.data()["authorUserName"],
          authorUserId: result.data()["authorUserId"],
          publicBlogDate: DateTime.parse(result.data()["publicBlogDate"]),
          publicBlogText: result.data()["publicBlogText"],
          // publicBlogCurrentUserLiked: true,
          authorImageUrl: result.data()["authorImageUrl"],
          publicBlogLikes: (result.data()["publicBlogLikes"] as List<dynamic>)
              .map((userid) => userid as String)
              .toList(),
          publicBlogMood: result.data()["publicBlogMood"],
          isAuthor: _userID == result.data()["authorUserId"],
        );
        loadedBlogs.add(loadedBlog);
      }
    });
      _userSavedBlogList = loadedBlogs;
      notifyListeners();
  }


  Future<void> fetchUserPublicBlogs()async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    var _userID = _auth.currentUser.uid;
    List<PublicBlog> loadedBlogs = [];
    var snapshot = await FirebaseDatabase.instance.reference().child(_userID).child('userpublicblogs').once();
    _userPublicBlogIdList.clear();
    var ref = await snapshot.value;
    if(ref!=null){
      ref.forEach((key,values){
        _userPublicBlogIdList.add(key);
      });
    }
    await Future.forEach(_userPublicBlogIdList, (savedblogId)async {
    var querySnapshot = await firestoreInstance.collection("publicblogs").doc(savedblogId).get(); //.then((querySnapshot) {
    if(querySnapshot.exists) {
        PublicBlog loadedBlog = PublicBlog(
          publicBlogId: querySnapshot.id,
          publicBlogTitle: querySnapshot.data()["publicBlogTitle"],
          authorUserName: querySnapshot.data()["authorUserName"],
          authorUserId: querySnapshot.data()["authorUserId"],
          publicBlogDate:
              DateTime.parse(querySnapshot.data()["publicBlogDate"]),
          publicBlogText: querySnapshot.data()["publicBlogText"],
          // publicBlogCurrentUserLiked:
          //     querySnapshot.data()["publicBlogCurrentUserLiked"],
          authorImageUrl: querySnapshot.data()["authorImageUrl"],
          publicBlogLikes:
              (querySnapshot.data()["publicBlogLikes"] as List<dynamic>)
                  .map((userid) => userid.toString())
                  .toList(),
          publicBlogMood: querySnapshot.data()["publicBlogMood"],
          isAuthor: _userID == querySnapshot.data()["authorUserId"],
        );
        loadedBlogs.add(loadedBlog);
      }
    }
    );
    _userPublicBlogList = loadedBlogs;
    notifyListeners();
  }

  PublicBlog findPublicBlogById(String publicBlogId){
    return _publicBlogList.firstWhere((publicBlog) => publicBlog.publicBlogId == publicBlogId);
  }

  Future<void> likePublicBlog(String blogId,bool currentUserLikeStatus)async{
    var _userID = _auth.currentUser.uid;
    var currentBLog = findPublicBlogById(blogId);
    var likeBlogRef = FirebaseDatabase.instance.reference().child(_userID).child('userlikedpost').child(blogId);
    currentBLog.publicBlogCurrentUserLiked = currentUserLikeStatus;
    if (currentUserLikeStatus){
      var likeBlogPushRef = likeBlogRef.push();
      await likeBlogPushRef.set({
        'blogId' : blogId
      });
      currentBLog.publicBlogLikes.add(_userID);
      await firestoreInstance.collection("publicblogs").doc(blogId).update({
            // "publicBlogCurrentUserLiked": currentUserLikeStatus,
            "publicBlogLikes": FieldValue.arrayUnion(currentBLog.publicBlogLikes)
          });
          // notifyListeners();
    }else{
      _likedPostId.removeWhere((element) => element==blogId);
      await likeBlogRef.remove();
      var removeRef = [];
      removeRef.add(_userID);
      currentBLog.publicBlogLikes.remove(_userID);
      await firestoreInstance.collection("publicblogs").doc(blogId).update({
        // "publicBlogCurrentUserLiked": currentUserLikeStatus,
        "publicBlogLikes": FieldValue.arrayRemove(removeRef),
      });
    }
  }

  Future<void> deletePublicBlog(String blogId)async{
    var _userID = _auth.currentUser.uid;
    var likeBlogeRef = await FirebaseDatabase.instance.reference().child(_userID).child('userlikedpost').child(blogId).remove();
    var deleteSaveStatus = await FirebaseDatabase.instance.reference().child(_userID).child('savedblogs').child(blogId).remove();
    var userPublicBlogStatus = await FirebaseDatabase.instance.reference().child(_userID).child('userpublicblogs').child(blogId).remove();
    var querySnapshot = await firestoreInstance.collection("publicblogs").doc(blogId).delete();
  }

  Future<List<PublicBlog>> sortByMood(String mood)async{
    List<PublicBlog> sortMood = [];
     _publicBlogList.forEach((blog) {
      if(blog.publicBlogMood == mood) {
        sortMood.add(blog);
      }
    });
    // _moodSortedPublicBlogList = sortMood;
    return sortMood;
  }

}

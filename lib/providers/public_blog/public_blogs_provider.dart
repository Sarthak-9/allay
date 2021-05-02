import 'package:allay/models/public_blog/public_blog_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class PublicBlogs with ChangeNotifier {
  final firestoreInstance = FirebaseFirestore.instance;

  List<PublicBlog> _publicBlogList = [];
  List<PublicBlog> _userPublicBlogList = [];
  List<PublicBlog> _userSavedBlogList = [];
  List<String> _userSavedBlogIdList = [];

  List<PublicBlog> get publicBlogList => _publicBlogList;
  List<PublicBlog> get userPublicBlogList => _userPublicBlogList;
  List<PublicBlog> get userSavedBlogList => _userSavedBlogList;

  void addPublicBlog(PublicBlog newPublicBlog) {
    var blogFirestoreId;
    firestoreInstance.collection("publicblogs").add(
        {
          "publicBlogTitle" : newPublicBlog.publicBlogTitle,
          "authorUserName" : newPublicBlog.authorUserName,
          "publicBlogDate" : newPublicBlog.publicBlogDate.toIso8601String(),
          "publicBlogText": newPublicBlog.publicBlogText,
          "publicBlogCurrentUserLiked": newPublicBlog.publicBlogCurrentUserLiked,
          "authorImageUrl": newPublicBlog.authorImageUrl,
          "authorUserId": newPublicBlog.authorUserId,
          "publicBlogLikes": newPublicBlog.publicBlogLikes,
          "publicBlogMood": newPublicBlog.publicBlogMood,
        }).then((value){
      blogFirestoreId = value.id;
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

  void editPublicBlog(PublicBlog newPublicBlog) {
    // firestoreInstance.collection("publicblogs").
    PublicBlog newblog = PublicBlog(
      publicBlogId: DateTime.now().toIso8601String(),
      publicBlogTitle: newPublicBlog.publicBlogTitle,
      authorUserName: newPublicBlog.authorUserName,
      publicBlogDate: newPublicBlog.publicBlogDate,
      publicBlogText: newPublicBlog.publicBlogText,
      publicBlogCurrentUserLiked: newPublicBlog.publicBlogCurrentUserLiked,
      authorImageUrl: newPublicBlog.authorImageUrl,
      publicBlogLikes: newPublicBlog.publicBlogLikes,
      publicBlogMood: newPublicBlog.publicBlogMood,
    );
    _publicBlogList.add(newblog);
    notifyListeners();
  }

  Future<void> fetchBlogs()async{
    List<PublicBlog> loadedBlogs = [];
    try{
      final querySnapshot = await firestoreInstance.collection("publicblogs")
          .get(); //.then((querySnapshot) {
      querySnapshot.docs
        .forEach((result) {
          PublicBlog loadedBlog = PublicBlog(
            publicBlogId: result.id,
            publicBlogTitle: result.data()["publicBlogTitle"],
            authorUserName: result.data()["authorUserName"],
            authorUserId: result.data()["authorUserId"],
            publicBlogDate: DateTime.parse(result.data()["publicBlogDate"]),
            publicBlogText: result.data()["publicBlogText"],
            publicBlogCurrentUserLiked: result
                .data()["publicBlogCurrentUserLiked"],
            authorImageUrl: result.data()["authorImageUrl"],
            publicBlogLikes: result.data()["publicBlogLikes"],
            publicBlogMood: result.data()["publicBlogMood"],
          );
          loadedBlogs.add(loadedBlog);
        });
      // });
      }catch(error){
      print(error);
    }
    loadedBlogs.sort((a,b)=>b.publicBlogDate.compareTo(a.publicBlogDate));
    _publicBlogList = loadedBlogs;
    notifyListeners();
  }

  void saveBlog(String blogId){
    _userSavedBlogIdList.add(blogId);
    firestoreInstance.collection("publicblogs").doc("savedblogs").collection('collectionPath').add(
        {
          "savedBlogId" : blogId,
        }).then((value){
      // blogFirestoreId = value.id;
    });
  }

  Future<void> fetchSavedBlogs()async{
    List<PublicBlog> loadedBlogs = [];
    _userSavedBlogIdList.forEach((savedblogId)async {
      final querySnapshot = await firestoreInstance.collection(savedblogId)//.doc("savedblogs").collection(savedblogId)
          .get(); //.then((querySnapshot) {
      querySnapshot.docs
          .forEach((result) {
        PublicBlog loadedBlog = PublicBlog(
          publicBlogId: result.id,
          publicBlogTitle: result.data()["publicBlogTitle"],
          authorUserName: result.data()["authorUserName"],
          authorUserId: result.data()["authorUserId"],
          publicBlogDate: DateTime.parse(result.data()["publicBlogDate"]),
          publicBlogText: result.data()["publicBlogText"],
          publicBlogCurrentUserLiked: result
              .data()["publicBlogCurrentUserLiked"],
          authorImageUrl: result.data()["authorImageUrl"],
          publicBlogLikes: result.data()["publicBlogLikes"],
          publicBlogMood: result.data()["publicBlogMood"],
        );
        loadedBlogs.add(loadedBlog);
      });
    _userSavedBlogList = loadedBlogs;
    notifyListeners();
    });
  }

  void fetchUserPublicBlogs()async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    var _userID = _auth.currentUser.uid;
    var myPublicBlog =  _publicBlogList.where((publicBlog) => publicBlog.authorUserId == _userID);
    myPublicBlog.forEach((element) {
      _userPublicBlogList.add(element);
    });
  }

  void likeBlog(String blogId)async{
    final querySnapshot = await firestoreInstance.collection("publicblogs").doc(blogId).update({

    });
  }

  PublicBlog findPublicBlogById(String publicBlogId){
    return _publicBlogList.firstWhere((publicBlog) => publicBlog.publicBlogId == publicBlogId);
  }

}

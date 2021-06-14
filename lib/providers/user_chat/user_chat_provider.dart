import 'package:allay/models/user_chat/user_chat_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class UserChat with ChangeNotifier{
  List<UserChatModel> _userChats = [];

  List<UserChatModel> get userChats => _userChats;
  FirebaseAuth _authRef = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.reference();

  Future<void> postUserChat(UserChatModel chat)async{
    String _userId = _authRef.currentUser.uid;
    final chatRef = databaseRef.child(_userId).child('userchat').push();
    await chatRef.set({
      'userAccountId': _userId,
      'volunteerAccountId': null,
      'questionText': chat.questionText,
      'questionReply': null,
      'questionTags':chat.questionTags,
      'dateOfQuestion': chat.dateOfQuestion.toIso8601String(),
      'chatPreferredLanguage':chat.chatPreferredLanguage,
      'chatReplyScore':null
    });
    final activeChatRef = databaseRef.child('activechat').child(chatRef.key);
    await activeChatRef.set({
      'userChatId':chatRef.key,
      'userAccountId': _userId,
      'isActive': true,
      'volunteerAccountId': null,
      'postTime': DateTime.now().toIso8601String(),
    });
    UserChatModel newChat = UserChatModel(
      userChatId: chatRef.key,
      userAccountId: _userId,
      volunteerAccountId: null,
      questionText: chat.questionText,
      questionReply: null,
      questionTags: chat.questionTags,
      dateOfQuestion: chat.dateOfQuestion,
      chatPreferredLanguage: chat.chatPreferredLanguage,
      chatReplyScore: null,
    );
    _userChats.add(newChat);
    notifyListeners();
  }

  Future<void> fetchUserChat()async{
    String _userId = _authRef.currentUser.uid;
    List<UserChatModel> _loadedChat = [];
    var snapshot =await databaseRef.child(_userId).child('userchat').once();
    var ref = await snapshot.value;
    if(ref!=null){
      await ref.forEach((key,chat){
        UserChatModel newChat = UserChatModel(
        userChatId: key,
        userAccountId: chat["userAccountId"],
        volunteerAccountId: chat["volunteerAccountId"],
        questionText: chat["questionText"],
        questionReply: chat["questionReply"],
        questionTags: chat["questionTags"] as List<dynamic>!=null?(chat["questionTags"] as List<dynamic>).map((tag) => tag.toString()).toList():null,
        dateOfQuestion: DateTime.parse(chat["dateOfQuestion"]),
        chatPreferredLanguage: chat["chatPreferredLanguage"],
        chatReplyScore: chat["chatReplyScore"]!=null?double.parse(chat["chatReplyScore"].toString()):null,
      );
      _loadedChat.add(newChat);
      });
    }
    _loadedChat.sort((a,b)=>a.dateOfQuestion.compareTo(b.dateOfQuestion));
    _userChats = _loadedChat;
    notifyListeners();
  }

  UserChatModel findById(String chatId){
    return _userChats.firstWhere((chat) => chat.userChatId == chatId);
  }

  int findIndexById(String chatId){
    return _userChats.indexWhere((chat) => chat.userChatId == chatId);
  }

  Future<void> updateRating(int chatIndex,double rating)async{
    String _userId = _authRef.currentUser.uid;
    String chatId = _userChats[chatIndex].userChatId;
    _userChats[chatIndex].chatReplyScore = rating;
    var snapshot = databaseRef.child(_userId).child('userchat').child(chatId);
    await snapshot.update({
      'chatReplyScore':rating,
    });
    notifyListeners();
  }
}
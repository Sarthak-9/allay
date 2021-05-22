import 'package:flutter/material.dart';
import 'package:allay/models/user_chat/user_chat_model.dart';
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

    UserChatModel newChat = UserChatModel(
      userChatId: chatRef.key,
      userAccountId: _userId,
      volunteerAccountId: null,
      questionText: chat.questionText,
      questionReply: null,
      questionTags: null,
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
        // final tags = chat["questionTags"] as List<dynamic>;
        // List<String> qtag;
        // tags.forEach((element) { qtag.add(element);});
        UserChatModel newChat = UserChatModel(
        userChatId: chat["userChatId"],
        userAccountId: chat["userAccountId"],
        volunteerAccountId: chat["volunteerAccountId"],
        questionText: chat["questionText"],
        questionReply: chat["questionReply"],
        questionTags: chat["questionTags"] as List<dynamic>!=null?(chat["questionTags"] as List<dynamic>).map((tag) => tag.toString()).toList():null,
        dateOfQuestion: DateTime.parse(chat["dateOfQuestion"]),
        chatPreferredLanguage: chat["chatPreferredLanguage"],
        chatReplyScore: chat["chatReplyScore"],
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
}
import 'package:allay/models/volunteer/volunteer_chat_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class VolunteerChat with ChangeNotifier{
  List<VolunteerChatModel> _volunteerActiveChats = [];
  List<VolunteerChatModel> _volunteerPickedChats = [];
  List<VolunteerChatModel> _volunteerRepliedChats = [];

  List<VolunteerChatModel> get volunteerRepliedChats => _volunteerRepliedChats;
  List<VolunteerChatModel> get volunteerActiveChats => _volunteerActiveChats;
  List<VolunteerChatModel> get volunteerPickedChats => _volunteerPickedChats;
  FirebaseAuth _authRef = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.reference();

  Future<void> pickUserChat(int index,VolunteerChatModel chat)async{
    String _volunteerId = _authRef.currentUser.uid;
    final chatRef = databaseRef.child(chat.userAccountId).child('userchat').child(chat.userChatId);
    await chatRef.update({
      // 'userAccountId': _userId,
      'volunteerAccountId': _volunteerId,
      // 'questionText': chat.questionText,
      // 'questionReply': chat.questionReply,
      // 'questionTags':chat.questionTags,
      // 'dateOfQuestion': chat.dateOfQuestion.toIso8601String(),
      // 'chatPreferredLanguage':chat.chatPreferredLanguage,
      // 'chatReplyScore':null
    });
    final volunteerChatRef = databaseRef.child(_volunteerId).child('volunteerchat').push();
    await volunteerChatRef.set({
      'userAccountId': chat.userAccountId,
      'volunteerAccountId': _volunteerId,
      'userChatId': chat.userChatId,
      // 'questionText': chat.questionText,
      // 'questionReply': null,
      // 'questionTags':chat.questionTags,
      // 'dateOfQuestion': chat.dateOfQuestion.toIso8601String(),
      // 'chatPreferredLanguage':chat.chatPreferredLanguage,
      'chatReplyScore':null
    });
    final activeChatRef = databaseRef.child('activechat').child(chatRef.key);
    await activeChatRef.update({
    //   'userAccountId': _userId,
      'isActive': false,
      'volunteerAccountId': _volunteerId,
    //   'postTime': DateTime.now().toIso8601String(),
    // 'questionText': chat.questionText,
    // 'questionReply': null,
    // 'questionTags':chat.questionTags,
    // 'dateOfQuestion': chat.dateOfQuestion.toIso8601String(),
    // 'chatPreferredLanguage':chat.chatPreferredLanguage,
    // 'chatReplyScore':null
    });
    // VolunteerChatModel newChat = VolunteerChatModel(
    //   userChatId: chatRef.key,
    //   userAccountId: chat.userAccountId,
    //   volunteerAccountId: null,
    //   questionText: chat.questionText,
    //   questionReply: null,
    //   questionTags: null,
    //   dateOfQuestion: chat.dateOfQuestion,
    //   chatPreferredLanguage: chat.chatPreferredLanguage,
    //   chatReplyScore: null,
    // );
    // _volunteerChats.add(newChat);
    _volunteerActiveChats.removeAt(index);
    notifyListeners();
  }

  Future<void> replyUserChat(VolunteerChatModel chat)async{
    String _volunteerId = _authRef.currentUser.uid;
    final chatRef = databaseRef.child(chat.userAccountId).child('userchat').child(chat.userChatId);
    await chatRef.update({
      // 'userAccountId': _userId,
      'volunteerAccountId': _volunteerId,
      // 'questionText': chat.questionText,
      'questionReply': chat.questionReply,
      // 'questionTags':chat.questionTags,
      // 'dateOfQuestion': chat.dateOfQuestion.toIso8601String(),
      // 'chatPreferredLanguage':chat.chatPreferredLanguage,
      // 'chatReplyScore':null
    });
    // final volunteerChatRef = databaseRef.child(_volunteerId).child('volunteerchat').push();
    // await volunteerChatRef.set({
    //   'userAccountId': chat.userAccountId,
    //   'volunteerAccountId': _volunteerId,
    //   'userChatId': chat.userChatId,
    //   'questionText': chat.questionText,
      // 'questionReply': null,
      // 'questionTags':chat.questionTags,
      // 'dateOfQuestion': chat.dateOfQuestion.toIso8601String(),
      // 'chatPreferredLanguage':chat.chatPreferredLanguage,
      // 'chatReplyScore':null
    // });
    final activeChatRef =await databaseRef.child('activechat').child(chatRef.key).remove();
    // await activeChatRef.set({
    //   'userAccountId': _userId,
    //   'isActive': true,
    //   'volunteerAccountId': null,
    //   'postTime': DateTime.now().toIso8601String(),
      // 'questionText': chat.questionText,
      // 'questionReply': null,
      // 'questionTags':chat.questionTags,
      // 'dateOfQuestion': chat.dateOfQuestion.toIso8601String(),
      // 'chatPreferredLanguage':chat.chatPreferredLanguage,
      // 'chatReplyScore':null
    // });
    // VolunteerChatModel newChat = VolunteerChatModel(
    //   userChatId: chatRef.key,
    //   userAccountId: chat.userAccountId,
    //   volunteerAccountId: null,
    //   questionText: chat.questionText,
    //   questionReply: null,
    //   questionTags: null,
    //   dateOfQuestion: chat.dateOfQuestion,
    //   chatPreferredLanguage: chat.chatPreferredLanguage,
    //   chatReplyScore: null,
    // );
    // _volunteerChats.add(newChat);
    notifyListeners();
  }

  Future<void> fetchActiveChat()async{
    String _volunteerId = _authRef.currentUser.uid;
    List<VolunteerChatModel> _loadedActiveChat = [];
    // List<VolunteerChatModel> _loadedPersonalChat = [];
    var snapshot =  await databaseRef.child('activechat').once();
    Map<dynamic,dynamic> ref = await snapshot.value;
    if(ref!=null){
        // for(Map<dynamic,dynamic> entry in ref){
        //   print(entry["userAccountId"]);
        // }
      // await Future.any(
     await Future.forEach(ref.values,(activeChat)async{
        String userAccountId = activeChat["userAccountId"];
        String userChatId = activeChat["userChatId"];
        bool isActive = activeChat["isActive"];
        if(isActive){
          final chatSnapshot = await databaseRef.child(userAccountId).child(
              'userchat').child(userChatId).once();
          var chatRef = await chatSnapshot.value;
          VolunteerChatModel newChat = VolunteerChatModel(
            userChatId: userChatId,
            userAccountId: chatRef["userAccountId"],
            volunteerAccountId: chatRef["volunteerAccountId"],
            questionText: chatRef["questionText"],
            questionReply: chatRef["questionReply"],
            questionTags: chatRef["questionTags"] as List<dynamic> != null
                ? (chatRef["questionTags"] as List<dynamic>).map((tag) =>
                tag.toString()).toList()
                : null,
            dateOfQuestion: DateTime.parse(chatRef["dateOfQuestion"]),
            chatPreferredLanguage: chatRef["chatPreferredLanguage"],
            chatReplyScore:chatRef["chatReplyScore"]!=null? double.parse(chatRef["chatReplyScore"].toString()):null,
          );
          // print(chatRef["chatPreferredLanguage"]);
          _loadedActiveChat.add(newChat);
          // if (newChat.volunteerAccountId == _volunteerId) {
          //   _loadedPersonalChat.add(newChat);
          // }
        }}
        );
    }
    _loadedActiveChat.sort((a,b)=>a.dateOfQuestion.compareTo(b.dateOfQuestion));
    // _loadedPersonalChat.sort((a,b)=>a.dateOfQuestion.compareTo(b.dateOfQuestion));
    _volunteerActiveChats = _loadedActiveChat;
    // _volunteerPickedChats = _loadedPersonalChat;
    // print(_volunteerPickedChats[0].questionText);
    notifyListeners();
  }

  Future<void> fetchPickedChat()async{
    String _volunteerId = _authRef.currentUser.uid;
    // List<VolunteerChatModel> _loadedActiveChat = [];
    List<VolunteerChatModel> _loadedPickedChat = [];
    var snapshot =  await databaseRef.child(_volunteerId).child('volunteerchat').once();
    Map<dynamic,dynamic> ref = await snapshot.value;
    if(ref!=null){
      // for(Map<dynamic,dynamic> entry in ref){
      //   print(entry["userAccountId"]);
      // }
      // await Future.any(
      await Future.forEach(ref.values,(repliedChat)async{
        String userAccountId = repliedChat["userAccountId"];
        String userChatId = repliedChat["userChatId"];
        // bool isActive = repliedChat["isActive"];
        // if(isActive){
        final chatSnapshot = await databaseRef.child(userAccountId).child(
            'userchat').child(userChatId).once();
        var chatRef = await chatSnapshot.value;
        VolunteerChatModel newChat = VolunteerChatModel(
          userChatId: userChatId,
          userAccountId: chatRef["userAccountId"],
          volunteerAccountId: chatRef["volunteerAccountId"],
          questionText: chatRef["questionText"],
          questionReply: chatRef["questionReply"],
          questionTags: chatRef["questionTags"] as List<dynamic> != null
              ? (chatRef["questionTags"] as List<dynamic>).map((tag) =>
              tag.toString()).toList()
              : null,
          dateOfQuestion: DateTime.parse(chatRef["dateOfQuestion"]),
          chatPreferredLanguage: chatRef["chatPreferredLanguage"],
          chatReplyScore: chatRef["chatReplyScore"]!=null? double.parse(chatRef["chatReplyScore"].toString()):null,
        );
        // print(chatRef["chatPreferredLanguage"]);
        if(newChat.questionReply==null) {
          _loadedPickedChat.add(newChat);
        } // if (newChat.volunteerAccountId == _volunteerId) {
        //   _loadedPersonalChat.add(newChat);
        // }
      }
      );
    }
    // _loadedActiveChat.sort((a,b)=>a.dateOfQuestion.compareTo(b.dateOfQuestion));
    _loadedPickedChat.sort((a,b)=>a.dateOfQuestion.compareTo(b.dateOfQuestion));
    // _volunteerActiveChats = _loadedActiveChat;
    _volunteerPickedChats = _loadedPickedChat;
    // print(_volunteerRepliedChats[0].questionReply);
    notifyListeners();
  }

  Future<void> fetchRepliedChat()async{
    String _volunteerId = _authRef.currentUser.uid;
    // List<VolunteerChatModel> _loadedActiveChat = [];
    List<VolunteerChatModel> _loadedRepliedChat = [];
    var snapshot =  await databaseRef.child(_volunteerId).child('volunteerchat').once();
    Map<dynamic,dynamic> ref = await snapshot.value;
    if(ref!=null){
      // for(Map<dynamic,dynamic> entry in ref){
      //   print(entry["userAccountId"]);
      // }
      // await Future.any(
      await Future.forEach(ref.values,(repliedChat)async{
        String userAccountId = repliedChat["userAccountId"];
        String userChatId = repliedChat["userChatId"];
        // bool isActive = repliedChat["isActive"];
        // if(isActive){
          final chatSnapshot = await databaseRef.child(userAccountId).child(
              'userchat').child(userChatId).once();
          var chatRef = await chatSnapshot.value;
          VolunteerChatModel newChat = VolunteerChatModel(
            userChatId: userChatId,
            userAccountId: chatRef["userAccountId"],
            volunteerAccountId: chatRef["volunteerAccountId"],
            questionText: chatRef["questionText"],
            questionReply: chatRef["questionReply"],
            questionTags: chatRef["questionTags"] as List<dynamic> != null
                ? (chatRef["questionTags"] as List<dynamic>).map((tag) =>
                tag.toString()).toList()
                : null,
            dateOfQuestion: DateTime.parse(chatRef["dateOfQuestion"]),
            chatPreferredLanguage: chatRef["chatPreferredLanguage"],
            chatReplyScore: chatRef["chatReplyScore"]!=null? double.parse(chatRef["chatReplyScore"].toString()):null,
          );
          // print(chatRef["chatPreferredLanguage"]);
        if(newChat.questionReply!=null) {
          _loadedRepliedChat.add(newChat);
        }
        // _loadedRepliedChat.add(newChat);
          // if (newChat.volunteerAccountId == _volunteerId) {
          //   _loadedPersonalChat.add(newChat);
          // }
        }
      );
    }
    // _loadedActiveChat.sort((a,b)=>a.dateOfQuestion.compareTo(b.dateOfQuestion));
    _loadedRepliedChat.sort((a,b)=>a.dateOfQuestion.compareTo(b.dateOfQuestion));
    // _volunteerActiveChats = _loadedActiveChat;
    _volunteerRepliedChats = _loadedRepliedChat;
    // print(_volunteerRepliedChats[0].questionReply);
    notifyListeners();
  }

  // Future<void> fetchVolunteerChat()async{
  //   String _userId = _authRef.currentUser.uid;
  //   List<VolunteerChatModel> _loadedChat = [];
  //   var snapshot =await databaseRef.child(_userId).child('userchat').once();
  //   var ref = await snapshot.value;
  //   if(ref!=null){
  //     await ref.forEach((key,chat){
  //       // final tags = chat["questionTags"] as List<dynamic>;
  //       // List<String> qtag;
  //       // tags.forEach((element) { qtag.add(element);});
  //       VolunteerChatModel newChat = VolunteerChatModel(
  //         userChatId: key,
  //         userAccountId: chat["userAccountId"],
  //         volunteerAccountId: chat["volunteerAccountId"],
  //         questionText: chat["questionText"],
  //         questionReply: chat["questionReply"],
  //         questionTags: chat["questionTags"] as List<dynamic>!=null?(chat["questionTags"] as List<dynamic>).map((tag) => tag.toString()).toList():null,
  //         dateOfQuestion: DateTime.parse(chat["dateOfQuestion"]),
  //         chatPreferredLanguage: chat["chatPreferredLanguage"],
  //         chatReplyScore: chat["chatReplyScore"],
  //       );
  //       _loadedChat.add(newChat);
  //     });
  //   }
  //   _loadedChat.sort((a,b)=>a.dateOfQuestion.compareTo(b.dateOfQuestion));
  //   _volunteerActiveChats = _loadedChat;
  //   notifyListeners();
  // }

  VolunteerChatModel findById(String chatId){
    return _volunteerActiveChats.firstWhere((chat) => chat.userChatId == chatId);
  }

  int findIndexById(String chatId){
    return _volunteerActiveChats.indexWhere((chat) => chat.userChatId == chatId);
  }
  VolunteerChatModel findRepliedChatById(String chatId){
    return _volunteerRepliedChats.firstWhere((chat) => chat.userChatId == chatId);
  }

  int findRepliedChatIndexById(String chatId){
    return _volunteerRepliedChats.indexWhere((chat) => chat.userChatId == chatId);
  }
  VolunteerChatModel findPickedChatById(String chatId){
    return _volunteerPickedChats.firstWhere((chat) => chat.userChatId == chatId);
  }

  int findPickedChatIndexById(String chatId){
    return _volunteerPickedChats.indexWhere((chat) => chat.userChatId == chatId);
  }

  Future<void> updateRating(int chatIndex,double rating)async{
    String _userId = _authRef.currentUser.uid;
    String chatId = _volunteerActiveChats[chatIndex].userChatId;
    _volunteerActiveChats[chatIndex].chatReplyScore = rating;
    var snapshot = databaseRef.child(_userId).child('userchat').child(chatId);
    await snapshot.update({
      'chatReplyScore':rating
    });
    notifyListeners();
  }
}
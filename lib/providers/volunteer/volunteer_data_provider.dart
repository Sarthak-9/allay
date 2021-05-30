import 'package:allay/models/volunteer/volunteer_data_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VolunteerData with ChangeNotifier{
  final firestoreInstance = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  VolunteerDataModel _volunteerData;

  Future<void> addVolunteer(VolunteerDataModel volunteer)async{
    String _userID = _auth.currentUser.uid;
    var valunteerRef = FirebaseDatabase.instance.reference().child('volunteerdata').child(_userID);
    var snapshot = await valunteerRef.once();
    if(snapshot.value==null){
      var valunteerPushRef = valunteerRef.push();
      await valunteerPushRef.set({
        'volunteerUserId': volunteer.volunteerUserId,
        'volunteerName': volunteer.volunteerName,
        'volunteerAge': volunteer.volunteerAge,
        'volunteerEmail': volunteer.volunteerEmail,
        'volunteerPhone': volunteer.volunteerPhone,
        'approvedSelectorId': volunteer.approvedSelectorId,
        'chatUserId': volunteer.chatUserId,
        'currentChatUserId': volunteer.currentChatUserId,
        'reviewedPostId': volunteer.reviewedPostId
      });
    }
  }

  Future<void> fetchVolunteer()async{
    String _userID = _auth.currentUser.uid;
    var volunteerRef =await FirebaseDatabase.instance.reference().child('volunteerdata').child(_userID).once();
    var snapshot = await volunteerRef.value;
    if(snapshot!=null){

    }
  }

}
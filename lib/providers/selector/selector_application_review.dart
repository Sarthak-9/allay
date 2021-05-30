import 'package:allay/models/volunteer/volunteer_question_form_model.dart';
import 'package:allay/providers/volunteer/volunteer_application_form.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SelectionApplicationReview with ChangeNotifier {
  List<VolunteerFormModel> _volunteerActiveForms = [];
  List<VolunteerFormModel> _volunteerPickedForms = [];

  List<VolunteerFormModel> get volunteerActiveForms => _volunteerActiveForms;
  List<VolunteerFormModel> get volunteerPickedForms => _volunteerPickedForms;

  FirebaseAuth _authRef = FirebaseAuth.instance;
  final databaseRef = FirebaseDatabase.instance.reference();

  Future<void> pickVolunteerForm(int index,String volunteerId)async{
    String _selectorId = _authRef.currentUser.uid;
    String dateOfAllocation = DateTime.now().toIso8601String();
    // await activeApplicationRef.set({
    //   'userAccountId': _userId,
    //   'volunteerAccountId': null,
    //   'dateOfApplication': DateTime.now().toIso8601String(),
    // });
    // print(volunteerId);
    final applicationRef = databaseRef.child(volunteerId).child('volunteerapplication');
    await applicationRef.update({
      // 'userAccountId': _userId,
      'selectorAccountId': _selectorId,
      // 'volunteerAccountId': volunteerId,
      // 'volunteerAnswers': answers.toList(),
      'dateOfAllocation': dateOfAllocation,
      // 'isSelected': false,
    });
    final selectorApplicationRef = databaseRef.child(_selectorId).child('volunteerforms').child(volunteerId);
    await selectorApplicationRef.set({
      // 'userAccountId': _userId,
      'selectorAccountId': _selectorId,
      'volunteerAccountId': volunteerId,
      // 'volunteerAnswers': answers.toList(),
      'dateOfAllocation': dateOfAllocation,
      // 'isSelected': false,
    });
    final activeApplicationRef = databaseRef.child('volunteeractiveapplication').child(volunteerId);
    await activeApplicationRef.update({
      // 'userAccountId': _userId,
      'volunteerAccountId': volunteerId,
      'dateOfAllocation': dateOfAllocation,
    });
    _volunteerActiveForms.removeAt(index);
  }

  Future<void> fetchVolunteerActiveForm()async{
    String _selectoruserId = _authRef.currentUser.uid;
    List<VolunteerFormModel> _loadedActiveForms = [];
    final activeApplicationRef =await databaseRef.child('volunteeractiveapplication').once();
    Map<dynamic,dynamic> ref = await activeApplicationRef.value;
    if(ref!=null){
      await Future.forEach(ref.values, (activeForms)async{
        String userAccountId = activeForms["volunteerAccountId"];
        final applicationRef =await databaseRef.child(userAccountId).child('volunteerapplication').once();
        if(applicationRef!=null){
          var volunteerApplicationRef = await applicationRef.value;
          VolunteerFormModel loadedForm = VolunteerFormModel(
            volunteerId: volunteerApplicationRef["volunteerAccountId"],
            selectorId: volunteerApplicationRef["selectorAccountId"],
            volunteerAnswers:volunteerApplicationRef["volunteerAnswers"] as List<dynamic>!=null?(volunteerApplicationRef["volunteerAnswers"] as List<dynamic>).map((tag) => tag.toString()).toList():null,
            dateOfApplication:volunteerApplicationRef["dateOfApplication"]!=null? DateTime.parse(volunteerApplicationRef["dateOfApplication"]):null,
          );
          if(loadedForm.selectorId==null){
            _loadedActiveForms.add(loadedForm);
          }
        }
        // String userChatId = activeForms["userChatId"];
      });
    }
    _volunteerActiveForms = _loadedActiveForms;
    notifyListeners();
    // await activeApplicationRef.set({
    //   'userAccountId': _userId,
    //   'volunteerAccountId': null,
    //   'dateOfApplication': DateTime.now().toIso8601String(),
    // });
    // final applicationRef = databaseRef.child(_userId).child('volunteerapplication');
    // await applicationRef.set({
    //   'userAccountId': _userId,
    //   'volunteerAccountId': null,
    //   'volunteerAnswers': answers.toList(),
    //   'dateOfApplication': DateTime.now().toIso8601String(),
    //   'isSelected': false,
    // });
    // final activeApplicationRef = databaseRef.child('volunteeractiveapplication').child(_userId);
    // await activeApplicationRef.set({
    //   'userAccountId': _userId,
    //   'volunteerAccountId': null,
    //   'dateOfApplication': DateTime.now().toIso8601String(),
    // });
  }
  Future<void> fetchSelectorPickedForm()async{
    String _selectoruserId = _authRef.currentUser.uid;
    List<VolunteerFormModel> _loadedPickedForms = [];
    final activeApplicationRef =await databaseRef.child(_selectoruserId).child('volunteerforms').once();
    Map<dynamic,dynamic> ref = await activeApplicationRef.value;
    if(ref!=null){
      await Future.forEach(ref.values, (activeForms)async{
       if(activeForms['awardedMarks']==null) {
          String volunteerAccountId = activeForms["volunteerAccountId"];
          final applicationRef = await databaseRef
              .child(volunteerAccountId)
              .child('volunteerapplication')
              .once();
          if (applicationRef != null) {
            var volunteerApplicationRef = await applicationRef.value;
            print(volunteerApplicationRef["selectorAccountId"]);
            VolunteerFormModel loadedForm = VolunteerFormModel(
              volunteerId: volunteerApplicationRef["volunteerAccountId"],
              selectorId: volunteerApplicationRef["selectorAccountId"],
              volunteerAnswers: volunteerApplicationRef["volunteerAnswers"]
                          as List<dynamic> !=
                      null
                  ? (volunteerApplicationRef["volunteerAnswers"]
                          as List<dynamic>)
                      .map((tag) => tag.toString())
                      .toList()
                  : null,
              dateOfApplication: volunteerApplicationRef["dateOfApplication"] !=
                      null
                  ? DateTime.parse(volunteerApplicationRef["dateOfApplication"])
                  : null,
            );
            // if(loadedForm.selectorId==null){
            _loadedPickedForms.add(loadedForm);
            // }
          }
        }
        // String userChatId = activeForms["userChatId"];
      });
    }
    _volunteerPickedForms = _loadedPickedForms;
    notifyListeners();
  }

  Future<void> approveVolunteer(String volunteerId,int awardedMarks)async{
    String _selectorId = _authRef.currentUser.uid;
    final applicationRef = databaseRef.child(volunteerId).child('volunteerapplication');
    await applicationRef.update({
      'awardedMarks': awardedMarks,
    });
    final firestoreInstance = FirebaseFirestore.instance;
    await firestoreInstance.collection("userdata").doc(volunteerId).update({
      'userRole':4,
      'dateOfApproval': DateTime.now().toIso8601String()
    }).then((value) {
      // blogFirestoreId = value.id;
    });
    final selectorApplicationRef = databaseRef.child(_selectorId).child('volunteerforms').child(volunteerId);
    await selectorApplicationRef.update({
      'awardedMarks':awardedMarks,
      'isSelected': true,
    });
    final activeApplicationRef =await databaseRef.child('volunteeractiveapplication').child(volunteerId).remove();
  }
  Future<void> declineVolunteer(String volunteerId,int awardedMarks)async{
    String _selectorId = _authRef.currentUser.uid;

    final applicationRef = databaseRef.child(volunteerId).child('volunteerapplication');
    await applicationRef.update({
      'awardedMarks': null,
      'dateOfApplication':null,
    });
    final selectorApplicationRef = databaseRef.child(_selectorId).child('volunteerforms').child(volunteerId);
    await selectorApplicationRef.update({
      'awardedMarks':awardedMarks,
      'isSelected': false,
    });
    final activeApplicationRef =await databaseRef.child('volunteeractiveapplication').child(volunteerId).remove();
  }


  VolunteerFormModel findPickedFormById(String volunteerId){
    return _volunteerPickedForms.firstWhere((chat) => chat.volunteerId == volunteerId);
  }
}
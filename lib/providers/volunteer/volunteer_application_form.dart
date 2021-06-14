import 'package:allay/models/volunteer/volunteer_question_form_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class VolunteerApplicationForm with ChangeNotifier{
   VolunteerFormModel _volunteerApplicationForm;

   VolunteerFormModel get volunteerApplicationForm =>
      _volunteerApplicationForm;

   FirebaseAuth _authRef = FirebaseAuth.instance;
   final databaseRef = FirebaseDatabase.instance.reference();

   Future<void> applyVolunteer(Map<String,String> answers)async{
      String _userId = _authRef.currentUser.uid;
      final applicationRef = databaseRef.child(_userId).child('volunteerapplication');
      await applicationRef.set({
         'volunteerAccountId': _userId,
         'selectorAccountId': null,
         'volunteerAnswers': answers,
         'dateOfApplication': DateTime.now().toIso8601String(),
         'isSelected': false,
      });
      final activeApplicationRef = databaseRef.child('volunteeractiveapplication').child(_userId);
      await activeApplicationRef.set({
         'volunteerAccountId': _userId,
         'selectorAccountId': null,
         'dateOfApplication': DateTime.now().toIso8601String(),
      });
   }
   Future<bool> fetchVolunteerForm()async{
      String _userId = _authRef.currentUser.uid;
      final applicationRef =await databaseRef.child(_userId).child('volunteerapplication').once();
      if(applicationRef!=null){
         var volunteerApplicationRef = await applicationRef.value;
         if(volunteerApplicationRef==null){
            return true;
         }
         VolunteerFormModel loadedForm = VolunteerFormModel(
            volunteerId: volunteerApplicationRef["volunteerAccountId"],
            selectorId: volunteerApplicationRef["selectorAccountId"],
            volunteerAnswers:volunteerApplicationRef["volunteerAnswers"] as Map<dynamic,dynamic> !=null?(volunteerApplicationRef["volunteerAnswers"] as Map<dynamic,dynamic> ):null,//.map((tag) => tag.toString()).toList():null,
            dateOfApplication:volunteerApplicationRef["dateOfApplication"]!=null? DateTime.parse(volunteerApplicationRef["dateOfApplication"]):null,
         );
         // print(loadedForm.dateOfApplication);
         if(loadedForm.dateOfApplication != null){
            return false;
         }
      }
      return true;
   }
}
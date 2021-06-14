import 'package:allay/models/volunteer/volunteer_question_model.dart';
import 'package:flutter/material.dart';

class VolunteerFormModel{
  Map<dynamic,dynamic> volunteerAnswers;
  final String volunteerId;
  final String selectorId;
  final DateTime dateOfApplication;
  final int awardedMarks;
  bool isSelected=false;

  VolunteerFormModel({this.volunteerAnswers, this.volunteerId, this.selectorId,
      this.dateOfApplication, this.awardedMarks, this.isSelected});
}
import 'package:flutter/material.dart';

class VolunteerDataModel {
  final String volunteerUserId;
  final String volunteerName;
  final int volunteerAge;
  final String volunteerEmail;
  final String volunteerPhone;
  final String approvedSelectorId;
  List<String> chatUserId;
  String currentChatUserId;
  List<String> reviewedPostId;

  VolunteerDataModel({
      this.volunteerUserId,
      this.volunteerName,
      this.volunteerAge,
      this.volunteerEmail,
      this.volunteerPhone,
      this.approvedSelectorId,
      this.chatUserId,
      this.currentChatUserId,
      this.reviewedPostId});
}
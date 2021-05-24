
class VolunteerChatModel{
  final String userChatId;
  final String userAccountId;
  final String volunteerAccountId;
  final String questionText;
  String questionReply;
  final List<String> questionTags;
  final DateTime dateOfQuestion;
  final String chatPreferredLanguage;
  double chatReplyScore;

  VolunteerChatModel({
    this.userChatId,
    this.userAccountId,
    this.volunteerAccountId,
    this.questionText,
    this.questionReply,
    this.questionTags,
    this.dateOfQuestion,
    this.chatPreferredLanguage,
    this.chatReplyScore});
}
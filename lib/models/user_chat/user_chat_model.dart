
class UserChatModel{
  final String userChatId;
  final String userAccountId;
  final String volunteerAccountId;
  final String questionText;
  final String questionReply;
  final List<String> questionTags;
  final DateTime dateOfQuestion;
  final String chatPreferredLanguage;
  final int chatReplyScore;

  UserChatModel({
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
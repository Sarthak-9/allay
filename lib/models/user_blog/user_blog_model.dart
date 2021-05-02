
import 'dart:io';

class UserBlog{
  final String userBlogId;
  final String userBlogTitle;
  final String userBlogMood;
  final DateTime userBlogDate;
  final String userBlogImageUrl;
  final String userBlogText;
  final String userBlogAnalysisReport;
  File userBlogImage;
  UserBlog({
      this.userBlogId,
      this.userBlogTitle,
      this.userBlogMood,
      this.userBlogDate,
      this.userBlogImageUrl,
      this.userBlogText,
      this.userBlogAnalysisReport,
      this.userBlogImage,
  });
}
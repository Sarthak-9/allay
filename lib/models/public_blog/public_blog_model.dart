
class PublicBlog{
  final String publicBlogId;
  final String publicBlogTitle;
  final String authorUserName;
  final String authorUserId;
  final String authorImageUrl;
  final String publicBlogMood;
  final DateTime publicBlogDate;
  final String publicBlogText;
  final List<String> publicBlogLikes;
  bool publicBlogCurrentUserLiked;

  PublicBlog({
      this.publicBlogId,
      this.publicBlogTitle,
      this.authorUserName,
      this.authorUserId,
      this.authorImageUrl,
      this.publicBlogMood,
      this.publicBlogDate,
      this.publicBlogText,
      this.publicBlogLikes,
      this.publicBlogCurrentUserLiked});
}
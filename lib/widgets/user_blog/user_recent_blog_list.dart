import 'package:allay/providers/user_blog/user_blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'user_blog_widget.dart';

class UserRecentBlogList extends StatefulWidget {
  const UserRecentBlogList({Key key}) : super(key: key);

  @override
  _UserRecentBlogListState createState() => _UserRecentBlogListState();
}

class _UserRecentBlogListState extends State<UserRecentBlogList> {
  bool isLoading = true;
  @override
  void initState() {
    setState(() {
    isLoading = true;
    });
    // TODO: implement initState
    Future.delayed(Duration.zero).then((value) => fetch());
    // fetch();
    super.initState();
  }
  @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   fetch();
  //
  //   super.didChangeDependencies();
  // }
  void fetch()async{
    Provider.of<UserBlogs>(context, listen: false).fetchRecentBlogs();
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    var recentUserBlogsList = Provider.of<UserBlogs>(context).recentUserBlogs;
    return isLoading?Center(child: CircularProgressIndicator(),): SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: recentUserBlogsList.isEmpty
          ? Center(
        child: Text(
          'No Blogs',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      )
          :GridView.builder(
        physics: ScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1),
        itemBuilder: (ctx, i) => UserBlogWidget(
          userBlogId: recentUserBlogsList[i].userBlogId,
          userBlogTitle:
          recentUserBlogsList[i].userBlogTitle,
          userBlogText: recentUserBlogsList[i].userBlogText,
        ),
        itemCount: recentUserBlogsList.length,
      ),
    );
    SizedBox(
    height: 10,
    );
  }
}

import 'package:allay/models/user_blog/user_blog_model.dart';
import 'package:flutter/material.dart';

import 'user_blog_widget.dart';

class UserBlogSearch extends SearchDelegate<String> {
  List<UserBlog> searchBlog;

  UserBlogSearch(this.searchBlog);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
    throw UnimplementedError();
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
    // TODO: implement buildLeading
    throw UnimplementedError();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    // throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final List<UserBlog> suggestionList = query.isEmpty
        ? []
        : searchBlog.where((userblog) {
            return userblog.userBlogTitle
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();
    // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: suggestionList.length,
      itemBuilder: (ctx, i) => UserBlogWidget(
        userBlogId: suggestionList[i].userBlogId,
        userBlogTitle: suggestionList[i].userBlogTitle,
        userBlogText: suggestionList[i].userBlogText,
      ),
      // child: FestivalWidget(),
      // child: ListView.builder(itemBuilder: (){}),
    );
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}

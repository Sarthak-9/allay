import 'package:allay/models/public_blog/public_blog_model.dart';
import 'package:flutter/material.dart';

import 'public_blog_grid_widget.dart';

class BlogSearch extends SearchDelegate<String> {
  List<PublicBlog> searchBlog;

  BlogSearch(this.searchBlog);

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
    final List<PublicBlog> suggestionList = query.isEmpty
        ? []
        : searchBlog.where((blog) {
            return blog.publicBlogTitle
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                blog.authorUserName.toLowerCase().contains(query.toLowerCase());
          }).toList();
    // return ListView.builder(itemBuilder: (ctx, i) => ListTile());
    return GridView.builder(
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: suggestionList.length,
      itemBuilder: (ctx, i) => PublicBlogGridWidget(
        publicBlogId: suggestionList[i].publicBlogId,
        publicBlogTitle: suggestionList[i].publicBlogTitle,
        publicBlogText: suggestionList[i].publicBlogText,
      ),
      // child: FestivalWidget(),
      // child: ListView.builder(itemBuilder: (){}),
    );
    // TODO: implement buildSuggestions
    throw UnimplementedError();
  }
}

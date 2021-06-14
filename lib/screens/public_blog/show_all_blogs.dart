import 'package:allay/providers/constants.dart';
import 'package:allay/providers/public_blog/public_blogs_provider.dart';
import 'package:allay/widgets/public_blog/public_blog_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowAllBlogs extends StatefulWidget {
  static const routeName = '/show-all-blogs-screen';
  // const ShowAllBlogs({Key key}) : super(key: key);
  int blogtype;
  ShowAllBlogs({this.blogtype});

  @override
  _ShowAllBlogsState createState() => _ShowAllBlogsState();
}

class _ShowAllBlogsState extends State<ShowAllBlogs> {
  int blogType = 0;
  @override
  void initState() {
    // TODO: implement initState
    blogType =widget.blogtype;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var userPublicBlogList =
        Provider.of<PublicBlogs>(context).userPublicBlogList;
    var savedBlogList = Provider.of<PublicBlogs>(context).userSavedBlogList;
    return Scaffold(
      appBar: MainAppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                blogType == 1 ?'My Saved Blogs': 'My Public Blogs',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            SizedBox(
              height: 10,
            ),
            blogType == 1?
            GridView.builder(
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (ctx, i) => PublicBlogGridWidget(
                publicBlogId: savedBlogList[i].publicBlogId,
                publicBlogTitle: savedBlogList[i].publicBlogTitle,
                publicBlogText: savedBlogList[i].publicBlogText,
              ),
              itemCount: savedBlogList.length,
            ):GridView.builder(
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (ctx, i) => PublicBlogGridWidget(
                publicBlogId: userPublicBlogList[i].publicBlogId,
                publicBlogTitle:
                userPublicBlogList[i].publicBlogTitle,
                publicBlogText:
                userPublicBlogList[i].publicBlogText,
              ),
              itemCount: userPublicBlogList.length,
            ),
          ],
        ),
      ),
    );
  }
}

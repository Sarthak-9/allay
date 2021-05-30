import 'package:allay/providers/public_blog/public_blogs_provider.dart';
import 'package:allay/widgets/public_blog/public_blog_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserPublicBlogList extends StatefulWidget {
  const UserPublicBlogList({Key key}) : super(key: key);

  @override
  _UserPublicBlogListState createState() => _UserPublicBlogListState();
}

class _UserPublicBlogListState extends State<UserPublicBlogList> {
  bool isLoading = true;
  @override
  void initState() {
    // setState(() {
    //   isLoading = true;
    // });
    // TODO: implement initState
    // fetch();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UserPublicBlogList oldWidget) {
    // TODO: implement didUpdateWidget
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration.zero).then((value) => fetch());

    super.didUpdateWidget(oldWidget);
  }
  void fetch()async{
    await Provider.of<PublicBlogs>(context, listen: false)
        .fetchUserPublicBlogs();
  setState(() {
    isLoading = false;
  });
  }

  @override
  Widget build(BuildContext context) {
    var userPublicBlogList =
        Provider.of<PublicBlogs>(context).userPublicBlogList;
    return isLoading?Center(child: CircularProgressIndicator(),):SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: userPublicBlogList.isEmpty
          ? Center(
        child: Text(
          'No Blogs',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      )
          : GridView.builder(
        physics: ScrollPhysics(),
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1),
        itemBuilder: (ctx, i) => PublicBlogGridWidget(
          publicBlogId: userPublicBlogList[i].publicBlogId,
          publicBlogTitle:
          userPublicBlogList[i].publicBlogTitle,
          publicBlogText:
          userPublicBlogList[i].publicBlogText,
        ),
        itemCount: userPublicBlogList.length,
      ),
    );
  }
}

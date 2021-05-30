import 'package:allay/providers/public_blog/public_blogs_provider.dart';
import 'package:allay/widgets/public_blog/public_blog_grid_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSavedBlogList extends StatefulWidget {
  const UserSavedBlogList({Key key}) : super(key: key);

  @override
  _UserSavedBlogListState createState() => _UserSavedBlogListState();
}

class _UserSavedBlogListState extends State<UserSavedBlogList> {
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

  void fetch()async{
    await Provider.of<PublicBlogs>(context, listen: false).fetchSavedBlogs();
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    var savedBlogList = Provider.of<PublicBlogs>(context).userSavedBlogList;
    return isLoading?Center(child: CircularProgressIndicator(),): SizedBox(
      height: MediaQuery.of(context).size.height * 0.2,
      child: savedBlogList.isEmpty
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
          publicBlogId: savedBlogList[i].publicBlogId,
          publicBlogTitle: savedBlogList[i].publicBlogTitle,
          publicBlogText: savedBlogList[i].publicBlogText,
        ),
        itemCount: savedBlogList.length,
      ),
    );
  }
}

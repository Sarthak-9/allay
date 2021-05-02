import 'package:allay/providers/public_blog/public_blogs_provider.dart';
import 'package:allay/providers/user_blog/user_blog_provider.dart';
import 'package:allay/widgets/public_blog/public_blog_grid_widget.dart';
import 'package:allay/widgets/public_blog/public_blog_list.dart';
import 'package:allay/widgets/user_blog/user_blog_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class UserBlogsScreen extends StatefulWidget {
  @override
  _UserBlogsScreenState createState() => _UserBlogsScreenState();
}

class _UserBlogsScreenState extends State<UserBlogsScreen> {
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration.zero).then((_) {
        fetch();
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // fetch();
  }
  void fetch()async{
    setState(() {
      isLoading = true;
    });
   await Provider.of<PublicBlogs>(context,listen: false).fetchBlogs();
   await Provider.of<UserBlogs>(context,listen: false).fetchUserBlog();
    Provider.of<UserBlogs>(context,listen: false).fetchRecentBlogs();
    Provider.of<PublicBlogs>(context,listen: false).fetchUserPublicBlogs();
    await Provider.of<PublicBlogs>(context,listen: false).fetchSavedBlogs();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var userBlogsList = Provider.of<UserBlogs>(context).userBlogList;
    var recentUserBlogsList = Provider.of<UserBlogs>(context).recentUserBlogs;
    var userPublicBlogList = Provider.of<PublicBlogs>(context).userPublicBlogList;
    var savedBlogList = Provider.of<PublicBlogs>(context).userSavedBlogList;
    return Container(
      padding: EdgeInsets.all(8.0),
      child:isLoading? Center(child: CircularProgressIndicator(
        backgroundColor: Theme.of(context).primaryColor,
      ),): SingleChildScrollView(
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
                'My Blogs',
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
            Text(' Recent Blogs',style: TextStyle(
              fontSize: 20,
              color: Colors.teal,
            ),),
            Divider(),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.2,
              child:recentUserBlogsList.isEmpty? Center(
                child: Text('No Blogs',style: TextStyle(
                  fontSize: 18,
                ),),
              ): GridView.builder(
                physics: ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                  itemBuilder: (ctx, i) => UserBlogWidget(
                    userBlogId: recentUserBlogsList[i].userBlogId,
                    userBlogTitle: recentUserBlogsList[i].userBlogTitle,
                    userBlogText: recentUserBlogsList[i].userBlogText,
                  ),
                  itemCount: recentUserBlogsList.length,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(' My Saved Blogs',style: TextStyle(
              fontSize: 20,
              color: Colors.teal,
            ),),
            Divider(
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.2,
              child: GridView.builder(
                physics: ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                itemBuilder: (ctx, i) => UserBlogWidget(
                  userBlogId: savedBlogList[i].publicBlogId,
                  userBlogTitle: savedBlogList[i].publicBlogTitle,
                  userBlogText: savedBlogList[i].publicBlogText,
                ),
                itemCount: savedBlogList.length,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(' My Public Blogs',style: TextStyle(
              fontSize: 20,
              color: Colors.teal,
            ),),
            Divider(),
            //
            SizedBox(
              height: MediaQuery.of(context).size.height*0.2,
              child:userPublicBlogList.isEmpty? Center(
                child: Text('No Blogs',style: TextStyle(
                  fontSize: 18,
                ),),
              ):  GridView.builder(
                physics: ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
                itemBuilder: (ctx, i) => PublicBlogGridWidget(
                  publicBlogId: userPublicBlogList[i].publicBlogId,
                    publicBlogTitle: userPublicBlogList[i].publicBlogTitle,
                  publicBlogText: userPublicBlogList[i].publicBlogText,
                ),
                itemCount: userPublicBlogList.length,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text(' All Blogs',style: TextStyle(
              fontSize: 20,
              color: Colors.teal,
            ),),
            Divider(),
            userBlogsList.isEmpty? Center(
              child: Text('No Blogs',style: TextStyle(
                fontSize: 18,
              ),),
            ):
            GridView.builder(
              physics: ScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (ctx, i) => UserBlogWidget(
                userBlogId: userBlogsList[i].userBlogId,
                userBlogTitle: userBlogsList[i].userBlogTitle,
                userBlogText: userBlogsList[i].userBlogText,
              ),
              itemCount: userBlogsList.length,
            ),
          ],
        ),
      ),
    );
  }
}

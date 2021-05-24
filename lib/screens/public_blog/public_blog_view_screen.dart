import 'package:allay/providers/public_blog/public_blogs_provider.dart';
import 'package:allay/screens/user_blog/edit_blog_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:allay/screens/public_blog/public_blog_author_profile_screen.dart';
import '../../homepage.dart';
import '../../providers/contants.dart';

class PublicBlogViewScreen extends StatefulWidget {
  static const routeName = '/public-blog-view-screen';

  @override
  _PublicBlogViewScreenState createState() => _PublicBlogViewScreenState();
}

class _PublicBlogViewScreenState extends State<PublicBlogViewScreen> {
  bool likedStatus = false;
  String photoUrl = null;
  @override
  Widget build(BuildContext context) {
    var publicBlogId = ModalRoute.of(context).settings.arguments as String;
    var publicBlog = Provider.of<PublicBlogs>(context, listen: false)
        .findPublicBlogById(publicBlogId);
    int publicBlogLikes = publicBlog.publicBlogLikes != null
        ? publicBlog.publicBlogLikes.length
        : 0;
    photoUrl = publicBlog.authorImageUrl;
    likedStatus = publicBlog.publicBlogCurrentUserLiked;
    return Scaffold(
      appBar:  MainAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                    color: Theme.of(context).primaryColor, width: 2)),
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  publicBlog.publicBlogTitle,
                  style: TextStyle(fontSize: 22),
                ),
                ListTile(
                  onTap: ()=>Navigator.of(context).pushNamed(PublicBlogAuthorProfileScreen.routeName,arguments: publicBlogId),
                  leading: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.09,
                    backgroundImage:photoUrl!=null?NetworkImage(photoUrl): AssetImage("assets/images/userimage.png"),
                  ),
                  title: Text(publicBlog.authorUserName),
                  subtitle:
                      Text(DateFormat('dd / MM / yyyy').format(DateTime.now())),
                  trailing: Chip(
                      backgroundColor: getMoodColor(publicBlog.publicBlogMood),
                      label: Text(
                        publicBlog.publicBlogMood,
                        style: TextStyle(color: Colors.white),
                      )),
                ),
                Divider(),
                Text(
                  publicBlog.publicBlogText,
                  style: TextStyle(fontSize: 20),
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        IconButton(
                            icon: publicBlog.publicBlogCurrentUserLiked
                                ? Icon(Icons.thumb_up_alt_rounded)
                                : Icon(Icons.thumb_up_alt_outlined),
                            onPressed: () async {
                              likedStatus = !likedStatus;
                              // if(likedStatus){
                              //   ++publicBlogLikes;
                              //   print(publicBlogLikes);
                              // }else{
                              //   --publicBlogLikes;
                              //   print(publicBlogLikes);
                              // }
                              await Provider.of<PublicBlogs>(context,
                                      listen: false)
                                  .likePublicBlog(
                                      publicBlog.publicBlogId, likedStatus);
                              setState(() {});
                            }),
                        Text(publicBlogLikes.toString()),
                      ],
                    ),
                    IconButton(
                        icon: Icon(Icons.share_rounded), onPressed: () {}),
                    IconButton(icon: Icon(Icons.save), onPressed: ()async {
                      Provider.of<PublicBlogs>(context,listen: false).saveBlog(publicBlog.publicBlogId);
                    }),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                if (publicBlog.isAuthor)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: (){
                          Navigator.of(context).pushNamed(EditBlogScreen.routeName,arguments: publicBlogId);
                        },
                        child: Text(
                          '  Edit Blog  ',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.teal)),
                      ),
                      ElevatedButton(
                        onPressed:() {
                          deleteBlog(publicBlog.publicBlogId);
                        },
                        child: Text(
                          'Delete Blog',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.teal)),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void deleteBlog(String blogId) async {
    bool deleteStatus = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to delete this blog?.'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              deleteStatus = false;
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              deleteStatus = true;
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
    if(deleteStatus){
        await Provider.of<PublicBlogs>(context,listen: false).deletePublicBlog(blogId);
        Navigator.of(context).pushReplacementNamed(MyHomePage.routeName);
      // Navigator.of(context).p
    }
  }
}

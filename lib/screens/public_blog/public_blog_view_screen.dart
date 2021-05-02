import 'package:allay/providers/public_blog/public_blogs_provider.dart';
import 'package:allay/widgets/public_blog/public_blog_list.dart';
import 'package:allay/widgets/public_blog/public_blog_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../providers/contants.dart';

class PublicBlogViewScreen extends StatefulWidget {
  static const routeName = '/public-blog-view-screen';

  @override
  _PublicBlogViewScreenState createState() => _PublicBlogViewScreenState();
}

class _PublicBlogViewScreenState extends State<PublicBlogViewScreen> {
  @override
  Widget build(BuildContext context) {
    var publicBlogId = ModalRoute.of(context).settings.arguments;
    var publicBlog = Provider.of<PublicBlogs>(context, listen: false)
        .findPublicBlogById(publicBlogId);
    int publicBlogLikes = publicBlog.publicBlogLikes != null ? publicBlog.publicBlogLikes.length : 0;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Allay',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
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
                  leading: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.09,
                    backgroundImage: AssetImage("assets/images/userimage.png"),
                  ),
                  title: Text('authorUserName'),
                  subtitle:
                      Text(DateFormat('dd / MM / yyyy').format(DateTime.now())),
                  trailing: Chip(
                      backgroundColor: getMoodColor(publicBlog.publicBlogMood),
                      label: Text(
                        'Depressed',
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
                            onPressed: () {
                              publicBlog.publicBlogCurrentUserLiked =
                                  !publicBlog.publicBlogCurrentUserLiked;
                              publicBlogLikes=5;
                              setState(() {
                              });
                            }),
                        Text(publicBlogLikes.toString()),
                      ],
                    ),
                    IconButton(
                        icon: Icon(Icons.share_rounded), onPressed: () {}),
                    IconButton(icon: Icon(Icons.save), onPressed: () {}),
                  ],
                )
              ],
            ),
          ),
        ),
        // child: PublicBlogWidget(
        //   publicBlogId: publicBlog.publicBlogId,
        //   publicBlogText: publicBlog.publicBlogText,
        //   publicBlogTitle: publicBlog.publicBlogTitle,
        //   publicBlogDate: publicBlog.publicBlogDate,
        //   publicBlogMood: publicBlog.publicBlogMood,
        //   authorProfilePicture: publicBlog.authorImageUrl,
        //   currentUserLiked: publicBlog.publicBlogCurrentUserLiked,
        // ),
      ),
    );
  }
}

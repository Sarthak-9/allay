import 'package:allay/providers/contants.dart';
import 'package:allay/providers/user_blog/user_blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sentiment_dart/sentiment_dart.dart';

import '../../homepage.dart';

class UserBlogViewScreen extends StatefulWidget {
  static const routeName = '/user-blog-view-screen';

  @override
  _UserBlogViewScreenState createState() => _UserBlogViewScreenState();
}

class _UserBlogViewScreenState extends State<UserBlogViewScreen> {
  int analysisScore = 0;
  @override
  Widget build(BuildContext context) {
    var userBlogId = ModalRoute.of(context).settings.arguments as String;
    var userBlog = Provider.of<UserBlogs>(context).findUserBlogById(userBlogId);
    var imageUrl = userBlog.userBlogImageUrl;
    analysisScore =userBlog.userBlogAnalysisReport;
    return Scaffold(
      appBar: MainAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(userBlog.userBlogTitle,style: TextStyle(
                    fontSize: 26
                ),),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage:imageUrl!=null? NetworkImage(imageUrl): AssetImage('assets/images/userimage.png'),
                        radius: MediaQuery.of(context).size.width * 0.18,
                      ),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 24.0)),
                      Column(
                        children: [
                          Chip(
                            backgroundColor: getMoodColor(userBlog.userBlogMood),
                            label: Text(userBlog.userBlogMood,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          Text(DateFormat('dd / MM / yyyy').format(userBlog.userBlogDate),)
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(),
                SizedBox(
                  height: 20,
                ),
                Container(
                    // height: MediaQuery.of(context).size.height *0.44,
                    child: Text(userBlog.userBlogText,style: TextStyle(
                      fontSize: 22,
                    ),)
                ),
                SizedBox(
                  height: 50,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Card(
                    shadowColor: Theme.of(context).primaryColor,
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Column(
                      children: [
                        Text('Analysis Report',style: TextStyle(
                          fontSize: 20
                        ),),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                            padding:const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(9),
                                  border: Border.all(
                                      color: Theme.of(context).primaryColor, width: 0.7)),
                              child: FAProgressBar(
                                currentValue:analysisScore>=0? analysisScore : -analysisScore,
                                // displayText: '%',
                                direction: Axis.horizontal,
                                // backgroundColor: Colors.red,
                                progressColor: analysisScore>=0?Colors.green : Colors.red,
                              ),
                            )),
                        SizedBox(height: 20,),
                        Text(
                          'Your score is : ${userBlog.userBlogAnalysisReport}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20,),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: ElevatedButton(
                    onPressed: ()=>deleteBlog(userBlogId),
                    child: Text('Delete Blog'),
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.teal)),
                  ),
                ),
              ],
            ),
          ),
        ),
      )
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
      await Provider.of<UserBlogs>(context,listen: false).deleteBlog(blogId);
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage(tabNumber: 1,)));      // Navigator.of(context).p
    }
    return;
  }
}

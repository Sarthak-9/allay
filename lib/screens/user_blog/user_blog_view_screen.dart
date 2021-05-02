import 'package:allay/providers/contants.dart';
import 'package:allay/providers/user_blog/user_blog_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sentiment_dart/sentiment_dart.dart';

class UserBlogViewScreen extends StatefulWidget {
  static const routeName = '/user-blog-view-screen';

  @override
  _UserBlogViewScreenState createState() => _UserBlogViewScreenState();
}

class _UserBlogViewScreenState extends State<UserBlogViewScreen> {
  @override
  Widget build(BuildContext context) {
    var userBlogId = ModalRoute.of(context).settings.arguments as String;
    var userBlog = Provider.of<UserBlogs>(context).findUserBlogById(userBlogId);
    var imageUrl = userBlog.userBlogImageUrl;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Allay',style: TextStyle(
            color: Colors.white,
            fontSize: 24
        ),),
      ),
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
                Container(
                    height: MediaQuery.of(context).size.height *0.44,
                    child: Text(userBlog.userBlogText)
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
                        Text(
                          'Your score is : ${userBlog.userBlogAnalysisReport}',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 20,),
                        // ElevatedButton(
                        //   onPressed: () {},
                        //   child: Text('Analyze Again'),
                        //   style: ButtonStyle(
                        //       backgroundColor: MaterialStateProperty.all(Colors.teal)),
                        // ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      )
    );
  }
  // void analyzeBlog() {
  //   if (userB) {
  //     var blogText = _blogtextController.text;
  //     final sentiment = Sentiment();
  //     analysisReport = sentiment.analysis(blogText);
  //     print(analysisReport);
  //     analysisScore = analysisReport['score'].toString();
  //     setState(() {});
  //   }
  // }
}
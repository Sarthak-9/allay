import 'dart:io';

import 'package:allay/homepage.dart';
import 'package:allay/models/public_blog/public_blog_model.dart';
import 'package:allay/models/user_blog/user_blog_model.dart';
import 'package:allay/providers/contants.dart';
import 'package:allay/providers/public_blog/public_blogs_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';
import 'package:sentiment_dart/sentiment_dart.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditBlogScreen extends StatefulWidget {
  static const routeName = '/edit-blog-screen';
  @override
  _EditBlogScreenState createState() => _EditBlogScreenState();
}

class _EditBlogScreenState extends State<EditBlogScreen> {
  final addBlogKey = GlobalKey<FormState>();
  var sentiment = Sentiment();
  final _blogtitleNode = FocusNode();
  final _blogtextNode = FocusNode();
  DateTime dateTime;
  int moodNumber = -1;
  var analysisReport = null;
  int analysisScore = 0;
  var publicBlogId = '';
  String editedTitle = '';
  String editedText = '';
  String editedMood = '';
  PublicBlog publicBlog;
  bool moodchanged = false;
  Map<String, int> postiveWords = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    publicBlogId = ModalRoute.of(context).settings.arguments as String;
    publicBlog = Provider.of<PublicBlogs>(context, listen: false)
        .findPublicBlogById(publicBlogId);
    moodNumber = getMoodNumber(publicBlog.publicBlogMood);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Color borderColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: MainAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: addBlogKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Edit Blog',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 10,
                ),
                Divider(),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 25,
                  alignment: WrapAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setMood(1);
                      },
                      child: Text('Happy'),
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.resolveWith((states) => Size(80.0,35.0)),
                          backgroundColor: MaterialStateProperty.all(
                              moodNumber == 1 || moodNumber == -1
                                  ? const Color(0xFFD4860B)
                                  : const Color(0xFFD4860B).withOpacity(0.5))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setMood(2);
                      },
                      child: Text('Excited'),
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.resolveWith((states) => Size(80.0,35.0)),
                          backgroundColor: MaterialStateProperty.all(
                              moodNumber == 2 || moodNumber == -1
                                  ? const Color(0xFF149A80)
                                  : const Color(0xFF149A80).withOpacity(0.5)) //#D4860B
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setMood(3);
                      },
                      child: Text('Angry'),
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.resolveWith((states) => Size(80.0,35.0)),
                          backgroundColor: MaterialStateProperty.all(
                              moodNumber == 3 || moodNumber == -1
                                  ? const Color(0xFFE12E1C)
                                  : const Color(0xFFE12E1C).withOpacity(0.5))),
                    ),
                  ],
                ),
                Wrap(
                  spacing: 25,
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setMood(4);
                      },
                      child: Text('Sad'),
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.resolveWith((states) => Size(90.0,35.0)),
                          backgroundColor: MaterialStateProperty.all(
                              moodNumber == 4 || moodNumber == -1
                                  ? const Color(0xFF1E2B37)
                                  : const Color(0xFF1E2B37).withOpacity(0.5))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setMood(5);
                      },
                      child: Text('Depressed'),
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.resolveWith((states) => Size(90.0,35.0)),
                          backgroundColor: MaterialStateProperty.all(
                              moodNumber == 5 || moodNumber == -1
                                  ? const Color(0xFF809395)
                                  : const Color(0xFF809395).withOpacity(0.5))),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setMood(6);
                      },
                      child: Text('Neutral'),
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.resolveWith((states) => Size(90.0,35.0)),
                          backgroundColor: MaterialStateProperty.all(
                              moodNumber == 6 || moodNumber == -1
                                  ?  Colors.blue
                                  : Colors.blue.withOpacity(0.5)) //#D4860B
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: borderColor, width: 2)),
                  child: TextFormField(
                    initialValue: publicBlog.publicBlogTitle,
                    onChanged: (val){
                      editedTitle = val;
                    },
                    onSaved: (val){
                      editedTitle = val;
                    },
                    // controller: _blogtitleController,
                    textCapitalization: TextCapitalization.words,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(hintText: 'Title'),
                  ),
                ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: borderColor, width: 2)),
                      child: Text(moodchanged?getMoodText(moodNumber):publicBlog.publicBlogMood,
                        style: TextStyle(
                            fontSize: 16
                        ),
                      )
                  ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: borderColor, width: 2)),
                  child: Text(
                    DateFormat('dd / MM / yyyy').format(publicBlog.publicBlogDate),
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  )
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  // height: MediaQuery.of(context).size.height *0.6,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: borderColor, width: 2)),
                  child: TextFormField(
                    initialValue: publicBlog.publicBlogText,
                    textCapitalization: TextCapitalization.sentences,
                    focusNode: _blogtextNode,
                    onChanged: (val){
                      editedText = val;
                    },
                    onSaved: (val){
                      editedText = val;
                    },
                    maxLines:
                    (MediaQuery.of(context).size.height * 0.025).toInt(),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(hintText: 'Write here'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  // height: MediaQuery.of(context).size.width*0.9,
                  child: ElevatedButton(
                    onPressed: analyzeBlog,
                    child: Text('Analyze Again'),
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.teal)),
                  ),
                ),
                if (analysisReport != null)
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
                          Text(
                            'Analysis Report',
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Padding(
                              padding:const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(9),
                                    border: Border.all(
                                        color: borderColor, width: 0.7)),
                                child: FAProgressBar(
                                  currentValue:analysisScore>=0? analysisScore : -analysisScore,
                                  // displayText: '%',
                                  direction: Axis.horizontal,
                                  // backgroundColor: Colors.red,
                                  progressColor: analysisScore>=0?Colors.green : Colors.red,
                                ),
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'Your score is : ${analysisScore.toString()}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 20,
                          ),
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
                    onPressed: editBlog,
                    child: Text('Save Changes'),
                    style: ButtonStyle(
                        backgroundColor:
                        MaterialStateProperty.all(Colors.teal)),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void setMood(int buttonNumber) {
    moodNumber = buttonNumber;
    moodchanged = true;
    setState(() {});
  }

  void analyzeBlog() {
      if(editedText.isEmpty){
        editedText = publicBlog.publicBlogText;
      }
      final sentiment = Sentiment();
      analysisReport = sentiment.analysis(editedText);
      analysisScore = (analysisReport['comparative']*100).toInt();
      setState(() {});

  }

  void editBlog() async {
    var isValid = addBlogKey.currentState.validate();
    if (!isValid) {
      print('invalid');
      return;
    }
    if(editedTitle.isEmpty){
      editedTitle = publicBlog.publicBlogTitle;
    }
    if(editedText.isEmpty){
      editedText = publicBlog.publicBlogText;
    }
    PublicBlog currentBlog = PublicBlog(
        publicBlogId: publicBlogId,
        publicBlogTitle: editedTitle,
        publicBlogMood: getMoodText(moodNumber),
        publicBlogText: editedText,
    );
    await Provider.of<PublicBlogs>(context, listen: false).editPublicBlog(currentBlog);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage(tabNumber: 0,)));
  }
}

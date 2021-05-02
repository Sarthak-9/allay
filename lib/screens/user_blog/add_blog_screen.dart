import 'dart:io';

import 'package:allay/homepage.dart';
import 'package:allay/models/public_blog/public_blog_model.dart';
import 'package:allay/models/user_blog/user_blog_model.dart';
import 'package:allay/providers/contants.dart';
import 'package:allay/providers/public_blog/public_blogs_provider.dart';
import 'package:allay/providers/user_blog/user_blog_provider.dart';
import 'package:allay/providers/user_data/user_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sentiment_dart/sentiment_dart.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:provider/provider.dart';

class AddBlogScreen extends StatefulWidget {
  @override
  _AddBlogScreenState createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final addBlogKey = GlobalKey<FormState>();
  var sentiment = Sentiment();
  final _blogtitleController = TextEditingController();
  final _blogtextController = TextEditingController();
  bool _dateSelected = false;
  DateTime dateTime;
  File photoOfTheDay = null;
  int moodNumber = -1;
  var analysisReport = null;
  var analysisScore = '0';
  Map<String, int> postiveWords = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'How are you feeling today ?',
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
                GestureDetector(
                  onTap: _takePictureofTheDay,
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.18,
                    backgroundImage: photoOfTheDay != null
                        ? FileImage(photoOfTheDay)
                        : AssetImage("assets/images/userimage.png"),
                  ),
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
                          backgroundColor: MaterialStateProperty.all(
                              moodNumber == 1 || moodNumber == -1
                                  ? const Color(0xFFD4860B)
                                  : Colors.grey)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setMood(2);
                      },
                      child: Text('Excited'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              moodNumber == 2 || moodNumber == -1
                                  ? const Color(0xFF149A80)
                                  : Colors.grey) //#D4860B
                          ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setMood(3);
                      },
                      child: Text('Angry'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              moodNumber == 3 || moodNumber == -1
                                  ? const Color(0xFFE12E1C)
                                  : Colors.grey)),
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
                          backgroundColor: MaterialStateProperty.all(
                              moodNumber == 4 || moodNumber == -1
                                  ? const Color(0xFF1E2B37)
                                  : Colors.grey)),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setMood(5);
                      },
                      child: Text('Depressed'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              moodNumber == 5 || moodNumber == -1
                                  ? const Color(0xFF809395)
                                  : Colors.grey)),
                    ),
                    // SizedBox(width: 30,),
                    ElevatedButton(
                      onPressed: () {
                        setMood(6);
                      },
                      child: Text('Neutral'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              moodNumber == 6 || moodNumber == -1
                                  ?  Colors.blue
                                  : Colors.grey) //#D4860B
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
                          color: Theme.of(context).primaryColor, width: 2)),
                  child: TextFormField(
                    controller: _blogtitleController,
                    textCapitalization: TextCapitalization.words,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(hintText: 'Title'),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                          color: Theme.of(context).primaryColor, width: 2)),
                  child: TextButton(
                    child: _dateSelected
                        ? Text(
                            DateFormat('dd / MM / yyyy').format(dateTime),
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          )
                        : Text(
                            'Select Date',
                            style: TextStyle(
                              color: Colors.black45,
                            ),
                          ),
                    style: TextButton.styleFrom(
                        // minimumSize: MaterialStateProperty.all(Size.fromWidth(MediaQuery.of(context).size.width * 0.8)),
                        tapTargetSize: MaterialTapTargetSize.padded,
                        minimumSize: const Size(double.infinity,50),
                    ),
                    // splashColor: Colors.red.shade50,
                    // focusColor: Colors.red,
                    onPressed: () async {
                      // FocusNode().context.un
                      dateTime = await PlatformDatePicker.showDate(
                        context: context,
                        firstDate: DateTime(DateTime.now().year - 50),
                        initialDate: DateTime.now(),
                        lastDate: DateTime(DateTime.now().year + 2),
                        builder: (context, child) => Theme(
                          data: ThemeData(
                            colorScheme: ColorScheme.light(
                              primary: Theme.of(context).primaryColor,
                            ),
                            buttonTheme: ButtonThemeData(
                                textTheme: ButtonTextTheme.primary),
                          ),
                          child: child,
                        ),
                      );
                      if (dateTime != null) {
                        setState(() {
                          _dateSelected = true;
                        });
                      }
                    },
                  ),
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
                          color: Theme.of(context).primaryColor, width: 2)),
                  child: TextFormField(
                    controller: _blogtextController,
                    textCapitalization: TextCapitalization.sentences,
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
                    child: Text('Analyze your mood'),
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
                          Text(
                            'Your score is : $analysisScore',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          // ElevatedButton(
                          //   onPressed: () {},
                          //   child: Text('Analyze Again'),
                          //   style: ButtonStyle(
                          //       backgroundColor: MaterialStateProperty.all(Colors.teal)),
                          // ),
                        ],
                      ),
                    ),
                  ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: publishAsPrivate,
                      child: Text('Publish as Personal'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.teal)),
                    ),
                    ElevatedButton(
                      onPressed: publishAsPublic,
                      child: Text('   Publish as Public   '),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.teal)),
                    ),
                  ],
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

  Future<void> _takePictureofTheDay() async {
    try {
      final pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        // maxWidth: maxWidth,
        // maxHeight: maxHeight,
        // imageQuality: quality,
      );
      setState(() {
        photoOfTheDay = File(pickedFile.path);
      });
    } catch (e) {
      print(e);
    }
  }

  void setMood(int buttonNumber) {
    moodNumber = buttonNumber;
    setState(() {});
  }

  void analyzeBlog() {
    if (_blogtextController.text.isNotEmpty) {
      var blogText = _blogtextController.text;
      final sentiment = Sentiment();
      analysisReport = sentiment.analysis(blogText);
      print(analysisReport);
      analysisScore = analysisReport['score'].toString();
      setState(() {});
    }
  }

  void publishAsPrivate() async {
    // addBlogKey.currentState.
    if (moodNumber == -1) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Select Mood !!'),
          content: Text('Set mood of the day first.'),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
      return;
    }
    if (dateTime == null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Select Date !!'),
          content: Text('Set date of the blog.'),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
      return;
    }
    var isValid = addBlogKey.currentState.validate();
    if (!isValid) {
      return;
    }

    UserBlog currentBlog = UserBlog(
      userBlogTitle: _blogtitleController.text,
      userBlogMood: getMoodText(moodNumber),
      userBlogDate: dateTime,
      userBlogText: _blogtextController.text,
      userBlogAnalysisReport: analysisScore,
      userBlogImage: photoOfTheDay,
      userBlogImageUrl: null,
    );
    Provider.of<UserBlogs>(context, listen: false).addUserBlog(currentBlog);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage(tabNumber: 1,)));
  }

  void publishAsPublic() async {
    // addBlogKey.currentState.
    if (moodNumber == -1) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Select Mood !!'),
          content: Text('Set mood of the day first.'),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
      return;
    }
    if (dateTime == null) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Select Date !!'),
          content: Text('Set date of the blog.'),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );
      return;
    }
    var isValid = addBlogKey.currentState.validate();
    if (!isValid) {
      return;
    }
    FirebaseAuth _auth = FirebaseAuth.instance;
    var _userID = _auth.currentUser.uid;
    var authorImageUrl = Provider.of<UserData>(context).userData.profilePhotoLink;
    PublicBlog currentBlog = PublicBlog(
        authorUserName: _auth.currentUser.displayName,
        authorUserId: _userID,
        authorImageUrl: authorImageUrl,
        publicBlogTitle: _blogtitleController.text,
        publicBlogMood: getMoodText(moodNumber),
        publicBlogDate: dateTime,
        publicBlogText: _blogtextController.text,
        publicBlogCurrentUserLiked: false);
        Provider.of<PublicBlogs>(context, listen: false).addPublicBlog(currentBlog);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage(tabNumber: 0,)));
    // Provider.of<PublicBlogs>(context, listen: false).fetchBlogs();
    // addBlogKey.currentState.val
  }
}

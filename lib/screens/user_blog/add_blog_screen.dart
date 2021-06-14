import 'dart:io';

import 'package:allay/homepage.dart';
import 'package:allay/models/public_blog/public_blog_model.dart';
import 'package:allay/models/user_blog/user_blog_model.dart';
import 'package:allay/providers/constants.dart';
import 'package:allay/providers/public_blog/public_blogs_provider.dart';
import 'package:allay/providers/user_blog/user_blog_provider.dart';
import 'package:allay/providers/user_data/user_data_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

import 'package:multi_select_flutter/multi_select_flutter.dart';
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
  // QuillController _controller = QuillController.basic();
  List<String> _selectedTags = [];
  final _items = tagList
      .map((inter) => MultiSelectItem<String>(inter, inter))
      .toList();
  bool _dateSelected = false;
  DateTime dateTime;
  File photoOfTheDay = null;
  int moodNumber = -1;
  var analysisReport = null;
  int analysisScore = 0;
  Map<String, int> postiveWords = {};

  @override
  Widget build(BuildContext context) {
    Color borderColor = Theme.of(context).primaryColor;
    double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                      child: Text('HAPPY'),
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
                      child: Text('EXCITED'),
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
                      child: Text('ANGRY'),
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
                      child: Text('SAD'),
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
                      child: Text('DEPRESSED'),
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
                      child: Text('NEUTRAL'),
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
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.black54
                      )
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        // alignment: Alignment.center,
                        // decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.circular(5),
                        //     border: Border.all(
                        //         color: borderColor, width: 2)),
                        child: TextFormField(
                          controller: _blogtitleController,
                          textCapitalization: TextCapitalization.words,
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(hintText: 'Title'),
                          validator: (value) {
                            if (value.length == 0) {
                              return 'Enter a valid title';
                            }
                            return null;
                          },
                        ),
                      ),
                      if(moodNumber!=-1)
                        SizedBox(
                          height: 20,
                        ),
                      if(moodNumber!=-1)
                        Container(
                            height: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              // color: Colors.red,//getMoodColorFromNumber(moodNumber),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: borderColor, width: 2)
                            ),
                            child: Text(getMoodText(moodNumber),
                              style: TextStyle(
                                fontSize: 16,
                                color: getMoodColorFromNumber(moodNumber),
                              ),
                            )
                        ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: 50,
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: borderColor, width: 2)),
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
                            tapTargetSize: MaterialTapTargetSize.padded,
                            minimumSize: const Size(double.infinity,50),
                          ),
                          onPressed: () async {
                            FocusScope.of(context).unfocus();
                            dateTime = await PlatformDatePicker.showDate(
                              context: context,
                              firstDate: DateTime(DateTime.now().year - 100),
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
                      // Container(
                      //     height: 100,
                      //     child: QuillToolbar.basic(controller: _controller)),
                      // Container(
                      //   height: 500,
                      //   child: Expanded(
                      //     child: QuillEditor.basic(
                      //       controller: _controller,
                      //       readOnly: false, // true for view only mode
                      //     ),
                      //   ),
                      // ),
                      Container(
                        // height: MediaQuery.of(context).size.height *0.6,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: borderColor, width: 2)),
                        child: TextFormField(
                          controller: _blogtextController,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (value) {
                            if (value.length <=0) {
                              return 'Blog is not long enough';
                            }
                            return null;
                          },
                          maxLines:
                          (MediaQuery.of(context).size.height * 0.025).toInt(),
                          textAlign: TextAlign.center,
                          decoration: InputDecoration(hintText: 'Write here',border: InputBorder.none),
                        ),
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),
                      // MultiSelectBottomSheetField(
                      //   searchTextStyle: TextStyle(
                      //     color: Colors.black,
                      //   ),
                      //   listType: MultiSelectListType.CHIP,
                      //   itemsTextStyle: TextStyle(
                      //     color: Colors.black,
                      //   ),
                      //   validator: (values){
                      //     if(values == null || values.length<=5)
                      //       return null;
                      //     return 'Choose max 5 tags only';
                      //   },
                      //   autovalidateMode: AutovalidateMode.always,
                      //   selectedItemsTextStyle: TextStyle(
                      //     color: Colors.white,
                      //   ),
                      //   // searchable: true,
                      //   items: _items,
                      //   title: Text("Tags", style: TextStyle(
                      //     color: Colors.black,
                      //     fontSize: 16,
                      //   ),),
                      //   selectedColor: Colors.teal,
                      //   decoration: BoxDecoration(
                      //     color: Theme.of(context).primaryColor.withOpacity(0.1),
                      //     borderRadius: BorderRadius.all(Radius.circular(5)),
                      //     border: Border.all(
                      //       color: Theme.of(context).primaryColor,
                      //       width: 2,
                      //     ),
                      //   ),
                      //
                      //   buttonIcon: Icon(
                      //     Icons.category,
                      //     color: Colors.teal,
                      //   ),
                      //   buttonText: Text(
                      //     "Tags",
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 16,
                      //     ),
                      //   ),
                      //   onConfirm: (results) {
                      //     _selectedTags = results;
                      //   },
                      //
                      //   // maxChildSize: 0.8,
                      //   // initialChildSize: 0.6,
                      // ),
                    ],
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
                        elevation: MaterialStateProperty.all(3),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: publishAsPrivate,
                      child: Text('Publish as Personal',style: TextStyle(
                        color: Colors.white,
                      ),),
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(3),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.teal)),
                    ),
                    ElevatedButton(
                      onPressed: publishAsPublic,
                      child: Text('   Publish as Public   ',style: TextStyle(
                        color: Colors.white,
                      ),),
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(3),
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
        imageQuality: 50
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
      analysisScore = (analysisReport['comparative']*100).toInt();
      setState(() {});
    }
  }

  void publishAsPrivate() async {
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
    if(analysisScore ==0) {
      analyzeBlog();
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
    var isValid = addBlogKey.currentState.validate();
    if (!isValid) {
      return;
    }
    bool uploadBlog = false;
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Are you sure?'),
          content: Text('Do you want to upload this blog publically?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: (){
                uploadBlog = false;
                Navigator.of(ctx).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                uploadBlog = true;
                Navigator.of(ctx).pop();
              },
            )
          ],
        ),
      );

    if(uploadBlog){
      FirebaseAuth _auth = FirebaseAuth.instance;
      var _userID = _auth.currentUser.uid;
      var userData = Provider.of<UserData>(context, listen: false).userData;
      List<String> initLikes = [];
      PublicBlog currentBlog = PublicBlog(
          authorUserName: userData.userName,
          authorUserId: _userID,
          authorImageUrl: userData.profilePhotoLink,
          publicBlogTitle: _blogtitleController.text,
          publicBlogMood: getMoodText(moodNumber),
          publicBlogDate: DateTime.now(),
          publicBlogText: _blogtextController.text,
          publicBlogLikes: initLikes,
          publicBlogCurrentUserLiked: false);
      Provider.of<PublicBlogs>(context, listen: false)
          .addPublicBlog(currentBlog);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    tabNumber: 0,
                  )));
    }
  }
}

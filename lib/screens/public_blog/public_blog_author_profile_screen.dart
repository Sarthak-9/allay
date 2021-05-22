import 'dart:convert';

import 'package:allay/models/public_blog/public_blog_model.dart';
import 'package:allay/providers/contants.dart';
import 'package:allay/providers/public_blog/public_blogs_provider.dart';
import 'package:allay/providers/user_data/user_data_model.dart';
import 'package:allay/screens/user_data/login_page.dart';
import 'package:allay/widgets/user_data/user_not_loggedin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PublicBlogAuthorProfileScreen extends StatefulWidget {
  static const routeName = '/public-blog-author-profile-screen';
  @override
  _PublicBlogAuthorProfileScreenState createState() => _PublicBlogAuthorProfileScreenState();
}

class _PublicBlogAuthorProfileScreenState extends State<PublicBlogAuthorProfileScreen> {
  String publicBlogId = '';
  PublicBlog publicBlog;
  String _username=' ';
  String _userEmailId=' ';
  String _userPhone = ' ';
  String _userProfilePhoto = null;
  var _isLoading = true;
  var _loggedIn = false;
  var _loggingOut = false;
  var _logOut = false;
  final storage = new FlutterSecureStorage();
  DateTime _userDob = null;
  Future<void> _fetchProfile()async{
      var currentUser = publicBlog.authorDetails;
      _username = currentUser.userName;
      _userEmailId = currentUser.userEmail;
      _userPhone = currentUser.userPhone;
      _userDob = currentUser.dateofBirth;
      _userProfilePhoto = currentUser.profilePhotoLink!=null?currentUser.profilePhotoLink:null;

      setState(() {
      _isLoading = false;
    });
  }
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    setState(() {
      _isLoading = true;
    });
    publicBlogId = ModalRoute.of(context).settings.arguments as String;
    publicBlog = Provider.of<PublicBlogs>(context, listen: false)
        .findPublicBlogById(publicBlogId);
    _fetchProfile();
    super.didChangeDependencies();
  }
  @override
  void didUpdateWidget(covariant PublicBlogAuthorProfileScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: MainAppBar(),
      body: Container(
        // alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 12.0),
        child: _isLoading? Center(
          child: CircularProgressIndicator(
          ),
        ) :
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Author\'s Profile',
                style: TextStyle(
                    fontSize: 30.0,
                    fontFamily: 'Libre Baskerville'
                  //color: Colors.white
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 24,
              ),
              CircleAvatar(
                backgroundImage: _userProfilePhoto != null? NetworkImage(_userProfilePhoto) :   AssetImage('assets/images/userimage.png'),
                //: FileImage(loadedBirthday.imageofPerson),
                radius: MediaQuery.of(context).size.width * 0.18,
              ),

              SizedBox(height: 20,),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: Colors.black54
                    )
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.person_outline_rounded,
                        color: themeColor,
                        size: 28.0,
                      ),
                      title: Text('Name',textAlign: TextAlign.left,
                        textScaleFactor: 1.3,
                        style: TextStyle(
                          color: themeColor,
                        ),),
                      subtitle: Text(
                        _username,
                        //textScaleFactor: 1.4,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      child: ListTile(
                        leading: Icon(
                          Icons.calendar_today_rounded,
                          color: themeColor,
                          size: 28.0,
                        ),
                        title: Text('Birth Date',textAlign: TextAlign.left,
                          textScaleFactor: 1.3,
                          style: TextStyle(
                            color: themeColor,
                          ),),
                        subtitle: _userDob!=null
                            ? Text(
                          DateFormat('dd / MM / yyyy')
                              .format(_userDob),
                          //textScaleFactor: 1.4,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        )
                            : Text('None'),
                      ),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.account_circle_rounded,
                        color: themeColor,
                        size: 28.0,
                      ),
                      title: Text('Email',textAlign: TextAlign.left,
                        textScaleFactor: 1.3,
                        style: TextStyle(
                          color: themeColor,
                        ),),
                      subtitle: Text(
                        _userEmailId,
                        //textScaleFactor: 1.4,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                    ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: themeColor,
                        size: 28.0,
                      ),
                      title: Text('Phone',textAlign: TextAlign.left,
                        textScaleFactor: 1.3,
                        style: TextStyle(
                          color: themeColor,
                        ),),
                      subtitle: Text(
                        _userPhone!=null?_userPhone:'None',
                        //textScaleFactor: 1.4,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30,),

            ],
          ),
        ),
      ),
    );
  }
  Future<void> logoutUser()async{
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Logging out'),
        content: Text('Are you sure you want to logout'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              _logOut = true;
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
    if(_logOut){
      setState(() {
        _loggingOut = true;
      });
      FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.signOut();
      await storage.write(key: "signedIn",value: "false");
      setState(() {
        _loggingOut = false;
      });
      Navigator.of(context).pushNamedAndRemoveUntil(LoginPage.routename, (route) => false);
    }
  }
}

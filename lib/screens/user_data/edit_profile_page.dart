import 'dart:convert';
import 'dart:io';

import 'package:allay/providers/constants.dart';
import 'package:allay/providers/user_data/user_data_provider.dart';
import 'package:allay/screens/user_data/user_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:provider/provider.dart';
import 'package:allay/models/user_data/user_data_model.dart';

import '../../homepage.dart';

class UserAccountEditScreen extends StatefulWidget {
  static const routename = '/user-account-edit-screen';

  @override
  _UserAccountEditScreenState createState() => _UserAccountEditScreenState();
}

class _UserAccountEditScreenState extends State<UserAccountEditScreen> {
  final formkey = GlobalKey<FormState>();
  String _username=' ';
  String _userEmailId=' ';
  String userBio = ' ';
  DateTime userDateOfBirth;
  // var dateTime;
  var _dateSelected = false;
  bool _isLoading = true;
  bool _loggedIn = false;
  var _dobPresent = false;
  bool _loggingOut = false;
  // var _logOut = false;
  File _imageofUser;
  var pickedFile = null;
  final storage = new FlutterSecureStorage();
  var userPhoneController = TextEditingController();
  UserDataModel currentUser;
  // DateTime _userDob = null;

  Future<void> _fetchProfile()async{
    FirebaseAuth _auth = FirebaseAuth.instance;
    if(_auth == null||_auth.currentUser==null){
      setState(() {
        _loggedIn = false;
      });
    }else{
      setState(() {
        _loggedIn = true;
      });
    }
    if(_loggedIn){
      setState(() {
        _isLoading = true;
      });
      await Provider.of<UserData>(context,listen: false).fetchUser();
      currentUser = Provider.of<UserData>(context,listen: false).userData;
      _username = currentUser.userName;
      _userEmailId = currentUser.userEmail;
      userBio = currentUser.userBio;
      userDateOfBirth = currentUser.userDateOfBirth;
      // dateTime = _userDob;
    }
    setState(() {
      _isLoading = false;
    });
  }
  @override
  void initState()  {
    // TODO: implement initState
    _fetchProfile();
    super.initState();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _takePictureofCouple() async {
    pickedFile = await ImagePicker().getImage(
      source: ImageSource
          .gallery,
      imageQuality: 60,
    );
    if (pickedFile != null) {
      _imageofUser = File(pickedFile.path);
    } else {
      print('No image selected.');
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: MainAppBar(),
      body: SingleChildScrollView(
        child: Container(
          // alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 12.0),
          child: _isLoading? Center(
            child: CircularProgressIndicator(
            ),
          ) :
          Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Edit Profile',
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
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: pickedFile == null
                            ? AssetImage('assets/images/userimage.png')
                            : FileImage(_imageofUser),
                        radius:60
                        // MediaQuery.of(context).size.width * 0.18,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4.0,
                        ),
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.grey.withOpacity(0.25),
                        radius:
                        MediaQuery.of(context).size.width * 0.075,
                        child: IconButton(
                          icon: Icon(Icons.camera_alt_outlined),
                          onPressed: _takePictureofCouple,
                          iconSize:
                          MediaQuery.of(context).size.width * 0.10,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ],
                  ),
                ),
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
                        Icons.person,
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
                    ListTile(
                      leading: Icon(
                        Icons.date_range_rounded,
                        color: themeColor,
                        size: 28.0,
                      ),
                      title: Text('Birth Date',textAlign: TextAlign.left,
                        textScaleFactor: 1.3,
                        style: TextStyle(
                          color: themeColor,
                        ),),
                      subtitle: userDateOfBirth!=null
                          ? Text(DateFormat('dd / MM / yyyy').format(userDateOfBirth),
                        //textScaleFactor: 1.4,
                        textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,
                      )
                          : Text('None'),
                      trailing:userDateOfBirth==null? IconButton(
                        icon: Icon(Icons.calendar_today_rounded),onPressed: (){},
                      ):SizedBox(),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.mail_rounded,
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
                    Form(
                      key: formkey,
                      child: ListTile(
                        leading: Icon(
                          Icons.text_snippet_rounded,
                          color: themeColor,
                          size: 28.0,
                        ),
                        title: TextFormField(
                          initialValue: userBio,//_userPhone==null ? '': _userPhone,
                          // controller: userPhoneController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          onSaved: (value){
                            userBio = value;
                          },
                          // validator: (value) {
                          //   if (value.length !=10) {
                          //     return 'Enter valid phone number';
                          //   }
                          //   return null;
                          // },
                        ),
                        // subtitle: Text(
                        //   _userPhone!=null?_userPhone:'None',
                        //   //textScaleFactor: 1.4,
                        //   textAlign: TextAlign.start,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24,),
              MaterialButton(
                elevation: 0,
                // minWidth: double.maxFinite,
                onPressed: updateProfile,
                color: Colors.teal,
                child:_loggingOut? CircularProgressIndicator(): Text('Update Profile',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                textColor: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateProfile()async{
    var isValid = formkey.currentState.validate();
    if (!isValid) {
      return;
    }
    formkey.currentState.save();
    // var userBio = userPhoneController.text;
    // if(userPhoneController.text.isEmpty){
    //   userBio = userBio;
    // }
    UserDataModel updateUser = UserDataModel( userBio: userBio, userDateOfBirth: userDateOfBirth,userProfileImage: _imageofUser);
    await Provider.of<UserData>(context,listen: false).updateUser(updateUser);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => UserProfilePage()), (route) => false);
  }

}
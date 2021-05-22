import 'dart:convert';
import 'dart:io';

import 'package:allay/providers/contants.dart';
import 'package:allay/providers/user_data/user_data_model.dart';
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
  String _userPhone = ' ';
  var dateTime;
  var _dateSelected = false;
  var _isLoading = true;
  var _loggedIn = false;
  var _dobPresent = false;
  var _loggingOut = false;
  // var _logOut = false;
  File _imageofUser;
  var pickedFile = null;
  final storage = new FlutterSecureStorage();
  var userPhoneController = TextEditingController();
  UserDataModel currentUser;
  DateTime _userDob = null;

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
      _userPhone = currentUser.userPhone;
      _userDob = currentUser.dateofBirth;
      dateTime = _userDob;
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
                        radius:
                        MediaQuery.of(context).size.width * 0.18,
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
                      decoration: BoxDecoration(
                        // border: Borde
                        // Border.all(
                        //
                        //     color: Colors.black54
                        // )
                      ),
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
                        subtitle: dateTime!=null
                            ? Text(
                          DateFormat('dd / MM / yyyy')
                              .format(dateTime),
                          //textScaleFactor: 1.4,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        )
                            : Text('None'),
                        trailing:_userDob==null? OutlineButton(
                          child: Icon(Icons.date_range_rounded),
                          color: Colors.red.shade50,
                          splashColor: Colors.red.shade50,
                          focusColor: Colors.red,
                          onPressed: () async {
                            dateTime = await PlatformDatePicker.showDate(
                              context: context,
                              firstDate: DateTime(DateTime.now().year - 50),
                              initialDate: DateTime.now(),
                              lastDate: DateTime(DateTime.now().year + 2),
                              builder: (context, child) => Theme(
                                data: ThemeData.light().copyWith(
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
                        ):SizedBox(),
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
                    Form(
                      key: formkey,
                      child: ListTile(
                        leading: Icon(
                          Icons.phone,
                          color: themeColor,
                          size: 28.0,
                        ),
                        title: TextFormField(
                          // initialValue: _userPhone==null ? '': _userPhone,
                          controller: userPhoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value.length !=10) {
                              return 'Enter valid phone number';
                            }
                            return null;
                          },                      ),
                        subtitle: Text(
                          _userPhone!=null?_userPhone:'None',
                          //textScaleFactor: 1.4,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                        ),
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
    var phoneNumber = userPhoneController.text;
    if(userPhoneController.text.isEmpty){
      phoneNumber = _userPhone;
    }
    UserDataModel updateUser = UserDataModel( userPhone: phoneNumber, dateofBirth: dateTime,userProfileImage: _imageofUser);
    await Provider.of<UserData>(context,listen: false).updateUser(updateUser);
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MyHomePage(tabNumber: 4,)));
  }

}
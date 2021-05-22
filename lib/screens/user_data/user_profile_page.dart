import 'dart:convert';

import 'package:allay/providers/contants.dart';
import 'package:allay/providers/user_data/user_data_model.dart';
import 'package:allay/screens/user_data/login_page.dart';
import 'package:allay/widgets/maindrawer.dart';
import 'package:allay/widgets/user_data/user_not_loggedin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'edit_profile_page.dart';

class UserProfilePage extends StatefulWidget {
  static const routename = '/user-profile-page';

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  String _username = ' ';
  String _userEmailId = ' ';
  String _userPhone = ' ';
  String _userProfilePhoto = null;
  int touchedIndex;
  var _isLoading = true;
  var _loggedIn = false;
  var _loggingOut = false;
  var _logOut = false;
  final storage = new FlutterSecureStorage();
  DateTime _userDob = null;
  Future<void> _fetchProfile() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth == null || _auth.currentUser == null) {
      setState(() {
        _loggedIn = false;
      });
    } else {
      setState(() {
        _loggedIn = true;
      });
    }
    if (_loggedIn) {
      setState(() {
        _isLoading = true;
      });
      await Provider.of<UserData>(context, listen: false).fetchUser();
      var currentUser = Provider.of<UserData>(context, listen: false).userData;
      _username = currentUser.userName;
      _userEmailId = currentUser.userEmail;
      _userPhone = currentUser.userPhone;
      _userDob = currentUser.dateofBirth;
      _userProfilePhoto = currentUser.profilePhotoLink != null
          ? currentUser.profilePhotoLink
          : null;
    }
    // _userDob = _userProfile['userDOB'];
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    _fetchProfile();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant UserProfilePage oldWidget) {
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
      drawer: MainDrawer(),
      body: Container(
        // alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _loggedIn
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          'My Profile',
                          style: TextStyle(
                              fontSize: 30.0, fontFamily: 'Libre Baskerville'
                              //color: Colors.white
                              ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                        CircleAvatar(
                          backgroundImage: _userProfilePhoto != null
                              ? NetworkImage(_userProfilePhoto)
                              : AssetImage('assets/images/userimage.png'),
                          //: FileImage(loadedBirthday.imageofPerson),
                          radius: MediaQuery.of(context).size.width * 0.18,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black54)),
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  Icons.person_outline_rounded,
                                  color: themeColor,
                                  size: 28.0,
                                ),
                                title: Text(
                                  'Name',
                                  textAlign: TextAlign.left,
                                  textScaleFactor: 1.3,
                                  style: TextStyle(
                                    color: themeColor,
                                  ),
                                ),
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
                                  title: Text(
                                    'Birth Date',
                                    textAlign: TextAlign.left,
                                    textScaleFactor: 1.3,
                                    style: TextStyle(
                                      color: themeColor,
                                    ),
                                  ),
                                  subtitle: _userDob != null
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
                                title: Text(
                                  'Email',
                                  textAlign: TextAlign.left,
                                  textScaleFactor: 1.3,
                                  style: TextStyle(
                                    color: themeColor,
                                  ),
                                ),
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
                                title: Text(
                                  'Phone',
                                  textAlign: TextAlign.left,
                                  textScaleFactor: 1.3,
                                  style: TextStyle(
                                    color: themeColor,
                                  ),
                                ),
                                subtitle: Text(
                                  _userPhone != null ? _userPhone : 'None',
                                  //textScaleFactor: 1.4,
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        // Text('My Blogs')
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width*0.55,
                          width: MediaQuery.of(context).size.width*0.55,
                          child: PieChart(
                            PieChartData(
                              // pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                              //   setState(() {
                              //     if (pieTouchResponse.touchInput is FlLongPressEnd ||
                              //         pieTouchResponse.touchInput is FlPanEnd) {
                              //       touchedIndex = -1;
                              //     } else {
                              //       touchedIndex = pieTouchResponse.touchedSectionIndex;
                              //     }
                              //   });
                              // }),
                              borderData: FlBorderData(
                                show: false,
                              ),
                              sectionsSpace: 0,
                              centerSpaceRadius: 60,
                              sections: [
                                PieChartSectionData(
                                  value: 30,
                                  radius: 50,
                                  color: getMoodColorFromNumber(1),
                                  // title: 'Happy'
                                ),
                                PieChartSectionData(
                                  value: 20,
                                  radius: 50,
                                  color: getMoodColorFromNumber(2),
                                  // title: 'Excited'
                                ),
                                PieChartSectionData(
                                  value: 15,
                                  radius: 50,
                                  color: getMoodColorFromNumber(3),
                                  // title: 'Angry'
                                ),
                                PieChartSectionData(
                                  value: 20,
                                  radius: 50,
                                  color: getMoodColorFromNumber(4),
                                  // title: 'Sad'
                                ),
                                PieChartSectionData(
                                  value: 10,
                                  radius: 50,
                                  color: getMoodColorFromNumber(5),
                                  // title: 'Depressed'
                                ),
                                PieChartSectionData(
                                    value: 35,
                                    radius: 50,
                                    color: getMoodColorFromNumber(6),
                                    // title: 'Neutral'
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
                            MaterialButton(
                              elevation: 0,
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(UserAccountEditScreen.routename);
                              },
                              color: Colors.teal,
                              child: Text('Edit Profile',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              textColor: Colors.white,
                            ),
                            MaterialButton(
                              elevation: 0,
                              // minWidth: double.maxFinite,
                              // height: 50,
                              onPressed: logoutUser,
                              color: Colors.teal,
                              child: _loggingOut
                                  ? CircularProgressIndicator()
                                  : Text('   Logout   ',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16)),
                              textColor: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : UserNotLoggedIn(),
      ),
    );
  }

  Future<void> logoutUser() async {
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
    if (_logOut) {
      setState(() {
        _loggingOut = true;
      });
      FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.signOut();
      await storage.write(key: "signedIn", value: "false");
      setState(() {
        _loggingOut = false;
      });
      Navigator.of(context)
          .pushNamedAndRemoveUntil(LoginPage.routename, (route) => false);
    }
  }
}

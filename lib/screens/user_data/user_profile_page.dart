import 'package:allay/homepage.dart';
import 'package:allay/providers/constants.dart';
import 'package:allay/providers/user_data/user_data_provider.dart';
import 'package:allay/providers/volunteer/volunteer_application_form.dart';
import 'package:allay/screens/user_data/login_page.dart';
import 'package:allay/screens/volunteer/volunteer_application_rules_screen.dart';
import 'package:allay/screens/volunteer/volunteer_application_screen.dart';
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
  String userBio;
  String _userProfilePhoto = null;
  // int touchedIndex;
  bool _isLoading = true;
  bool _loggedIn = false;
  bool _loggingOut = false;
  bool _logOut = false;
  final storage = new FlutterSecureStorage();
  DateTime userDateOfBirth = null;
  bool applyButton = false;
  int userRole = 5;
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
      userRole = currentUser.userRole;
      _username = currentUser.userName;
      _userEmailId = currentUser.userEmail;
      userBio = currentUser.userBio;
      userDateOfBirth = currentUser.userDateOfBirth;
      _userProfilePhoto = currentUser.profilePhotoLink != null
          ? currentUser.profilePhotoLink
          : null;
      if (currentUser.userRole == 5) {
        applyButton =
            await Provider.of<VolunteerApplicationForm>(context, listen: false)
                .fetchVolunteerForm();
      }
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
        // padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : _loggedIn
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          color: Colors.blueGrey,//const Color(0xFF305496).withOpacity(0.9),
                          // color: Colors.teal.shade300,
                          // height: 300,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                'My Profile',
                                style: TextStyle(
                                  color: Colors.white,
                                    fontSize: 30.0, fontFamily: 'Libre Baskerville'
                                  //color: Colors.white
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: new BorderRadius.all(new Radius.circular(70.0)),
                                  border: new Border.all(
                                    color: Colors.white,
                                    width: 4.0,
                                  ),
                                ),
                                child: CircleAvatar(
                                  // foregroundColor: Colors.blue,
                                  backgroundImage: _userProfilePhoto != null
                                      ? NetworkImage(_userProfilePhoto)
                                      : AssetImage('assets/images/userimage.png'),
                                  //: FileImage(loadedBirthday.imageofPerson),
                                  radius: 65//MediaQuery.of(context).size.width * 0.18,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                _username,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                //textScaleFactor: 1.4,
                                textAlign: TextAlign.center,
                                // overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if(userBio!=null)
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(horizontal: 16.0),
                                child: Text(
                                  userBio,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22.0,
                                  ),

                                  //textScaleFactor: 1.4,
                                  textAlign: TextAlign.center,
                                  // overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Container(
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(8),
                            //     border: Border.all(color: Colors.black54)),
                            child: Column(
                              children: [
                                // ListTile(
                                //   leading: Icon(
                                //     Icons.person,
                                //     color: themeColor,
                                //     size: 28.0,
                                //   ),
                                //   title: Text(
                                //     'Name',
                                //     textAlign: TextAlign.left,
                                //     textScaleFactor: 1.3,
                                //     style: TextStyle(
                                //       color: themeColor,
                                //     ),
                                //   ),
                                //   subtitle: Text(
                                //     _username,
                                //     //textScaleFactor: 1.4,
                                //     textAlign: TextAlign.start,
                                //     overflow: TextOverflow.ellipsis,
                                //   ),
                                // ),
                                SizedBox(
                                  height: 5,
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.date_range_rounded,
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
                                  subtitle: userDateOfBirth != null
                                      ? Text(
                                      DateFormat('dd / MM / yyyy').format(userDateOfBirth),
                                          //textScaleFactor: 1.4,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                        )
                                      : Text('None'),
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.account_circle_rounded,
                                    color: themeColor,
                                    size: 28.0,
                                  ),
                                  title: Text(
                                    'Role',
                                    textAlign: TextAlign.left,
                                    textScaleFactor: 1.3,
                                    style: TextStyle(
                                      color: themeColor,
                                    ),
                                  ),
                                  subtitle: Text(
                                    getRoleText(userRole),
                                    //textScaleFactor: 1.4,
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                ListTile(
                                  leading: Icon(
                                    Icons.email_rounded,
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
                                // ListTile(
                                //   leading: Icon(
                                //     Icons.phone,
                                //     color: themeColor,
                                //     size: 28.0,
                                //   ),
                                //   title: Text(
                                //     'Phone',
                                //     textAlign: TextAlign.left,
                                //     textScaleFactor: 1.3,
                                //     style: TextStyle(
                                //       color: themeColor,
                                //     ),
                                //   ),
                                //   subtitle: Text(
                                //     _userPhone != null ? _userPhone : 'None',
                                //     //textScaleFactor: 1.4,
                                //     textAlign: TextAlign.start,
                                //     overflow: TextOverflow.ellipsis,
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        if (applyButton)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child:
                            MaterialButton(
                              elevation: 3,
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(VolunteerApplicationRulesScreen.routeName);
                                // Navigator.of(context)
                                //     .pushNamed(UserAccountEditScreen.routename);
                              },
                              color: Theme.of(context).primaryColor,
                              child: Text('Apply for Volunteer',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              textColor: Colors.white,
                            ),
                        ),
                        // SizedBox(
                        //   height: 20,
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            MaterialButton(
                              elevation: 3,
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(UserAccountEditScreen.routename);
                              },
                              color: Theme.of(context).primaryColor,
                              child: Text('Edit Profile',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16)),
                              textColor: Colors.white,
                            ),
                            MaterialButton(
                              elevation: 3,
                              // minWidth: double.maxFinite,
                              // height: 50,
                              onPressed: logoutUser,
                              color: Theme.of(context).primaryColor,
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

  Future<void> updateRole() async {
    // bool applyVolunteer = false;
    // await showDialog(
    //   context: context,
    //   builder: (ctx) => AlertDialog(
    //     title: Text('Are you sure?'),
    //     content: Text('Do you want to submit this application form?'),
    //     actions: <Widget>[
    //       TextButton(
    //         child: Text('No'),
    //         onPressed: () {
    //           applyVolunteer = false;
    //           Navigator.of(ctx).pop();
    //         },
    //       ),
    //       TextButton(
    //         child: Text('Yes'),
    //         onPressed: () {
    //           applyVolunteer = true;
    //           Navigator.of(ctx).pop();
    //         },
    //       )
    //     ],
    //   ),
    // );
    // setState(() {
    //   _loggingOut = true;
    // });
    // await Provider.of<UserData>(context, listen: false).updateUserRole(role);
    // await Provider.of<UserData>(context, listen: false).fetchUser();
    // if(role == 5){
    //   Navigator.of(context)
    //       .pushNamedAndRemoveUntil(MyHomePage.routeName, (route) => false);
    // }else{
    // if (applyVolunteer)

    // }
    // setState(() {
    //   _loggingOut = false;
    // });
  }
}

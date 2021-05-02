import 'dart:async';

import 'package:allay/homepage.dart';
import 'package:allay/providers/user_data/user_data_model.dart';
import 'package:allay/screens/user_data/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:platform_date_picker/platform_date_picker.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  static const routename = '/signup-page';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final Color primaryColor = Color(0xff18203d);

  final Color secondaryColor = Color(0xff232c51);

  final Color logoGreen = Color(0xff25bcbb);

  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _signupKey = GlobalKey<FormState>();
  final TextEditingController _displayName = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordVerifyController =
      TextEditingController();
  DateTime dateTime = null;
  bool _dateSelected = false;
  bool _obsecurePassword = true;
  bool _obsecurePasswordVerify = true;
  final storage = new FlutterSecureStorage();

  bool _isSuccess;
  String _userEmail = '';
  String _userPassword = '';
  String _username = '';
  String _userPhoneNumber = '';
  Timer timer;
  var _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _phoneNumberController.dispose();
    _passwordVerifyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   actions: [
        //     IconButton(
        //         color: Colors.white70,
        //         // color: Theme.of(context).primaryColor,
        //         icon: Icon(Icons.cancel_outlined),
        //         onPressed: () async{
        //           await storage.write(key: "signedIn",value: "null");
        //           Navigator.of(context).pushReplacementNamed(MyHomePage.routeName);
        //         }),
        //   ],
        // ),
        // backgroundColor: primaryColor,
        body: Stack(
        children: [
          Container(
            color: Colors.grey,
            child: Image.asset(
              "assets/images/background_sample.jpg",
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            alignment: Alignment.topCenter,
            margin: EdgeInsets.symmetric(horizontal: 30),
            child: SingleChildScrollView(
            child: Form(
              key: _signupKey,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 80,
                  ),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        'ALLAY',
                        style: TextStyle(
                          fontSize: 45,
                          // color: Colors.white
                        ),
                      )),
                  SizedBox(height: 50),
                  Text(
                    'Sign-up to Allay and begin ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                    // style:
                    // GoogleFonts.openSans(color: Colors.white, fontSize: 28),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2)),
                    padding: EdgeInsets.all(4.0),
                    child: TextFormField(
                      controller: _usernameController,
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _username = value;
                      },
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Name',
                          labelStyle: TextStyle(color: Colors.teal),
                          icon: Icon(
                            Icons.person_outline_rounded,
                            color: primaryColor,
                          ),
                          // prefix: Icon(icon),
                          border: InputBorder.none),
                    ),
                  ),
                  // // _buildTextField(
                  // //     nameController, Icons.account_circle, 'Username'),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2)),
                    padding: EdgeInsets.all(4.0),
                    child: TextFormField(
                      controller: _phoneNumberController,
                      validator: (value) {
                        if (value.isEmpty || value.length != 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPhoneNumber = value;
                      },
                      keyboardType: TextInputType.phone,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Phone',
                          labelStyle: TextStyle(color: Colors.teal),
                          icon: Icon(
                            Icons.phone,
                            color: primaryColor,
                          ),
                          // prefix: Icon(icon),
                          border: InputBorder.none),
                    ),
                  ),
                  // _buildTextField(
                  //     nameController, Icons.account_circle, 'Username'),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2)),
                    padding: EdgeInsets.all(4.0),
                    child: TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value.isEmpty || !value.contains('@')) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userEmail = value;
                      },
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.teal),
                          icon: Icon(
                            Icons.account_circle,
                            color: primaryColor,
                          ),
                          // prefix: Icon(icon),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2)),
                    padding: EdgeInsets.all(4.0),
                    child: TextFormField(
                      controller: _passwordController,
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password must be at least 7 characters';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _userPassword = value;
                      },
                      obscureText: _obsecurePassword,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.teal),
                          icon: Icon(
                            Icons.lock,
                            color: primaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.compass_calibration_outlined),
                            onPressed: (){
                              setState(() {
                                _obsecurePassword = !_obsecurePassword;
                              });
                            },
                          ),
                          // prefix: Icon(icon),
                          border: InputBorder.none),
                    ),
                  ),
                  // _buildTextField(passwordController, Icons.lock, 'Password'),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2)),
                    padding: EdgeInsets.all(4.0),
                    child: TextFormField(
                      controller: _passwordVerifyController,
                      validator: (value) {
                        if (value.isEmpty || value.length < 7) {
                          return 'Password must be atleast 7 charachters';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      // onSaved: (value) {
                      //   _userPassword = value;
                      // },
                      obscureText: _obsecurePasswordVerify,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          labelText: 'Verify Password',
                          labelStyle: TextStyle(color: Colors.teal),
                          icon: Icon(
                            Icons.lock,
                            color: primaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.compass_calibration_outlined),
                            onPressed: (){
                              setState(() {
                                _obsecurePasswordVerify = !_obsecurePasswordVerify;
                              });
                            },
                          ),
                          // prefix: Icon(icon),
                          border: InputBorder.none),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double
                        .maxFinite, //MediaQuery.of(context).size.width*0.7,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Theme.of(context).primaryColor, width: 2)),
                    padding: EdgeInsets.all(4.0),
                    child: TextButton(
                      child: Text(
                        _dateSelected
                            ? DateFormat('dd / MM / yyyy').format(dateTime)
                            : 'Select your Date of Birth',
                        style: TextStyle(
                          color: Colors.teal,
                        ),
                      ),
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        dateTime = await PlatformDatePicker.showDate(
                          context: context,
                          firstDate: DateTime(DateTime.now().year - 100),
                          initialDate: DateTime.now(),
                          lastDate: DateTime(DateTime.now().year + 2),
                          builder: (context, child) => Theme(
                            data: ThemeData.light().copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Theme.of(context).primaryColor,
                              ),
                              buttonTheme: ButtonThemeData(
                                  textTheme: ButtonTextTheme.primary),
                              // colorScheme: ColorScheme.light(
                              //     primary: const Color(0xFF8CE7F1)),
                              // buttonTheme: ButtonThemeData(
                              //     textTheme: ButtonTextTheme.primary
                              // ),
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
                  SizedBox(height: 30),
                  Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.teal, width: 2)),
                    child: MaterialButton(
                      elevation: 0,
                      minWidth: double.maxFinite,
                      height: 50,
                      onPressed: _registerAccount,
                      color: Colors.teal,
                      child: _isLoading
                          ? CircularProgressIndicator(
                        backgroundColor: Theme.of(context).primaryColor,
                      )
                          : Text('SignUp',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16)),
                      // textColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  MaterialButton(
                    color: Colors.grey.shade100,
                    child: Text(
                      "  Sign-in Instead  ",
                      style: TextStyle(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16
                      ),
                    ),
                    onPressed: () {
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MyHomePage(tabNumber: 0,)));
                      // Navigator.of(context).pushNamed(SignUp.routename);
                      // Navigator.pushNamed(context, SignUp.routename);
                      Navigator.of(context).pushReplacementNamed(LoginPage.routename);
                    },
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Future<void> _registerAccount() async {
    FocusScope.of(context).unfocus();
    var isValid = _signupKey.currentState.validate();
    if (isValid) {
      _signupKey.currentState.save();
    }
    setState(() {
      _isLoading = true;
    });
    User user;
    try {
      if (isValid){
        user = (await _auth.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        ))
            .user;
      }
    } on FirebaseAuthException catch (signUpError) {
      if(signUpError.code == 'email-already-in-use'){
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Email already registered'),
            content: Text(
                'This email is already registered. Please login with your credentials'),
            actions: <Widget>[
              TextButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                  if (Navigator.canPop(context)) {
                    Navigator.of(ctx).pop();
                  }
                },
              )
            ],
          ),
        );
      }
    }

    if (isValid && user != null) {
      if (!user.emailVerified) {
        await user.sendEmailVerification();
        errorBar();
        bool _userVerified = await user.emailVerified;
        timer = Timer.periodic(Duration(seconds: 3), (timer) async {
          user = _auth.currentUser;
          await user.reload();
          _userVerified = user.emailVerified;
          if (_userVerified) {
            timer.cancel();
            // await storage.write(key: "driveStarted", value: "true");
            await storage.write(key: "signedIn",value: "true");
            FirebaseAuth _auth = FirebaseAuth.instance;
            if(_auth ==null||_auth.currentUser==null){
              return false ;
            }
            try{
              UserDataModel newUser = UserDataModel(userEmail: _userEmail, userPhone: _userPhoneNumber, userName: _username, dateofBirth: dateTime,);
              await Provider.of<UserData>(context,listen: false).addUser(newUser);
            } catch (error) {
              print(error);
              throw error;
            }
            setState(() {
              _isLoading = false;
            });
            // user.uid;
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MyHomePage(tabNumber: 0,)));
          }
        });
      }
    } else {
      _isSuccess = false;
    }
    setState(() {
      _isLoading = false;
    });
  }
  void errorBar()async {
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Verify Email to proceed'),
        content: Text(
            'A verification link has been sent to your email. Please verify it to proceed further.'),
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
  }

  // Future<void> _registerAccount() async {
  //   FocusScope.of(context).unfocus();
  //   var isValid = _signupKey.currentState.validate();
  //   if (isValid) {
  //     _signupKey.currentState.save();
  //   }
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   User user;
  //   try {
  //     if (isValid) {
  //       user = (await _auth.createUserWithEmailAndPassword(
  //         email: _emailController.text,
  //         password: _passwordController.text,
  //       ))
  //           .user;
  //     }
  //   } on FirebaseAuthException catch (signUpError) {
  //     if (signUpError.code == 'email-already-in-use') {
  //       await showDialog(
  //         context: context,
  //         builder: (ctx) => AlertDialog(
  //           title: Text('Email already registered'),
  //           content: Text(
  //               'This email is already registered. Please login with your credentials'),
  //           actions: <Widget>[
  //             TextButton(
  //               child: Text('Okay'),
  //               onPressed: () {
  //                 Navigator.of(ctx).pop();
  //                 if (Navigator.canPop(context)) {
  //                   Navigator.of(ctx).pop();
  //                 }
  //               },
  //             )
  //           ],
  //         ),
  //       );
  //     }
  //   }
  //
  //   if (isValid && user != null) {
  //     if (!user.emailVerified) {
  //       await user.sendEmailVerification();
  //       errorBar();
  //       bool _userVerified = await user.emailVerified;
  //       timer = Timer.periodic(Duration(seconds: 3), (timer) async {
  //         user = _auth.currentUser;
  //         await user.reload();
  //         _userVerified = user.emailVerified;
  //         if (_userVerified) {
  //           timer.cancel();
  //           await storage.write(key: "driveStarted", value: "true");
  //           // await storage.write(key: "emailsignin",value: "true");
  //           FirebaseAuth _auth = FirebaseAuth.instance;
  //           if (_auth == null || _auth.currentUser == null) {
  //             return false;
  //           }
  //           try {
  //             UserDataModel newUser = UserDataModel(userEmail: _userEmail, userPhone: _userPhoneNumber, userName: _username, dateofBirth: dateTime);
  //             await Provider.of<UserData>(context,listen: false).addUser(newUser);
  //           } catch (error) {
  //             throw error;
  //           }
  //           setState(() {
  //             _isLoading = false;
  //           });
  //           // user.uid;
  //           Navigator.of(context).pushReplacement(
  //               MaterialPageRoute(builder: (context) => MyHomePage(tabNumber: 0,)));
  //         }
  //       });
  //     }
  //   } else {
  //     _isSuccess = false;
  //   }
  //   setState(() {
  //     _isLoading = false;
  //   });
  // }
  //
  // void errorBar() async {
  //   await showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: Text('Verify Email to proceed'),
  //       content: Text(
  //           'A verification link has been sent to your email. Please verify it to proceed further.'),
  //       actions: <Widget>[
  //         TextButton(
  //           child: Text('Okay'),
  //           onPressed: () {
  //             Navigator.of(ctx).pop();
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }
}

import 'package:allay/homepage.dart';
import 'package:allay/providers/user_data/user_data_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import 'signup_page.dart';

class LoginPage extends StatefulWidget {
  static const routename = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Color(0xff18203d);

  final Color secondaryColor = Color(0xff232c51);

  final Color logoGreen = Color(0xff25bcbb);

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final _loginkey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();

  String _userEmail = '';
  String _userPassword = '';
  var _isLoading = false;
  var _obsecurePassword = true;
  final FirebaseAuth _firebaseAuthLogin = FirebaseAuth.instance;

  final GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: Colors.transparent,
        //   elevation: 0,
        //   actions: [
        //     IconButton(
        //         color: primaryColor,
        //         // color: Theme.of(context).primaryColor,
        //         icon: Icon(Icons.cancel_outlined), onPressed: ()async{
        //       await storage.write(key: "signedIn",value: "null");
        //       // Navigator.of(context).pushReplacementNamed(HomePage.routeName);
        //     }),
        //   ],
        // ),
        body: Stack(
          children: [
            Container(
              color: Colors.grey,
              child: Image.asset("assets/images/background_sample.jpg",height: MediaQuery.of(context).size.height,fit: BoxFit.cover,),
            ),
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                child: Form(
                  key: _loginkey,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 80,),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child:Text('ALLAY',style: TextStyle(
                          fontSize: 45,
                            // color: Colors.white
                        ),)
                      ),
                      SizedBox(height: 50),
                      Text(
                        'Sign-in to Allay',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          // color: Colors.white,
                          fontSize: 20,
                        ),
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
                        padding: EdgeInsets.all(4.0),//.symmetric(horizontal: 4.0),
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
                              labelText: 'Username',
                              labelStyle: TextStyle(color: Colors.teal),
                              icon: Icon(
                                Icons.account_circle,
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
                          controller: _passwordController,
                          validator: (value) {
                            if (value.isEmpty || value.length < 7) {
                              return 'Password must be atleast 7 charachters';
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
                      SizedBox(height: 30),
                      Container(decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: Colors.teal, width: 2)
                        ),
                        child: MaterialButton(
                          elevation: 0,
                          minWidth: double.maxFinite,
                          height: 50,
                          onPressed: _submitAuthFormLogin,
                          color: Colors.teal,
                          child: _isLoading ? CircularProgressIndicator(
                            backgroundColor: Theme.of(context).primaryColor,
                          ): Text('Login',
                              style: TextStyle(color: Colors.white, fontSize: 16)),
                          textColor: Colors.white,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: Theme.of(context).primaryColor, width: 2)),
                        child: MaterialButton(
                          elevation: 0,
                          minWidth: double.maxFinite,
                          height: 50,
                          onPressed: _signInWithGoogle,
                          color: Theme.of(context).primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(Icons.assignment_ind),
                              SizedBox(width: 10),
                              Text('Sign-in using Google',
                                  style: TextStyle(color: Colors.white, fontSize: 16)),
                            ],
                          ),
                          textColor: Colors.white,
                        ),
                      ),
                      // OutlinedButton(onPressed: (){}),
                      SizedBox(height: 20),
                      MaterialButton(
                        color: Colors.grey.shade100,
                        child: Text(
                          "  New here ? Sign Up  ",
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
                          Navigator.of(context).pushReplacementNamed(SignUp.routename);
                        },
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed:_resetPassword,
                        child: Text(
                          "Forgot Password ? Need help ",
                          style: TextStyle(color: Colors.teal.shade400, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  _signInWithGoogle()async {
    try{
      final GoogleSignInAccount googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential loginCredential = GoogleAuthProvider.credential(idToken: googleAuth.idToken,accessToken: googleAuth.accessToken);
      final authResult = await _firebaseAuthLogin.signInWithCredential(loginCredential);
      final User user = authResult.user;
      if(user!=null){
        if (authResult.additionalUserInfo.isNewUser) {
          UserDataModel newUser = UserDataModel(userEmail: user.email, userPhone: user.phoneNumber, userName: user.displayName, dateofBirth: null,profilePhotoLink: user.photoURL);
          await Provider.of<UserData>(context,listen: false).addUser(newUser);
        }
        await storage.write(key: "signedIn",value: "true");
        // Navigator.of(context).pushReplacementNamed(HomePage.routeName);
      }}catch(error){
      print(error);
    }
  }

  void _submitAuthFormLogin() async {
    FocusScope.of(context).unfocus();
    var isValid = _loginkey.currentState.validate();
    if (isValid) {
      _loginkey.currentState.save();
    }
    setState(() {
      _isLoading = true;
    });
    var message = 'An error occured, please check your credentials';
    UserCredential authResult;
    try {
      if (isValid){
        authResult = await _firebaseAuthLogin.signInWithEmailAndPassword(
            email: _userEmail, password: _userPassword);
        await storage.write(key: "signedIn",value: "true");
        // await storage.write(key: "emailsignin",value: "true");

        // storage.write(key: "driveStarted", value: "false");
        // final prefs = await SharedPreferences.getInstance();
        // if(!prefs.containsKey('userData')){
        //   prefs.setString('userData', _emailController.text);
        // }
        Navigator.of(context).pushReplacementNamed(MyHomePage.routeName);
      }
    } on PlatformException catch (error) {
      if (error.message != null) message = error.message;
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Failed to Sign-in'),
          content: Text(
              message),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
                // if (Navigator.canPop(context)) {
                //   Navigator.of(ctx).pop();
                // }
              },
            )
          ],
        ),
      );
    }on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Failed to Sign-in'),
          content: Text(
              message),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
                // if (Navigator.canPop(context)) {
                //   Navigator.of(ctx).pop();
                // }
              },
            )
          ],
        ),
      );
    }
    catch (err) {
      message = 'An error occured. Please try again';
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Failed to Sign-in'),
          content: Text(
              message),
          actions: <Widget>[
            TextButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
                // if (Navigator.canPop(context)) {
                //   Navigator.of(ctx).pop();
                // }
              },
            )
          ],
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
    // if(!isValid){
    //   print('11');
    //   // Scaffold.of(context).showSnackBar(SnackBar(
    //   //   content: Text('message'),
    //   //   backgroundColor: Theme.of(context).errorColor,
    //   // ));
    // }
  }
  void _resetPassword()async{
    if(_emailController.text.isEmpty||!_emailController.text.contains('@')){
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Enter a valid email'),
          content: Text(
              'Unable to reset password to as email address is not valid.'),
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
    await _firebaseAuthLogin.sendPasswordResetEmail(email: _emailController.text);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Password reset link sent'),
        content: Text(
            'A password reset link has been sent to your email. Please follow the steps to reset your password.'),
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

}
import 'package:allay/providers/user_blog/user_blog_provider.dart';
import 'package:allay/screens/public_blog/public_blog_view_screen.dart';
import 'package:allay/screens/public_blog/show_all_blogs.dart';
import 'package:allay/screens/user_blog/edit_blog_screen.dart';
import 'package:allay/screens/user_blog/user_blog_view_screen.dart';
import 'package:allay/screens/user_data/edit_profile_page.dart';
import 'package:allay/screens/user_data/signup_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:provider/provider.dart';

import 'homepage.dart';
import 'providers/public_blog/public_blogs_provider.dart';
import 'providers/user_data/user_data_model.dart';
import 'screens/user_data/login_page.dart';

var signin = false;

Future<void> main() async{
  final storage = new FlutterSecureStorage();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  signin = await storage.read(key: "signedIn") == "true" ? true : false;

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx)=> PublicBlogs(),),
        ChangeNotifierProvider(create: (ctx)=>UserBlogs()),
        ChangeNotifierProvider(create: (ctx)=>UserData()),
      ],
      child: MaterialApp(
        title: 'Allay',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF2C3E50),
          primarySwatch: Colors.teal,
          accentColor: Colors.teal,
        ),
        routes: {
          UserBlogViewScreen.routeName: (ctx)=> UserBlogViewScreen(),
          PublicBlogViewScreen.routeName: (ctx)=> PublicBlogViewScreen(),
          MyHomePage.routeName: (ctx)=> MyHomePage(tabNumber: 0,),
          SignUp.routename: (ctx)=> SignUp(),
          LoginPage.routename: (ctx)=> LoginPage(),
          UserAccountEditScreen.routename: (ctx)=> UserAccountEditScreen(),
          EditBlogScreen.routeName: (ctx)=> EditBlogScreen(),
          ShowAllBlogs.routeName: (ctx)=> ShowAllBlogs(blogtype: 2,),
          // PublicBlogViewScreen.
        },
        home: signin==true? MyHomePage(tabNumber: 0,) : LoginPage(),//MyHomePage(tabNumber: 0,),
      ),
    );
  }
}


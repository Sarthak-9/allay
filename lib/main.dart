import 'package:allay/models/user_chat/user_chat_model.dart';
import 'package:allay/providers/user_blog/user_blog_provider.dart';
import 'package:allay/screens/public_blog/public_blog_view_screen.dart';
import 'package:allay/screens/public_blog/show_all_blogs.dart';
import 'package:allay/screens/user_blog/edit_blog_screen.dart';
import 'package:allay/screens/user_blog/user_blog_view_screen.dart';
import 'package:allay/screens/user_chat/post_question_screen.dart';
import 'package:allay/screens/user_chat/user_chat_screen.dart';
import 'package:allay/screens/user_data/edit_profile_page.dart';
import 'package:allay/screens/user_data/signup_page.dart';
import 'package:allay/screens/user_data/user_profile_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'homepage.dart';
import 'providers/selector/selector_application_review.dart';
import 'providers/volunteer/volunteer_application_form.dart';
import 'providers/volunteer/volunteer_chat_provider.dart';
import 'providers/public_blog/public_blogs_provider.dart';
import 'providers/user_chat/user_chat_provider.dart';
import 'providers/user_data/user_data_provider.dart';
import 'screens/selector/selector_active_form_screen.dart';
import 'screens/selector/selector_picked_form_screen.dart';
import 'screens/selector/selector_picked_form_view_screen.dart';
import 'screens/volunteer/volunteer_application_screen.dart';
import 'screens/volunteer/volunteer_chat_reply_screen.dart';
import 'screens/volunteer/volunteer_picked_chat_screen.dart';
import 'screens/volunteer/volunteer_replied_chat_screen.dart';
import 'screens/volunteer/volunteer_replied_chat_view_screen.dart';
import 'screens/public_blog/public_blog_author_profile_screen.dart';
import 'screens/user_chat/user_question_reply_screen.dart';
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
        ChangeNotifierProvider(create: (ctx)=>UserChat()),
        ChangeNotifierProvider(create: (ctx)=>VolunteerChat()),
        ChangeNotifierProvider(create: (ctx)=>VolunteerApplicationForm()),
        ChangeNotifierProvider(create: (ctx)=>SelectionApplicationReview()),
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
          UserProfilePage.routename:(ctx)=> UserProfilePage(),
          UserAccountEditScreen.routename: (ctx)=> UserAccountEditScreen(),
          EditBlogScreen.routeName: (ctx)=> EditBlogScreen(),
          ShowAllBlogs.routeName: (ctx)=> ShowAllBlogs(blogtype: 2,),
          PublicBlogAuthorProfileScreen.routeName:(ctx)=>PublicBlogAuthorProfileScreen(),
          PostQuestionScreen.routeName:(ctx)=>PostQuestionScreen(),
          UserChatScreen.routeName:(ctx)=>UserChatScreen(),
          UserQuestionReplyScreen.routeName: (ctx)=>UserQuestionReplyScreen(),
          VolunteerPickedChatScreen.routeName: (ctx)=>VolunteerPickedChatScreen(),
          VolunteerChatReplyScreen.routeName:(ctx)=> VolunteerChatReplyScreen(),
          VolunteerRepliedChatScreen.routeName:(ctx)=> VolunteerRepliedChatScreen(),
          VolunteerRepliedChatViewScreen.routeName:(ctx)=>VolunteerRepliedChatViewScreen(),
          VolunteerQuestionApplicationScreen.routeName:(ctx)=> VolunteerQuestionApplicationScreen(),
          SelectorActiveFormScreen.routeName:(ctx)=>SelectorActiveFormScreen(),
          SelectorPickedFormScreen.routeName:(ctx) => SelectorPickedFormScreen(),
          SelectorPickedFormViewScreen.routeName:(ctx) => SelectorPickedFormViewScreen(),
        },
        home:CheckLogin()//signin==true? MyHomePage(tabNumber: 0,) : LoginPage(),//MyHomePage(tabNumber: 0,),
      ),
    );
  }
}

class CheckLogin extends StatefulWidget {
  const CheckLogin({Key key}) : super(key: key);

  @override
  _CheckLoginState createState() => _CheckLoginState();
}

class _CheckLoginState extends State<CheckLogin> {
  bool isLoading = true;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    // TODO: implement initState
    Future.delayed(Duration.zero).then((value) => fetch());
    // fetch();
    super.initState();
  }
  void fetch() async {
    await Provider.of<UserData>(context, listen: false).fetchUser().then((value) => print('22'));
    // Future.delayed(Duration.zero).then((value) => print(1));
  setState(() {
    isLoading = false;
  });
  }
  @override
  Widget build(BuildContext context) {
    return isLoading ? Container(
      alignment: Alignment.center,
      color: Colors.white,
      child: Image.asset("assets/images/IMG.jpg"),):signin==true? MyHomePage(tabNumber: 0,) : LoginPage();//MyHomePage(tabNumber: 0,);
  }
}



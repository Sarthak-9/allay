import 'package:allay/providers/contants.dart';
import 'package:allay/providers/user_data/user_data_provider.dart';
import 'package:allay/screens/user_blog/add_blog_screen.dart';
import 'package:allay/screens/user_blog/user_blogs_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/public_blog/public_blogs_provider.dart';
import 'screens/controls/volunteer_active_chat_screen.dart';
import 'screens/public_blog/public_blogs_screen.dart';
import 'screens/user_chat/post_question_screen.dart';
import 'screens/user_chat/user_chat_screen.dart';
import 'screens/user_data/user_profile_page.dart';
import 'widgets/maindrawer.dart';

class MyHomePage extends StatefulWidget {
  int tabNumber;
  static const routeName = '/home';

  MyHomePage({this.tabNumber});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedTab = 0,userRole;
  GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    fetch();
    selectedTab = widget.tabNumber;
    super.initState();
  }

  void fetch() async {
    await Provider.of<UserData>(context, listen: false).fetchUser();
    userRole = Provider.of<UserData>(context, listen: false).userData.userRole;
  print(userRole);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          index: selectedTab,
          height: 50.0,
          items: <Widget>[
            Icon(
              Icons.note_rounded,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.list,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.add,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.chat,
              size: 30,
              color: Colors.white,
            ),
            Icon(
              Icons.question_answer_rounded,
              size: 30,
              color: Colors.white,
            ),
          ],
          color: const Color(0xFF2C3E50),
          // buttonBackgroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.teal,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onTap: (index) {
            setState(() {
              selectedTab = index;
            });
          },
          letIndexChange: (index) => true,
        ),
        appBar: MainAppBar(),
        drawer: MainDrawer(),
        body: tabsWidget());
  }

  Widget tabsWidget() {
    switch (selectedTab) {
      case 0:
        return AllBlogsScreen(); //UserAllEventsScreen();

      case 1:
        return UserBlogsScreen();

      case 2:
        return AddBlogScreen();

      case 3:
        return userRole == 5?PostQuestionScreen():UserChatScreen();
      //
      case 4:
        return userRole == 5?UserChatScreen():VolunteerActiveChatScreen();

      default:
        return Container();
    }
  }
}

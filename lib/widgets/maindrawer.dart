import 'package:allay/providers/user_data/user_data_provider.dart';
import 'package:allay/screens/admin/admin_control_screen.dart';
import 'package:allay/screens/selector/selector_active_form_screen.dart';
import 'package:allay/screens/user_data/login_page.dart';
import 'package:allay/screens/user_data/user_profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart' as URL;
import '../homepage.dart';

class MainDrawer extends StatelessWidget {
  final storage = new FlutterSecureStorage();
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    var currentUser = Provider.of<UserData>(context, listen: false).userData;
    return Drawer(
      child: Column(
        children: [
          Container(
            height: statusBarHeight,
            color: Theme.of(context).primaryColor,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    backgroundImage: currentUser.profilePhotoLink != null
                        ? NetworkImage(currentUser.profilePhotoLink)
                        : AssetImage('assets/images/userimage.png'),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey,
                  ),
                  // otherAccountsPictures: [
                  //   if(currentUser.userRole<5)
                    // Icon(
                    //   Icons.how_to_reg,
                    //   size: 30,
                    //   color: Colors.white,
                    // ),
                  // ],
                  // currentAccountPictureSize: 30,
                  accountName: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 150,
                        child: Text(currentUser.userName,style: TextStyle(
                          fontSize: 18
                        ),
                        overflow: TextOverflow.ellipsis ,),
                      ),
                      SizedBox(width: 30,),
                      Icon(
                        Icons.how_to_reg,
                        size: 30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  accountEmail: Text(currentUser.userEmail),
                  onDetailsPressed: () =>
                      Navigator.of(context).pushNamed(UserProfilePage.routename),

                  // decoration: BoxDecoration(
                  //     gradient: LinearGradient(
                  //       colors: [
                  //         Colors.green, Colors.lightGreen
                  //       ],
                  //     )
                  // ),
                ),
                ListTile(
                  leading: Icon(Icons.home_rounded),
                  title: Text("Home"),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                                  tabNumber: 0,
                                )));
                  },
                ),
                // Divider(),
                if(currentUser.userRole==1)
                ListTile(
                    leading: Icon(Icons.apps_rounded),
                    title: Text("Admin Controls"),
                    onTap: () => Navigator.of(context)
                        .pushNamed(AdminControlScreen.routeName)),
                if(currentUser.userRole==2)
                  ListTile(
                  leading: Icon(Icons.apps_rounded),
                  title: Text("Selector Controls"),
                  onTap: () => Navigator.of(context)
                      .pushNamed(SelectorActiveFormScreen.routeName),
                ),
                // Divider(),
                ListTile(
                  leading: Icon(Icons.account_circle_rounded),
                  title: Text("My Account"),
                  onTap: () =>
                      Navigator.of(context).pushNamed(UserProfilePage.routename),
                ),

                ListTile(
                  leading: Icon(Icons.email_rounded),
                  title: Text("Help and Feedback"),
                  onTap: () async {
    String email ="allayconvo@gmail.com";
    String url = 'mailto:$email';
    if (await URL.canLaunch(url)) {
    await URL.launch(url);
    } else {
    throw 'Could not launch $url';
    }}
                ),
                ListTile(
                  leading: Icon(Icons.arrow_forward_ios_rounded),
                  title: Text("Logout"),
                  onTap: () => logoutUser(context),
                ),
                AboutListTile(
                  icon: Icon(Icons.info_outline,),
                  applicationLegalese:
                      'This Application is designed and developed by DTS Tech.This is an app to support mental health and well being but is not associated to a particular individual or situation.',
                  applicationVersion: '0.0.0.1',
                  child: Text('About'),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> logoutUser(BuildContext context) async {
    bool _logOut = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Logging out'),
        content: Text('Are you sure you want to logout?'),
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
      FirebaseAuth _auth = FirebaseAuth.instance;
      await _auth.signOut();
      await storage.write(key: "signedIn", value: "false");
      Navigator.of(context)
          .pushNamedAndRemoveUntil(LoginPage.routename, (route) => false);
    }
  }
}

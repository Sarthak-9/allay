import 'package:allay/models/public_blog/public_blog_model.dart';
import 'package:allay/providers/constants.dart';
import 'package:allay/providers/public_blog/public_blogs_provider.dart';
import 'package:allay/screens/user_data/login_page.dart';
import 'package:allay/widgets/maindrawer.dart';
import 'package:allay/widgets/public_blog/public_blog_grid_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class PublicBlogAuthorProfileScreen extends StatefulWidget {
  static const routeName = '/public-blog-author-profile-screen';
  @override
  _PublicBlogAuthorProfileScreenState createState() =>
      _PublicBlogAuthorProfileScreenState();
}

class _PublicBlogAuthorProfileScreenState
    extends State<PublicBlogAuthorProfileScreen> {
  String publicBlogId = '';
  PublicBlog publicBlog;
  String _username = ' ';
  String _userEmailId = ' ';
  String userBio = ' ';
  String _userProfilePhoto = null;
  var _isLoading = true;
  var _loggedIn = false;
  var _loggingOut = false;
  var _logOut = false;
  final storage = new FlutterSecureStorage();
  DateTime userDateOfBirth = null;
  List<PublicBlog> authorPublicBlog = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    setState(() {
      _isLoading = true;
    });
    publicBlogId = ModalRoute.of(context).settings.arguments as String;
    publicBlog = Provider.of<PublicBlogs>(context, listen: false)
        .findPublicBlogById(publicBlogId);
    // Future.delayed(Duration.zero).then((value)async{
    //   authorPublicBlog = await Provider.of<PublicBlogs>(context, listen: false)
    //       .fetchAuthorBlogs(publicBlog.authorUserId);
    // // });
    _fetchProfile();
    // authorPublicBlog =
    //     Provider.of<PublicBlogs>(context).authorPublicBlogList;

    super.didChangeDependencies();
  }

  Future<void> _fetchProfile() async {
    authorPublicBlog = await Provider.of<PublicBlogs>(context, listen: false)
        .fetchAuthorBlogs(publicBlog.authorUserId);

    var currentUser = publicBlog.authorDetails;
    _username = currentUser.userName;
    _userEmailId = currentUser.userEmail;
    userBio = currentUser.userBio;
    userDateOfBirth = currentUser.userDateOfBirth;
    _userProfilePhoto = currentUser.profilePhotoLink != null
        ? currentUser.profilePhotoLink
        : null;

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void didUpdateWidget(covariant PublicBlogAuthorProfileScreen oldWidget) {
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
            : SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Author\'s Profile',
                      style: TextStyle(
                          fontSize: 30.0, fontFamily: 'Libre Baskerville'
                          //color: Colors.white
                          ),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(
                      height: 20,
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
                    Text(
                      _username,
                      style: TextStyle(fontSize: 22,
                          fontWeight: FontWeight.bold
                      ),
                      //textScaleFactor: 1.4,
                      textAlign: TextAlign.center,
                      // overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      userBio != null ? userBio : '',
                      style: TextStyle(
                        // color: Colors.white,
                        fontSize: 22.0,
                      ),
                      //textScaleFactor: 1.4,
                      textAlign: TextAlign.center,
                      // overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Author\'s Blogs',
                      style: TextStyle(
                        fontSize: 24,
                        // fontWeight: FontWeight.bold,
                        color: Colors.teal
                      ),
                    ),
                    Divider(),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.2,
                      child: authorPublicBlog.isEmpty
                          ? Center(
                              child: Text(
                                'No Blogs',
                                style: TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                            )
                          : GridView.builder(
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2),
                              itemBuilder: (ctx, i) => PublicBlogGridWidget(
                                publicBlogId:
                                authorPublicBlog[i].publicBlogId,
                                publicBlogTitle:
                                authorPublicBlog[i].publicBlogTitle,
                                publicBlogText:
                                authorPublicBlog[i].publicBlogText,
                              ),
                              itemCount: authorPublicBlog.length,
                            ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
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

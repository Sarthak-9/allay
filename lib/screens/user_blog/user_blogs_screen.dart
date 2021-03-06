import 'package:allay/models/user_blog/user_blog_model.dart';
import 'package:allay/providers/public_blog/public_blogs_provider.dart';
import 'package:allay/providers/user_blog/user_blog_provider.dart';
import 'package:allay/screens/public_blog/show_all_blogs.dart';
import 'package:allay/widgets/public_blog/public_blog_grid_widget.dart';
import 'package:allay/widgets/user_blog/user_blog_search.dart';
import 'package:allay/widgets/user_blog/user_blog_widget.dart';
import 'package:allay/widgets/user_blog/user_public_blog_list.dart';
import 'package:allay/widgets/user_blog/user_recent_blog_list.dart';
import 'package:allay/widgets/user_blog/user_saved_blog_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class UserBlogsScreen extends StatefulWidget {
  @override
  _UserBlogsScreenState createState() => _UserBlogsScreenState();
}

class _UserBlogsScreenState extends State<UserBlogsScreen> {
  TextEditingController searchTextController = TextEditingController();
  bool isLoading = false;
  List<UserBlog> sortedMood = [];
  bool isMoodSorted = false;
  bool _isSearching;
  String _searchText = "";
  String _chosenValue;

  // List<dynamic> festivals = [];
  // List<UserBlog> searchResult = [];
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration.zero).then((_) {
      update();
    });
    // TODO: implement initState
    super.initState();
  }
  _UserBlogsScreenState() {
    searchTextController.addListener(() {
      if (searchTextController.text.isEmpty) {
        setState(() {
          _isSearching = false;
          _searchText = "";
        });
      } else {
        setState(() {
          _isSearching = true;
          _searchText = searchTextController.text;
        });
      }
    });
  }

  void sortByMood(String mood) {
    sortedMood = Provider.of<UserBlogs>(context, listen: false).sortByMood(mood);
    setState(() {
      isMoodSorted = true;
    });
  }
  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   // fetch();
  //
  // }
  // @override
  // void didUpdateWidget(covariant UserBlogsScreen oldWidget) {
  //   // TODO: implement didUpdateWidget
  //   setState(() {
  //     isLoading = true;
  //   });
  //   update();
  //   // Future.delayed(Duration.zero).then((_)async   {
  //   //
  //   //   update();
  //   // });
  //
  //   super.didUpdateWidget(oldWidget);
  //
  // }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void update()async{
    await fetch();
  }

  Future<void> fetch() async {


    // await Provider.of<PublicBlogs>(context, listen: false).fetchBlogs();
    await Provider.of<UserBlogs>(context, listen: false).fetchUserBlog();

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var userBlogsList = Provider.of<UserBlogs>(context).userBlogList;
    return Container(
      padding: EdgeInsets.all(8.0),
      height: MediaQuery.of(context).size.height-AppBar().preferredSize.height-kToolbarHeight-NavigationToolbar.kMiddleSpacing-15,
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).primaryColor,
              ),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      'My Blogs',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    ' Recent Blogs',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                    ),
                  ),
                  Divider(),
                  UserRecentBlogList(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' My Saved Blogs',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.teal,
                        ),
                      ),
                      TextButton(
                        onPressed: (){
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ShowAllBlogs(blogtype: 1,)));
                        },
                        child: Text('Show All',style: TextStyle(
                            color: Colors.blue
                        ),),

                      ),
                    ],
                  ),
                  Divider(),
                  UserSavedBlogList(),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        ' My Public Blogs',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.teal,
                        ),
                      ),
                      TextButton(
                          onPressed: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(builder: (context) => ShowAllBlogs(blogtype: 2,)));
                          },
                          child: Text('Show All',style: TextStyle(
                            color: Colors.blue
                          ),),

                      ),
                    ],
                  ),
                  Divider(),
                  //
                  UserPublicBlogList(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    ' All Blogs',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.teal,
                    ),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            showSearch(
                                context: context,
                                delegate: UserBlogSearch(userBlogsList));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search),
                              Text(
                                ' Search Blogs',
                                style: TextStyle(
                                  fontSize: 16.0,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          )),
                      DropdownButton<String>(
                        value: _chosenValue,
                        underline: Container(color: Colors.blue,),
                        style: TextStyle(color: Colors.teal),
                        items: <String>[
                          'Happy',
                          'Excited',
                          'Angry',
                          'Sad',
                          'Depressed',
                          'Neutral',
                          'No Filters'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(color: Colors.black,fontSize: 18.0),
                            ),
                          );
                        }).toList(),
                        hint: Text(
                          "Sort by Category",
                          style: TextStyle(
                              color: Colors.teal,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w600),
                        ),
                        onChanged: (String mood) {
                          // String displayMood='';
                          setState(() {
                            _chosenValue = mood;
                          });
                          if(mood == 'No Filters'){
                            isMoodSorted = false;
                            sortedMood.clear();
                          }else {
                            sortByMood(mood);
                          }
                          setState(() {

                          });
                        },
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  isMoodSorted?
                  sortedMood.isNotEmpty?
                  GridView.builder(
                    physics: ScrollPhysics(),
                    // scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2),
                    itemBuilder: (ctx, i) => UserBlogWidget(
                      userBlogId: sortedMood[i].userBlogId,
                      userBlogTitle: sortedMood[i].userBlogTitle,
                      userBlogText: sortedMood[i].userBlogText,
                    ),
                    itemCount: sortedMood.length,
                  ):SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: Center(
                      child: Text(
                        'No Blogs',
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                    ),
                  ):
                  userBlogsList.isEmpty
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.2,
                          child: Center(
                            child: Text(
                              'No Blogs',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        )
                      :GridView.builder(
                          physics: ScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (ctx, i) => UserBlogWidget(
                            userBlogId: userBlogsList[i].userBlogId,
                            userBlogTitle: userBlogsList[i].userBlogTitle,
                            userBlogText: userBlogsList[i].userBlogText,
                          ),
                          itemCount: userBlogsList.length,
                        ),
                ],
              ),
            ),
    );
  }
}

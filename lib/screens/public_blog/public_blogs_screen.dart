import 'package:allay/models/public_blog/public_blog_model.dart';
import 'package:allay/providers/public_blog/public_blogs_provider.dart';
import 'package:allay/providers/user_data/user_data_model.dart';
import 'package:allay/widgets/public_blog/public_blog_grid_widget.dart';
import 'package:allay/widgets/public_blog/public_blog_search.dart';
import 'package:allay/widgets/public_blog/public_blog_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/blogger/v3.dart';
import 'package:provider/provider.dart';

class AllBlogsScreen extends StatefulWidget {
  @override
  _AllBlogsScreenState createState() => _AllBlogsScreenState();
}

class _AllBlogsScreenState extends State<AllBlogsScreen> {
  bool isLoading = false;
  List<PublicBlog> sortedMood = [];
  bool isMoodSorted = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    fetch();
    _isSearching = false;
    // TODO: implement initState
    super.initState();
  }

  // @override
  // void didChangeDependencies() {
  //   // TODO: implement didChangeDependencies
  //   super.didChangeDependencies();
  //   // fetch();
  // }
  TextEditingController searchTextController = TextEditingController();

  bool _isSearching;
  String _searchText = "";
  String _chosenValue;

  List<PublicBlog> searchResult = [];

  _AllBlogsScreenState() {
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

  void fetch() async {
    await Provider.of<PublicBlogs>(context, listen: false).fetchBlogs();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> refresh(BuildContext context) async {
    await Provider.of<PublicBlogs>(context, listen: false).fetchBlogs();
  }

  void sortByMood(String mood) {
    sortedMood = Provider.of<PublicBlogs>(context, listen: false).sortByMood(mood);
    setState(() {
      isMoodSorted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    var publicBlogsList = Provider.of<PublicBlogs>(context).publicBlogList;
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ),
          )
        : RefreshIndicator(
            onRefresh: () => refresh(context),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Explore Blogs',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          onPressed: () {
                            showSearch(
                                context: context,
                                delegate: BlogSearch(publicBlogsList));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.search),
                              Text(
                                ' Search Blogs',
                                style: TextStyle(
                                  fontSize: 18.0,
                                    fontWeight: FontWeight.w800
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
                              fontSize: 18,
                              fontWeight: FontWeight.w600),
                        ),
                        onChanged: (String mood) {
                          // String displayMood='';
                          setState(() {
                            _chosenValue = mood;
                          });
                          if(mood == 'No Filters'){
                            // displayMood = 'Sort by Category';
                            isMoodSorted = false;
                            sortedMood.clear();
                          }else {
                            // displayMood = mood;
                            sortByMood(mood);
                          }
                        },
                      ),
                    ],
                  ),
                  Divider(),
                  SizedBox(
                    height: 10,
                  ),
                  isMoodSorted?
                  sortedMood!=null && sortedMood.isNotEmpty?
                  ListView.builder(
                    physics: ScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) => PublicBlogWidget(
                      publicBlogId: sortedMood[i].publicBlogId,
                      publicBlogTitle:
                      sortedMood[i].publicBlogTitle,
                      publicBlogMood:
                      sortedMood[i].publicBlogMood,
                      publicBlogDate:
                      sortedMood[i].publicBlogDate,
                      publicBlogText:
                      sortedMood[i].publicBlogText,
                      authorUserName:
                      sortedMood[i].authorUserName,
                      authorProfilePicture:
                      sortedMood[i].authorImageUrl,
                      currentUserLiked: sortedMood[i]
                          .publicBlogCurrentUserLiked,
                    ),
                    itemCount: sortedMood.length,
                  ):Text('No Blogs'):
                  (searchResult.length != 0 ||
                          searchTextController.text.isNotEmpty)
                      ? GridView.builder(
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2),
                          itemBuilder: (ctx, i) => PublicBlogGridWidget(
                            publicBlogId: searchResult[i].publicBlogId,
                            publicBlogTitle: searchResult[i].publicBlogTitle,
                            publicBlogText: searchResult[i].publicBlogText,
                          ),
                          itemCount: searchResult.length,
                        )
                      : publicBlogsList.isNotEmpty
                          ? ListView.builder(
                              physics: ScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemBuilder: (ctx, i) => PublicBlogWidget(
                                publicBlogId: publicBlogsList[i].publicBlogId,
                                publicBlogTitle:
                                    publicBlogsList[i].publicBlogTitle,
                                publicBlogMood:
                                    publicBlogsList[i].publicBlogMood,
                                publicBlogDate:
                                    publicBlogsList[i].publicBlogDate,
                                publicBlogText:
                                    publicBlogsList[i].publicBlogText,
                                authorUserName:
                                    publicBlogsList[i].authorUserName,
                                authorProfilePicture:
                                    publicBlogsList[i].authorImageUrl,
                                currentUserLiked: publicBlogsList[i]
                                    .publicBlogCurrentUserLiked,
                              ),
                              itemCount: publicBlogsList.length,
                            )
                          : Text('No Blogs'),
                  // PublicBlogWidget(),
                ],
              ),
            ),
          );
  }
}

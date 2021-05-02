import 'package:allay/providers/public_blog/public_blogs_provider.dart';
import 'package:allay/widgets/public_blog/public_blog_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AllBlogsScreen extends StatefulWidget {
  @override
  _AllBlogsScreenState createState() => _AllBlogsScreenState();
}

class _AllBlogsScreenState extends State<AllBlogsScreen> {
  bool isLoading = false;
  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration.zero).then((_) {
      fetch();
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // fetch();
  }
  void fetch()async{
    await Provider.of<PublicBlogs>(context,listen: false).fetchBlogs();
    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    var publicBlogsList = Provider.of<PublicBlogs>(context).publicBlogList;
    return isLoading? Center(child: CircularProgressIndicator(
      backgroundColor: Theme.of(context).primaryColor,
    ),):SingleChildScrollView(
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
          SizedBox(
            height: 10,
          ),
          publicBlogsList.isNotEmpty?
          ListView.builder(
            physics: ScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemBuilder: (ctx, i) => PublicBlogWidget(
              publicBlogId: publicBlogsList[i].publicBlogId,
              publicBlogTitle: publicBlogsList[i].publicBlogTitle,
              publicBlogMood: publicBlogsList[i].publicBlogMood,
              publicBlogDate: publicBlogsList[i].publicBlogDate,
              publicBlogText: publicBlogsList[i].publicBlogText,
              authorUserName: publicBlogsList[i].authorUserName,
              authorProfilePicture: publicBlogsList[i].authorImageUrl,
              currentUserLiked:  publicBlogsList[i].publicBlogCurrentUserLiked,
            ),
            itemCount: publicBlogsList.length,
          ): Text('No Blogs'),
          // PublicBlogWidget(),
        ],
      ),
    );
  }
}

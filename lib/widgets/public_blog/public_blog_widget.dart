import 'package:allay/providers/constants.dart';
import 'package:allay/providers/public_blog/public_blogs_provider.dart';
import 'package:allay/screens/public_blog/public_blog_author_profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../screens/public_blog/public_blog_view_screen.dart';

class PublicBlogWidget extends StatefulWidget {

  final String  publicBlogId;
  final String publicBlogTitle;
  final String publicBlogMood;
  final String publicBlogText;
  final DateTime publicBlogDate;
  final String authorProfilePicture;
  final String authorUserName;
  int likes;
  bool currentUserLiked;

  PublicBlogWidget({
      this.publicBlogId,
      this.publicBlogTitle,
      this.publicBlogMood,
      this.publicBlogText,
      this.publicBlogDate,
      this.authorProfilePicture,
      this.authorUserName,
      this.currentUserLiked
  });

  @override
  _PublicBlogWidgetState createState() => _PublicBlogWidgetState();
}

class _PublicBlogWidgetState extends State<PublicBlogWidget> {
  bool likedStatus = false;
  String photoUrl = null;
  @override
  void initState() {
    // TODO: implement initState
    likedStatus = widget.currentUserLiked;
    photoUrl = widget.authorProfilePicture;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.center,
        // decoration: BoxDecoration(
        //     borderRadius: BorderRadius.circular(5),
        //     border: Border.all(
        //         color: Theme.of(context).primaryColor, width: 2)),
        padding: EdgeInsets.all(8.0),
         child: Column(
           children: [
             Text(widget.publicBlogTitle,style: TextStyle(
               fontSize: 22
             ),),
             ListTile(
               onTap: ()=>Navigator.of(context).pushNamed(PublicBlogAuthorProfileScreen.routeName,arguments: widget.publicBlogId),
               leading: CircleAvatar(
                 radius: MediaQuery.of(context).size.width*0.09,
                 backgroundImage:photoUrl!=null?NetworkImage(photoUrl): AssetImage("assets/images/userimage.png"),
               ),
               title: Text(widget.authorUserName),
               subtitle: Text(DateFormat('dd / MM / yyyy').format(widget.publicBlogDate)),
               trailing: Chip(
                 backgroundColor: getMoodColor(widget.publicBlogMood),
                   label : Text(widget.publicBlogMood,style: TextStyle(
                     color: Colors.white
                   ),)),
             ),
             Divider(),
             Container(
               height: MediaQuery.of(context).size.height *0.44,
               child: SingleChildScrollView(
                 child: Text(widget.publicBlogText,style: TextStyle(
                     fontSize: 20
                 ),),
               )
             ),
             Container(
               height: 30,
               child: GridTileBar(
                 // backgroundColor: Theme.of(context).primaryColor.withOpacity(0.5),
                 title: TextButton(
                   onPressed: ()=>Navigator.of(context).pushNamed(PublicBlogViewScreen.routeName,arguments: widget.publicBlogId),
                   child: Text(
                     'See more',
                     style: TextStyle(
                         color: Colors.blue
                     ),
                     textAlign: TextAlign.center,
                   ),
                 ),
               ),
             ),
             Divider(),
             Row(
               mainAxisAlignment: MainAxisAlignment.spaceAround,
               children: [
                 IconButton(icon:likedStatus?Icon(Icons.thumb_up_alt_rounded):Icon(Icons.thumb_up_alt_outlined),
                     onPressed: (){
                       likedStatus = !likedStatus;
                   setState(() {});
                   Provider.of<PublicBlogs>(context,listen: false).likePublicBlog(widget.publicBlogId, likedStatus);
                     }),
                 // IconButton(icon:Icon(Icons.share_rounded),
                 //     onPressed: ()async{
                 //     }),
                 IconButton(icon:Icon(Icons.save),
                     onPressed: ()async{
                   bool saveStatus = await Provider.of<PublicBlogs>(context,listen: false).saveBlog(widget.publicBlogId);
                   if(saveStatus){
                        final snackBar =
                            SnackBar(content: Text('Blog Saved Successfully'));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }else{
                     final snackBar = SnackBar(content: Text('Blog Removed Successfully'));
                     ScaffoldMessenger.of(context).showSnackBar(snackBar);
                   }
                    }),
               ],
             ),
             // SizedBox(
             //   height: 10,
             // ),
             // Divider(
             //   color: Theme.of(context).primaryColor,
             //   thickness: 4,
             // )
           ],
         ),
      ),
    );
  }
}

import 'package:allay/providers/contants.dart';
import 'package:allay/providers/public_blog/public_blogs_provider.dart';
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
                color: Theme.of(context).primaryColor, width: 2)),
        padding: EdgeInsets.all(8.0),
         child: Column(
           children: [
             Text(widget.publicBlogTitle,style: TextStyle(
               fontSize: 22
             ),),
             ListTile(
               leading: CircleAvatar(
                 radius: MediaQuery.of(context).size.width*0.09,
                 backgroundImage: AssetImage("assets/images/userimage.png"),
               ),
               title: Text('authorUserName'),
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
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: [
                 IconButton(icon:widget.currentUserLiked?Icon(Icons.thumb_up_alt_rounded):Icon(Icons.thumb_up_alt_outlined),
                     onPressed: (){
                   widget.currentUserLiked = !widget.currentUserLiked;
                   setState(() {

                   });
                     }),
                 IconButton(icon:Icon(Icons.share_rounded),
                     onPressed: ()async{
                     await  Provider.of<PublicBlogs>(context,listen: false).saveBlog(widget.publicBlogId);
                     }),
                 IconButton(icon:Icon(Icons.save),
                     onPressed: (){}),
               ],
             )
           ],
         ),
      ),
    );
  }
}

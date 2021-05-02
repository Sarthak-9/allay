import 'package:allay/screens/user_blog/user_blog_view_screen.dart';
import 'package:flutter/material.dart';

import '../../screens/public_blog/public_blog_view_screen.dart';

class PublicBlogGridWidget extends StatelessWidget {
  final String publicBlogId;
  final String publicBlogTitle;
  final String publicBlogText;


  PublicBlogGridWidget({this.publicBlogId,this.publicBlogTitle, this.publicBlogText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: ()=>Navigator.of(context).pushNamed(PublicBlogViewScreen.routeName,arguments: publicBlogId),
        child: Container(
          height: MediaQuery.of(context).size.height*0.25,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Theme.of(context).primaryColor, width: 2)),
          // padding: const EdgeInsets.symmetric(horizontal: 6.0,vertical: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: GridTile(
              child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(5),
                  child: Text(publicBlogText)),
              // child: Image(
              //   fit: BoxFit.fill,
              //   width: MediaQuery.of(context).size.width*0.3,
              //   image: NetworkImage(widget._festivalImageUrl[0]),
              // ),
              footer: GridTileBar(
                backgroundColor: Theme.of(context).primaryColor.withOpacity(0.7),
                title: Text(
                  publicBlogTitle,
                  style: TextStyle(
                      color: Colors.white
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

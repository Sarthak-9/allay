import 'package:allay/screens/user_blog/user_blog_view_screen.dart';
import 'package:flutter/material.dart';

class AdminControlWidget extends StatelessWidget {
  final String controlId;
  final String controlTitle;

  AdminControlWidget({this.controlId, this.controlTitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        // onTap: ()=>Navigator.of(context).pushNamed(UserBlogViewScreen.routeName,arguments: userBlogId),
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
                  child: Text(controlTitle)),
              // child: Image(
              //   fit: BoxFit.fill,
              //   width: MediaQuery.of(context).size.width*0.3,
              //   image: NetworkImage(widget._festivalImageUrl[0]),
              // ),

            ),
          ),
        ),
      ),
    );
  }
}

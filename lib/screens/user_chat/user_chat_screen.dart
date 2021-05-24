import 'package:allay/models/user_chat/user_chat_model.dart';
import 'package:allay/providers/contants.dart';
import 'package:allay/providers/user_chat/user_chat_provider.dart';
import 'package:allay/providers/user_data/user_data_provider.dart';
import 'package:allay/screens/user_chat/post_question_screen.dart';
import 'package:allay/screens/user_chat/user_question_reply_screen.dart';
import 'package:allay/widgets/maindrawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserChatScreen extends StatefulWidget {
  const UserChatScreen({Key key}) : super(key: key);
  static const routeName = '/user-chat-screen';

  @override
  _UserChatScreenState createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {
  List<UserChatModel> userChats = [];
  bool isLoading = false;
  int userRole=5;
  @override
  void initState() {
    userRole = Provider.of<UserData>(context, listen: false).userData.userRole;
    setState(() {
      isLoading = true;
    });
    Future.delayed(Duration.zero).then((value) => fetch());
    // TODO: implement initState
    super.initState();
  }

  void fetch()async{
    await Provider.of<UserChat>(context, listen: false).fetchUserChat();
    userChats = Provider.of<UserChat>(context, listen: false).userChats;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return
      userRole!=5?Scaffold(
        // appBar: MainAppBar(),
      // drawer: MainDrawer(),
        floatingActionButton: CircleAvatar(
          radius: 25,
          child: IconButton(
            icon: Icon(Icons.add,color: Colors.white,),
            onPressed: ()=>Navigator.of(context).pushNamed(PostQuestionScreen.routeName),
          ),
        ),
        body: MainBody()
    ):
    MainBody();
  }

  Widget MainBody(){
    return isLoading ? Center(
      child: CircularProgressIndicator(),
    ):SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'My Questions',
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
            Expanded(
              // height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                  itemCount: userChats.length,
                  itemBuilder: (ctx,i)=>ListTile(
                    // leading: Text('Q : ',style: TextStyle(
                    //   fontSize: 20
                    // ),),
                    onTap: ()=>Navigator.of(context).pushNamed(UserQuestionReplyScreen.routeName,arguments:userChats[i].userChatId ),
                    title: Text('Q : '+ userChats[i].questionText),
                    trailing: Chip(label: Text(userChats[i].volunteerAccountId == null?'Posted':userChats[i].questionReply == null ? 'Assigned': 'Replied',style: TextStyle(
                        color: Colors.white
                    ),),backgroundColor: Colors.green,),
                    subtitle: Text(DateFormat('dd / MM / yyyy').format(userChats[i].dateOfQuestion)),

                  )),
            ),
          ],
        ),
      ),
    );
  }
  // String getLabelText(String status){
  //
  // }
}

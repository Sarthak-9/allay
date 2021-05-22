import 'package:allay/models/user_chat/user_chat_model.dart';
import 'package:allay/providers/user_chat/user_chat.dart';
import 'package:allay/screens/user_chat/user_question_reply_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class UserChatViewScreen extends StatefulWidget {
  const UserChatViewScreen({Key key}) : super(key: key);

  @override
  _UserChatViewScreenState createState() => _UserChatViewScreenState();
}

class _UserChatViewScreenState extends State<UserChatViewScreen> {
  List<UserChatModel> userChats = [];
  bool isLoading = false;

  @override
  void initState() {
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

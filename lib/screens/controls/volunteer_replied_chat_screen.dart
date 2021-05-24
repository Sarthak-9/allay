import 'package:allay/models/controls/volunteer_chat_model.dart';
import 'package:allay/models/user_chat/user_chat_model.dart';
import 'package:allay/providers/contants.dart';
import 'package:allay/providers/controls/volunteer_chat_provider.dart';
import 'package:allay/screens/user_chat/user_question_reply_screen.dart';
import 'package:allay/widgets/maindrawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'volunteer_replied_chat_view_screen.dart';

class VolunteerRepliedChatScreen extends StatefulWidget {
  const VolunteerRepliedChatScreen({Key key}) : super(key: key);
  static const routeName = '/volunteer-replied-chat-screen';

  @override
  _VolunteerRepliedChatScreenState createState() => _VolunteerRepliedChatScreenState();
}

class _VolunteerRepliedChatScreenState extends State<VolunteerRepliedChatScreen> {
  List<VolunteerChatModel> pickedChats = [];
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
    // await Provider.of<VolunteerChat>(context, listen: false).fetchActiveChat();
    await Provider.of<VolunteerChat>(context, listen: false).fetchRepliedChat();
    pickedChats = Provider.of<VolunteerChat>(context, listen: false).volunteerRepliedChats;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      drawer: MainDrawer(),
      body: isLoading ? Center(
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
                'Replied Questions',
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
                    itemCount: pickedChats.length,
                    itemBuilder: (ctx,i)=>Container(
                      padding: EdgeInsets.all(4.0),
                      child: Card(
                        elevation: 4,
                        shadowColor: Theme.of(context).primaryColor,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0,vertical: 8.0),
                          child: ListTile(
                            // leading: Text('Q : ',style: TextStyle(
                            //   fontSize: 20
                            // ),),
                            onTap: ()=>Navigator.of(context).pushNamed(VolunteerRepliedChatViewScreen.routeName,arguments:pickedChats[i].userChatId ),
                            title: Text('Q : '+ pickedChats[i].questionText),
                            // trailing: ElevatedButton(child: Text('Pick'),onPressed: (){
                            //   pickQuestion(pickedChats[i]);
                            // },),
                            // trailing: Chip(label: Text(activeChats[i].volunteerAccountId == null?'Posted':activeChats[i].questionReply == null ? 'Assigned': 'Replied',style: TextStyle(
                            //     color: Colors.white
                            // ),),backgroundColor: Colors.green,),
                            subtitle: Text(DateFormat('dd / MM / yyyy').format(pickedChats[i].dateOfQuestion)),
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void pickQuestion(VolunteerChatModel chat)async{
  //   bool pick = false;
  //   await showDialog(
  //     context: context,
  //     builder: (ctx) => AlertDialog(
  //       title: Text('Are you sure'),
  //       content: Text('Do you want to pick this question?'),
  //       actions: <Widget>[
  //         TextButton(
  //           child: Text('No'),
  //           onPressed: (){
  //             pick = false;
  //             Navigator.of(ctx).pop();
  //           },
  //         ),
  //         TextButton(
  //           child: Text('Yes'),
  //           onPressed: () {
  //             pick = true;
  //             Navigator.of(ctx).pop();
  //           },
  //         )
  //       ],
  //     ),
  //   );
  //   if(pick){
  //     await Provider.of<VolunteerChat>(context, listen: false).pickUserChat(chat);
  //   }
  // }
// String getLabelText(String status){
//
// }
}

import 'package:allay/models/volunteer/volunteer_chat_model.dart';
import 'package:allay/models/user_chat/user_chat_model.dart';
import 'package:allay/providers/volunteer/volunteer_chat_provider.dart';
import 'package:allay/screens/volunteer/volunteer_picked_chat_screen.dart';
import 'package:allay/screens/volunteer/volunteer_replied_chat_screen.dart';
import 'package:allay/screens/user_chat/user_question_reply_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'volunteer_chat_reply_screen.dart';

class VolunteerActiveChatScreen extends StatefulWidget {
  const VolunteerActiveChatScreen({Key key}) : super(key: key);

  @override
  _VolunteerActiveChatScreenState createState() =>
      _VolunteerActiveChatScreenState();
}

class _VolunteerActiveChatScreenState extends State<VolunteerActiveChatScreen> {
  List<VolunteerChatModel> activeChats = [];
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

  void fetch() async {
    await Provider.of<VolunteerChat>(context, listen: false).fetchActiveChat();
    activeChats =
        Provider.of<VolunteerChat>(context, listen: false).volunteerActiveChats;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Container(

      child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height-AppBar().preferredSize.height-kToolbarHeight-NavigationToolbar.kMiddleSpacing-15,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Active Questions',
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
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(VolunteerPickedChatScreen.routeName),
                          child: Text(
                            'Picked Questions',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context)
                              .pushNamed(VolunteerRepliedChatScreen.routeName),
                          child: Text(
                            'Replied Questions',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 18,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: activeChats.length,
                          itemBuilder: (ctx, i) => Container(
                                padding: EdgeInsets.all(4.0),
                                child: Card(
                                  elevation: 4,
                                  shadowColor: Theme.of(context).primaryColor,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Column(
                                      children: [
                                        ListTile(
                                            leading: Icon(
                                              Icons.category,
                                              color: Colors.teal,
                                              size: 28.0,
                                            ),
                                            title: Text(
                                              'Tags',
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 20),
                                            ),
                                            subtitle: (activeChats[i]
                                                            .questionTags ==
                                                        null ||
                                                    activeChats[i]
                                                        .questionTags
                                                        .isEmpty)
                                                ? Container(
                                                    child: Text('None'),
                                                  )
                                                : Container(
                                                    height: 50,
                                                    width: MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.70,
                                                    child: ListView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemBuilder: (ctx, j) {
                                                        return Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      2.0),
                                                          child: Chip(
                                                            label: Text(
                                                              activeChats[i]
                                                                  .questionTags[j],
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                            backgroundColor:
                                                                Theme.of(context)
                                                                    .accentColor,
                                                          ),
                                                        );
                                                      },
                                                      itemCount: activeChats[i]
                                                          .questionTags
                                                          .length,
                                                      shrinkWrap: true,
                                                      physics:
                                                          ClampingScrollPhysics(),
                                                      //padding: const EdgeInsets.all(10),
                                                    ))),
                                        Divider(),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 4.0, vertical: 8.0),
                                          child: ListTile(
                                            // leading: Text('Q : ',style: TextStyle(
                                            //   fontSize: 20
                                            // ),),
                                            // // onTap: ()=>Navigator.of(context).pushNamed(UserQuestionReplyScreen.routeName,arguments:activeChats[i].userChatId ),

                                            title: Text('Q : ' +
                                                activeChats[i].questionText,style: TextStyle(
                                                fontSize: 18
                                            ),),
                                            trailing: ElevatedButton(
                                              child: Text('Pick'),
                                              onPressed: () {
                                                pickQuestion(i,activeChats[i]);
                                              },
                                            ),
                                            // trailing: Chip(label: Text(activeChats[i].volunteerAccountId == null?'Posted':activeChats[i].questionReply == null ? 'Assigned': 'Replied',style: TextStyle(
                                            //     color: Colors.white
                                            // ),),backgroundColor: Colors.green,),
                                            // subtitle: Text(
                                            //     DateFormat('dd / MM / yyyy')
                                            //         .format(activeChats[i]
                                            //             .dateOfQuestion)),
                                          ),
                                        ),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                                DateFormat('dd / MM / yyyy')
                                                    .format(activeChats[i]
                                                    .dateOfQuestion)),
                                            Text(activeChats[i].chatPreferredLanguage)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                    ),
                    // SizedBox(height: 50,),
                  ],
                ),
              ),
            ),
        );
  }

  void pickQuestion(int index,VolunteerChatModel chat) async {
    bool pick = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you have a solution to this question?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              pick = false;
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              pick = true;
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
    if (pick) {
      await Provider.of<VolunteerChat>(context, listen: false)
          .pickUserChat(index,chat);
    }
    setState(() {

    });
  }
// String getLabelText(String status){
//
// }
}

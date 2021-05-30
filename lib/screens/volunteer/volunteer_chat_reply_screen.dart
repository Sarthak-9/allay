import 'package:allay/models/volunteer/volunteer_chat_model.dart';
import 'package:allay/providers/contants.dart';
import 'package:allay/providers/volunteer/volunteer_chat_provider.dart';
import 'package:allay/widgets/maindrawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../homepage.dart';

class VolunteerChatReplyScreen extends StatefulWidget {
  static const routeName = '/volunteer-chat-reply-screen';

  @override
  _VolunteerChatReplyScreenState createState() =>
      _VolunteerChatReplyScreenState();
}

class _VolunteerChatReplyScreenState extends State<VolunteerChatReplyScreen> {
  // List<UserChatModel> userChats = [];
  final replyQuestionController = TextEditingController();
  String userChatId;
  int chatIndex;
  double rating;
  VolunteerChatModel userChat;
  bool isLoading = false;

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    // Future.delayed(Duration.zero).then((value) => fetch());
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    userChatId = ModalRoute.of(context).settings.arguments as String;
    chatIndex = Provider.of<VolunteerChat>(context, listen: false)
        .findPickedChatIndexById(userChatId);
    final userChatList =
        Provider.of<VolunteerChat>(context, listen: false).volunteerPickedChats;
    userChat = userChatList[chatIndex];
    super.didChangeDependencies();
  }

  void fetch() async {
    // await Provider.of<UserChat>(context, listen: false).fetchUserChat();
    // userChats = Provider.of<UserChat>(context, listen: false).userChats;
  }
  @override
  Widget build(BuildContext context) {
    Color borderColor = Theme.of(context).primaryColor;
    // double deviceHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: MainAppBar(),
      drawer: MainDrawer(),
      body: Container(
        padding: const EdgeInsets.all(8.0),
        // height: MediaQuery.,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Reply Question',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    userChat.chatPreferredLanguage,
                    style: TextStyle(fontSize: 22),
                  ),
                  Text(
                    DateFormat('dd / MM / yyyy')
                        .format(userChat.dateOfQuestion),
                    style: TextStyle(fontSize: 22),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                // height: MediaQuery.of(context).size.height * 0.4,
                // padding: EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: borderColor, width: 2)),
                child: ListTile(
                  leading: Icon(
                    Icons.category,
                    color: Colors.teal,
                    size: 28.0,
                  ),
                  title: Text(
                    'Tags',
                    textAlign: TextAlign.left,
                    textScaleFactor: 1.3,
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  subtitle: (userChat.questionTags == null ||
                          userChat.questionTags.isEmpty)
                      ? Container(
                          child: Text('None'),
                        )
                      : Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.70,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (ctx, i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                                child: Chip(
                                  label: Text(
                                    userChat.questionTags[i],
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: Theme.of(context).accentColor,
                                ),
                              );
                            },
                            itemCount: userChat.questionTags.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            //padding: const EdgeInsets.all(10),
                          ),
                        ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              Card(
                elevation: 6,
                shadowColor: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // shape: Border.all( width: 2,),
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(5),
                //   // border: Border.all( width: 2)
                // ),
                child: Container(
                    alignment: Alignment.topCenter,
                    height: MediaQuery.of(context).size.height * 0.2,
                    padding: EdgeInsets.all(5.0),
                    // decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(5),
                    // border: Border.all( width: 2)
                    // ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'Question',
                            style: TextStyle(
                                fontSize: 22,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          // Divider(),
                          Text(
                            userChat.questionText,
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Volunteer\'s Analysis',
                style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 10,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                // height: MediaQuery.of(context).size.height *0.6,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: borderColor, width: 2)),
                child: Form(
                  // key: postQuestionKey,
                  child: TextFormField(
                    controller: replyQuestionController,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value.length <= 30) {
                        return 'Question length not enough';
                      }
                      return null;
                    },
                    // onChanged: (value),
                    maxLines:
                        (MediaQuery.of(context).size.height * 0.025).toInt(),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        hintText: 'Write here', border: InputBorder.none),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(onPressed: postReply, child: Text('Post Reply')),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void postReply()async{
    userChat.questionReply = replyQuestionController.text;
    await Provider.of<VolunteerChat>(context, listen: false).replyUserChat(userChat);
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => MyHomePage(
              tabNumber: 4,
            )));
  }
  // void rateReply() async {
  //   await Provider.of<UserChat>(context, listen: false)
  //       .updateRating(chatIndex, rating);
  //   setState(() {});
  // }
}

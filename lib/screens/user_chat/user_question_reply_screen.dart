import 'package:allay/models/user_chat/user_chat_model.dart';
import 'package:allay/providers/contants.dart';
import 'package:allay/providers/user_chat/user_chat.dart';
import 'package:allay/widgets/maindrawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserQuestionReplyScreen extends StatefulWidget {
  static const routeName = '/user-question-reply-screen';

  @override
  _UserQuestionReplyScreenState createState() =>
      _UserQuestionReplyScreenState();
}

class _UserQuestionReplyScreenState extends State<UserQuestionReplyScreen> {
  // List<UserChatModel> userChats = [];
  String userChatId;
  UserChatModel userChat;
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
    userChat =
        Provider.of<UserChat>(context, listen: false).findById(userChatId);
    super.didChangeDependencies();
  }

  void fetch() async {
    // await Provider.of<UserChat>(context, listen: false).fetchUserChat();
    // userChats = Provider.of<UserChat>(context, listen: false).userChats;
  }
  @override
  Widget build(BuildContext context) {
    Color borderColor = Theme.of(context).primaryColor;
    double deviceHeight = MediaQuery.of(context).size.height;
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
                'View Reply',
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
              Text(
                'Question',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.2,
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: borderColor, width: 2)),
                  child: SingleChildScrollView(
                    child: Text(
                      userChat.questionText,
                      style: TextStyle(fontSize: 20),
                    ),
                  )),
              SizedBox(
                height: 20,
              ),
              Text(
                'Volunteer\'s Analysis',
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: borderColor, width: 2)),
                  child: SingleChildScrollView(
                      child: Text(
                    userChat.questionReply != null
                        ? userChat.questionReply
                        : 'Analysis in progress',
                    style: TextStyle(fontSize: 20),
                  )))
            ],
          ),
        ),
      ),
    );
  }
}

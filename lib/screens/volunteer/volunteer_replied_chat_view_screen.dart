import 'package:allay/models/volunteer/volunteer_chat_model.dart';
import 'package:allay/models/user_chat/user_chat_model.dart';
import 'package:allay/providers/constants.dart';
import 'package:allay/providers/volunteer/volunteer_chat_provider.dart';
import 'package:allay/widgets/maindrawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rating_bar/rating_bar.dart';

class VolunteerRepliedChatViewScreen extends StatefulWidget {
  static const routeName = '/replied-chat-view-screen';

  @override
  _VolunteerRepliedChatViewScreenState createState() =>
      _VolunteerRepliedChatViewScreenState();
}

class _VolunteerRepliedChatViewScreenState extends State<VolunteerRepliedChatViewScreen> {
  // List<UserChatModel> userChats = [];
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
    chatIndex = Provider.of<VolunteerChat>(context, listen: false).findRepliedChatIndexById(userChatId);
    final userChatList = Provider.of<VolunteerChat>(context, listen: false).volunteerRepliedChats;
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
              Container(
                  alignment: Alignment.topCenter,
                  height: MediaQuery.of(context).size.height * 0.4,
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: borderColor, width: 2)),
                  child: SingleChildScrollView(
                      child: Text(
                        userChat.questionReply != null
                            ? userChat.questionReply
                            : 'Analysis in progress...',
                        style: TextStyle(fontSize: 20),
                      ))),
              SizedBox(
                height: 10,
              ),
              if (userChat.questionReply != null)
                Text(
                  'Answer Ratings',
                  style: TextStyle(
                    fontSize: 22,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              SizedBox(
                height: 10,
              ),

              userChat.chatReplyScore!=null?
                RatingBar.readOnly(
                  initialRating: userChat.chatReplyScore == null
                      ? 0
                      : userChat.chatReplyScore,
                  // onRatingChanged: (setRating) => setState(() => rating = setRating),
                  filledIcon: Icons.star,
                  emptyIcon: Icons.star_border,
                  halfFilledIcon: Icons.star_half,
                  isHalfAllowed: true,
                  filledColor: Colors.green,
                  emptyColor: Colors.redAccent,
                  halfFilledColor: Colors.amberAccent,
                  size: 40,
                ):Text('Rating not received yet'),
              SizedBox(
                height: 10,
              ),
              // if (userChat.questionReply != null &&
              //     userChat.chatReplyScore == null)
              //   ElevatedButton(onPressed: rateReply, child: Text('Confirm Rating')),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void rateReply()async{
  //   await Provider.of<UserChat>(context, listen: false).updateRating(chatIndex, rating);
  //   setState(() {
  //
  //   });
  // }
}

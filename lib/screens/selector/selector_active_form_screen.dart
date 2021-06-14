import 'package:allay/models/volunteer/volunteer_chat_model.dart';
import 'package:allay/models/user_chat/user_chat_model.dart';
import 'package:allay/models/volunteer/volunteer_question_form_model.dart';
import 'package:allay/providers/constants.dart';
import 'package:allay/providers/selector/selector_application_review.dart';
import 'package:allay/providers/volunteer/volunteer_application_form.dart';
import 'package:allay/providers/volunteer/volunteer_chat_provider.dart';
import 'package:allay/screens/volunteer/volunteer_picked_chat_screen.dart';
import 'package:allay/screens/volunteer/volunteer_replied_chat_screen.dart';
import 'package:allay/screens/user_chat/user_question_reply_screen.dart';
import 'package:allay/widgets/maindrawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'selector_picked_form_screen.dart';

class SelectorActiveFormScreen extends StatefulWidget {
  const SelectorActiveFormScreen({Key key}) : super(key: key);
  static const routeName = '/selector-active-form-screen';

  @override
  _SelectorActiveFormScreenState createState() =>
      _SelectorActiveFormScreenState();
}

class _SelectorActiveFormScreenState extends State<SelectorActiveFormScreen> {
  List<VolunteerFormModel> activeForms = [];
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
    await Provider.of<SelectionApplicationReview>(context, listen: false)
        .fetchVolunteerActiveForm();
    activeForms =
        Provider.of<SelectionApplicationReview>(context, listen: false)
            .volunteerActiveForms;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      drawer: MainDrawer(),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      kToolbarHeight -
                      NavigationToolbar.kMiddleSpacing -
                      15,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Volunteer Active Forms',
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
                                .pushNamed(SelectorPickedFormScreen.routeName),
                            child: Text(
                              'Picked Forms',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          // TextButton(
                          //   onPressed: () => Navigator.of(context)
                          //       .pushNamed(VolunteerRepliedChatScreen.routeName),
                          //   child: Text(
                          //     'Replied Questions',
                          //     style: TextStyle(
                          //       color: Colors.blue,
                          //       fontSize: 18,
                          //     ),
                          //     textAlign: TextAlign.center,
                          //   ),
                          // ),
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
                            itemCount: activeForms.length,
                            itemBuilder: (ctx, i) => Container(
                                  padding: EdgeInsets.all(4.0),
                                  child: Card(
                                    elevation: 4,
                                    shadowColor: Theme.of(context).primaryColor,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: ListTile(
                                        // leading: Text('Q : ',style: TextStyle(
                                        //   fontSize: 20
                                        // ),),
                                        // // onTap: ()=>Navigator.of(context).pushNamed(UserQuestionReplyScreen.routeName,arguments:activeChats[i].userChatId ),
                                        title: Text(
                                          'Active Form',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        subtitle: Text(
                                          DateFormat('dd / MM / yyyy').format(
                                              activeForms[i].dateOfApplication),
                                          // style: TextStyle(fontSize: 22),
                                        ),
                                        trailing: ElevatedButton(
                                          child: Text('Pick'),
                                          onPressed: () {
                                            pickQuestion(i,activeForms[i].volunteerId);
                                            setState(() {

                                            });
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
                                  ),
                                )),
                      ),
                      // SizedBox(height: 50,),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  void pickQuestion(int index,String volunteerId) async {
    bool pick = false;
    print(volunteerId);
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to pick this form?'),
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
      bool isActive = await Provider.of<SelectionApplicationReview>(context, listen: false).checkPickStatus(volunteerId);
      if(isActive){
        await Provider.of<SelectionApplicationReview>(context, listen: false)
            .pickVolunteerForm(index, volunteerId);
        final snackBar1 = SnackBar(content: Text('Form picked successfully !!'),duration: Duration(seconds: 3),backgroundColor: Colors.teal,);
        ScaffoldMessenger.of(context).showSnackBar(snackBar1);

      }else{
        final snackBar = SnackBar(content: Text('This form has already been picked'),duration: Duration(seconds: 3),);
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }
    }
    setState(() {});
  }
// String getLabelText(String status){
//
// }
}

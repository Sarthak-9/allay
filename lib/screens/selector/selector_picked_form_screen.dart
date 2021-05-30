import 'package:allay/models/volunteer/volunteer_chat_model.dart';
import 'package:allay/models/user_chat/user_chat_model.dart';
import 'package:allay/models/volunteer/volunteer_question_form_model.dart';
import 'package:allay/providers/contants.dart';
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

import 'selector_picked_form_view_screen.dart';

class SelectorPickedFormScreen extends StatefulWidget {
  const SelectorPickedFormScreen({Key key}) : super(key: key);
  static const routeName = '/selector-picked-form-screen';

  @override
  _SelectorPickedFormScreenState createState() =>
      _SelectorPickedFormScreenState();
}

class _SelectorPickedFormScreenState extends State<SelectorPickedFormScreen> {
  List<VolunteerFormModel> pickedForms = [];
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
        .fetchSelectorPickedForm();
    pickedForms =
        Provider.of<SelectionApplicationReview>(context, listen: false)
            .volunteerPickedForms;
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
                  'Volunteer Picked Forms',
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

                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: pickedForms.length,
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
                              onTap: ()=>Navigator.of(context).pushNamed(SelectorPickedFormViewScreen.routeName,arguments: pickedForms[i].volunteerId ),
                              title: Text(
                                'Picked Form',
                                style: TextStyle(fontSize: 18),
                              ),
                              subtitle: Text(
                                DateFormat('dd / MM / yyyy').format(
                                    pickedForms[i].dateOfApplication),
                                // style: TextStyle(fontSize: 22),
                              ),
                              // trailing: ElevatedButton(
                              //   child: Text('Pick'),
                              //   onPressed: () {
                              //     // pickQuestion(i,activeChats[i]);
                              //   },
                              // ),
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

  void pickQuestion(int index, VolunteerChatModel chat) async {
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
          .pickUserChat(index, chat);
    }
    setState(() {});
  }
// String getLabelText(String status){
//
// }
}

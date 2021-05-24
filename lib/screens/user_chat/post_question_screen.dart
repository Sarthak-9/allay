import 'package:allay/models/user_chat/user_chat_model.dart';
import 'package:allay/providers/contants.dart';
import 'package:allay/providers/user_chat/user_chat_provider.dart';
import 'package:allay/providers/user_data/user_data_provider.dart';
import 'package:allay/screens/user_chat/user_chat_screen.dart';
import 'package:allay/widgets/maindrawer.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:provider/provider.dart';

import '../../homepage.dart';

class PostQuestionScreen extends StatefulWidget {
  static const routeName = '/post-question-screen';
  @override
  _PostQuestionScreenState createState() => _PostQuestionScreenState();
}

class _PostQuestionScreenState extends State<PostQuestionScreen> {
  final postQuestionKey = GlobalKey<FormState>();
  final postQuestionController = TextEditingController();
  List<String> _selectedTags = [];
  int userRole;
  String chosenLanguage;
  final _items = tagList
      .map((inter) => MultiSelectItem<String>(inter, inter))
      .toList();

  // userRole = Provider.of<UserData>(context, listen: false).userData.userRole;
@override
  void initState() {
    // TODO: implement initState
  userRole = Provider.of<UserData>(context, listen: false).userData.userRole;
  // Future.delayed(Duration.zero).then((value) =>
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Color borderColor = Theme
        .of(context)
        .primaryColor;
    return userRole ==5?MainBody():Scaffold(
        appBar: MainAppBar(),
        drawer: MainDrawer(),
        body: MainBody()
    );
  }
  Widget MainBody(){
    Color borderColor = Theme
        .of(context)
        .primaryColor;
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Post Question',
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
            Text('Describe your question briefly.', style: TextStyle(
                fontSize: 20
            ),),
            SizedBox(
              height: 20,
            ),
            DropdownButton<String>(
              value: chosenLanguage,
              underline: Container(color: Colors.blue,),
              style: TextStyle(color: Colors.teal),
              items: <String>[
                'English',
                'Hindi',
                'Punjabi',
                'Bengali',
                'Gujrati',
                'Marathi',
                'Tamil',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: TextStyle(color: Colors.black, fontSize: 18.0),
                  ),
                );
              }).toList(),
              hint: Text(
                "Preferred Language",
                style: TextStyle(
                    color: Colors.teal,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600),
              ),
              onChanged: (String language) {
                // String displayMood='';
                setState(() {
                  chosenLanguage = language;
                  // _chosenValue = mood;
                });

                // setState(() {
                //
                // });
              },
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              // height: MediaQuery.of(context).size.height *0.6,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                      color: borderColor, width: 2)),
              child: Form(
                key: postQuestionKey,
                child: TextFormField(
                  controller: postQuestionController,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value.length <= 30) {
                      return 'Question length not enough';
                    }
                    return null;
                  },
                  maxLines:
                  (MediaQuery
                      .of(context)
                      .size
                      .height * 0.025).toInt(),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                      hintText: 'Write here', border: InputBorder.none),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            MultiSelectBottomSheetField(
              searchTextStyle: TextStyle(
                color: Colors.black,
              ),
              listType: MultiSelectListType.CHIP,
              itemsTextStyle: TextStyle(
                color: Colors.black,
              ),
              validator: (values) {
                if (values == null || values.length <= 5)
                  return null;
                return 'Choose max 5 tags only';
              },
              autovalidateMode: AutovalidateMode.always,
              selectedItemsTextStyle: TextStyle(
                color: Colors.white,
              ),
              // searchable: true,
              items: _items,
              title: Text("Tags", style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),),
              selectedColor: Colors.teal,
              decoration: BoxDecoration(
                color: Theme
                    .of(context)
                    .primaryColor
                    .withOpacity(0.1),
                borderRadius: BorderRadius.all(Radius.circular(5)),
                border: Border.all(
                  color: Theme
                      .of(context)
                      .primaryColor,
                  width: 2,
                ),
              ),

              buttonIcon: Icon(
                Icons.category,
                color: Colors.teal,
              ),
              buttonText: Text(
                "Tags",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              onConfirm: (results) {
                _selectedTags = results;
              },
              // maxChildSize: 0.8,
              // initialChildSize: 0.6,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: postQuestion,
              child: Text('   Post This Question   ', style: TextStyle(
                color: Colors.white,
              ),),
              style: ButtonStyle(
                  elevation: MaterialStateProperty.all(3),
                  backgroundColor:
                  MaterialStateProperty.all(Colors.teal)),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  void postQuestion()async{
    var isValid = postQuestionKey.currentState.validate();
    if (!isValid) {
      return;
    }
    bool post = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to post this question?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: (){
              post = false;
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              post = true;
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
    if(post){
      if(chosenLanguage==null||chosenLanguage.isEmpty){
        chosenLanguage = 'English';
      }
      UserChatModel addChat = UserChatModel(questionText: postQuestionController.text,dateOfQuestion: DateTime.now(),chatPreferredLanguage: chosenLanguage,questionTags: _selectedTags);
      await Provider.of<UserChat>(context, listen: false).postUserChat(addChat);
      int userRole = Provider.of<UserData>(context, listen: false).userData.userRole;
      print(userRole);
      if(userRole==5){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                  tabNumber: 4,
                )));
      }else{
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage(
                  tabNumber: 3,
                )));
        // Navigator.of(context).pushReplacementNamed(UserChatScreen.routeName);
      }
    }
  }

}

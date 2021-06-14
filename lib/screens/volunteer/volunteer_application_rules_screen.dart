import 'package:allay/providers/constants.dart';
import 'package:allay/screens/volunteer/volunteer_application_screen.dart';
import 'package:allay/widgets/maindrawer.dart';
import 'package:flutter/material.dart';

class VolunteerApplicationRulesScreen extends StatefulWidget {
  const VolunteerApplicationRulesScreen({Key key}) : super(key: key);
  static const routeName = '/volunteer-application-rules-screen';

  @override
  _VolunteerApplicationRulesScreenState createState() => _VolunteerApplicationRulesScreenState();
}

class _VolunteerApplicationRulesScreenState extends State<VolunteerApplicationRulesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      drawer: MainDrawer(),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
              height: 20,
            ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Volunteer Application Rules',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(),
              SizedBox(
                height: 10,
              ),
              ListTile(
                leading: Text('1'),
                title: Text('Volunteer has to be qualified enough to answer questions using his Emotional Intelligence which must portray his honest ideology and problem solving skills.'),
              ),
              ListTile(
                leading: Text('2'),
                title: Text('Plagiarism at any cost will not be tolerated.'),
              ),
              ListTile(
                leading: Text('3'),
                title: Text('Volunteer must anonymously solve problems of the users by this structure :'),
              ),
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,0,0),
                  child: Icon(Icons.arrow_right_alt),
                ),
                title: Text('Volunteer will get a list of active questions. He can pick the question if he feels that he has proper remedy to the problem after complete analysis.'),
              ),
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,0,0),
                  child: Icon(Icons.arrow_right_alt),
                ),
                title: Text('He has to answer the picked question within 72 hours in the most simple and consoling way possible.'),
              ),
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,0,0),
                  child: Icon(Icons.arrow_right_alt),
                ),
                title: Text('Volunteer has the right to mark a question as irrelevant or out of bound if genuinely he finds it so. '),
              ),
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,0,0),
                  child: Icon(Icons.arrow_right_alt),
                ),
                title: Text('Volunteer will receive a rating for his answer by the user which he should use for further scope of improvement'),
              ),
              ListTile(
                leading: Text('4'),
                title: Text('On getting the confirmation of approval, volunteer must follow the following code of conduct :'),
              ),
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,0,0),
                  child: Icon(Icons.arrow_right_alt),
                ),
                title: Text('Volunteer has to be humble with everyone and deal every case patiently'),
              ),
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,0,0),
                  child: Icon(Icons.arrow_right_alt),
                ),
                title: Text('Volunteer cannot use harsh words and should not be rude at even worst case scenarios.'),
              ),
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,0,0),
                  child: Icon(Icons.arrow_right_alt),
                ),
                title: Text('Volunteer should limit the scope of personal bias or his current situation.'),
              ),
              ListTile(
                leading: Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,0,0),
                  child: Icon(Icons.arrow_right_alt),
                ),
                title: Text('Volunteer should limit the scope of personal bias or his current situation.'),
              ),
              SizedBox(
                height: 20,
              ),

              ElevatedButton(onPressed: updateRole, child: Text('Proceed to Test')),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> updateRole() async {
    bool applyVolunteer = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to proceed to volunteer application test?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              applyVolunteer = false;
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              applyVolunteer = true;
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
    // setState(() {
    //   _loggingOut = true;
    // });
    // await Provider.of<UserData>(context, listen: false).updateUserRole(role);
    // await Provider.of<UserData>(context, listen: false).fetchUser();
    // if(role == 5){
    //   Navigator.of(context)
    //       .pushNamedAndRemoveUntil(MyHomePage.routeName, (route) => false);
    // }else{
    if (applyVolunteer)
      Navigator.of(context)
          .pushNamed(VolunteerQuestionApplicationScreen.routeName);
    // }
    // setState(() {
    //   _loggingOut = false;
    // });
  }
}

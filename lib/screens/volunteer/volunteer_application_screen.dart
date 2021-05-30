import 'package:allay/homepage.dart';
import 'package:allay/providers/contants.dart';
import 'package:allay/providers/volunteer/volunteer_application_form.dart';
import 'package:allay/widgets/maindrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VolunteerQuestionApplicationScreen extends StatefulWidget {
  const VolunteerQuestionApplicationScreen({Key key}) : super(key: key);
  static const routeName = '/volunteer-question-application-screen';

  @override
  _VolunteerQuestionApplicationScreenState createState() =>
      _VolunteerQuestionApplicationScreenState();
}

class _VolunteerQuestionApplicationScreenState
    extends State<VolunteerQuestionApplicationScreen> {
  final volunteerQuestionApplicationKey = GlobalKey<FormState>();
  final question0 = TextEditingController();
  final question1 = TextEditingController();
  final question2 = TextEditingController();
  final question3 = TextEditingController();
  final question4 = TextEditingController();
  final question5 = TextEditingController();
  final question6 = TextEditingController();
  final question7 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final deviceWidth = MediaQuery.of(context).size.width * 0.9;
    return Scaffold(
      appBar: MainAppBar(),
      drawer: MainDrawer(),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: Form(
            key: volunteerQuestionApplicationKey,
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    'Volunteer Application ',
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
                SizedBox(
                    height: 230,
                    width: deviceWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question 1 :',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Image.network(volunteerQuestions[0]),
                        TextFormField(
                          controller: question0,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Enter a valid answer';
                            return null;
                          },
                          decoration: InputDecoration(hintText: 'Answer'),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                    height: 230,
                    width: deviceWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question 2 :',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Image.network(volunteerQuestions[1]),
                        TextFormField(
                          controller: question1,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Enter a valid answer';
                            return null;
                          },
                          decoration: InputDecoration(hintText: 'Answer'),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                    height: 230,
                    width: deviceWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Question 3 :',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Image.network(volunteerQuestions[2]),
                        TextFormField(
                          controller: question2,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Enter a valid answer';
                            return null;
                          },
                          decoration: InputDecoration(hintText: 'Answer'),
                        ),
                      ],
                    )),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 230,
                  width: deviceWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question 4 :',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Image.network(volunteerQuestions[3]),
                      TextFormField(
                        controller: question3,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Enter a valid answer';
                          return null;
                        },
                        decoration: InputDecoration(hintText: 'Answer'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 230,
                  width: deviceWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question 5 :',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Image.network(volunteerQuestions[4]),
                      TextFormField(
                        controller: question4,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty)
                            return 'Enter a valid answer';
                          return null;
                        },
                        decoration: InputDecoration(hintText: 'Answer'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Divider(thickness: 2.0,),
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 300,
                  width: deviceWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question 6 :',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Image.network(volunteerQuestions[5]),
                      SizedBox(
                        height: 100,
                        child: TextFormField(
                          controller: question5,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Enter a valid answer';
                            return null;
                          },
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Answer',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 300,
                  width: deviceWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question 7 :',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Image.network(volunteerQuestions[6]),
                      SizedBox(
                        height: 100,
                        child: TextFormField(
                          controller: question6,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Enter a valid answer';
                            return null;
                          },
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Answer',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: 300,
                  width: deviceWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Question 8 :',
                        style: TextStyle(fontSize: 18),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Image.network(volunteerQuestions[7]),
                      SizedBox(
                        height: 100,
                        child: TextFormField(
                          controller: question7,
                          validator: (value) {
                            if (value == null || value.isEmpty)
                              return 'Enter a valid answer';
                            return null;
                          },
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Answer',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                    onPressed: postAnswers,
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(150,40)
                    ),
                    child: Text('Apply')),
                SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void postAnswers() async {
    bool isValid = volunteerQuestionApplicationKey.currentState.validate();
    if (!isValid) {
      return;
    }
    bool uploadQuestions = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure'),
        content: Text('Do you want to upload this blog publically?'),
        actions: <Widget>[
          TextButton(
            child: Text('No'),
            onPressed: () {
              uploadQuestions = false;
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              uploadQuestions = true;
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
    if (uploadQuestions) {
      List<String> answers = List<String>.filled(10, '0');
      answers[0] = question0.text;
      answers[1] = question1.text;
      answers[2] = question2.text;
      answers[3] = question3.text;
      answers[4] = question4.text;
      answers[5] = question5.text;
      answers[6] = question6.text;
      answers[7] = question7.text;
      await Provider.of<VolunteerApplicationForm>(context, listen: false)
          .applyVolunteer(answers);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(MyHomePage.routeName, (route) => false);
    }
  }
}

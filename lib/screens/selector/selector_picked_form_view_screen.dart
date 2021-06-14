import 'package:allay/homepage.dart';
import 'package:allay/models/volunteer/volunteer_question_form_model.dart';
import 'package:allay/providers/constants.dart';
import 'package:allay/providers/selector/selector_application_review.dart';
import 'package:allay/providers/volunteer/volunteer_application_form.dart';
import 'package:allay/screens/selector/selector_picked_form_screen.dart';
import 'package:allay/widgets/maindrawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectorPickedFormViewScreen extends StatefulWidget {
  const SelectorPickedFormViewScreen({Key key}) : super(key: key);
  static const routeName = '/selector-picked-form-view-screen';

  @override
  _SelectorPickedFormViewScreenState createState() =>
      _SelectorPickedFormViewScreenState();
}

class _SelectorPickedFormViewScreenState
    extends State<SelectorPickedFormViewScreen> {
  final volunteerQuestionApplicationKey = GlobalKey<FormState>();
  final marksController = TextEditingController();

  VolunteerFormModel pickedForm ;
  String volunteerId;
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
    volunteerId = ModalRoute.of(context).settings.arguments as String;
    fetch();
    super.didChangeDependencies();
  }

  void fetch() async {
    pickedForm =
        Provider.of<SelectionApplicationReview>(context, listen: false)
            .findPickedFormById(volunteerId);
    setState(() {
      isLoading = false;
    });
  }

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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Column(
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
                    SizedBox(
                      height: 10,
                    ),
                    Text('Answer : '+pickedForm.volunteerAnswers['answer1'],style: TextStyle(fontSize: 18),),
                  ],
                ),
                Divider(),

                SizedBox(
                  height: 30,
                ),
                Column(
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
                    SizedBox(
                      height: 10,
                    ),
                    Text('Answer : '+pickedForm.volunteerAnswers['answer2'],style: TextStyle(fontSize: 18),),

                  ],
                ),
                Divider(),

                SizedBox(
                  height: 30,
                ),
                Column(
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
                    SizedBox(
                      height: 10,
                    ),
                    Text('Answer : '+pickedForm.volunteerAnswers['answer3'],style: TextStyle(fontSize: 18),),

                  ],
                ),
                Divider(),

                SizedBox(
                  height: 30,
                ),
                Column(
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
                    SizedBox(
                      height: 10,
                    ),
                    Text('Answer : '+pickedForm.volunteerAnswers['answer4'],style: TextStyle(fontSize: 18),),

                  ],
                ),
                Divider(),

                SizedBox(
                  height: 30,
                ),
                Column(
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
                    SizedBox(
                      height: 10,
                    ),
                    Text('Answer : '+pickedForm.volunteerAnswers['answer5'],style: TextStyle(fontSize: 18),),

                  ],
                ),
                Divider(),

                SizedBox(
                  height: 20,
                ),
                Divider(thickness: 2.0,),
                SizedBox(
                  height: 20,
                ),
                Column(
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
                      height: 10,
                    ),
                    SizedBox(
                      height: 100,
                      child: Text('Answer : '+pickedForm.volunteerAnswers['answer6'],style: TextStyle(fontSize: 18),),

                    ),
                  ],
                ),
                Divider(),

                SizedBox(
                  height: 30,
                ),
                Column(
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
                      height: 10,
                    ),
                    SizedBox(
                      height: 100,
                      child: Text('Answer : '+pickedForm.volunteerAnswers['answer7'],style: TextStyle(fontSize: 18),),

                    ),
                  ],
                ),
                Divider(),

                SizedBox(
                  height: 30,
                ),
                Column(
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
                      height: 10,
                    ),
                    SizedBox(
                      height: 100,
                      child: Text('Answer : '+pickedForm.volunteerAnswers['answer8'],style: TextStyle(fontSize: 18),),

                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                TextFormField(
                  controller: marksController,
                  keyboardType: TextInputType.number,
                  validator: (value){
                    if(value.isEmpty){
                      return "Enter valid marks";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Awarded Marks'
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: declineVolunteer,
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(150,40)
                        ),
                        child: Text('Decline')),
                    ElevatedButton(
                        onPressed: approveVolunteer,
                        style: ElevatedButton.styleFrom(
                            minimumSize: Size(150,40)
                        ),
                        child: Text('Approve')),
                  ],
                ),
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

  void approveVolunteer() async {
    bool isValid = volunteerQuestionApplicationKey.currentState.validate();
    if (!isValid) {
      return;
    }
    bool uploadQuestions = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to approve this volunteer?'),
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
      int awardedMarks = int.parse(marksController.text);
      await Provider.of<SelectionApplicationReview>(context, listen: false).approveVolunteer(volunteerId, awardedMarks);
      // await Provider.of<VolunteerApplicationForm>(context, listen: false)
      //     .applyVolunteer(answers);
      Navigator.of(context)
          .pushReplacementNamed(SelectorPickedFormScreen.routeName);
    }
  }
  void declineVolunteer() async {
    bool isValid = volunteerQuestionApplicationKey.currentState.validate();
    if (!isValid) {
      return;
    }
    bool uploadQuestions = false;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Are you sure?'),
        content: Text('Do you want to decline this volunteer?'),
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
      int awardedMarks = int.parse(marksController.text);
      await Provider.of<SelectionApplicationReview>(context, listen: false).declineVolunteer(volunteerId, awardedMarks);
      // await Provider.of<VolunteerApplicationForm>(context, listen: false)
      //     .applyVolunteer(answers);
      Navigator.of(context)
          .pushReplacementNamed(SelectorPickedFormScreen.routeName);
    }
  }
}

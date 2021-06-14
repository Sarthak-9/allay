import 'package:allay/providers/constants.dart';
import 'package:allay/widgets/admin/admin_control_widget.dart';
import 'package:allay/widgets/maindrawer.dart';
import 'package:flutter/material.dart';

class AdminControlScreen extends StatefulWidget {
  const AdminControlScreen({Key key}) : super(key: key);
  static const routeName = '/admin-control-screen';

  @override
  _AdminControlScreenState createState() => _AdminControlScreenState();
}

class _AdminControlScreenState extends State<AdminControlScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      drawer: MainDrawer(),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Admin Controls',
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
              LimitedBox(
                child: GridView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                children: [
                  AdminControlWidget(controlId: '1',controlTitle: 'Reported Blogs',),
                  AdminControlWidget(controlId: '2',controlTitle: 'Reported Chats',),
                  AdminControlWidget(controlId: '3',controlTitle: 'Reported Users',),
                  AdminControlWidget(controlId: '4',controlTitle: 'Reported Volunteers',),
                ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

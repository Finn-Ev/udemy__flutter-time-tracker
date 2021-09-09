import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class HomePage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _confirmSignout(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: 'Sign out?',
        content: 'Do you really want to log out?',
        defaultActionText: 'Logout',
        cancelActionText: 'Cancel');

    //* when the user clicks outside of the dialog or presses the backbutton, the pop method gets 'null' as a parameter instad of a bool
    if (didRequestSignOut == null) return;

    if (didRequestSignOut) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          TextButton(
            child: Text('Logout'),
            onPressed: () => _confirmSignout(context),
            style: TextButton.styleFrom(
                primary: Colors.white, textStyle: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}

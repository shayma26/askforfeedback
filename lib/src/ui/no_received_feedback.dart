import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:askforfeedback/feedback_const.dart';
import '../components/important_title.dart';
import '../components/rounded_button.dart';
import 'send_screen.dart';

class NoReceivedFeedback extends StatelessWidget {
  static String id = 'noreceivedfeedback';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: RoundedButton(
        onPressed: () {
          Navigator.pushNamed(context, SendFeedback.id);
        },
        label: 'Give Feedback',
        labelSize: 17,
        width: 170,
      ),
      body: Column(
        children: <Widget>[
          ImportantTitle(
            biggerTitle: 'Received Feedback',
            bigTitle: 'No Feedback yet',
            verticalPadding: 70,
          ),
          Center(child: Image.asset('images/nofeedback.png')),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../components/custom_text_field.dart';
import '../components/rounded_button.dart';
import 'login.dart';
import '../components/text_link.dart';
import 'package:askforfeedback/feedback_const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _newUser = Firestore.instance;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: ListView(children: <Widget>[
          Hero(
            tag: 'welcome',
            child: Container(
              margin:
                  EdgeInsets.only(top: 60.0, left: 72, right: 72, bottom: 150),
              child: Stack(
                alignment: AlignmentDirectional.topCenter,
                overflow: Overflow.visible,
                children: <Widget>[
                  Text(
                    'Welcome!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Color(0xff4196FD),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 0,
                    height: 150,
                    child: Image.asset(
                      'images/welcome_image.png',
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(23)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                CustomTextField(
                  labelController: _firstNameController,
                  labelName: 'First Name',
                ),
                CustomTextField(
                  labelController: _lastNameController,
                  labelName: 'Last Name',
                ),
                CustomTextField(
                  labelController: _emailController,
                  labelName: 'Email',
                  textType: TextInputType.emailAddress,
                ),
                CustomTextField(
                  labelController: _passwordController,
                  labelName: 'Password',
                  obscure: true,
                ),
                SizedBox(
                  height: 50,
                ),
                RoundedButton(
                  label: 'Sign Up',
                  labelSize: 18.0,
                  width: 222,
                  onPressed: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try {
                      final newUser =
                          await _auth.createUserWithEmailAndPassword(
                              email: _emailController.text,
                              password: _passwordController.text);
                      if (newUser != null) {
                        _newUser.collection('users').add({
                          'first_name': _firstNameController.text,
                          'last_name': _lastNameController.text
                        });
                        Navigator.pushNamed(context, 'noreceivedfeedback');
                      }
                    } catch (e) {
                      print(e);
                    }
                    setState(() {
                      showSpinner = false;
                    });
                  },
                ),
                TextLink(
                  text: 'Have an account? Login ▸',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return LogIn();
                        },
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}

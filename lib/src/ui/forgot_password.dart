import 'package:askforfeedback/src/blocs/forgot_password_bloc.dart';
import 'package:askforfeedback/src/blocs/forgot_password_bloc_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:askforfeedback/src/data/_constants.dart';
import 'package:flutter/widgets.dart';
import 'components/rounded_button.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'forgotpassword';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ForgotPasswordBloc _bloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _bloc = ForgotPasswordBlocProvider.of(context);
  }

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 40.0,
            ),
            Image.asset('images/forgot_password.png'),
            Container(
              padding: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(23.0),
                    topLeft: Radius.circular(23.0)),
              ),
              child: Column(
                children: <Widget>[
                  //ShowAlert(),
                  Row(
                    children: <Widget>[
                      backIcon(),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.15,
                      ),
                      Text(
                        'Forgot Password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text(
                      'Enter the E-mail address associated with your account',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 17.0),
                    ),
                  ),
                  Container(
                    height: 45.0,
                    child: emailField(),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 30.0),
                    child: resetButton(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  IconButton backIcon() {
    return IconButton(
        alignment: Alignment.centerLeft,
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.pop(context);
        });
  }

  Widget emailField() {
    return StreamBuilder(
        stream: _bloc.email,
        builder: (context, snapshot) {
          return TextFormField(
            keyboardType: TextInputType.emailAddress,
            autovalidate: true,
            onChanged: (data) {
              _bloc.changeEmail(data);
            },
            decoration: InputDecoration(
                filled: true,
                hintText: 'mail@example.com',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 7.0, horizontal: 30),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0))),
          );
        });
  }

  Widget resetButton() {
    return StreamBuilder(
        stream: _bloc.progressBarStatus,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData || snapshot.hasError || !snapshot.data) {
            return button();
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  Widget button() {
    return RoundedButton(
        label: 'Reset Password',
        width: MediaQuery.of(context).size.width * 0.55,
        labelWeight: FontWeight.w500,
        elevation: 3.0,
        onPressed: () async {
          _bloc.showProgressBar(true);
          _bloc.reset().then((_) {
            showValidMessage();
          }).catchError((_) {
            showErrorMessage();
          });
          _bloc.showProgressBar(false);
        });
  }

  void showErrorMessage() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.blue,
        content: Text(
          "Please enter a valid E-mail",
          style: TextStyle(fontSize: 17),
        ),
        duration: new Duration(seconds: 2)));
  }

  void showValidMessage() {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        backgroundColor: Colors.blue,
        content: Text(
          "A password reset link has been sent to your email",
          style: TextStyle(fontSize: 17),
        ),
        duration: new Duration(seconds: 2)));
  }
}

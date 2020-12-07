import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:halpla/src/constants/ui.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';
import '../constants/ui.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  bool loggingIn = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  showErrorDialog(BuildContext context, String error) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {},
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Oops"),
      content: Text(error),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future trySignUp() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      if (userCredential.user != null) {
        User user = userCredential.user;
        await Provider.of<AuthProvider>(context, listen: false).smsLogin(user);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else {
        print(e.code);
      }
      showErrorDialog(context, e.code);
    } catch (e) {
      print(e.toString());
      showErrorDialog(context, e.toString());
    }
  }

  Future trySignIn() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text);
      if (userCredential.user != null) {
        User user = userCredential.user;
        await Provider.of<AuthProvider>(context, listen: false).smsLogin(user);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print(e.code);
      }
    }
  }

  Widget renderRoundLoginButton() {
    return RaisedButton(
        onPressed: trySignIn,
        child: Container(
            width: MediaQuery.of(context).size.width * 0.72,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Login",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredokaOne(
                      fontSize: 24, color: Colors.white)),
            )),
        color: lightGreen,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.transparent)));
  }

  Widget renderRoundSignUpButton() {
    return RaisedButton(
        onPressed: trySignUp,
        child: Container(
            width: MediaQuery.of(context).size.width * 0.72,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Sign Up",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.fredokaOne(
                      fontSize: 24, color: Colors.white)),
            )),
        color: lightPink,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
            side: BorderSide(color: Colors.transparent)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightBlue,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            loading
                ? SpinKitFadingCube(
                    color: Color(0xfff53b57),
                    size: 100.0,
                  )
                : Center(
                    child: Column(
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.only(bottom: 25),
                            padding: EdgeInsets.all(25),
                            width: MediaQuery.of(context).size.width * 0.80,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.white,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            child: Column(children: [
                              Text("Welcome",
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.fredokaOne(
                                      fontSize: 28, color: Colors.black)),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new TextField(
                                  controller: emailController,
                                  decoration: new InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                      ),
                                      filled: true,
                                      hintStyle: new TextStyle(
                                          color: Colors.grey[800]),
                                      hintText: "Email",
                                      fillColor: Colors.white70),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: new TextField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: new InputDecoration(
                                      contentPadding:
                                          EdgeInsets.fromLTRB(10, 0, 10, 0),
                                      border: new OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                      ),
                                      filled: true,
                                      hintStyle: new TextStyle(
                                          color: Colors.grey[800]),
                                      hintText: "Password",
                                      fillColor: Colors.white70),
                                ),
                              ),
                            ])),
                        loggingIn
                            ? renderRoundLoginButton()
                            : renderRoundSignUpButton(),
                        SizedBox(height: 25),
                        InkWell(
                          onTap: () {
                            setState(() => loggingIn = !loggingIn);
                          },
                          child: Text(
                              loggingIn
                                  ? "Create New Account"
                                  : "I Have An Account",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.fredokaOne(
                                  fontSize: 14, color: Colors.white)),
                        )
                      ],
                    ),
                  )
          ],
        ));
  }
}

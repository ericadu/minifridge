import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/screens/home.dart';

class SignupPage extends StatefulWidget {
  static const routeName = '/signup';

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void registerToFirebase() {
    firebaseAuth
    .createUserWithEmailAndPassword(
        email: emailController.text, password: passwordController.text)
    .then((result) {
      print(result);
      Navigator.pushReplacementNamed(
        context,
        HomePage.routeName
      );
    }).catchError((err) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Error"),
              content: Text(err.message),
              actions: [
                FlatButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Sign Up with Email'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Enter Email",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Email';
                  }
                  return null;
                },
              )
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Enter Password",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                // The validator receives the text that the user has entered.
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Password';
                  }
                  return null;
                },
              )
            ),
            RaisedButton(
              color: Colors.lightBlue,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  registerToFirebase();
                }
              },
              child: Text('Submit'),
            )
          ])
        )
      )
    );
  }
}
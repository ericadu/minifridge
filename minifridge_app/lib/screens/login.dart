import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minifridge_app/view/user_notifier.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _key = GlobalKey<ScaffoldState>();
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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserNotifier>(context);

    return new Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text('Login with Email'),
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
            user.status == Status.Authenticating 
              ? Center(child: CircularProgressIndicator())
              : RaisedButton(
                  color: Colors.lightBlue,
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      // loginToFirebase();
                      if (!await user.signIn(
                        emailController.text, passwordController.text))
                        _key.currentState.showSnackBar(SnackBar(
                          content: Text("Something is wrong"),
                        ));
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
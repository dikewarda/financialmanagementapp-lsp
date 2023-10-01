import 'package:flutter/material.dart';
import 'package:financialmanagement_app/models/user.dart';
import 'package:financialmanagement_app/helpers/database_helper.dart';
import 'package:financialmanagement_app/screens/register.dart';
import 'package:financialmanagement_app/screens/home.dart';
import 'package:financialmanagement_app/helpers/user_provider.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  void _loginUser() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    User? user = await _databaseHelper.getUserByUsername(username);

    if (user != null && user.password == password) {
      Provider.of<UserProvider>(context, listen: false)
          .setLoggedInUser(username);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Otentikasi gagal'),
            content: Text('username atau password salah.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Login'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/logo/logo.png',
                  width: 200,
                  height: 200,
                ),
                SizedBox(height: 20),
                Text('Financial Management App',
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.center),
                SizedBox(height: 30),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(labelText: 'Username'),
                ),
                SizedBox(height: 16.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: _loginUser,
                  child: Text('Login'),
                ),
                SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text('Belum punya akun? Registrasi disini.'),
                ),
              ],
            ),
          ),
        ));
  }
}

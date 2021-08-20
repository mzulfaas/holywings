import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:holywings/model/user.dart';
import 'package:holywings/shared/shared.dart';
import 'package:http/http.dart';
import 'package:progress_indicator_button/progress_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard-page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  processLogin(String username, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var urlPostLogin =
        baseURL + "api/user/authenticate?username=$username&password=$password";
    Response r = await post(Uri.parse(urlPostLogin));
    print(r.statusCode);
    print(r.body);
    print("Ini url post login: $urlPostLogin");
    var jsonLogin = await post(Uri.parse(urlPostLogin));
    if (jsonLogin.body.toString().isEmpty) {
      print("aduh gagal loawding");
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Error"),
                content: Text("Please check your username and password !!",
                    style: TextStyle(
                      color: Colors.red,
                    )),
                actions: <Widget>[
                  // ignore: deprecated_member_use
                  FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('OK'),
                  )
                ],
              ));
      return false;
    }
    var user = User.fromJson(jsonDecode(jsonLogin.body));
    print("cek ini : ${user.data.accessToken},${user.data.accessTokenExpAt}");
    print(user.data);
    print(user.reason);
    print(jsonLogin.body.toString());
    print(jsonLogin.body.toString().isEmpty);
    var dataLogin = json.decode(jsonLogin.body);
    print("Ini datalogin : $dataLogin");
    print("Ini username: $username");
    print("Ini password $password");
    if (dataLogin['status'] != null) {
      prefs.setString("getAccessToken", user.data.accessToken);
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => DashboardPage()),
          (Route<dynamic> route) => false);
    }
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(left: 24.0, right: 24.0),
            children: [
              Container(
                padding: EdgeInsets.fromLTRB(45, 0, 45, 0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Username!!';
                    }
                    return null;
                  },
                  controller: _usernameController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'Username',
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(45, 0, 45, 0),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter Password!!';
                    }
                    return null;
                  },
                  controller: _passController,
                  textAlign: TextAlign.center,
                  autofocus: false,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: Theme.of(context).primaryColorDark,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    ),
                    hintText: 'Password',
                    filled: true,
                    contentPadding: EdgeInsets.fromLTRB(65.0, 10.0, 20.0, 10.0),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.fromLTRB(100, 0, 100, 0),
                height: 45,
                // ignore: deprecated_member_use
                child: ProgressButton(
                  // animationDuration: Duration(days:8),
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                  strokeWidth: 0,
                  child: Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: (AnimationController controller) {
                    if (controller.isCompleted) {
                      controller.reverse();
                    } else {
                      controller.forward();
                    }
                    if (_formKey.currentState.validate()) {
                      processLogin(
                          _usernameController.text, _passController.text

                      );
                      controller.forward();
                      print("Ini proses login");
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

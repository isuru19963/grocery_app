import 'package:flutter/material.dart';
import 'package:markets/src/Test/test.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

import '../../generated/l10n.dart';
import '../controllers/user_controller.dart';
import '../elements/BlockButtonWidget.dart';
import '../helpers/app_config.dart' as config;
import '../helpers/helper.dart';
import '../repository/user_repository.dart' as userRepo;
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/cupertino.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:convert';
import 'dart:io';
import '../models/user.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:markets/src/repository/user_repository.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);
final facebookLogin = FacebookLogin();
class LoginWidget extends StatefulWidget {
  @override
  _LoginWidgetState createState() => _LoginWidgetState();
}

class _LoginWidgetState extends StateMVC<LoginWidget> {
  UserController _con;

  TextEditingController email_cntrl = new TextEditingController();
  TextEditingController password_cntrl = new TextEditingController();
  _LoginWidgetState() : super(UserController()) {
    _con = controller;
  }
  @override
  void initState() {
    super.initState();
    if (userRepo.currentUser.value.apiToken != null) {
      Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
    }
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {

    });

  }

  void loginFacebook() async {

    final facebookLoginResult = await facebookLogin.logIn(['email']);
    if (facebookLoginResult.status == FacebookLoginStatus.loggedIn) {
      print('awa');
      FacebookAccessToken myToken = facebookLoginResult.accessToken;
      // AuthCredential credential =
      // FacebookAuthProvider.getCredential(accessToken: myToken.token);
      //
      // var user = await FirebaseAuth.instance.signInWithCredential(credential);
    }else{
      print(facebookLoginResult.errorMessage);
    }

    print(facebookLoginResult.accessToken);
    print(facebookLoginResult.accessToken.token);
    print(facebookLoginResult.accessToken.expires);
    print(facebookLoginResult.accessToken.permissions);
    print(facebookLoginResult.accessToken.userId);
    print(facebookLoginResult.accessToken.isValid());

    print(facebookLoginResult.errorMessage);
    print(facebookLoginResult.status);

    final token = facebookLoginResult.accessToken.token;

    /// for profile details also use the below code
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=$token');
    final profile = json.decode(graphResponse.body);
    print(profile['email']);

    final String url =
        '${GlobalConfiguration().getValue('api_base_url')}userValid';
    final client = new http.Client();
    var data = {
      "email": profile['email'],
    };
    final loginResponse = await client.post(
      url,
      headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      body: json.encode(data),
    );
    if (json.decode(loginResponse.body)['data']['code'] == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user',json.encode(json.decode((loginResponse.body))['data']));
      setState(() {
        currentUser.value = User.fromJSON(json.decode(loginResponse.body)['data']);
      });
      var currents=await prefs.getString('current_user');
      print(currentUser.value.apiToken);
      if(currentUser.value.apiToken!=null){
        await Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
      }


    } else if (json.decode(loginResponse.body)['data']['code'] == 404) {
      final String url ='${GlobalConfiguration().getValue('api_base_url')}register';
      final client = new http.Client();
      var data = {
        "email": profile['email'],
        "name": profile['name'],
        "password": 'password',
      };
      final response = await client.post(
        url,
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(data),
      );
      print(json.decode(response.body)['data']);
      if (response.statusCode == 200) {
        if (json.decode(response.body)['data'] != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('current_user',json.encode(json.decode((response.body))['data']));
          setState(() {
            currentUser.value = User.fromJSON(json.decode(response.body)['data']);
          });
          print(currentUser.value.apiToken);
          if(currentUser.value.apiToken!=null){
            await   Navigator.of(context)
                .pushReplacementNamed('/Pages', arguments: 2);
          }

        }
      } else if (response.statusCode == 401) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print(prefs.getString('current_user'));
        // Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
      }

    }
    /*
    from profile you will get the below params
    {
     "name": "Iiro Krankka",
     "first_name": "Iiro",
     "last_name": "Krankka",
     "email": "iiro.krankka\u0040gmail.com",
     "id": "<user id here>"
    }
   */
  }

  void loginGoogle() async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
        'profile'
        // you can add extras if you require
      ],
    );

    _googleSignIn.signIn().then((GoogleSignInAccount acc) async {
      GoogleSignInAuthentication auth = await acc.authentication;
      print(acc.id);
      print(acc.email);
      print(acc.displayName);
      print(acc.photoUrl);

      acc.authentication.then((GoogleSignInAuthentication auth) async {
        final String url =
            '${GlobalConfiguration().getValue('api_base_url')}userValid';
        final client = new http.Client();
        var data = {
          "email": acc.email,
        };
        final loginResponse = await client.post(
          url,
          headers: {HttpHeaders.contentTypeHeader: 'application/json'},
          body: json.encode(data),
        );
        print(json.decode(loginResponse.body));
        if (json.decode(loginResponse.body)['data']['code'] == null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('current_user',json.encode(json.decode((loginResponse.body))['data']));
          setState(() {
            currentUser.value = User.fromJSON(json.decode(loginResponse.body)['data']);
          });
          print(currentUser.value.apiToken);
          if(currentUser.value.apiToken!=null){
            await   Navigator.of(context)
                .pushReplacementNamed('/Pages', arguments: 2);
          }


        } else if (json.decode(loginResponse.body)['data']['code'] == 404) {
          final String url ='${GlobalConfiguration().getValue('api_base_url')}register';
          final client = new http.Client();
          var data = {
            "email": acc.email,
            "name": acc.displayName,
            "password": 'password',
          };
          final response = await client.post(
            url,
            headers: {HttpHeaders.contentTypeHeader: 'application/json'},
            body: json.encode(data),
          );
          print(json.decode(response.body)['data']);
          if (response.statusCode == 200) {
            if (json.decode(response.body)['data'] != null) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('current_user',json.encode(json.decode((response.body))['data']));
              setState(() {
                currentUser.value = User.fromJSON(json.decode(response.body)['data']);
              });
              print(currentUser.value.apiToken);
              if(currentUser.value.apiToken!=null){
                await   Navigator.of(context)
                    .pushReplacementNamed('/Pages', arguments: 2);
              }
            }
          } else if (response.statusCode == 401) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            print(prefs.getString('current_user'));
            Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);
          }

        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper.of(context).onWillPop,
      child: Scaffold(
        key: _con.scaffoldKey,
        resizeToAvoidBottomPadding: false,
        body: Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Positioned(
              top: 0,
              child: Container(
                width: config.App(context).appWidth(100),
                height: config.App(context).appHeight(37),
                decoration: BoxDecoration(color: Theme.of(context).accentColor),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(37) - 120,
              child: Container(
                width: config.App(context).appWidth(84),
                height: config.App(context).appHeight(37),
                child: Text(
                  S.of(context).lets_start_with_login,
                  style: Theme.of(context)
                      .textTheme
                      .headline2
                      .merge(TextStyle(color: Theme.of(context).primaryColor)),
                ),
              ),
            ),
            Positioned(
              top: config.App(context).appHeight(37) - 50,
              child: Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 50,
                        color: Theme.of(context).hintColor.withOpacity(0.2),
                      )
                    ]),
                margin: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                padding:
                    EdgeInsets.only(top: 50, right: 27, left: 27, bottom: 20),
                width: config.App(context).appWidth(88),
//              height: config.App(context).appHeight(55),
                child: Form(
                  key: _con.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TextFormField(
                        controller: email_cntrl,
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (input) => _con.user.email = input,
                        validator: (input) => !input.contains('@')
                            ? S.of(context).should_be_a_valid_email
                            : null,
                        decoration: InputDecoration(
                          labelText: S.of(context).email,
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: 'johndoe@gmail.com',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.alternate_email,
                              color: Theme.of(context).accentColor),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                      SizedBox(height: 30),
                      TextFormField(
                        controller: password_cntrl,
                        keyboardType: TextInputType.text,
                        onSaved: (input) => _con.user.password = input,
                        validator: (input) => input.length < 3
                            ? S.of(context).should_be_more_than_3_characters
                            : null,
                        obscureText: _con.hidePassword,
                        decoration: InputDecoration(
                          labelText: S.of(context).password,
                          labelStyle:
                              TextStyle(color: Theme.of(context).accentColor),
                          contentPadding: EdgeInsets.all(12),
                          hintText: '••••••••••••',
                          hintStyle: TextStyle(
                              color: Theme.of(context)
                                  .focusColor
                                  .withOpacity(0.7)),
                          prefixIcon: Icon(Icons.lock_outline,
                              color: Theme.of(context).accentColor),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _con.hidePassword = !_con.hidePassword;
                              });
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(_con.hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.5))),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .focusColor
                                      .withOpacity(0.2))),
                        ),
                      ),
                      SizedBox(height: 30),
                      BlockButtonWidget(
                        text: Text(
                          S.of(context).login,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          _con.login();
                        },
                      ),
                      SizedBox(height: 15),
                      FlatButton(
                       onPressed: () {
                          Navigator.of(context).pushReplacementNamed('/Pages', arguments: 2);

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => SignInDemo()),
                          // );
                        },
                        shape: StadiumBorder(),
                        textColor: Theme.of(context).hintColor,
                        child: Text(S.of(context).skip),
                        padding:
                            EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                      ),
                      SignInButton(
                        Buttons.GoogleDark,
                        text: "Sign up with Google",
                        onPressed: () async {
                          loginGoogle();
                        },
                      ),
                      SignInButton(
                        Buttons.Facebook,
                        text: "Sign up with Facebook",
                        onPressed: () async {
                          loginFacebook();
                        },
                      ),
//                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              child: Column(
                children: <Widget>[
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushReplacementNamed('/ForgetPassword');
                    },
                    textColor: Theme.of(context).hintColor,
                    child: Text(S.of(context).i_forgot_password),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/SignUp');
                    },
                    textColor: Theme.of(context).hintColor,
                    child: Text(S.of(context).i_dont_have_an_account),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

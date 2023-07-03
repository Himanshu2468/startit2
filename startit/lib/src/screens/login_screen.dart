import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:startit/src/services/facebookSignInApi.dart';
import '../services/googleSignInApi.dart';
import '../../main.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String move = "";

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          left: width * 0.1,
          right: width * 0.1,
          top: height * 0.1,
          bottom: height * 0.1,
        ),
        // width: MediaQuery.of(context).size.width * 0.1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Container(
                height: height * 0.08,
                width: width * 0.6,
                child: Image.asset("assets/images/startitsplash2.PNG"),
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    isEnglish
                        ? "How STARTiT works for you?"
                        : 'STARTiT आपके लिए कैसे काम करता है',
                  ),
                ),
                Icon(
                  Icons.open_in_new_rounded,
                  color: Colors.lightBlue,
                ),
              ],
            ),
            Text(
              isEnglish ? "Welcome to STARTiT" : 'STARTiT में आपका स्वागत है',
              style: TextStyle(
                fontSize: 26,
              ),
            ),
            SizedBox(height: height * 0.05),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed("/user_login");
              },
              child: Text(
                isEnglish
                    ? 'Login with STARTiT'
                    : 'STARTiT बटन के साथ लॉगिन करें',
              ),
            ),
            SizedBox(height: height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                Text(
                  isEnglish ? "Or" : 'या',
                  style: TextStyle(fontSize: 20, color: Colors.black38),
                ),
                SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Divider(
                    // thickness: MediaQuery.of(context).size.width * 0.5,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            SizedBox(height: height * 0.03),
            Text(
              isEnglish ? "Login With" : 'लॉगिन करें',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: Image.asset("assets/images/facebook.png"),
                  onTap: () {
                    signInFB();
                  },
                ),
                GestureDetector(
                  child: Image.asset("assets/images/google.png"),
                  onTap: () {
                    googleSignIn();
                  },
                ),
                // Image.asset("assets/images/linkedIn.png"),
              ],
            ),
            SizedBox(height: height * 0.05),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  isEnglish ? "Create your " : 'अपना ',
                  style: TextStyle(color: Colors.black54),
                ),
                TextButton(
                    style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/signUp');
                    },
                    child: Text(
                      "STARTiT",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                Text(
                  isEnglish ? "Account" : 'खाता बनाएं',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future googleSignIn() async {
    final user = await GoogleSignInApi.login();
    String googleUserFullName = user.displayName;
    String googleUserFirstName = googleUserFullName.split(' ').first;
    String googleUserLastName =
        googleUserFullName.split(googleUserFirstName).last.trim();
    String googleUserEmail = user.email;
    String googleUserUniqueId = user.id;
    print(googleUserFullName);
    print(googleUserFirstName);
    print(googleUserLastName);
    print(googleUserEmail);
    print(googleUserUniqueId);

    GoogleSignInApi.googleLoginUser(
      context,
      move,
      googleUserFirstName,
      googleUserLastName,
      googleUserEmail,
      googleUserUniqueId,
    );
  }

  Future signInFB() async {
    // final result = await FacebookAuth.instance
    //     .login(permissions: ["public_profile", "email"]);

    // final userData = await FacebookAuth.instance.getUserData();
    // print("USERDATA");
    // print(userData);

    final result = await FacebookSignInApi.login();
    print(result.status);
    print(result.errorMessage);
    print(result.accessToken.token);
    final token = result.accessToken.token;
    final graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
    final profile = json.decode(graphResponse.body);
    print(profile);

    String facebookUserFirstName =
        profile["first_name"] != null ? profile["first_name"] : "";
    String facebookUserLastName =
        profile["last_name:"] != null ? profile["last_name:"] : "";
    String facebookUserEmail = profile["email"] != null ? profile["email"] : "";
    String facebookUserUniqueId =
        profile["id"] != null ? profile["id"] : profile["id"];

    FacebookSignInApi.facebookLoginUser(
      context,
      move,
      facebookUserFirstName,
      facebookUserLastName,
      facebookUserEmail,
      facebookUserUniqueId,
    );
  }
}

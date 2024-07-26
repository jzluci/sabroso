// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sabroso/global/common/toast.dart';
import 'package:sabroso/modules/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:sabroso/modules/user_auth/widgets/form_container_widget.dart';
import 'package:sabroso/modules/user_auth/widgets/login_modal.dart';
import 'package:sabroso/utils/AppColor.dart';

class RegisterModal extends StatefulWidget {
  @override
  State<RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends State<RegisterModal> {
  final FirebaseAuthServices _auth = FirebaseAuthServices();
  final _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _userNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 85 / 100,
          padding: EdgeInsets.only(left: 16, right: 16, bottom: 32, top: 16),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            physics: BouncingScrollPhysics(),
            children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: MediaQuery.of(context).size.width * 35 / 100,
                  margin: EdgeInsets.only(bottom: 20),
                  height: 6,
                  decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              // header
              Container(
                margin: EdgeInsets.only(bottom: 24),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'inter'),
                ),
              ),
              FormContainerWidget(
                controller: _userNameController,
                hintText: "Username",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _emailController,
                hintText: "Email",
                isPasswordField: false,
              ),
              SizedBox(
                height: 10,
              ),
              FormContainerWidget(
                controller: _passwordController,
                hintText: "Password",
                isPasswordField: true,
              ),
              SizedBox(
                height: 30,
              ),
              GestureDetector(
                onTap: _signUp,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                      color: AppColor.primarySoft,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    "Create Account",
                    style: TextStyle(
                        color: AppColor.secondary,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'inter'),
                  )),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // google sign in button
              GestureDetector(
                onTap: _signInWithGoogle,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 60,
                  decoration: BoxDecoration(
                      color: AppColor.primarySoft,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(FontAwesomeIcons.google,color: AppColor.secondary,),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Sign in with google",
                            style: TextStyle(
                                color: AppColor.secondary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'inter'),
                          ),
                        ],
                      )),
                ),
              ),
              // Login textbutton
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    isScrollControlled: true,
                    builder: (context) {
                      return LoginModal();
                    },
                  );
                },
                style: TextButton.styleFrom(
                  primary: Colors.white,
                ),
                child: RichText(
                  text: TextSpan(
                    text: 'Have an account? ',
                    style: TextStyle(color: Colors.grey),
                    children: [
                      TextSpan(
                          style: TextStyle(
                            color: AppColor.primary,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'inter',
                          ),
                          text: 'Log in')
                    ],
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _signUp() async {
    String username = _userNameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    if (user != null) {
      showToast(message: "User created.");
      await _firestore.collection('users').doc(user.uid).set({
        'username': username,
        'email': email,
      });
      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
    } else {
      showToast(message: "Some error occured.");
    }
  }

  _signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    final _firestore = FirebaseFirestore.instance;

    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        var result = await _firebaseAuth.signInWithCredential(credential);

        if (result.additionalUserInfo!.isNewUser) {
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
          await _firestore.collection('users').doc(result.user?.uid).set({
            "email": result.user?.email,
            "username": result.user?.email
                ?.substring(0, result.user?.email?.indexOf('@')),
          });
        } else {
          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
        }
      }
    } catch (e) {
      showToast(message: "Some error occurred.");
      print(e);
    }
  }
}

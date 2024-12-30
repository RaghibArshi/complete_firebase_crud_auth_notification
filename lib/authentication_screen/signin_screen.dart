import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/authentication_screen/forgot_password_screen.dart';
import 'package:flutter_firebase_app/authentication_screen/signup_screen.dart';
import 'package:flutter_firebase_app/notification/notification_services.dart';
import 'package:flutter_firebase_app/screens/home_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  NotificationServices notificationServices = NotificationServices();

  userSignIn(String email, String password)async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('SignIn Successfully', style: TextStyle(fontSize: 18.0, color: Colors.white),),
        ),
      );
      Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orange,
            content: Text('No user found with this email !', style: TextStyle(fontSize: 18.0, color: Colors.white),),
          ),
        );
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('Password you entered is wrong', style: TextStyle(fontSize: 18.0, color: Colors.white),),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractWhenAppNotOpen(context);
    notificationServices.getDeviceToken().then((value){
      print('Device_Token:-');
      log(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            'assets/image/siginbg.jpg', fit: BoxFit.fill,),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text('Sign In Here !', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                      )),
                  const SizedBox(height: 20.0,),
                  TextFormField(
                    controller: emailController,
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'Enter registered email';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.6),
                      hintText: 'Enter Your Email',
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  TextFormField(
                    controller: passwordController,
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'Enter your password';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.6),
                      hintText: 'Enter Password',
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40.0,),
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            backgroundColor: Colors.purple.shade600
                        ),
                        onPressed: (){
                          if (formKey.currentState!.validate()){
                            userSignIn(emailController.text, passwordController.text);
                          }
                        },
                        child: const Text('Sign In', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white),)
                    ),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPasswordScreen()));
                          },
                          child: const Text('Forgot Password', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),)),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Don't have an account ?", style: TextStyle(color: Colors.white),),
                      TextButton(
                          onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignUpScreen()));
                          },
                          child: const Text('Go To Sign Up', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

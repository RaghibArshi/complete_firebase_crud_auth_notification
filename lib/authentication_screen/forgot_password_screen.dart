import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/authentication_screen/signup_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  resetPassword(String email) async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Reset password email sent', style: TextStyle(fontSize: 18.0, color: Colors.white),),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.orange,
            content: Text('User not found !', style: TextStyle(fontSize: 18.0, color: Colors.white),),
          ),
        );
      }
    }
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
                        child: Text('Password Recovery !', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
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
                          print(emailController.text);
                          if (formKey.currentState!.validate()){
                            resetPassword(emailController.text);
                          }
                        },
                        child: const Text('Send Email', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white),)
                    ),
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

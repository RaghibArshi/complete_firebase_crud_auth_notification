import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_app/screens/home_screen.dart';
import 'package:flutter_firebase_app/authentication_screen/signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  registration(String name, String email, String? password)async{

    if(password != null){
      try{
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
              content: Text('Registered Successfully', style: TextStyle(fontSize: 18.0, color: Colors.white),),
          ),
        );
        Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomeScreen()));
      } on FirebaseException catch (e) {
        if (e.code == 'weak-password'){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.grey,
              content: Text('Enter strong password !', style: TextStyle(fontSize: 18.0, color: Colors.white),),
            ),
          );
        } else if (e.code == 'email-already-in-use'){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.orange,
              content: Text('User already exists !', style: TextStyle(fontSize: 18.0, color: Colors.white),),
            ),
          );
        }
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
                        child: Text('Sign Up Here !', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                      )),
                  const SizedBox(height: 20.0,),
                  TextFormField(
                    controller: nameController,
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'Please enter name !';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.6),
                      hintText: 'Enter Your Name',
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  TextFormField(
                    controller: emailController,
                    validator: (value){
                      if (value == null || value.isEmpty){
                        return 'Please enter email-id !';
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
                        return 'Please enter password !';
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
                        print(nameController.text);
                        print(emailController.text);
                        print(passwordController.text);
                        if (formKey.currentState!.validate()) {
                          registration(nameController.text, emailController.text, passwordController.text);
                        }
                        },
                        child: const Text('Create New Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white),)
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    children: [
                      const Text('Already have an account ?', style: TextStyle(color: Colors.white),),
                      TextButton(
                          onPressed: (){
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SignInScreen()));
                          },
                          child: const Text('Go To Login', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),)),
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

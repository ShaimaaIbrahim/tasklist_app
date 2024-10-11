import 'package:flutter/material.dart';
import 'package:tasklist_app/func.dart';

import '../main.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> with Func{
  bool rememberme = false;
  TextEditingController usernamecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  final _key = GlobalKey<FormState>();
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _key,
                child: ListView(
                  children: [
                    Hero(
                        tag: "landing",
                        child: Image.asset("assets/task.jpg", width: 300)),
                    TextFormField(
                      controller: usernamecontroller,
                      decoration: InputDecoration(
                          hintText: 'Enter name',
                          suffix: IconButton(
                              onPressed: (){
                                usernamecontroller.clear();
                              },
                              icon: Icon(Icons.clear))
                      ),
                      validator: (_){
                        if(_==null || _.isEmpty){
                          return "please enter username";
                        }else{
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      controller: passwordcontroller,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Enter password',
                          suffix: IconButton(
                              onPressed: (){
                                passwordcontroller.clear();
                              },
                              icon: Icon(Icons.clear))
                      ),
                      validator: (_){
                        if(_==null || _.isEmpty){
                          return "please enter password";
                        }else{
                          return null;
                        }
                      },
                    ),
                    CheckboxListTile(
                      value: rememberme,
                      onChanged: (_) {
                        setState(() {
                          rememberme = _ ?? false;
                        });
                      },
                      title: const Text("Remember Me"),
                    ),
                    Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                            onPressed: (){
                              if(_key.currentState!.validate()){
                                getUserUsingBasic(
                                    usernamecontroller.text,
                                    passwordcontroller.text,
                                    context);
                              }
                            },
                            style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                            child: const Text("Sign In"))
                    ),
                    const SizedBox(height: 100,),
                    OutlinedButton(onPressed: (){
                      Navigator.pushNamed(context, "/signup");

                    }, child: const Text("Do not have account? signup"))
                  ],
                )
              )
          )
      ),
    );
  }
}

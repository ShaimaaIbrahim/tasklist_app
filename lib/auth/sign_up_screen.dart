import 'package:flutter/material.dart';
import 'package:tasklist_app/func.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> with Func{
  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _key,
            child: Column(
              children: [       
                Hero(
                  tag: "landing",
                  child: Image.asset("assets/task.jpg", width: 300)),
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                      hintText: 'Enter name',
                      suffix: IconButton(
                          onPressed: (){
                            nameController.clear();
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
                  controller: usernameController,
                  decoration: InputDecoration(
                      hintText: 'Enter username',
                      suffix: IconButton(
                          onPressed: (){
                            usernameController.clear();
                          },
                          icon: const Icon(Icons.clear))
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
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                      hintText: 'Enter password',
                      suffix: IconButton(
                          onPressed: (){
                            passwordController.clear();
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
                SizedBox(height: 50,),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                        onPressed: () async{
                          if(_key.currentState!.validate()) {
                              await createUserUsingBasic(
                                  nameController.text,
                                  usernameController.text,
                                  passwordController.text,
                                  context);
                            }
                        },
                        style: ElevatedButton.styleFrom(shape: StadiumBorder()),
                        child: Text("Sign Up"))
                ),
                Spacer(),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, "/signin");

                }, child: Text("Alreay have account? signin"))
              ],
            ),
          )
        ),
      ),
    );
  }
}

import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:flutter/material.dart';
import 'package:tasklist_app/func.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with Func{
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Hero(tag: "landing", child: Image.asset("assets/task.jpg")),
              Text(
                "Organize your tasks",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),),
              Padding(
                padding: EdgeInsets.all(8),
                child: Text("lets organize your tasks to be rganized ets organize your tasks to be rganized",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                  ),),
              ),
              ElevatedButton(
                  onPressed: () async{
                    //await getLoginStatus(context);
                    Navigator.pushNamed(context, "/signin");
                  },
                  style: ElevatedButton.styleFrom(shape: const CircleBorder(),padding: const EdgeInsets.all(20)),
                  child: const Icon(Icons.arrow_forward_ios_sharp))
            ],
          )
      ),
    );
  }
}



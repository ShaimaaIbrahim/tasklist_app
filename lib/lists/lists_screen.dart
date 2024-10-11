import 'dart:async';

import 'package:empty_widget/empty_widget.dart';
import 'package:flutter/material.dart';
import 'package:tasklist_app/func.dart';
import 'package:tasklist_app/lists/view_list.dart';

class ListsScreen extends StatefulWidget {
  const ListsScreen({super.key});

  @override
  State<ListsScreen> createState() => _ListsScreenState();
}

class _ListsScreenState extends State<ListsScreen> with Func{
  
  TextEditingController listName = TextEditingController();
  final _key = GlobalKey<FormState>();
  int _selectedIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: const Text(
          "My Lists",
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        actions: [
          IconButton(
              onPressed: (){
                Navigator.pushNamed(context, "/settings");
              }, 
              icon: const Icon(Icons.settings)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.more_horiz))
        ],
      ),
      body:  SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
            future: getLists(context),
            builder: (ctx, shots){
              if(shots.hasData){
                if(shots.data!.isEmpty){
                  return _emptyListWidget();
                }
                else if(shots.data!.isNotEmpty){
                  var entriesList = shots.data?.entries.toList();
                  return ListView.builder(
                    itemCount: shots.data!.length+1, // Total number of items
                    itemBuilder: (context, index) {
                      if(index==shots.data!.length){
                        return ElevatedButton.icon(
                          onPressed: _showDialog,
                          icon: const Icon(Icons.add),
                          label: const Text("Add List"),
                        );
                      }
                      return Card(
                          child: ListTile(
                            onTap: (){
                             Navigator.pushNamed(context, 
                                 ViewList.routeName, 
                                 arguments: ViewArguments(
                                     id: entriesList?[index].value["id"]??"", 
                                     listName: entriesList?[index].value["name"]??"", 
                                     all: false)
                             );
                       },
                            leading: const Icon(Icons.list),
                            title: Text(entriesList?[index].value["name"]),
                            trailing:  const Icon(Icons.arrow_right),
                          )
                      );
                    },
                  ); 
                }
                return _emptyListWidget();
              }
              else{
                return _emptyListWidget();
              }
            })
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.restaurant), label: 'Recipe'),
          BottomNavigationBarItem(
              icon: Icon(Icons.file_download_sharp), label: 'Files'),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat_bubble), label: 'Chat Room')
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue[800],
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        unselectedLabelStyle:
        const TextStyle(color: Colors.black, fontSize: 11),
        unselectedIconTheme: const IconThemeData(size: 15),
        onTap: _onItemTapped,
      ),
    );
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    if (_selectedIndex == 1) {
      Navigator.pushNamed(context, "/recipe");
    } else if (_selectedIndex == 2) {
      Navigator.pushNamed(context, "/file");
    } else {
      Navigator.pushNamed(context, "/chat");
    }
  }
  
  _showDialog(){
    showDialog(context: context, builder: (_){
      return AlertDialog(
        icon: const CircleAvatar(
          radius: 30,
          child: Icon(
              Icons.add,
              size: 30
          ),
        ),
        content: Form(
            key: _key,
            child: TextFormField(
              controller: listName,
              decoration: const InputDecoration(
                hintText: 'Add name',
              ),
              validator: (_){
                if(_==null || _.isEmpty){
                  return "add list name";
                }else{
                  return null;
                }
              },
            )
        ),
        actions: [
          ElevatedButton(
           onPressed: () async{
            if(_key.currentState!.validate()){
              createNewList(listName.text, context);
              listName.clear();
              setState(() {});
            }
          },
           child: const Text("Add")
          )
        ],
      );
    });
  }
  
  _emptyListWidget(){
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyWidget(
              image: null,
              packageImage: PackageImage.Image_1,
              title: "No list",
              subTitle: "No Lists available yet",
            ),
            ElevatedButton.icon(
              onPressed: _showDialog,
              icon: const Icon(Icons.add),
              label: const Text("Add List"),
            )
          ],
        )
    );
  }
}

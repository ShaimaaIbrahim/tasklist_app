
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tasklist_app/constants.dart';

import 'http_service.dart';
import '../main.dart';

mixin Func {
 static HttpService _httpService = HttpService();

  static Future<Response<dynamic>?> sendRequest({
    required String endPoint,
    required Method method,
    Map<String, dynamic>? params,
    String? authorizationHeader,
}) async{
    //init dio 
    _httpService.init(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          "Authorization": authorizationHeader
        }
      )
    );
   //request endpoint 
   final response = await _httpService.request(
       endPoint: endPoint,
       method: method,
       params: params);
   
    return response;
  }


 ////////////////////////////LISTS/////////////////////////

 Future<Map<String, dynamic>> getLists(BuildContext context) async {
   Map<String, dynamic> lists = {};

   await sendRequest(endPoint: allLists, method: Method.GET).then((lsts) {
     lists = lsts?.data as Map<String, dynamic>;
   }).catchError((onError) {
     ScaffoldMessenger.of(context)
         .showSnackBar(const SnackBar(content: Text("Failed to fetch lists")));
   });
   return lists;
 }

 createNewList(String name, BuildContext context) async{
    sendRequest(
       endPoint: newList, 
       method: Method.POST,
       params: {"name": name})
       .then((_){
         debugPrint(">>>>>>>createNewList ${_?.data.toString()}");
         Navigator.of(context).pop();
   }).catchError((_){
     debugPrint(">>>>>>>createNewList ${_.toString()}"); 
   });
 }
 
 getSingleList(String id) async{
   await sendRequest(
       endPoint: '$baseUrl$singleList$id',
       method: Method.GET);

 }
 
 updateSingleList(String id, String name) async{
   await sendRequest(
       endPoint: '$singleList$id',
       method: Method.PATCH,
       params: {"name": name});

 }
 
 deleteSingleList(String id) async{
   await sendRequest(
       endPoint: '$singleList$id',
       method: Method.DELETE);

 }
 
 
 ////////////////////////////TASKS/////////////////////////

 Future<Map<String, dynamic>> getItems(BuildContext context) async{
    var allItems = Map<String, dynamic>();
    
    await sendRequest(endPoint: '$baseUrl$items', method: Method.GET).then((itms){
       allItems = itms?.data as Map<String, dynamic>;
    }).catchError((err){
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
    });
    return allItems;
 }

  createItem(BuildContext context,String listId,  String name, String description, bool status) async{
   await sendRequest(
       endPoint: '$baseUrl$items', 
       method: Method.POST,
       params: {"description": description, "name": name, "status": status, "listId": listId});
   
 }

 Future<Map<String, dynamic>> getItemsById(BuildContext context,String id) async{
   var items = <String, dynamic>{}; 
   
    await sendRequest(
       endPoint: '$itemsByList$id',
       method: Method.GET
   ).then((_){
      items = _?.data as Map<String, dynamic>; 
   }).catchError((err){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
    });
    
   return items;
 }
 
 updateItem(String id,String listId, String description, String name, bool status) async{
   await sendRequest(
       endPoint: '$baseUrl$itemsByList$id',
       method: Method.PATCH,
       params: {"description": description, "name": name, "status": status, "listId": listId});

 }
 
 deleteItem(String id) async{
   await sendRequest(
       endPoint: '$baseUrl$itemsByList$id',
       method: Method.DELETE);
 }

////////////////////////////FIREBASE/////////////////////////
 getFirebaseLists(BuildContext context){
   var lists = <String, dynamic>{};

   sendRequest(endPoint: firebase, method: Method.GET).then((_){
     lists = _?.data as Map<String, dynamic>;
   }).catchError((error){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),));
   });
   return lists;
 }
 
  createListUsingFirebase(String name) async{
    await sendRequest(
    endPoint: firebase,
    method: Method.POST,
    params: {"name": name});
  }

  updateListUsingFirebase(String id, String name) async{
    await sendRequest(
        endPoint: '$firebase$id',
        method: Method.PATCH,
        params: {"name": name});

  }

  deleteListUsingFirebase(String id) async{
    await sendRequest(
        endPoint: '$firebase$id',
        method: Method.DELETE);

  }

  ////////////////////////////POSTGRESQL/////////////////////////
  getPostgresqlLists(BuildContext context){
    var lists = <String, dynamic>{};

    sendRequest(endPoint: postgresql, method: Method.GET).then((_){
      lists = _?.data as Map<String, dynamic>;
    }).catchError((error){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),));
    });
    return lists;
  }

  createListUsingPostgresql(String name) async{
    await sendRequest(
        endPoint: postgresql,
        method: Method.POST,
        params: {"name": name});
  }

  updateListUsingPostgresql(String id, String name) async{
    await sendRequest(
        endPoint: '$postgresql$id',
        method: Method.PATCH,
        params: {"name": name});

  }

  deleteListUsingPostgresql(String id) async{
    await sendRequest(
        endPoint: '$postgresql$id',
        method: Method.DELETE);

  }

  ////////////////////////////REDIS CACHE/////////////////////////

  setLoginStatus(int status) async{
    await sendRequest(
    endPoint: cache,
    method: Method.POST,
    params: {"loggedin": status});
  }
  
  getLoginStatus(BuildContext context) async{
    final response = await sendRequest(
        endPoint: cache,
        method: Method.GET
    ).then((value)=> value);
    debugPrint("response: $response");
    
    if(context.mounted){
      if(response?.data["success"]){
        if(response?.data["message"]==0){
          Navigator.pushNamed(context, "/signin"); 
        }else{
          Navigator.pushNamed(context, "/lists");
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response?.data["message"])));
      }
    }
  }
  
  /////////////////////////BASIC AUTH/////////////////////
  createUserUsingBasic(String name, String username, String password,BuildContext context) async{
    await sendRequest(
        endPoint: basicAuth,
        method: Method.POST,
        params: {
          "name": name, 
          "username": username, 
          "password": password}).then((_){
           if(context.mounted){
             if(_?.statusCode==200){
               Navigator.pushNamed(context, "/signin");
             }else{
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("unable to sign in")));
             }
           }
    }).catchError((err){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("unable to sign in")));
    });
  }

  getUserUsingBasic(String username, String password,BuildContext context) async{
    await sendRequest(
        endPoint: basicAuth,
        method: Method.GET,
        params: {
          "username": username,
          "password": password
        },
        authorizationHeader: 'Basic ${base64.encode('$username:$password'.codeUnits)}'
    ).then((_){
      customProvider.setUser(_?.data);
      if(context.mounted){
        if(_?.statusCode==200){
          setLoginStatus(1);
          Navigator.pushNamed(context, "/lists");
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("unable to sign in")));
        }
      }
    }).catchError((err){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
    });
  }

  updateUserUsingBasic(String id,String name, String username, String newPassword,String oldPassword ,BuildContext context) async{
    await sendRequest(
        endPoint: '$basicAuth$id',
        method: Method.PATCH,
        params: {
          "name": name,
          "username": username,
          "password": newPassword
        },
        authorizationHeader: 'Basic ${base64.encode('$username:$oldPassword'.codeUnits)}'
    ).then((result){
      if(context.mounted){
        if(result?.statusCode==200){
          ///sign in navigation 
        }else{
          ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("${result?.statusCode}")));
        }
      }
    }).catchError((err){
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text(err.toString())));
    });
  }
  
  deleteUserUsingBasic(String id) async{
    await sendRequest(
        endPoint: '$basicAuth$id',
        method: Method.DELETE
    );
  }
  
   /////////////////////////BEARER AUTH/////////////////////
  createUserUsingBearer(String name, String username, String password,BuildContext context) async{
    await sendRequest(
        endPoint: bearerAuth,
        method: Method.POST,
        params: {
          "name": name,
          "username": username,
          "password": password}).then((_){
      if(context.mounted){
        if(_?.statusCode==200){
          ///sign in navigation 
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("unable to sign in")));
        }
      }
    }).catchError((err){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("unable to sign in")));
    });
  }

  getUserUsingBearer(String id, String username, String password,BuildContext context) async{
    await sendRequest(
        endPoint: basicAuth,
        method: Method.GET,
        params: {
          "username": username,
          "password": password}
    )
        .then((_){
      if(context.mounted){
        if(_?.statusCode==200){
          ///sign in navigation 
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("unable to sign in")));
        }
      }
    }).catchError((err){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("unable to sign in")));
    });
  }

  updateUserUsingBearer(String id,String name, String username, String newPassword,String oldPassword , String sessionToken ,BuildContext context) async{
    await sendRequest(
        endPoint: '$bearerAuth$id',
        method: Method.PATCH,
        params: {
          "name": name,
          "username": username,
          "password": newPassword
        },
        authorizationHeader: 'Basic $sessionToken'
    ).then((_){
      if(context.mounted){
        if(_?.statusCode==200){
          ///sign in navigation 
        }else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("unable to sign in")));
        }
      }
    }).catchError((err){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("unable to sign in")));
    });
  }

  deleteUserUsingBearer(String id, String sessionToken ,BuildContext context) async{
    await sendRequest(
        endPoint: '$bearerAuth$id',
        method: Method.DELETE,
        authorizationHeader: 'Basic $sessionToken'
    );
  }
  
/////////////////////////REST APIS/////////////////////
  Future<List<dynamic>> getRecipe(BuildContext context) async{
   var reciep = [];
   await sendRequest(
       endPoint: restapi,
       method: Method.GET
   ).then((value){
     reciep = jsonDecode(value?.data)["meals"];
     //debugPrint(">>>>reciep: $reciep");
   }).catchError((err){
     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("unable to sign in")));
   });
   return reciep;
 } 

}
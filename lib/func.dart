
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:tasklist_app/constants.dart';

import 'http_service.dart';

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

 Map<String, dynamic> getAllLists(BuildContext context){
   var lists = <String, dynamic>{};
   
   sendRequest(endPoint: '$baseUrl$allLists', method: Method.GET).then((_){
      lists = _?.data as Map<String, dynamic>;
   }).catchError((error){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()),));
   });
    return lists;
  }

 createNewList(String name) async{
   await sendRequest(
       endPoint: '$baseUrl$newList', 
       method: Method.POST,
       params: {"name": name});
   
 }
 
 getSingleList(String id) async{
   await sendRequest(
       endPoint: '$baseUrl$singleList$id',
       method: Method.GET);

 }
 
 updateSingleList(String id, String name, BuildContext context) async{
   await sendRequest(
       endPoint: '$baseUrl$singleList$id',
       method: Method.PATCH,
       params: {"name": name});

 }
 
 deleteSingleList(String id) async{
   await sendRequest(
       endPoint: '$baseUrl$singleList$id',
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

  createItem(BuildContext context,String listId, String description, String name, bool status) async{
   await sendRequest(
       endPoint: '$baseUrl$items', 
       method: Method.POST,
       params: {"description": description, "name": name, "status": status, "listId": listId});
   
 }

 Future<Map<String, dynamic>> getItemsById(BuildContext context,String id) async{
   var items = <String, dynamic>{}; 
   
    await sendRequest(
       endPoint: '$baseUrl$itemsByList$id',
       method: Method.GET
   ).then((_){
      items = _?.data as Map<String, dynamic>; 
   }).catchError((err){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err.toString())));
    });
    
   return items;
 }
 
 updateItem(BuildContext context,String id,String listId, String description, String name, bool status) async{
   await sendRequest(
       endPoint: '$baseUrl$itemsByList$id',
       method: Method.PATCH,
       params: {"description": description, "name": name, "status": status, "listId": listId});

 }
 
 deleteItem(BuildContext context,String id,String listId, String description, String name, bool status) async{
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
}
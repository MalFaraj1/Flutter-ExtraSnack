import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:restaurant_system/home.dart';
import 'package:restaurant_system/userinfo.dart';

class Orders{
  int _ID;
  String _name;
  String _item;
  int _quantity;
  String _status;

  Orders(this._ID, this._name, this._item, this._quantity, this._status);

  void setStatus(String status){
    this._status = status;
  }

  int getID(){
    return _ID;
  }

  String toString(){
    return 'ID: $_ID \nUser: $_name \nItem: $_item \nQuantity: $_quantity \nStatus: $_status';
  }
}

List<Orders> _orders = [];

void removeOrder(BuildContext context, int id) async{
  const url = 'http://10.0.2.2/restoSys/removeorder.php';
  //const url = 'http://ExtraSnack.free.nf/removeorder.php';
  final response = await http.post(
    Uri.parse(url),
    body: convert.jsonEncode({
      'id': id,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  final responseData = convert.jsonDecode(response.body);
  if (responseData['success']) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(responseData['message'])),
    );
  }else{
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error')),
    );
  }
}

void updateOrders() async{
  const url = 'http://10.0.2.2/restoSys/getorders.php';
  final response = await http.get(Uri.parse(url));

  _orders.clear();

  if(response.statusCode == 200){
    final jsonResponse  = convert.jsonDecode(response.body);
    for(var row in jsonResponse){
      Orders o = Orders(
          int.parse(row['ID']),
          row['name'],
          row['item'],
          int.parse(row['quantity']),
          row['status']
      );
      _orders.add(o);
    }
  }
}

void updateUserOrders() async{
  const url = 'http://10.0.2.2/restoSys/getuserorders.php';
  final response = await http.post(
    Uri.parse(url),
    body: convert.jsonEncode({
      'id': userID,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  _orders.clear();

  if(response.statusCode == 200){
    final jsonResponse  = convert.jsonDecode(response.body);
    for(var row in jsonResponse){
      Orders o = Orders(
          int.parse(row['ID']),
          row['name'],
          row['item'],
          int.parse(row['quantity']),
          row['status']
      );
      _orders.add(o);
    }
  }
}


void addOrder(BuildContext context, String quantity ,int iID, int uID) async{
  const url = 'http://10.0.2.2/restoSys/addorder.php';
  final response = await http.post(
    Uri.parse(url),
    body: convert.jsonEncode({
      'quantity' : quantity,
      'item_id' : iID,
      'user_id' : uID,
    }),
    headers: {'Content-Type': 'application/json'},
  );

  final responseData = convert.jsonDecode(response.body);
  if (responseData['success']) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(responseData['message'])),
    );
  }else{
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error')),
    );
  }
}



class viewOrders extends StatefulWidget {
  const viewOrders({super.key});

  @override
  State<viewOrders> createState() => _viewOrdersState();
}

class _viewOrdersState extends State<viewOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ExtraSnack',
          style: TextStyle(color: Colors.yellow),
        ),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  updateOrders();
                });
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => adminPage()),
                );
              },
              icon: const Icon(Icons.arrow_back)),
        ],
      ),

      body: ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (context, index){
            return Container(
              color: index % 2 == 0 ? Colors.yellow : Colors.red,
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Text(_orders[index].toString()),
                  ElevatedButton(
                      onPressed: (){
                        setState(() {
                          removeOrder(context, _orders[index].getID());

                        });
                      },
                      child: Text("Delivered"))
                ],
              ),
            );
          }
      ),
    );
  }
}

class userOrders extends StatefulWidget {
  const userOrders({super.key});

  @override
  State<userOrders> createState() => _userOrdersState();
}

class _userOrdersState extends State<userOrders> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'ExtraSnack',
          style: TextStyle(color: Colors.yellow),
        ),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  updateUserOrders();
                });
              },
              icon: const Icon(Icons.refresh)),
          IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              icon: const Icon(Icons.arrow_back)),
        ],
      ),

      body: ListView.builder(
          itemCount: _orders.length,
          itemBuilder: (context, index){
            return Container(
              color: index % 2 == 0 ? Colors.yellow : Colors.red,
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Text(_orders[index].toString()),
                  ElevatedButton(
                      onPressed: (){
                        setState(() {
                          removeOrder(context, _orders[index].getID());

                        });
                      },
                      child: Text("Delete Order"))
                ],
              ),
            );
          }
      ),
    );
  }
}




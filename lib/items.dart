import 'package:flutter/material.dart';
import 'package:restaurant_system/home.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:restaurant_system/items.dart';
import 'package:restaurant_system/orders.dart';
import 'package:restaurant_system/userinfo.dart';

class Items {
  int _itemID;
  String _name;
  String _description;
  String _category;
  int _price;
  String _image;

  Items(this._itemID, this._name, this._description, this._category,
      this._price, this._image);

  int getID() {
    return _itemID;
  }

  String getImage(){
    return _image;
  }

  String toString() {
    return 'ID: $_itemID \nUser: $_name \nDescription: $_description \nCategory: $_category \nPrice: \$$_price';
  }
}

List<Items> _items = [];

void updateItems() async {
  const url = 'http://10.0.2.2/restoSys/getitems.php';
  //const url = 'http://ExtraSnack.free.nf/getitems.php';
  final response = await http.get(Uri.parse(url));

  _items.clear();

  if (response.statusCode == 200) {
    final jsonResponse = convert.jsonDecode(response.body);
    for (var row in jsonResponse) {
      Items o = Items(
        int.parse(row['item_id']),
        row['name'],
        row['description'],
        row['category'],
        int.parse(row['price']),
        row['image'],
      );
      _items.add(o);
    }
    //print('Items: $_items'); // Debug
  } else {
    //print('Failed to fetch items: ${response.statusCode}');
  }
}

void removeItem(BuildContext context, int id) async {
  const url = 'http://10.0.2.2/restoSys/removeitem.php';
  //const url = 'http://ExtraSnack.free.nf/removeitem.php';
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
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error')),
    );
  }
}

class viewItems extends StatefulWidget {
  const viewItems({super.key});

  @override
  State<viewItems> createState() => _viewItemsState();
}

class _viewItemsState extends State<viewItems> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return Container(
              color: index % 2 == 0 ? Colors.yellow : Colors.red,
              padding: const EdgeInsets.all(5),
              child:
                Column(
                    children: [
                      Text(_items[index].toString()),
                      Image(image: AssetImage("images/${_items[index].getImage()}"), width: 200, height: 200,),
                      SizedBox(height: 5,),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              removeItem(context, _items[index].getID());
                            });
                          },
                          child: Text("Delete item")
                      ),
                    ],
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
          );
        });
  }
}



class usersItemsList extends StatefulWidget {
  const usersItemsList({super.key});

  @override
  State<usersItemsList> createState() => _usersItemsListState();
}

class _usersItemsListState extends State<usersItemsList> {
  List<TextEditingController> quantities = [];

  @override
  void initState() {
    super.initState();
    if (_items.isNotEmpty) {
      // Initialize controllers if _items is already populated
      quantities = List.generate(_items.length, (index) => TextEditingController());
    }
  }

  @override
  void dispose() {
    for (var quantity in quantities) {
      quantity.dispose();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    // If _items is empty, show a loading indicator or an appropriate message
    if (_items.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    // Ensure controllers are initialized if _items is now populated
    if (quantities.isEmpty) {
      quantities = List.generate(_items.length, (index) => TextEditingController());
    }
    return ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          return Container(
            color: index % 2 == 0 ? Colors.yellow : Colors.red,
            padding: const EdgeInsets.all(5),
            child:
            Column(
              children: [
                Text(_items[index].toString()),
                SizedBox(
                  width: 100,
                  height: 40,
                  child: TextField(
                    decoration: InputDecoration(border: OutlineInputBorder(), hintText: "Quantity"),
                    controller: quantities[index],
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(height: 10,),
                Image(image: AssetImage("images/${_items[index].getImage()}"), width: 150, height: 150,),
                SizedBox(height: 5,),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        addOrder(context, quantities[index].text, _items[index].getID(), userID);
                      });
                    },
                    child: Text("Order item")
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
            ),
          );
        });
  }
}


class addItem extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  Future<void> addItems(BuildContext context, String name, String description,
      String category, String price, String image) async {
    const url = 'http://10.0.2.2/restoSys/additem.php';
    //const url = 'http://ExtraSnack.free.nf/additem.php';
    final response = await http.post(
      Uri.parse(url),
      body: convert.jsonEncode({
        'name': name,
        'description': description,
        'category': category,
        'price': price,
        'image': image,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    final responseData = convert.jsonDecode(response.body);
    if (responseData['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Item added successfully")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(responseData['message'])),
      );
    }
  }

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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => adminPage()),
                );
              },
              icon: const Icon(Icons.arrow_back)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Item name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'descrption'),
            ),
            TextField(
              controller: categoryController,
              decoration: InputDecoration(labelText: 'category'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'price'),
            ),
            TextField(
              controller: imageController,
              decoration: InputDecoration(labelText: 'image path'),
            ),
            ElevatedButton(
              onPressed: () {
                addItems(
                  context,
                  nameController.text,
                  descriptionController.text,
                  categoryController.text,
                  priceController.text,
                  imageController.text,
                );
              },
              child: Text('Add'),
            ),
            SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

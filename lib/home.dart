import 'package:flutter/material.dart';
import 'package:restaurant_system/items.dart';
import 'package:restaurant_system/orders.dart';
import 'package:restaurant_system/userinfo.dart';

//admin page

class adminPage extends StatefulWidget {
  const adminPage({super.key});

  @override
  State<adminPage> createState() => _adminPageState();
}

class _adminPageState extends State<adminPage> {
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
                  MaterialPageRoute(builder: (context) => addItem()),
                );
              },
              icon: const Icon(Icons.add)
          ),
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => viewOrders()),
              );
            },
            icon: const Icon(Icons.remove_red_eye)
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  updateItems();
                });
              },
              icon: const Icon(Icons.refresh)
          ),

        ],
      ),
      body: viewItems(),
    );
  }
}

//_____________________________________________________________________________________________________
//Home page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                  MaterialPageRoute(builder: (context) => userOrders()),
                );
              },
              icon: const Icon(Icons.remove_red_eye)
          ),
          IconButton(
              onPressed: () {
                setState(() {
                  updateItems();
                });
              },
              icon: const Icon(Icons.refresh)
          ),

        ],
      ),
      body: usersItemsList(),
    );
  }
}


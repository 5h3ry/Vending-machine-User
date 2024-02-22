/*
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  final List<String> selectedIds;
  final String machineId;

  CartPage({required this.selectedIds, required this.machineId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Map<String, dynamic>>> _selectedItemsFuture;

  @override
  void initState() {
    super.initState();
    _selectedItemsFuture = _fetchSelectedItems();
  }

  Future<List<Map<String, dynamic>>> _fetchSelectedItems() async {
    List<Map<String, dynamic>> selectedItemsData = [];
    // Query Firestore to fetch details of selected items using selectedIds
    await Future.forEach(widget.selectedIds, (String id) async {
      // Fetch the item document from the 'items' subcollection under the machine document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Machines')
          .doc(widget.machineId)
          .collection('items')
          .doc(id)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        selectedItemsData.add(data);
      }
    });
    return selectedItemsData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCC00),
        title: Text('Cart'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _selectedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found in the cart'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> itemData = snapshot.data![index];
                // Display details of each selected item
                return ListTile(
                  title: Text(itemData['itemName']),
                  subtitle: Text('Price: ${itemData['price']}, Quantity: ${itemData['quantity']}'),
                  // Add more details as needed
                );
              },
            );
          }
        },
      ),
    );
  }
}



 */

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CartPage extends StatefulWidget {
  final List<String> selectedIds;
  final String machineId;

  CartPage({required this.selectedIds, required this.machineId});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<List<Map<String, dynamic>>> _selectedItemsFuture;

  Map<String, String> itemQuantities = {};

  @override
  void initState() {
    super.initState();
    _selectedItemsFuture = _fetchSelectedItems();
  }

  Future<List<Map<String, dynamic>>> _fetchSelectedItems() async {
    List<Map<String, dynamic>> selectedItemsData = [];
    // Query Firestore to fetch details of selected items using selectedIds
    await Future.forEach(widget.selectedIds, (String id) async {
      // Fetch the item document from the 'items' subcollection under the machine document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Machines')
          .doc(widget.machineId)
          .collection('items')
          .doc(id)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        selectedItemsData.add(data);
        itemQuantities[id] = '1'; // Set initial quantity to 1 for each item
      }
    });
    return selectedItemsData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCC00),
        title: Text('Cart'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _selectedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found in the cart'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> itemData = snapshot.data![index];
                String itemId = widget.selectedIds[index];
                // Display details of each selected item
                return ListTile(
                  title: Text(itemData['itemName']),
                  subtitle: Row(
                    children: <Widget>[
                      Text('Price: ${itemData['price']}'),
                      SizedBox(width: 20),
                      Text('Quantity: ${itemData['quantity']}'),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            int quantity = int.parse(itemQuantities[itemId] ?? '1');
                            if (quantity > 1) {
                              quantity--;
                              itemQuantities[itemId] = quantity.toString();
                            }
                          });
                        },
                      ),
                      Text('${itemQuantities[itemId]}'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          setState(() {
                            int quantity = int.parse(itemQuantities[itemId] ?? '1');
                            if (quantity < int.parse(itemData['quantity'])) {
                              quantity++;
                              itemQuantities[itemId] = quantity.toString();
                            }
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
/*
class _CartPageState extends State<CartPage> {
  late Future<List<Map<String, dynamic>>> _selectedItemsFuture;

  String current_quantity="1";
  @override
  void initState() {
    super.initState();
    _selectedItemsFuture = _fetchSelectedItems();
  }

  Future<List<Map<String, dynamic>>> _fetchSelectedItems() async {
    List<Map<String, dynamic>> selectedItemsData = [];
    // Query Firestore to fetch details of selected items using selectedIds
    await Future.forEach(widget.selectedIds, (String id) async {
      // Fetch the item document from the 'items' subcollection under the machine document
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Machines')
          .doc(widget.machineId)
          .collection('items')
          .doc(id)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        selectedItemsData.add(data);
      }
    });
    return selectedItemsData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCC00),
        title: Text('Cart'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _selectedItemsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No items found in the cart'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> itemData = snapshot.data![index];
                // Display details of each selected item
                return ListTile(
                  title: Text(itemData['itemName']),
                  subtitle: Row(
                    children: <Widget>[
                      Text('Price: ${itemData['price']}'),
                      SizedBox(width: 20),
                      Text('Quantity: ${itemData['quantity']}'),
                      SizedBox(width: 20),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: () {
                          setState(() {
                            if (int.parse(current_quantity)>1){
                              current_quantity =(int.parse(current_quantity) -1).toString();}
                          });

                        },
                      ),
                      Text('$current_quantity'),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          // Implement logic to increase quantity
                          setState(() {
                            if (int.parse(current_quantity)<int.parse(itemData['quantity'])){
                              current_quantity =(int.parse(current_quantity) +1).toString();}
                          });
                        },
                      ),
                    ],
                  ),
                  // Add more details as needed
                );
              },
            );
          }
        },
      ),
    );
  }
}


 */

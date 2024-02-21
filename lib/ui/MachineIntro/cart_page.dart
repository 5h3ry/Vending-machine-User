
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


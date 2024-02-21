//
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:vending_app/ui/MachineIntro/cart_page.dart';
//
// class ItemListScreen extends StatefulWidget {
//   final String machineId;
//
//   ItemListScreen({required this.machineId});
//
//   @override
//   State<ItemListScreen> createState() => _ItemListScreenState();
// }
//
// class _ItemListScreenState extends State<ItemListScreen> {
//   final auth = FirebaseAuth.instance;
//   final nameController = TextEditingController();
//   final priceController = TextEditingController();
//   final quantityController = TextEditingController();
//
//   List<String> selectedIds = [];
//   int cartItemCount = 0;
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Color(0xFFFFCC00),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text('Items List'),
//             SizedBox(width: 10),
//             buildCartIcon(),
//           ],
//         ),
//         centerTitle: true,
//       ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('Machines')
//             .doc(widget.machineId)
//             .collection('items')
//             .snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             // return Center(child: CircularProgressIndicator());
//           }
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//             return Center(child: Text('No data found'));
//           }
//           return ListView(
//             children: buildListTilesFromSubcollection(snapshot.data!),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget buildCartIcon() {
//     return Stack(
//       children: [
//         IconButton(
//           onPressed: () {
//             // Navigator.push(
//             //   context,
//             //   MaterialPageRoute(builder: (context) => CartPage()),
//             // );
//             // Show a toast or navigate to the cart page
//             // with the selected items when the cart icon is pressed.
//           },
//           icon: Icon(Icons.shopping_cart),
//         ),
//         cartItemCount > 0
//             ? Positioned(
//           right: 8,
//           top: 8,
//           child: CircleAvatar(
//             backgroundColor: Colors.red,
//             radius: 10,
//             child: Text(
//               cartItemCount.toString(),
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 12,
//               ),
//             ),
//           ),
//         )
//             : SizedBox(),
//       ],
//     );
//   }
//
//   List<Widget> buildListTilesFromSubcollection(QuerySnapshot querySnapshot) {
//     return querySnapshot.docs.map((doc) {
//       var data = doc.data() as Map<String, dynamic>?;
//
//       if (data != null) {
//         String id = doc.id;
//         String itemName = data['itemName'] ?? '';
//         String price = data['price'] ?? '';
//         String quantity = data['quantity'] ?? '';
//         String imageUrl = data['imageUrl'] ?? '';
//         bool isSelected = selectedIds.contains(id);
//         return ListTile(
//           leading: imageUrl.isNotEmpty ? Image.network(imageUrl) : SizedBox(),
//           title: Text(itemName),
//           subtitle: Text('Price: $price, Quantity: $quantity'),
//           trailing: ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 if (isSelected) {
//                   // If the item is already selected, remove it from the cart
//                   selectedIds.remove(id);
//                   cartItemCount--;
//                 } else {
//                   // If the item is not selected, add it to the cart
//                   selectedIds.add(id);
//                   cartItemCount++;
//                 }
//               });
//             },
//             child: Text(isSelected ? 'Remove from Cart' : 'Add to Cart'),
//           ),
//         );
//       } else {
//         return SizedBox();
//       }
//     }).toList();
//   }
//
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vending_app/ui/MachineIntro/cart_page.dart';

class ItemListScreen extends StatefulWidget {
  final String machineId;

  ItemListScreen({required this.machineId});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final auth = FirebaseAuth.instance;
  List<String> selectedIds = [];
  int cartItemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFFFCC00),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Items List'),
            SizedBox(width: 10),
            buildCartIcon(),
          ],
        ),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Machines')
            .doc(widget.machineId)
            .collection('items')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No data found'));
          }
          return ListView(
            children: buildListTilesFromSubcollection(snapshot.data!),
          );
        },
      ),
    );
  }

  Widget buildCartIcon() {
    return Stack(
      children: [
        IconButton(
          onPressed: () {
            if (cartItemCount > 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(selectedIds: selectedIds, machineId: widget.machineId),
                ),
              );


            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Your cart is empty!')),
              );
            }
          },
          icon: Icon(Icons.shopping_cart),
        ),
        cartItemCount > 0
            ? Positioned(
          right: 8,
          top: 8,
          child: CircleAvatar(
            backgroundColor: Colors.red,
            radius: 10,
            child: Text(
              cartItemCount.toString(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
          ),
        )
            : SizedBox(),
      ],
    );
  }

  void addToCart(String id) {
    setState(() {
      if (selectedIds.contains(id)) {
        selectedIds.remove(id);
        cartItemCount--;
      } else {
        selectedIds.add(id);
        cartItemCount++;
      }
    });
  }

  List<Widget> buildListTilesFromSubcollection(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>?;

      if (data != null) {
        String id = doc.id;
        String itemName = data['itemName'] ?? '';
        String price = data['price'] ?? '';
        String quantity = data['quantity'] ?? '';
        String imageUrl = data['imageUrl'] ?? '';
        bool isSelected = selectedIds.contains(id);
        return ListTile(
          leading: imageUrl.isNotEmpty ? Image.network(imageUrl) : SizedBox(),
          title: Text(itemName),
          subtitle: Text('Price: $price, Quantity: $quantity'),
          trailing: ElevatedButton(
            onPressed: () {
              addToCart(id);
            },
            child: Text(isSelected ? 'Remove from Cart' : 'Add to Cart'),
          ),
        );
      } else {
        return SizedBox();
      }
    }).toList();
  }
}

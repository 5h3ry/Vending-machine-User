import 'package:flutter/material.dart';
import 'package:vending_app/ui/Drawer/FabTab.dart';
import 'package:vending_app/ui/MachineIntro/select_machine_for_item.dart';
import 'package:vending_app/ui/Pages/AboutUs.dart';
import 'package:vending_app/ui/Pages/OrderHistoryPage.dart';
import 'package:vending_app/ui/auth/login_screen.dart';
import '../Drawer/drawer_side.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Color primaryColor = Colors.white;
  Color textColor = Colors.black;
  Color scaffoldBackgroundColor = Color(0xffffcc00);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: scaffoldBackgroundColor,
        elevation: 0.0,
        title: Text(
          "My Profile",
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
      drawer: DrawerSide(),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 60,
                color: scaffoldBackgroundColor,
              ),
              Container(
                height: 548,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: 250,
                          height: 80,
                          padding: EdgeInsets.only(left: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              // Your existing code
                            ],
                          ),
                        ),
                      ],
                    ),
                    listTile(
                      icon: Icons.shop_outlined,
                      title: "My Orders",
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Select a Machine"),
                              content: Text("Please select a machine before proceeding to the Order."),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    // setState(() {
                                    //   _currentIndex = 3;
                                    // });
                                    Navigator.of(context).pop();
                                  },
                                  child: Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    listTile(
                      icon: Icons.person_outline,
                      title: "Refer A Friends",
                      backgroundColor: Colors.white,
                    ),
                    listTile(
                      icon: Icons.add_chart,
                      title: "About Us",
                      backgroundColor: Colors.white,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AboutUs()),
                        );

                      },
                    ),
                    listTile(
                      icon: Icons.file_copy_outlined,
                      title: "Help",
                      backgroundColor: Colors.white,
                    ),
                    listTile(
                      icon: Icons.exit_to_app_outlined,
                      title: "Log Out",
                      backgroundColor: Colors.white,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginScreen()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25, left: 30),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: primaryColor,
              child: CircleAvatar(
                backgroundImage: AssetImage("assets/vending.png"),
                radius: 45,
                backgroundColor: scaffoldBackgroundColor,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "My Cart",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "My Orders",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );

  }
  int _currentIndex = 3;

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Handle tap events for each tab
    switch (index) {
      case 0:
        onHomeTapped();
        break;
      case 1:
        onCartTapped();
        break;
      case 2:
        onOrdersTapped();
        break;
      case 3:
        onProfileTapped();
        break;
    }
  }

  void onHomeTapped() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectMachineForItems()));
  }

  void onCartTapped() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select a Machine"),
          content: Text("Please select a machine before proceeding to the cart."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 3;
                });
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void onOrdersTapped() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select a Machine"),
          content: Text("Please select a machine before proceeding to the Order."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _currentIndex = 3;
                });
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void onProfileTapped() {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ProfilePage()));
  }



  Widget listTile({
    IconData? icon,
    String? title,
    VoidCallback? onTap,
    Color? backgroundColor,
  }) {
    return Column(
      children: [
        Divider(
          height: 1,
        ),
        ListTile(
          leading: Icon(icon ?? Icons.error),
          title: Text(title ?? ""),
          tileColor: backgroundColor ?? Colors.blue,
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        )
      ],
    );
  }
}
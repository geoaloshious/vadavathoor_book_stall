import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vadavathoor_book_stall/components/user_profile/user_profile.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'package:vadavathoor_book_stall/screens/book_purchase/book_purchase.dart';
import 'package:vadavathoor_book_stall/screens/db_viewer.dart';
import 'package:vadavathoor_book_stall/screens/empty_screen.dart';
// import 'package:vadavathoor_book_stall/screens/publishers.dart';
import 'package:vadavathoor_book_stall/screens/sales/sales.dart';
// import 'package:vadavathoor_book_stall/screens/stationary.dart';
import 'package:vadavathoor_book_stall/screens/under_development.dart';
import 'package:vadavathoor_book_stall/screens/manage_users/index.dart';

import '../providers/user.dart';

final leftItems = [
  {'label': 'Book Purchases', 'icon': Icons.book},
  {'label': 'Sales', 'icon': Icons.monetization_on},
  {'label': 'Stationary purchases', 'icon': Icons.image},
  {'label': 'Publishers', 'icon': Icons.house},
  {'label': 'Users', 'icon': Icons.account_box}
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = 0;
  bool showDBViewer = true;
  bool _isDrawerOpen = true;

  renderRightSide() {
    switch (currentPage) {
      case 0:
        return const BookPurchase();
      case 1:
        return const SalesWidget();
      case 2:
        // return const Stationary();
        return const UnderDevelopment();
      case 3:
        // return const Publishers();
        return const UnderDevelopment();
      case 4:
        return const UsersWidget();
      default:
        return const EmptyScreenWidget();
    }
  }

  void openDBViewer() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Size screenSize = MediaQuery.of(context).size;

        return Dialog(
          child: Container(
            constraints: BoxConstraints(
              minHeight: screenSize.height,
              maxWidth: screenSize.width * 0.8,
            ),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                //#pending - while scrolling, header and submit should be sticky
                child: DbViewer(),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 1,
            leading: IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () {
                  setState(() {
                    _isDrawerOpen = !_isDrawerOpen;
                  });
                }),
            actions: [
              Consumer<UserProvider>(builder: (cntx, user, _) {
                if (user.user.role == UserRole.developer) {
                  return IconButton(
                      icon: const Icon(Icons.table_view),
                      onPressed: openDBViewer);
                } else {
                  return const SizedBox.shrink();
                }
              }),
              UserProfileWidget(resetPage: () {
                setState(() {
                  currentPage = 0;
                });
              }),
              const SizedBox(width: 100)
            ]),
        body: Row(
          children: [
            AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: _isDrawerOpen ? 250.0 : 60.0,
                decoration: BoxDecoration(color: Colors.blueGrey, boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 2)
                ]),
                child: Consumer<UserProvider>(builder: (context, user, child) {
                  return ListView.builder(
                      itemCount: leftItems.length,
                      itemBuilder: (context, index) {
                        if (leftItems[index]['label'] == 'Users' &&
                            user.user.role != UserRole.admin &&
                            user.user.role != UserRole.developer) {
                          return null;
                        }

                        Color backgroundColor, textColor;
                        if (currentPage == index) {
                          backgroundColor = Colors.white;
                          textColor = Colors.blueGrey;
                        } else {
                          backgroundColor = Colors.blueGrey;
                          textColor = Colors.white;
                        }

                        return TextButton(
                            style: TextButton.styleFrom(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.all(20),
                                backgroundColor: backgroundColor,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero)),
                            onPressed: () {
                              setState(() {
                                currentPage = index;
                              });
                            },
                            child: Row(children: [
                              Icon(leftItems[index]['icon'] as IconData,
                                  color: textColor),
                              if (_isDrawerOpen) ...[
                                const SizedBox(width: 10),
                                Text(leftItems[index]['label'] as String,
                                    style: TextStyle(color: textColor))
                              ]
                            ]));
                      });
                })),
            Expanded(child: Container(child: renderRightSide()))
          ],
        ));
  }
}

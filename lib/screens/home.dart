import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vadavathoor_book_stall/components/user_profile/user_profile.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'package:vadavathoor_book_stall/screens/book_categories/index.dart';
import 'package:vadavathoor_book_stall/screens/book_purchase/index.dart';
import 'package:vadavathoor_book_stall/screens/book_stall_details.dart';
import 'package:vadavathoor_book_stall/screens/db_viewer.dart';
import 'package:vadavathoor_book_stall/screens/empty_screen.dart';
import 'package:vadavathoor_book_stall/screens/publishers/publishers.dart';
import 'package:vadavathoor_book_stall/screens/sales/index.dart';
import 'package:vadavathoor_book_stall/screens/under_development.dart';
import 'package:vadavathoor_book_stall/screens/manage_users/index.dart';

import '../providers/user.dart';

final group1 = [
  {'id': 4, 'label': 'Sales', 'icon': Icons.monetization_on},
  {'id': 3, 'label': 'Book Purchases', 'icon': Icons.book},
  {'id': 5, 'label': 'Stationary Purchases', 'icon': Icons.attach_file},
];

final group2 = [
  {'id': 6, 'label': 'Publishers', 'icon': Icons.house, 'showDivider': true},
  {'id': 7, 'label': 'Book Categories', 'icon': Icons.shelves},
];

final group3 = [
  {'id': 1, 'label': 'Users', 'icon': Icons.account_box, 'showDivider': true},
  {'id': 2, 'label': 'Book Stall Details', 'icon': Icons.add_business}
];

final int defaultPage = 4;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentPage = defaultPage;
  bool showDBViewer = true;
  bool _isDrawerOpen = true;

  renderRightSide() {
    switch (currentPage) {
      case 1:
        return const UsersWidget();
      case 2:
        return const BookStallDetailsWidget();
      case 3:
        return const BookPurchase();
      case 4:
        return const SalesWidget();
      case 5:
        return const UnderDevelopment();
      case 6:
        return const PublishersWidget();
      case 7:
        return const BookCategoriesWidget();
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
                  currentPage = defaultPage;
                });
              })
            ]),
        body: Row(children: [
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
                final items = [
                  ...group1,
                  ...group2,
                  if (user.user.role == UserRole.admin ||
                      user.user.role == UserRole.developer)
                    ...group3
                ];

                return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      Color backgroundColor, textColor;
                      if (currentPage == items[index]['id']) {
                        backgroundColor = Colors.white;
                        textColor = Colors.blueGrey;
                      } else {
                        backgroundColor = Colors.blueGrey;
                        textColor = Colors.white;
                      }

                      return Column(
                        children: [
                          if (items[index]['showDivider'] == true)
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child:
                                    Container(height: 1, color: Colors.grey)),
                          TextButton(
                              style: TextButton.styleFrom(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.all(20),
                                  backgroundColor: backgroundColor,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.zero)),
                              onPressed: () {
                                setState(() {
                                  currentPage = items[index]['id']! as int;
                                });
                              },
                              child: Row(children: [
                                Icon(items[index]['icon'] as IconData,
                                    color: textColor),
                                if (_isDrawerOpen) ...[
                                  const SizedBox(width: 10),
                                  Text(items[index]['label'] as String,
                                      style: TextStyle(color: textColor))
                                ]
                              ])),
                        ],
                      );
                    });
              })),
          Expanded(child: Container(child: renderRightSide()))
        ]));
  }
}

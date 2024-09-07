import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/screens/manage_users/batch.dart';
import 'package:vadavathoor_book_stall/screens/manage_users/users.dart';

class ManageUsersIndexWidget extends StatefulWidget {
  const ManageUsersIndexWidget({super.key});

  @override
  State<ManageUsersIndexWidget> createState() => _ManageUsersIndexState();
}

class _ManageUsersIndexState extends State<ManageUsersIndexWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DefaultTabController(
          length: 2,
          child: Column(children: [
            TabBar(
              tabs: [Tab(text: 'Users'), Tab(text: 'Batches')],
              dividerHeight: 0,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: TabBarView(children: [UsersWidget(), UserBatchWidget()]))
          ])),
    );
  }
}

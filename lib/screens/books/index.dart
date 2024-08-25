import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/screens/books/authors.dart';

import 'books.dart';
import 'categories.dart';
import 'publishers.dart';

class BookHomeWidget extends StatefulWidget {
  const BookHomeWidget({super.key});

  @override
  State<BookHomeWidget> createState() => _BookHomeState();
}

class _BookHomeState extends State<BookHomeWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: DefaultTabController(
          length: 4,
          child: Column(children: [
            TabBar(
              tabs: [
                Tab(text: 'Books'),
                Tab(text: 'Authors'),
                Tab(text: 'Publishers'),
                Tab(text: 'Categories')
              ],
              dividerHeight: 0,
              indicatorSize: TabBarIndicatorSize.tab,
              unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
              labelStyle: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
                child: TabBarView(children: [
              BooksWidget(),
              AuthorsWidget(),
              PublishersWidget(),
              BookCategoriesWidget()
            ]))
          ])),
    );
  }
}

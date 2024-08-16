import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'package:vadavathoor_book_stall/db/functions/book_category.dart';
import 'package:vadavathoor_book_stall/db/functions/publisher.dart';
import 'package:vadavathoor_book_stall/db/models/book_category.dart';
import 'package:vadavathoor_book_stall/screens/book_categories/edit_category.dart';

class BookCategoriesWidget extends StatefulWidget {
  const BookCategoriesWidget({super.key});

  @override
  State<BookCategoriesWidget> createState() => _BookCategoriesState();
}

class _BookCategoriesState extends State<BookCategoriesWidget> {
  final _nameController = TextEditingController();
  List<BookCategoryModel> categories = [];

  void add() async {
    final name = _nameController.text.trim();
    if (name != '') {
      await addBookCategory(name);
      _nameController.clear();
      setData();
    }
  }

  onPressEdit(BookCategoryModel selectedItem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        Size screenSize = MediaQuery.of(context).size;

        return Dialog(
          child: Container(
            constraints: BoxConstraints(
              minHeight: screenSize.height * 0.2,
              maxWidth: screenSize.width * 0.4,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: EditBookCategoryWidget(
                    data: selectedItem,
                    updateUI: () {
                      setData();
                      Navigator.of(context).pop();
                    }),
              ),
            ),
          ),
        );
      },
    );
  }

  onPressDelete(String selectedID) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await editBookCategory(
                    categoryID: selectedID, status: DBRowStatus.deleted);
                setData();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void setData() async {
    final temp = await getBookCategories();
    setState(() {
      categories = temp;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Row(children: [
            Expanded(
                child: TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Category Name'),
                    controller: _nameController)),
            const SizedBox(width: 20),
            ElevatedButton(
                style:
                    ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                onPressed: add,
                child: const Text('Add', style: TextStyle(color: Colors.white)))
          ]),
          const SizedBox(height: 20),
          const Text('Book Categories',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          const Row(
            children: [
              Text('Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(width: 80)
            ],
          ),
          Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.2, color: Colors.blueGrey)))),
          Expanded(
              child: categories.isNotEmpty
                  ? ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) => Row(children: [
                            Expanded(
                                child: Text(categories[index].categoryName)),
                            IconButton(
                                icon: const Icon(Icons.edit),
                                tooltip: 'Edit',
                                onPressed: () {
                                  onPressEdit(categories[index]);
                                }),
                            IconButton(
                                icon: const Icon(Icons.delete),
                                tooltip: 'Delete',
                                onPressed: () {
                                  onPressDelete(categories[index].categoryID);
                                })
                          ]))
                  : const Text("No records found"))
        ]));
  }
}

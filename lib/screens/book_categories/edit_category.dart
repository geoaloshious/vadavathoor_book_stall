import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/db/functions/book_category.dart';
import 'package:vadavathoor_book_stall/db/functions/publisher.dart';
import 'package:vadavathoor_book_stall/db/models/book_category.dart';

enum UserModalMode { add, edit }

class EditBookCategoryWidget extends StatefulWidget {
  final BookCategoryModel data;
  final void Function() updateUI;

  const EditBookCategoryWidget(
      {super.key, required this.data, required this.updateUI});

  @override
  State<EditBookCategoryWidget> createState() => _EditBookCategoryState();
}

class _EditBookCategoryState extends State<EditBookCategoryWidget> {
  TextEditingController _nameController = TextEditingController();

  Map<String, bool> inputErrors = {};

  void _saveData() async {
    final name = _nameController.text.trim();

    Map<String, bool> tempInputErrors = {};

    if (name.isEmpty) {
      tempInputErrors['name'] = true;
    }

    if (tempInputErrors.isEmpty) {
      await editBookCategory(
          categoryID: widget.data.categoryID, categoryName: name);
      widget.updateUI();
    } else {
      setState(() {
        inputErrors = tempInputErrors;
      });
    }
  }

  void setData() {
    _nameController = TextEditingController(text: widget.data.categoryName);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Edit Category',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Close',
                onPressed: () {
                  Navigator.of(context).pop();
                }),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  border: const OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                      borderSide: inputErrors['name'] == true
                          ? const BorderSide(color: Colors.red, width: 1)
                          : const BorderSide(color: Colors.grey, width: 1)),
                ),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'name': false};
                  });
                },
              ),
            )
          ],
        ),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: _saveData, child: const Text('Submit')),
      ],
    );
  }
}
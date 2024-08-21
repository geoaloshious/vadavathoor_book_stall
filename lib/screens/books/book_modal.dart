import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/classes/books.dart';
import 'package:vadavathoor_book_stall/components/modal_close_confirmation.dart';
import 'package:vadavathoor_book_stall/db/functions/book_author.dart';
import 'package:vadavathoor_book_stall/db/functions/book_category.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/book_author.dart';
import 'package:vadavathoor_book_stall/db/models/book_category.dart';
import 'package:vadavathoor_book_stall/db/models/book_publisher.dart';

import '../../components/drop_down.dart';
import '../../db/functions/book.dart';
import '../../db/functions/publisher.dart';

class BookModalWidget extends StatefulWidget {
  final BookListItemModel? data;
  final void Function() updateUI;

  const BookModalWidget({super.key, this.data, required this.updateUI});

  @override
  State<BookModalWidget> createState() => _BookModalState();
}

class _BookModalState extends State<BookModalWidget> {
  TextEditingController _bookNameController = TextEditingController();
  TextEditingController _authorNameController = TextEditingController();
  TextEditingController _publisherController = TextEditingController();
  TextEditingController _categoryNameController = TextEditingController();

  String _authorID = '';
  String _publisherID = '';
  String _categoryID = '';
  bool _isExistingAuthor = false;
  bool _isExistingCategory = false;
  bool _isExistingPublisher = false;
  Map<String, bool> inputErrors = {};

  List<BookAuthorModel> authors = [];
  List<PublisherModel> publishers = [];
  List<BookCategoryModel> bookCategories = [];

  void _saveData() async {
    final bookName = _bookNameController.text.trim();
    final authorName = _authorNameController.text.trim();
    final publisherName = _publisherController.text.trim();
    final categoryName = _categoryNameController.text.trim();

    Map<String, bool> tempInputErrors = {};

    if (bookName == '') {
      tempInputErrors['bookName'] = true;
    }

    if (_isExistingAuthor) {
      if (_authorID == '') {
        tempInputErrors['authorName'] = true;
      }
    } else {
      if (authorName == '') {
        tempInputErrors['authorName'] = true;
      }
    }

    if (_isExistingPublisher) {
      if (_publisherID == '') {
        tempInputErrors['publisherName'] = true;
      }
    } else {
      if (publisherName == '') {
        tempInputErrors['publisherName'] = true;
      }
    }

    if (_isExistingCategory) {
      if (_categoryID == '') {
        tempInputErrors['categoryName'] = true;
      }
    } else {
      if (categoryName == '') {
        tempInputErrors['categoryName'] = true;
      }
    }

    if (tempInputErrors.isEmpty) {
      if (widget.data != null) {
        await editBook(widget.data!.bookID, bookName, _authorID, authorName,
            _publisherID, publisherName, _categoryID, categoryName);
      } else {
        await addBook(bookName, _authorID, authorName, _publisherID,
            publisherName, _categoryID, categoryName);
      }

      widget.updateUI();
      Navigator.of(context).pop();
    } else {
      setState(() {
        inputErrors = tempInputErrors;
      });
    }
  }

  void setData() async {
    if (widget.data != null) {
      setState(() {
        _isExistingAuthor = true;
        _isExistingCategory = true;
        _isExistingPublisher = true;

        _authorID = widget.data!.authorID;
        _publisherID = widget.data!.publisherID;
        _categoryID = widget.data!.categoryID;
      });

      _bookNameController = TextEditingController(text: widget.data!.bookName);
      _authorNameController =
          TextEditingController(text: widget.data!.authorName);
      _publisherController =
          TextEditingController(text: widget.data!.publisherName);
      _categoryNameController =
          TextEditingController(text: widget.data!.categoryName);
    }

    final tempAuthors = await getBookAuthors();
    final tempPubs = await getPublishers();
    final tempCatgs = await getBookCategories();

    setState(() {
      authors = tempAuthors;
      publishers = tempPubs;
      bookCategories = tempCatgs;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('${widget.data == null ? 'Add' : 'Edit'} Book',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
        IconButton(
            icon: const Icon(Icons.close),
            tooltip: 'Close',
            onPressed: () {
              showModalCloseConfirmation(context);
            }),
      ]),
      const SizedBox(height: 10.0),
      Row(children: [
        Expanded(
            child: CheckboxListTile(
                title: const Text('Existing Author'),
                value: _isExistingAuthor,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _isExistingAuthor = value ?? false;
                    _authorID = '';
                  });
                })),
        Expanded(
            child: CheckboxListTile(
                title: const Text('Existing Publisher'),
                value: _isExistingPublisher,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _isExistingPublisher = value ?? false;
                    _publisherID = '';
                  });
                })),
        Expanded(
            child: CheckboxListTile(
                title: const Text('Existing Category'),
                value: _isExistingCategory,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _isExistingCategory = value ?? false;
                    _categoryID = '';
                  });
                }))
      ]),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(
            child: TextField(
                controller: _bookNameController,
                decoration: InputDecoration(
                    labelText: 'Book name',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: inputErrors['bookName'] == true
                            ? const BorderSide(color: Colors.red, width: 1)
                            : const BorderSide(color: Colors.grey, width: 1))),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'bookName': false};
                  });
                })),
        const SizedBox(width: 16.0),
        Expanded(
            child: _isExistingAuthor
                ? CustomDropdown(
                    items: authors.map((i) => i.toDropdownData()).toList(),
                    selectedValue: _authorID,
                    label: 'Select Author',
                    hasError: inputErrors['authorName'] == true,
                    onValueChanged: (value) {
                      setState(() {
                        _authorID = value;
                        inputErrors = {...inputErrors, 'authorName': false};
                      });
                    })
                : TextField(
                    controller: _authorNameController,
                    decoration: InputDecoration(
                        labelText: 'Author name',
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: inputErrors['authorName'] == true
                                ? const BorderSide(color: Colors.red, width: 1)
                                : const BorderSide(
                                    color: Colors.grey, width: 1))),
                    onChanged: (value) {
                      setState(() {
                        inputErrors = {...inputErrors, 'authorName': false};
                      });
                    }))
      ]),
      const SizedBox(height: 20),
      Row(children: [
        Expanded(
            child: _isExistingPublisher
                ? CustomDropdown(
                    items: publishers.map((i) => i.toDropdownData()).toList(),
                    selectedValue: _publisherID,
                    label: 'Select Publisher',
                    hasError: inputErrors['publisherName'] == true,
                    onValueChanged: (value) {
                      setState(() {
                        _publisherID = value;
                        inputErrors = {...inputErrors, 'publisherName': false};
                      });
                    })
                : TextField(
                    controller: _publisherController,
                    decoration: InputDecoration(
                        labelText: 'Publisher name',
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: inputErrors['publisherName'] == true
                                ? const BorderSide(color: Colors.red, width: 1)
                                : const BorderSide(
                                    color: Colors.grey, width: 1))),
                    onChanged: (value) {
                      setState(() {
                        inputErrors = {...inputErrors, 'publisherName': false};
                      });
                    })),
        const SizedBox(width: 16.0),
        Expanded(
            child: _isExistingCategory
                ? CustomDropdown(
                    items:
                        bookCategories.map((i) => i.toDropdownData()).toList(),
                    selectedValue: _categoryID,
                    label: 'Select Category',
                    hasError: inputErrors['categoryName'] == true,
                    onValueChanged: (value) {
                      setState(() {
                        _categoryID = value;
                        inputErrors = {...inputErrors, 'categoryName': false};
                      });
                    })
                : TextField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                        labelText: 'Category name',
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: inputErrors['categoryName'] == true
                                ? const BorderSide(color: Colors.red, width: 1)
                                : const BorderSide(
                                    color: Colors.grey, width: 1))),
                    onChanged: (value) {
                      setState(() {
                        inputErrors = {...inputErrors, 'categoryName': false};
                      });
                    }))
      ]),
      const SizedBox(height: 20.0),
      ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
          onPressed: _saveData,
          child: const Text('Submit', style: TextStyle(color: Colors.white)))
    ]);
  }
}

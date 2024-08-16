import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:vadavathoor_book_stall/db/functions/book_category.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/book_category.dart';
import 'package:vadavathoor_book_stall/db/models/book_publisher.dart';

import '../../classes.dart';
import '../../components/drop_down.dart';
import '../../db/functions/book.dart';
import '../../db/functions/book_purchase.dart';
import '../../db/functions/publisher.dart';

class EditBookPurchaseWidget extends StatefulWidget {
  final BookPurchaseListItemModel data;
  final void Function() updateUI;

  const EditBookPurchaseWidget(
      {super.key, required this.data, required this.updateUI});

  @override
  State<EditBookPurchaseWidget> createState() => _EditBookPurchaseState();
}

class _EditBookPurchaseState extends State<EditBookPurchaseWidget> {
  var _publisherController = TextEditingController();
  var _bookNameController = TextEditingController();
  var _categoryNameController = TextEditingController();
  var _quantityController = TextEditingController();
  var _priceController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _publisherID = '';
  String _bookID = '';
  String _categoryID = '';
  bool _isExistingCategory = true;
  bool _isExistingPublisher = true;
  bool _isExistingBook = true;
  Map<String, bool> inputErrors = {};

  List<PublisherModel> publishers = [];
  List<BookModel> books = [];
  List<BookCategoryModel> bookCategories = [];

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }

    //#pending - do we need an option to pick time
    // final TimeOfDay? timePicked = await showTimePicker(
    //     context: context, initialTime: TimeOfDay.fromDateTime(_selectedDate));
  }

  void _saveData() async {
    final publisherName = _publisherController.text.trim();
    final bookName = _bookNameController.text.trim();
    final categoryName = _categoryNameController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final purchaseDate = _selectedDate.millisecondsSinceEpoch;

    Map<String, bool> tempInputErrors = {};

    if (_isExistingPublisher) {
      if (_publisherID == '') {
        tempInputErrors['publisherName'] = true;
      }
    } else {
      if (publisherName == '') {
        tempInputErrors['publisherName'] = true;
      }
    }

    if (_isExistingBook) {
      if (_bookID == '') {
        tempInputErrors['bookName'] = true;
      }
    } else {
      if (bookName == '') {
        tempInputErrors['bookName'] = true;
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

    if (quantity == 0) {
      tempInputErrors['quantity'] = true;
    }

    if (price == 0) {
      tempInputErrors['bookPrice'] = true;
    }

    if (tempInputErrors.isEmpty) {
      await editBookPurchase(
          widget.data.purchaseID,
          _publisherID,
          publisherName,
          _bookID,
          bookName,
          _categoryID,
          categoryName,
          quantity,
          price,
          purchaseDate);

      widget.updateUI();
      Navigator.of(context).pop();
    } else {
      setState(() {
        inputErrors = tempInputErrors;
      });
    }
  }

  void setData() async {
    _bookID = widget.data.bookID;
    _publisherID = widget.data.publisherID;
    _categoryID = widget.data.categoryID;
    _selectedDate =
        DateTime.fromMillisecondsSinceEpoch(widget.data.purchaseDate);
    _publisherController =
        TextEditingController(text: widget.data.publisherName);
    _bookNameController = TextEditingController(text: widget.data.bookName);
    _categoryNameController =
        TextEditingController(text: widget.data.categoryName);
    _quantityController =
        TextEditingController(text: widget.data.quantityPurchased.toString());
    _priceController =
        TextEditingController(text: widget.data.bookPrice.toString());

    final tempPubs = await getPublishers();
    final tempBooks = await getBooks();
    final tempCatgs = await getBookCategories();

    setState(() {
      publishers = tempPubs;
      books = tempBooks;
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
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Edit Purchase',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Close',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirmation'),
                        content:
                            const Text('Are you sure you want to discard?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text('Discard'),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ],
        ),
        Row(
          children: [
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
                },
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text('Existing Book'),
                value: _isExistingBook,
                controlAffinity: ListTileControlAffinity.leading,
                onChanged: (bool? value) {
                  setState(() {
                    _isExistingBook = value ?? false;
                    _bookID = '';
                  });
                },
              ),
            ),
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
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
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
                          inputErrors = {
                            ...inputErrors,
                            'publisherName': false
                          };
                        });
                      },
                    )
                  : TextField(
                      controller: _publisherController,
                      decoration: InputDecoration(
                        labelText: 'Publisher name',
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: inputErrors['publisherName'] == true
                                ? const BorderSide(color: Colors.red, width: 1)
                                : const BorderSide(
                                    color: Colors.grey, width: 1)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          inputErrors = {
                            ...inputErrors,
                            'publisherName': false
                          };
                        });
                      },
                    ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: _isExistingBook
                  ? CustomDropdown(
                      items: books.map((i) => i.toDropdownData()).toList(),
                      selectedValue: _bookID,
                      label: 'Select Book',
                      hasError: inputErrors['bookName'] == true,
                      onValueChanged: (value) {
                        setState(() {
                          _bookID = value;
                          inputErrors = {...inputErrors, 'bookName': false};
                        });
                      },
                    )
                  : TextField(
                      controller: _bookNameController,
                      decoration: InputDecoration(
                        labelText: 'Book name',
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: inputErrors['bookName'] == true
                                ? const BorderSide(color: Colors.red, width: 1)
                                : const BorderSide(
                                    color: Colors.grey, width: 1)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          inputErrors = {...inputErrors, 'bookName': false};
                        });
                      },
                    ),
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: _isExistingCategory
                  ? CustomDropdown(
                      items: bookCategories
                          .map((i) => i.toDropdownData())
                          .toList(),
                      selectedValue: _categoryID,
                      label: 'Select Category',
                      hasError: inputErrors['categoryName'] == true,
                      onValueChanged: (value) {
                        setState(() {
                          _categoryID = value;
                          inputErrors = {...inputErrors, 'categoryName': false};
                        });
                      },
                    )
                  : TextField(
                      controller: _categoryNameController,
                      decoration: InputDecoration(
                        labelText: 'Category name',
                        border: const OutlineInputBorder(),
                        enabledBorder: OutlineInputBorder(
                            borderSide: inputErrors['categoryName'] == true
                                ? const BorderSide(color: Colors.red, width: 1)
                                : const BorderSide(
                                    color: Colors.grey, width: 1)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          inputErrors = {...inputErrors, 'categoryName': false};
                        });
                      },
                    ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _quantityController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              decoration: InputDecoration(
                labelText: 'Quantity',
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                    borderSide: inputErrors['quantity'] == true
                        ? const BorderSide(color: Colors.red, width: 1)
                        : const BorderSide(color: Colors.grey, width: 1)),
              ),
              onChanged: (value) {
                setState(() {
                  inputErrors = {...inputErrors, 'quantity': false};
                });
              },
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: TextField(
              controller: _priceController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
              ],
              decoration: InputDecoration(
                labelText: 'Book price',
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                    borderSide: inputErrors['bookPrice'] == true
                        ? const BorderSide(color: Colors.red, width: 1)
                        : const BorderSide(color: Colors.grey, width: 1)),
              ),
              onChanged: (value) {
                setState(() {
                  inputErrors = {...inputErrors, 'bookPrice': false};
                });
              },
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
              child: GestureDetector(
                  onTap: _selectDate,
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Purchase Date',
                      suffixIcon: Icon(Icons.calendar_today),
                      border: OutlineInputBorder(),
                    ),
                    child: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                  )))
        ]),
        const SizedBox(height: 20.0),
        ElevatedButton(onPressed: _saveData, child: const Text('Submit')),
      ],
    );
  }
}

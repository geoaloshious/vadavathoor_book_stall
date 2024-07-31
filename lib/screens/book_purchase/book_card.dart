import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vadavathoor_book_stall/classes.dart';
import 'package:vadavathoor_book_stall/components/drop_down.dart';
import 'package:vadavathoor_book_stall/db/functions/book.dart';
import 'package:vadavathoor_book_stall/db/functions/book_purchase.dart';
import 'package:vadavathoor_book_stall/db/functions/publisher.dart';

class BookCard extends StatefulWidget {
  final BookPurchaseListItemModel data;

  const BookCard({super.key, required this.data});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  TextEditingController _publisherController = TextEditingController();
  TextEditingController _bookNameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  Map<String, bool> inputErrors = {};
  bool editMode = false;
  String _publisherID = '';
  String _bookID = '';
  bool _isPublisherChecked = true;
  bool _isBookChecked = true;

  void _saveData() {
    final publisherName = _publisherController.text.trim();
    final bookName = _bookNameController.text.trim();
    final quantity = _quantityController.text.trim();
    final price = _priceController.text.trim();

    Map<String, bool> tempInputErrors = {};

    if (_isPublisherChecked) {
      if (_publisherID == '') {
        tempInputErrors['publisherName'] = true;
      }
    } else {
      if (publisherName == '') {
        tempInputErrors['publisherName'] = true;
      }
    }

    if (_isBookChecked) {
      if (_bookID == '') {
        tempInputErrors['bookName'] = true;
      }
    } else {
      if (bookName == '') {
        tempInputErrors['bookName'] = true;
      }
    }

    if (quantity == '' || quantity == '0') {
      tempInputErrors['quantity'] = true;
    }

    if (price == '' || double.tryParse(price) == 0) {
      tempInputErrors['bookPrice'] = true;
    }

    setState(() {
      if (tempInputErrors.isEmpty) {
        editBookPurchase(widget.data.purchaseID, _publisherID, publisherName,
            _bookID, bookName, quantity, price);
        editMode = false;
      } else {
        inputErrors = tempInputErrors;
      }
    });
  }

  void _deletePurchase() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this purchase?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                deleteBookPurchase(widget.data.purchaseID);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void setData() {
    _bookID = widget.data.bookID;
    _publisherID = widget.data.publisherID;
    _publisherController =
        TextEditingController(text: widget.data.publisherName);
    _bookNameController = TextEditingController(text: widget.data.bookName);
    _quantityController = TextEditingController(text: widget.data.quantity);
    _priceController = TextEditingController(text: widget.data.bookPrice);
  }

  @override
  void initState() {
    super.initState();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: editMode,
                    child: Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('Existing Publisher'),
                            value: _isPublisherChecked,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? value) {
                              setState(() {
                                _isPublisherChecked = value ?? false;
                                _publisherID = '';
                              });
                            },
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('Existing Book'),
                            value: _isBookChecked,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (bool? value) {
                              setState(() {
                                _isBookChecked = value ?? false;
                                _bookID = '';
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6.0),
                  Row(
                    children: [
                      Expanded(
                          child: _isPublisherChecked
                              ? ValueListenableBuilder(
                                  valueListenable: publishersNotifier,
                                  builder: (ctx, publishers, child) {
                                    return CustomDropdown(
                                      items: publishers
                                          .map((i) => i.toDropdownData())
                                          .toList(),
                                      selectedValue: _publisherID,
                                      label: 'Select Publisher',
                                      hasError:
                                          inputErrors['publisherName'] == true,
                                      disabled: !editMode,
                                      onValueChanged: (value) {
                                        setState(() {
                                          _publisherID = value;
                                          inputErrors = {
                                            ...inputErrors,
                                            'publisherName': false
                                          };
                                        });
                                      },
                                    );
                                  })
                              : TextField(
                                  enabled: editMode,
                                  controller: _publisherController,
                                  onChanged: (value) {
                                    setState(() {
                                      inputErrors = {
                                        ...inputErrors,
                                        'publisherName': false
                                      };
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Publisher name',
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                inputErrors['publisherName'] ==
                                                        true
                                                    ? Colors.red
                                                    : Colors.grey,
                                            width: 1)),
                                  ))),
                      const SizedBox(width: 8),
                      Expanded(
                          child: _isBookChecked
                              ? ValueListenableBuilder(
                                  valueListenable: booksNotifier,
                                  builder: (ctx, books, child) {
                                    return CustomDropdown(
                                      items: books
                                          .map((i) => i.toDropdownData())
                                          .toList(),
                                      selectedValue: _bookID,
                                      label: 'Select Book',
                                      hasError: inputErrors['bookName'] == true,
                                      disabled: !editMode,
                                      onValueChanged: (value) {
                                        setState(() {
                                          _bookID = value;
                                          inputErrors = {
                                            ...inputErrors,
                                            'bookName': false
                                          };
                                        });
                                      },
                                    );
                                  })
                              : TextField(
                                  enabled: editMode,
                                  controller: _bookNameController,
                                  onChanged: (value) {
                                    setState(() {
                                      inputErrors = {
                                        ...inputErrors,
                                        'bookName': false
                                      };
                                    });
                                  },
                                  decoration: InputDecoration(
                                    labelText: 'Book name',
                                    enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color:
                                                inputErrors['bookName'] == true
                                                    ? Colors.red
                                                    : Colors.grey,
                                            width: 1)),
                                  )))
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          enabled: editMode,
                          controller: _quantityController,
                          onChanged: (value) {
                            setState(() {
                              inputErrors = {...inputErrors, 'quantity': false};
                            });
                          },
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            labelText: 'Quantity',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: inputErrors['quantity'] == true
                                    ? const BorderSide(
                                        color: Colors.red, width: 2)
                                    : const BorderSide(
                                        color: Colors.grey, width: 1)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextField(
                          enabled: editMode,
                          controller: _priceController,
                          onChanged: (value) {
                            setState(() {
                              inputErrors = {
                                ...inputErrors,
                                'bookPrice': false
                              };
                            });
                          },
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d*')),
                          ],
                          decoration: InputDecoration(
                            labelText: 'Book price',
                            enabledBorder: UnderlineInputBorder(
                                borderSide: inputErrors['bookPrice'] == true
                                    ? const BorderSide(
                                        color: Colors.red, width: 2)
                                    : const BorderSide(
                                        color: Colors.grey, width: 1)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.delete),
                  tooltip: 'Delete',
                  onPressed: _deletePurchase,
                ),
                IconButton(
                  icon: Icon(editMode ? Icons.edit_off : Icons.edit),
                  tooltip: editMode ? 'Discard' : 'Edit',
                  onPressed: () {
                    setState(() {
                      if (editMode) {
                        setData();
                        inputErrors = {};
                        _isPublisherChecked = true;
                        _isBookChecked = true;
                      }

                      editMode = !editMode;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.save),
                  tooltip: 'Save',
                  onPressed: () {
                    if (editMode) {
                      _saveData();
                    }
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

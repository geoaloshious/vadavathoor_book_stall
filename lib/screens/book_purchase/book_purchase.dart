import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:vadavathoor_book_stall/components/drop_down.dart';
import 'package:vadavathoor_book_stall/db/functions/book.dart';
import 'package:vadavathoor_book_stall/db/functions/book_purchase.dart';
import 'package:vadavathoor_book_stall/db/functions/publisher.dart';
import 'package:vadavathoor_book_stall/screens/book_purchase/book_card.dart';

class BookPurchase extends StatefulWidget {
  const BookPurchase({super.key});

  @override
  State<BookPurchase> createState() => _BookPurchaseState();
}

class _BookPurchaseState extends State<BookPurchase> {
  final _publisherController = TextEditingController();
  final _bookNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _publisherID = '';
  String _bookID = '';
  bool _isPublisherChecked = false;
  bool _isBookChecked = false;
  Map<String, bool> inputErrors = {};

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
  }

  void _addBook() {
    final publisherName = _publisherController.text.trim();
    final bookName = _bookNameController.text.trim();
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final price = double.tryParse(_priceController.text.trim()) ?? 0;

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

    if (quantity == 0) {
      tempInputErrors['quantity'] = true;
    }

    if (price == 0) {
      tempInputErrors['bookPrice'] = true;
    }

    setState(() {
      if (tempInputErrors.isEmpty) {
        addBookPurchase(
            _publisherID,
            publisherName,
            _selectedDate.millisecondsSinceEpoch,
            _bookID,
            bookName,
            price,
            quantity);

        _publisherController.clear();
        _bookNameController.clear();
        _quantityController.clear();
        _priceController.clear();

        _bookID = '';
        _publisherID = '';
      } else {
        inputErrors = tempInputErrors;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    updatePublishersList();
    updateBooksList();
    updateBookPurchaseList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
            const SizedBox(height: 10.0),
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
                            );
                          })
                      : TextField(
                          controller: _publisherController,
                          decoration: InputDecoration(
                            labelText: 'Publisher name',
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: inputErrors['publisherName'] == true
                                    ? const BorderSide(
                                        color: Colors.red, width: 1)
                                    : const BorderSide(
                                        color: Colors.grey, width: 1)),
                            // Add auto-suggestion functionality here
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
                  child: _isBookChecked
                      ? ValueListenableBuilder(
                          valueListenable: booksNotifier,
                          builder: (ctx, books, child) {
                            return CustomDropdown(
                              items:
                                  books.map((i) => i.toDropdownData()).toList(),
                              selectedValue: _bookID,
                              label: 'Select Book',
                              hasError: inputErrors['bookName'] == true,
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
                          controller: _bookNameController,
                          decoration: InputDecoration(
                            labelText: 'Book name',
                            border: const OutlineInputBorder(),
                            enabledBorder: OutlineInputBorder(
                                borderSide: inputErrors['bookName'] == true
                                    ? const BorderSide(
                                        color: Colors.red, width: 1)
                                    : const BorderSide(
                                        color: Colors.grey, width: 1)),
                            // Add auto-suggestion functionality here
                          ),
                          onChanged: (value) {
                            setState(() {
                              inputErrors = {...inputErrors, 'bookName': false};
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
                      child:
                          Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                    ),
                  ),
                ),
                // const SizedBox(width: 16.0),
                // IconButton(
                //   icon: const Icon(Icons.add),
                //   onPressed: _addBook,
                // ),
              ],
            ),

            const SizedBox(height: 10.0),
            ElevatedButton(onPressed: _addBook, child: const Text('Submit')),
            const SizedBox(height: 20.0),

            Expanded(
                child: ValueListenableBuilder(
                    valueListenable: purchaseNotifier,
                    builder: (ctx, purchases, child) => ListView.builder(
                        itemCount: purchases.length,
                        itemBuilder: (context, index) =>
                            BookCard(data: purchases[index]))))

            // const SizedBox(height: 16.0),
            // ElevatedButton(
            //   onPressed: _addAttachment,
            //   child: const Text('Add Attachment'),
            // ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:vadavathoor_book_stall/components/modal_close_confirmation.dart';
import 'package:vadavathoor_book_stall/db/functions/book_category.dart';
import 'package:vadavathoor_book_stall/db/models/book.dart';
import 'package:vadavathoor_book_stall/db/models/book_category.dart';
import 'package:vadavathoor_book_stall/db/models/book_publisher.dart';

import '../../classes.dart';
import '../../components/drop_down.dart';
import '../../db/functions/book.dart';
import '../../db/functions/book_purchase.dart';
import '../../db/functions/publisher.dart';

class BookPurchaseModalWidget extends StatefulWidget {
  final BookPurchaseListItemModel? data;
  final void Function() updateUI;

  const BookPurchaseModalWidget({super.key, this.data, required this.updateUI});

  @override
  State<BookPurchaseModalWidget> createState() => _BookPurchaseModalState();
}

class _BookPurchaseModalState extends State<BookPurchaseModalWidget> {
  var _quantityController = TextEditingController();
  var _priceController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  String _bookID = '';
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
    final quantity = int.tryParse(_quantityController.text.trim()) ?? 0;
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final purchaseDate = _selectedDate.millisecondsSinceEpoch;

    Map<String, bool> tempInputErrors = {};

    if (quantity == 0) {
      tempInputErrors['quantity'] = true;
    }

    if (price == 0) {
      tempInputErrors['bookPrice'] = true;
    }

    if (tempInputErrors.isEmpty) {
      if (widget.data != null) {
        editBookPurchase(
                widget.data!.purchaseID, _bookID, quantity, price, purchaseDate)
            .then((res) {
          if (res['message'] == null) {
            widget.updateUI();
            Navigator.of(context).pop();
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                      title: const Text('Error'),
                      content: Text(res['message']!),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('OK'))
                      ]);
                });
          }
        });
      } else {
        await addBookPurchase(_bookID, purchaseDate, price, quantity);
        widget.updateUI();
        Navigator.of(context).pop();
      }
    } else {
      setState(() {
        inputErrors = tempInputErrors;
      });
    }
  }

  void setData() async {
    if (widget.data != null) {
      _bookID = widget.data!.bookID;

      _selectedDate =
          DateTime.fromMillisecondsSinceEpoch(widget.data!.purchaseDate);

      _quantityController = TextEditingController(
          text: widget.data!.quantityPurchased.toString());
      _priceController =
          TextEditingController(text: widget.data!.bookPrice.toString());
    }

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
    return Column(children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text('${widget.data == null ? 'Add' : 'Edit'} Purchase',
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
            child: CustomDropdown(
                items: books.map((i) => i.toDropdownData()).toList(),
                selectedValue: _bookID,
                label: 'Select Book',
                hasError: inputErrors['book'] == true,
                onValueChanged: (value) {
                  if (_bookID != value) {
                    setState(() {
                      _bookID = value;
                      inputErrors = {...inputErrors, 'book': false};
                    });
                  }
                })),
        const SizedBox(width: 16.0),
        Expanded(
            child: TextField(
                controller: _quantityController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    labelText: 'Quantity',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: inputErrors['quantity'] == true
                            ? const BorderSide(color: Colors.red, width: 1)
                            : const BorderSide(color: Colors.grey, width: 1))),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'quantity': false};
                  });
                }))
      ]),
      const SizedBox(height: 20.0),
      Row(children: [
        Expanded(
            child: TextField(
                controller: _priceController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))
                ],
                decoration: InputDecoration(
                    labelText: 'Book price',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: inputErrors['bookPrice'] == true
                            ? const BorderSide(color: Colors.red, width: 1)
                            : const BorderSide(color: Colors.grey, width: 1))),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'bookPrice': false};
                  });
                })),
        const SizedBox(width: 16.0),
        Expanded(
            child: GestureDetector(
                onTap: _selectDate,
                child: InputDecorator(
                    decoration: const InputDecoration(
                        labelText: 'Purchase Date',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder()),
                    child:
                        Text(DateFormat('yyyy-MM-dd').format(_selectedDate)))))
      ]),
      const SizedBox(height: 20.0),
      ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
          onPressed: _saveData,
          child: const Text('Submit', style: TextStyle(color: Colors.white)))
    ]);
  }
}

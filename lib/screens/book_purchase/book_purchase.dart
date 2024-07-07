import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:vadavathoor_book_stall/screens/book_purchase/book_card.dart';

class BookPurchase extends StatefulWidget {
  const BookPurchase({super.key});

  @override
  State<BookPurchase> createState() => _BookPurchaseState();
}

class _BookPurchaseState extends State<BookPurchase> {
  final List<Map<String, dynamic>> _books = [];
  final _publisherController = TextEditingController();
  final _bookNameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

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
    final bookName = _bookNameController.text;
    final quantity = _quantityController.text;
    final price = _priceController.text;

    Map<String, bool> tempInputErrors = {};

    if (bookName == '') {
      tempInputErrors['bookName'] = true;
    }

    if (quantity == '' || quantity == '0') {
      tempInputErrors['quantity'] = true;
    }

    if (price == '' || double.tryParse(price) == 0) {
      tempInputErrors['bookPrice'] = true;
    }

    setState(() {
      if (tempInputErrors.isEmpty) {
        _books.add({
          'bookName': bookName,
          'quantity': quantity,
          'bookPrice': price,
        });

        _bookNameController.clear();
        _quantityController.clear();
        _priceController.clear();
      } else {
        inputErrors = tempInputErrors;
      }
    });
  }

  void _addAttachment() {
    // Implement file upload functionality here
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
                  flex: 2,
                  child: TextField(
                    controller: _publisherController,
                    decoration: const InputDecoration(
                      labelText: 'Publisher',
                      suffixIcon: Icon(Icons.arrow_drop_down),
                    ),
                    // Add auto-suggestion functionality here
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: _selectDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        suffixIcon: Icon(Icons.calendar_today),
                        border: OutlineInputBorder(),
                      ),
                      child:
                          Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _bookNameController,
                    decoration: InputDecoration(
                      labelText: 'Book name',
                      suffixIcon: const Icon(Icons.arrow_drop_down),
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: inputErrors['bookName'] == true
                              ? const BorderSide(color: Colors.red, width: 2)
                              : const BorderSide(color: Colors.grey, width: 1)),
                      // Add auto-suggestion functionality here
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
                              ? const BorderSide(color: Colors.red, width: 2)
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
                              ? const BorderSide(color: Colors.red, width: 2)
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
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addBook,
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _books.length,
                itemBuilder: (context, index) {
                  return BookCard(
                      data: _books[index],
                      deleteBook: () {
                        setState(() {
                          _books.removeAt(index);
                        });
                      },
                      editBook: (newData) {
                        setState(() {
                          _books[index] = newData;
                        });
                      });
                },
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addAttachment,
              child: const Text('Add Attachment'),
            ),
          ],
        ),
      ),
    );
  }
}

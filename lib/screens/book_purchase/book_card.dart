import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookCard extends StatefulWidget {
  final Map<String, dynamic> data;
  final void Function() deleteBook;
  final void Function(Map<String, dynamic>) editBook;

  const BookCard(
      {super.key,
      required this.data,
      required this.deleteBook,
      required this.editBook});

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  TextEditingController _bookNameController = TextEditingController();
  TextEditingController _quantityController = TextEditingController();
  TextEditingController _priceController = TextEditingController();

  Map<String, bool> inputErrors = {};
  bool editMode = false;

  void _saveData() {
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
        widget.editBook({
          'bookName': bookName,
          'quantity': quantity,
          'bookPrice': price,
        });

        editMode = false;
      } else {
        inputErrors = tempInputErrors;
      }
    });
  }

  void _deleteBook() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this book?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.deleteBook();
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _bookNameController = TextEditingController(text: widget.data['bookName']);
    _quantityController = TextEditingController(text: widget.data['quantity']);
    _priceController = TextEditingController(text: widget.data['bookPrice']);
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
                  TextField(
                    enabled: editMode,
                    controller: _bookNameController,
                    onChanged: (value) {
                      setState(() {
                        inputErrors = {...inputErrors, 'bookName': false};
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Book name',
                      enabledBorder: UnderlineInputBorder(
                          borderSide: inputErrors['bookName'] == true
                              ? const BorderSide(color: Colors.red, width: 2)
                              : const BorderSide(color: Colors.grey, width: 1)),
                    ),
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
                  onPressed: _deleteBook,
                ),
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      editMode = true;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.save),
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

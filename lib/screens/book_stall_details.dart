import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'package:vadavathoor_book_stall/db/functions/utils.dart';
import 'package:vadavathoor_book_stall/providers/user.dart';

class BookStallDetailsWidget extends StatefulWidget {
  const BookStallDetailsWidget({super.key});

  @override
  State<BookStallDetailsWidget> createState() => _BookStallDetailsState();
}

class _BookStallDetailsState extends State<BookStallDetailsWidget> {
  TextEditingController _bookStallNameController = TextEditingController();
  TextEditingController _bookStallAddressController = TextEditingController();
  TextEditingController _bookStallPhoneController = TextEditingController();

  Map<String, bool> inputErrors = {};

  void setData() async {
    final tempName = await readMiscValue(MiscDBKeys.bookStallName);
    final tempAddress = await readMiscValue(MiscDBKeys.bookStallAdress);
    final tempPhone = await readMiscValue(MiscDBKeys.bookStallPhoneNumber);

    _bookStallNameController = TextEditingController(text: tempName);
    _bookStallAddressController = TextEditingController(text: tempAddress);
    _bookStallPhoneController = TextEditingController(text: tempPhone);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(builder: (cntx, user, _) {
      final loggedIn = user.user.userID != '';

      return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            TextField(
                controller: _bookStallNameController,
                decoration: InputDecoration(
                    labelText: 'Book stall name',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: inputErrors['bookStallName'] == true
                            ? const BorderSide(color: Colors.red, width: 1)
                            : const BorderSide(color: Colors.grey, width: 1))),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'bookStallName': false};
                  });
                }),
            const SizedBox(height: 20),
            TextField(
                controller: _bookStallAddressController,
                decoration: InputDecoration(
                    labelText: 'Book stall address',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: inputErrors['bookStallAddress'] == true
                            ? const BorderSide(color: Colors.red, width: 1)
                            : const BorderSide(color: Colors.grey, width: 1))),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'bookStallAddress': false};
                  });
                }),
            const SizedBox(height: 20),
            TextField(
                controller: _bookStallPhoneController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: InputDecoration(
                    labelText: 'Book stall phone number',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: inputErrors['bookStallPhone'] == true
                            ? const BorderSide(color: Colors.red, width: 1)
                            : const BorderSide(color: Colors.grey, width: 1))),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'bookStallPhone': false};
                  });
                }),
          ]));
    });
  }
}

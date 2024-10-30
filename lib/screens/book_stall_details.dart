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
  TextEditingController _bankName = TextEditingController();
  TextEditingController _accountName = TextEditingController();
  TextEditingController _accountNo = TextEditingController();
  TextEditingController _bankIFSC = TextEditingController();
  TextEditingController _bankBranch = TextEditingController();
  TextEditingController _visitAgain = TextEditingController();

  Map<String, bool> inputErrors = {};

  void setData() async {
    final tempName = await readMiscValue(MiscDBKeys.bookStallName);
    final tempAddress = await readMiscValue(MiscDBKeys.bookStallAdress);
    final tempPhone = await readMiscValue(MiscDBKeys.bookStallPhoneNumber);
    final tempBankName = await readMiscValue(MiscDBKeys.bankName);
    final tempAccountName = await readMiscValue(MiscDBKeys.accountName);
    final tempAccNo = await readMiscValue(MiscDBKeys.bankAccountNo);
    final tempIFSC = await readMiscValue(MiscDBKeys.bankIFSC);
    final tempBranch = await readMiscValue(MiscDBKeys.bankBranch);
    final tempVisitAgain = await readMiscValue(MiscDBKeys.visitAgain);

    setState(() {
      _bookStallNameController = TextEditingController(text: tempName);
      _bookStallAddressController = TextEditingController(text: tempAddress);
      _bookStallPhoneController = TextEditingController(text: tempPhone);
      _bankName = TextEditingController(text: tempBankName);
      _accountName = TextEditingController(text: tempAccountName);
      _accountNo = TextEditingController(text: tempAccNo);
      _bankIFSC = TextEditingController(text: tempIFSC);
      _bankBranch = TextEditingController(text: tempBranch);
      _visitAgain = TextEditingController(text: tempVisitAgain);
    });
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
                enabled: loggedIn,
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
                enabled: loggedIn,
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
                enabled: loggedIn,
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
            const SizedBox(height: 20),
            TextField(
                enabled: loggedIn,
                controller: _bankName,
                decoration: InputDecoration(
                    labelText: 'Bank name',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: inputErrors['bankName'] == true
                            ? const BorderSide(color: Colors.red, width: 1)
                            : const BorderSide(color: Colors.grey, width: 1))),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'bankName': false};
                  });
                }),
            const SizedBox(height: 20),
            TextField(
                enabled: loggedIn,
                controller: _accountName,
                decoration: InputDecoration(
                    labelText: 'Account name',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: inputErrors['accountName'] == true
                            ? const BorderSide(color: Colors.red, width: 1)
                            : const BorderSide(color: Colors.grey, width: 1))),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'accountName': false};
                  });
                }),
            const SizedBox(height: 20),
            TextField(
                enabled: loggedIn,
                controller: _accountNo,
                decoration: InputDecoration(
                    labelText: 'Bank account number',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: inputErrors['accountNo'] == true
                            ? const BorderSide(color: Colors.red, width: 1)
                            : const BorderSide(color: Colors.grey, width: 1))),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'accountNo': false};
                  });
                }),
            const SizedBox(height: 20),
            TextField(
                enabled: loggedIn,
                controller: _bankIFSC,
                decoration: InputDecoration(
                    labelText: 'Bank IFSC Code',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: inputErrors['ifsc'] == true
                            ? const BorderSide(color: Colors.red, width: 1)
                            : const BorderSide(color: Colors.grey, width: 1))),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'ifsc': false};
                  });
                }),
            const SizedBox(height: 20),
            TextField(
                enabled: loggedIn,
                controller: _bankBranch,
                decoration: InputDecoration(
                    labelText: 'Bank branch',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: inputErrors['bankBranch'] == true
                            ? const BorderSide(color: Colors.red, width: 1)
                            : const BorderSide(color: Colors.grey, width: 1))),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'bankBranch': false};
                  });
                }),
            const SizedBox(height: 20),
            TextField(
                enabled: loggedIn,
                controller: _visitAgain,
                decoration: InputDecoration(
                    labelText: 'Visit again message',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: inputErrors['visitAgain'] == true
                            ? const BorderSide(color: Colors.red, width: 1)
                            : const BorderSide(color: Colors.grey, width: 1))),
                onChanged: (value) {
                  setState(() {
                    inputErrors = {...inputErrors, 'visitAgain': false};
                  });
                }),
            const SizedBox(height: 20),
            if (loggedIn)
              TextButton(
                  style: TextButton.styleFrom(backgroundColor: Colors.blueGrey),
                  onPressed: () {
                    final stallName = _bookStallNameController.text.trim();
                    if (stallName.isNotEmpty) {
                      updateMiscValue(MiscDBKeys.bookStallName, stallName);
                    }
                    final stallAddress =
                        _bookStallAddressController.text.trim();
                    if (stallAddress.isNotEmpty) {
                      updateMiscValue(MiscDBKeys.bookStallAdress, stallAddress);
                    }
                    final stallPhone = _bookStallPhoneController.text.trim();
                    if (stallPhone.isNotEmpty) {
                      updateMiscValue(
                          MiscDBKeys.bookStallPhoneNumber, stallPhone);
                    }
                    final bankName = _bankName.text.trim();
                    if (bankName.isNotEmpty) {
                      updateMiscValue(MiscDBKeys.bankName, bankName);
                    }
                    final accountName = _accountName.text.trim();
                    if (accountName.isNotEmpty) {
                      updateMiscValue(MiscDBKeys.accountName, accountName);
                    }
                    final bankAccNo = _accountNo.text.trim();
                    if (bankAccNo.isNotEmpty) {
                      updateMiscValue(MiscDBKeys.bankAccountNo, bankAccNo);
                    }
                    final ifsc = _bankIFSC.text.trim();
                    if (ifsc.isNotEmpty) {
                      updateMiscValue(MiscDBKeys.bankIFSC, ifsc);
                    }
                    final branch = _bankBranch.text.trim();
                    if (branch.isNotEmpty) {
                      updateMiscValue(MiscDBKeys.bankBranch, branch);
                    }
                    final visitAgain = _visitAgain.text.trim();
                    if (visitAgain.isNotEmpty) {
                      updateMiscValue(MiscDBKeys.visitAgain, visitAgain);
                    }

                    _showSnackbar(context);
                  },
                  child:
                      const Text('Save', style: TextStyle(color: Colors.white)))
          ]));
    });
  }
}

void _showSnackbar(BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Details saved'),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 1),
      margin: EdgeInsets.all(16)));
}

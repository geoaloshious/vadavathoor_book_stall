import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vadavathoor_book_stall/components/modal_close_confirmation.dart';
import 'package:vadavathoor_book_stall/db/constants.dart';
import 'package:vadavathoor_book_stall/db/functions/user_batch.dart';
import 'package:vadavathoor_book_stall/db/functions/users.dart';
import 'package:vadavathoor_book_stall/db/models/user_batch.dart';
import 'package:vadavathoor_book_stall/db/models/users.dart';

import '../../components/drop_down.dart';

enum UserModalMode { add, edit }

class UsermodalWidget extends StatefulWidget {
  final UserModel? data;
  final UserModalMode mode;
  final void Function() updateUI;

  const UsermodalWidget(
      {super.key, this.data, required this.mode, required this.updateUI});

  @override
  State<UsermodalWidget> createState() => _UserModalState();
}

class _UserModalState extends State<UsermodalWidget> {
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String _batchID = '';
  String _role = UserRole.normal.toString();
  String _status = UserStatus.enabled.toString();
  Map<String, bool> inputErrors = {};
  String submitErrorMessage = '';

  List<Map<String, String>> _roles = [];
  List<Map<String, String>> _statuses = [];
  List<UserBatchModel> _batchList = [];

  void _saveData() async {
    final name = _firstNameController.text.trim();
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    Map<String, bool> tempInputErrors = {};

    if (name.isEmpty) {
      tempInputErrors['name'] = true;
    }

    if (username.isEmpty) {
      tempInputErrors['username'] = true;
    }

    if (password.isEmpty) {
      tempInputErrors['password'] = true;
    }

    if (_batchID == '') {
      tempInputErrors['batch'] = true;
    }

    if (tempInputErrors.isEmpty) {
      final fn = widget.mode == UserModalMode.add ? addUser : editUser;

      final res = await fn(UserModel(
          userID: widget.data?.userID ?? '',
          name: name,
          username: username,
          password: password,
          role: int.tryParse(_role) ?? UserRole.normal,
          batchID: _batchID,
          status: int.tryParse(_status) ?? UserStatus.enabled,
          createdDate: 0,
          createdBy: '',
          modifiedDate: 0,
          modifiedBy: '',
          notes: ''));

      if (res['error'] != null) {
        setState(() {
          submitErrorMessage = ErrorMessages.usernameTaken;
        });
      } else {
        widget.updateUI();
      }
    } else {
      setState(() {
        inputErrors = tempInputErrors;
      });
    }
  }

  void setData() async {
    final tempBatches = await getUserBatchList();

    setState(() {
      _batchList = tempBatches;
    });

    setState(() {
      _roles = [
        {'id': UserRole.admin.toString(), 'name': 'Admin'},
        {'id': UserRole.normal.toString(), 'name': 'Normal user'}
      ];
      _statuses = [
        {'id': UserStatus.enabled.toString(), 'name': 'Enabled'},
        {'id': UserStatus.disabled.toString(), 'name': 'Disabled'}
      ];
    });

    if (widget.mode == UserModalMode.edit && widget.data != null) {
      _batchID = widget.data!.batchID;
      _role = widget.data!.role.toString();
      _status = widget.data!.status.toString();
      _firstNameController = TextEditingController(text: widget.data!.name);
      _usernameController = TextEditingController(text: widget.data!.username);
      _passwordController = TextEditingController(text: widget.data!.password);
    }
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('${widget.mode == UserModalMode.add ? 'Add' : 'Edit'} User',
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
          IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Close',
              onPressed: () {
                showModalCloseConfirmation(context);
              })
        ]),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(
              child: TextField(
                  controller: _firstNameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
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
                  })),
          const SizedBox(width: 16.0),
          Expanded(
              child: CustomDropdown(
                  items: _batchList.map((i) => i.toDropdownData()).toList(),
                  selectedValue: _batchID.toString(),
                  label: 'Select Batch',
                  hasError: inputErrors['batch'] == true,
                  onValueChanged: (value) {
                    setState(() {
                      _batchID = value;
                      inputErrors = {...inputErrors, 'batch': false};
                    });
                  }))
        ]),
        const SizedBox(height: 10.0),
        Row(children: [
          Expanded(
            child: TextField(
              controller: _usernameController,
              inputFormatters: [
                FilteringTextInputFormatter.deny(RegExp(r'\s'))
              ],
              decoration: InputDecoration(
                labelText: 'Username',
                border: const OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                    borderSide: inputErrors['username'] == true
                        ? const BorderSide(color: Colors.red, width: 1)
                        : const BorderSide(color: Colors.grey, width: 1)),
              ),
              onChanged: (value) {
                setState(() {
                  inputErrors = {...inputErrors, 'username': false};
                });
              },
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
              child: TextField(
                  controller: _passwordController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ],
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                        borderSide: inputErrors['password'] == true
                            ? const BorderSide(color: Colors.red, width: 1)
                            : const BorderSide(color: Colors.grey, width: 1)),
                  ),
                  onChanged: (value) {
                    setState(() {
                      inputErrors = {...inputErrors, 'password': false};
                    });
                  }))
        ]),
        const SizedBox(height: 10),
        // Row(children: [
        //   Expanded(
        //       child: CustomDropdown(
        //     items: _roles,
        //     selectedValue: _role,
        //     label: 'Select Role',
        //     hasError: false,
        //     onValueChanged: (value) {
        //       setState(() {
        //         _role = value;
        //       });
        //     },
        //   )),
        //   const SizedBox(width: 16.0),
        //   Expanded(
        //       child: CustomDropdown(
        //           items: _statuses,
        //           selectedValue: _status,
        //           label: 'Select Status',
        //           hasError: false,
        //           onValueChanged: (value) {
        //             setState(() {
        //               _status = value;
        //             });
        //           }))
        // ]),
        const SizedBox(height: 20.0),
        submitErrorMessage != ''
            ? Text('$submitErrorMessage\n',
                style: const TextStyle(color: Colors.red))
            : const SizedBox.shrink(),
        ElevatedButton(
          onPressed: _saveData,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
          child: const Text('Submit', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

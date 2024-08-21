import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vadavathoor_book_stall/db/functions/users.dart';

class LoginDialogWidget extends StatefulWidget {
  const LoginDialogWidget({super.key});

  @override
  State<LoginDialogWidget> createState() => _LoginDialogState();
}

class _LoginDialogState extends State<LoginDialogWidget> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Map<String, bool> inputErrors = {};
  String loginResponse = '';

  void onPressLogin() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    Map<String, bool> tempInputErrors = {};

    if (username == '') {
      tempInputErrors['username'] = true;
    }

    if (password == '') {
      tempInputErrors['password'] = true;
    }

    if (tempInputErrors.isEmpty) {
      login(context, username, password).then((res) {
        if (res['error'] != null) {
          setState(() {
            loginResponse = res['error']!;
          });
        } else {
          Navigator.of(context).pop();
        }
      });
    } else {
      setState(() {
        inputErrors = tempInputErrors;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: [
              TextField(
                  controller: _usernameController,
                  autofocus: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ],
                  decoration: InputDecoration(
                      labelText: 'Username',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: inputErrors['username'] == true
                              ? const BorderSide(color: Colors.red, width: 1)
                              : const BorderSide(
                                  color: Colors.grey, width: 1))),
                  onChanged: (value) {
                    setState(() {
                      inputErrors = {...inputErrors, 'username': false};
                    });
                  }),
              const SizedBox(height: 10),
              TextField(
                  controller: _passwordController,
                  inputFormatters: [
                    FilteringTextInputFormatter.deny(RegExp(r'\s'))
                  ],
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: InputDecoration(
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      enabledBorder: OutlineInputBorder(
                          borderSide: inputErrors['password'] == true
                              ? const BorderSide(color: Colors.red, width: 1)
                              : const BorderSide(
                                  color: Colors.grey, width: 1))),
                  onChanged: (value) {
                    setState(() {
                      inputErrors = {...inputErrors, 'password': false};
                    });
                  },
                  onSubmitted: (value) {
                    onPressLogin();
                  }),
              const SizedBox(height: 20),
              loginResponse != ''
                  ? Text('$loginResponse\n',
                      style: const TextStyle(color: Colors.red))
                  : const SizedBox.shrink(),
              Row(children: [
                Expanded(
                    child: TextButton(
                        onPressed: onPressLogin,
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blueGrey,
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                        child: const Text('Login',
                            style: TextStyle(color: Colors.white))))
              ])
            ])));
  }
}

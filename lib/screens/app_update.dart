import 'package:flutter/material.dart';
import 'package:vadavathoor_book_stall/app_updation.dart';

class AppUpdateWidget extends StatefulWidget {
  const AppUpdateWidget({super.key});

  @override
  State<AppUpdateWidget> createState() => _AppUpdateState();
}

class _AppUpdateState extends State<AppUpdateWidget> {
  String currentVersion = '';
  String message = '';

  void setData() async {
    final temp = await getAppVersion();
    setState(() {
      currentVersion = temp;
      message = 'Checking for updates...';
    });

    final tempLatest = await getLatestAppVersion();

    if (tempLatest['version'] != null) {
      if (tempLatest['version'] != currentVersion) {
        setState(() {
          message =
              'Downloading and installing version ${tempLatest['version']}';
        });
        await downloadAndUpdate(tempLatest['url']!);
      } else {
        setState(() {
          message = 'No updates available';
        });
      }
    } else {
      setState(() {
        message = 'Error checking update';
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
          children: [Text('Current version : $currentVersion'), Text(message)]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'app_updation.dart';

class AppUpdateWidget extends StatefulWidget {
  const AppUpdateWidget({super.key});

  @override
  State<AppUpdateWidget> createState() => _AppUpdateState();
}

class _AppUpdateState extends State<AppUpdateWidget> {
  String currentVersion = '';
  String newVersion = '';
  String message = '';
  String changeLog = '';
  String downloadURL = '';
  bool isButtonDisabled = false;

  void setData() async {
    final temp = await getAppVersion();
    setState(() {
      currentVersion = temp;
      message = 'Checking for updates...';
    });

    final tempLatest = await getLatestAppVersion();

    if (tempLatest['version'] != null && tempLatest['changeLog'] != null) {
      if (tempLatest['version'] != currentVersion) {
        setState(() {
          message = '';
          newVersion = tempLatest['version']!;
          changeLog = tempLatest['changeLog']!;
          downloadURL = tempLatest['url']!;
        });
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
          'Current version: $currentVersion ${newVersion == '' ? '' : '\nNew version: $newVersion'}'),
      if (changeLog.isNotEmpty)
        ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 400),
            child: Markdown(data: changeLog)),
      Text(message),
      if (downloadURL.isNotEmpty)
        Center(
            child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor:
                            isButtonDisabled ? Colors.grey : Colors.blueGrey),
                    onPressed: isButtonDisabled
                        ? null
                        : () async {
                            setState(() {
                              message =
                                  'Starting updation in 5 seconds. App will be closing automatically.';
                              isButtonDisabled = true;
                            });
                            await Future.delayed(const Duration(seconds: 5));
                            await downloadAndUpdate(downloadURL);
                          },
                    child: const Text('Update',
                        style: TextStyle(color: Colors.white)))))
    ]);
  }
}

import 'package:flutter/material.dart';

import 'app_updation.dart';

class AppUpdateWidget extends StatefulWidget {
  const AppUpdateWidget({super.key});

  @override
  State<AppUpdateWidget> createState() => _AppUpdateState();
}

class _AppUpdateState extends State<AppUpdateWidget> {
  String currentVersion = '';
  String message = '';
  bool downloaded = false;

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
        await downloadAndUpdate(tempLatest['version']!, tempLatest['url']!);
        setState(() {
          downloaded = true;
          message =
              "\n• Go to Downloads folder\n• Extract bookstall_${tempLatest['version']!}.zip\n• Copy all files\n• Go to this application's folder\n• Close this application\n• Delete all files except database folder\n• Paste new files";
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
    return SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Current version : $currentVersion'),
      if (downloaded)
        Text.rich(
            TextSpan(children: [
              const TextSpan(text: "Download completed.\n\n"),
              const TextSpan(
                  text: "Instructions",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: message)
            ]),
            style: DefaultTextStyle.of(context).style)
      else
        Text(message)
    ]));
  }
}

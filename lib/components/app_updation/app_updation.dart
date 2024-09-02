import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vadavathoor_book_stall/components/app_updation/batch_script.dart';
import 'package:window_manager/window_manager.dart';

Future<String> getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

Future<Map<String, String>> getLatestAppVersion() async {
  final releasesUrl = Uri.parse(
      'https://api.github.com/repos/geoaloshious/vadavathoor_book_stall/releases/latest');
  final response = await http.get(releasesUrl);

  if (response.statusCode == 200) {
    final latestRelease = json.decode(response.body);
    String latestVersion =
        latestRelease['tag_name'].toString().replaceFirst('v', '');
    String downloadUrl = latestRelease['assets'][0]['browser_download_url'];

    return {
      'version': latestVersion,
      'url': downloadUrl,
      'changeLog': latestRelease['body']
    };
  }

  return {};
}

Future<void> downloadAndUpdate(String downloadUrl) async {
  final appFolderPath = Directory.current.path;

  final batchFile = File('$appFolderPath/update.bat');
  await batchFile.writeAsString(batchScript);

  try {
    await Process.start(
      'cmd.exe',
      ['/c', 'start', '$appFolderPath/update.bat', downloadUrl],
      mode: ProcessStartMode.detached,
      runInShell: true,
    );

    print('PowerShell script started in detached mode');
  } catch (e) {
    print('Error starting PowerShell script: $e');
  }

  windowManager.destroy();
}

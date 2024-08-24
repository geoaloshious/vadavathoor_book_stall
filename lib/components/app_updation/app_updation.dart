import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vadavathoor_book_stall/components/app_updation/power_shell_script.dart';

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

    return {'version': latestVersion, 'url': downloadUrl};
  }

  return {};
}

Future<void> downloadAndUpdate(String downloadUrl) async {
  final appFolderPath = Directory.current.path;

  final scriptFile = File('$appFolderPath/update.ps1');
  await scriptFile.writeAsString(appUpdationScript);

  try {
    Process.run('powershell.exe', [
      '-ExecutionPolicy',
      'Bypass',
      '-File',
      scriptFile.path
    ], environment: {
      'appFolderPath': appFolderPath,
      'downloadUrl': downloadUrl,
    });

    // exit(0);
  } catch (e) {
    print('Error executing PowerShell script: $e');
  } 
}

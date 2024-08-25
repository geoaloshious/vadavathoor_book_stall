import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

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

Future<void> downloadAndUpdate(String version, String downloadUrl) async {
  final directory = await getDownloadsDirectory();
  final filePath = '${directory?.path ?? ''}\\bookstall_$version.zip';

  final response = await http.get(Uri.parse(downloadUrl));
  File(filePath).writeAsBytesSync(response.bodyBytes);

/*
  final batchFile = File('$appFolderPath/update.bat');
  await batchFile.writeAsString(batchScript);

  try {
    final process = await Process.start(
      '$appFolderPath/update.bat',
      [downloadUrl], // Pass the download URL as an argument
      mode: ProcessStartMode.detached,
      runInShell: true,
    );

    print('PowerShell script started in detached mode');
  } catch (e) {
    print('Error starting PowerShell script: $e');
  }

  try {
    // exit(0);
  } on Exception catch (e) {
    writeToLog('exit error' + e.toString());
  }
  */
}

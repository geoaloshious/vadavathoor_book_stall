import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

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

Future<void> createUpdateScript(
    String appFolderPath, String zipFilePath) async {
  // Define the content of the Bash script
  String scriptContent = '''
#!/bin/bash

# Set the necessary paths
APP_FOLDER_PATH="$appFolderPath"
ZIP_FILE_PATH="$zipFilePath"
EXE_FILE_PATH="\$APP_FOLDER_PATH/vadavathoor_book_stall.exe"

# Backup Hive DB
# TEMP_HIVE_PATH="\$APP_FOLDER_PATH/temp_hive"
# mkdir -p "\$TEMP_HIVE_PATH"
# cp -r "\$HIVE_FOLDER_PATH" "\$TEMP_HIVE_PATH"

# Unzip new files
unzip "\$ZIP_FILE_PATH" -d "\$APP_FOLDER_PATH"

# Restore Hive DB
# rm -rf "\$HIVE_FOLDER_PATH"
# cp -r "\$TEMP_HIVE_PATH" "\$HIVE_FOLDER_PATH"
# rm -rf "\$TEMP_HIVE_PATH"

# Delete the zip file after updating
rm -f "\$ZIP_FILE_PATH"

# Run the executable file
"\$EXE_FILE_PATH" &
  ''';

  // Create the Bash script file
  final scriptFile = File('$appFolderPath/update.sh');
  await scriptFile.writeAsString(scriptContent);

  // Make the script executable
  await Process.run('chmod', ['+x', scriptFile.path]);
}

Future<void> runUpdateScript(String appFolderPath) async {
  await Process.start(
    'bash',
    ['$appFolderPath/update.sh'],
    workingDirectory: appFolderPath,
  );
}

Future<void> downloadAndUpdate(String downloadUrl) async {
  // Define paths
  final appDirectory = Directory.current.path;
  final tempDir = Directory('$appDirectory/temp_update');
  final zipFilePath = '${tempDir.path}/update.zip';

  await createUpdateScript(appDirectory, zipFilePath);

  // Create temp directory
  if (!tempDir.existsSync()) {
    tempDir.createSync();
  }

  // Download the zip file
  final response = await http.get(Uri.parse(downloadUrl));
  File(zipFilePath).writeAsBytesSync(response.bodyBytes);

  await runUpdateScript(appDirectory);
  exit(0);
}

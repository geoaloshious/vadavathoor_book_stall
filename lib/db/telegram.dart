import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path/path.dart' as path;
import 'package:archive/archive.dart';
import 'package:restart_app/restart_app.dart';

const botToken = '7217147107:AAHHkewwo3pl4DHU8NovfvRY9UcCc_OfYKw';
const chatId = '-1002193520515';
const apiId = '24071320';
const apiHash = 'd05d031f3a9c033429f2de9380a62413';
// const chatId = '495494047'; //myid

Future<void> sendFileToTelegram(String filePath) async {
  final Uri uri =
      Uri.parse('https://api.telegram.org/bot$botToken/sendDocument');

  var request = http.MultipartRequest('POST', uri)
    ..fields['chat_id'] = chatId
    ..files.add(await http.MultipartFile.fromPath('document', filePath));

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      print('File sent successfully!');
    } else {
      print('Failed to send file: ${response.statusCode}');
    }
  } catch (e) {
    print('Error occurred: $e');
  }
}

Future<void> sendMessageToTelegram(String message) async {
  final Uri uri =
      Uri.parse('https://api.telegram.org/bot$botToken/sendMessage');

  var response = await http.post(
    uri,
    body: {
      'chat_id': chatId,
      'text': message,
    },
  );

  if (response.statusCode == 200) {
    print('Message sent successfully!');
  } else {
    print(response.body);
  }
}

Future<void> getMessagesFromTG() async {
  final response = await http.post(
    Uri.parse('https://api.telegram.org/bot$botToken/getChat'),
    body: {'chat_id': chatId},
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    // Process the messages
    print(data);
  } else {
    print(response.body);
  }
}

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
  // Define paths
  final appDirectory = Directory.current.path;
  final tempDir = Directory('${appDirectory}/temp_update');
  final zipFilePath = '${tempDir.path}/update.zip';

  // Create temp directory
  if (!tempDir.existsSync()) {
    tempDir.createSync();
  }

  // Download the zip file
  final response = await http.get(Uri.parse(downloadUrl));
  File(zipFilePath).writeAsBytesSync(response.bodyBytes);

  // Extract the zip file
  final bytes = File(zipFilePath).readAsBytesSync();
  final archive = ZipDecoder().decodeBytes(bytes);

  // // Backup Hive database files
  // final hiveDir = Directory('${appDirectory}/database');
  // if (hiveDir.existsSync()) {
  //   hiveDir.renameSync('${appDirectory}/db_backup');
  // }

  // Replace old files with new ones
  for (final file in archive) {
    final filename = path.join(appDirectory, file.name);
    if (file.isFile) {
      final outFile = File(filename);
      outFile.createSync(recursive: true);
      outFile.writeAsBytesSync(file.content as List<int>);
    }
  }

  // // Restore the Hive database files
  // if (Directory('${appDirectory}/db_backup').existsSync()) {
  //   Directory('${appDirectory}/db_backup')
  //       .renameSync('${appDirectory}/database');
  // }

  // Clean up
  tempDir.deleteSync(recursive: true);
  // File(zipFilePath).deleteSync();

  // // Optionally, restart the application
  // restartApplication();
  Restart.restartApp();
}

void restartApplication() {
  Process.start(
    '${Directory.current.path}/vadavathoor_book_stall.exe',
    [],
    mode: ProcessStartMode.detached,
  );
  exit(0);
}

import 'dart:io';

import 'package:intl/intl.dart';
import 'package:vadavathoor_book_stall/utils.dart';

Future<void> writeToLog(String message) async {
  final logDirPath = '${Directory.current.path}/logs';
  final logDir = Directory(logDirPath);

  if (!await logDir.exists()) {
    await logDir.create(recursive: true);
  }

  final logFile = File(
      '$logDirPath/${DateFormat('dd-MM-yyyy').format(DateTime.now())}.txt');

  final timestamp =
      formatTimestamp(timestamp: DateTime.now().millisecondsSinceEpoch);
  await logFile.writeAsString('$timestamp: $message\n', mode: FileMode.append);
}

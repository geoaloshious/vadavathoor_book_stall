import 'dart:convert';
import 'package:http/http.dart' as http;

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

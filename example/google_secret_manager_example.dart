import 'dart:io';

import 'package:google_secret_manager/google_secret_manager.dart';

Future<void> main() async {
  final path = '${Directory.current.path}/gsm-service-account.json';
  final json = File(path).readAsStringSync();
  await GoogleSecretManager.initViaServiceAccountJson(json);

  final key = 'secret-name';
  final response = await GoogleSecretManager.instance.get(key);
  print('$key: ${response?.payload?.data}');
}

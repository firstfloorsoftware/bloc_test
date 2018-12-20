import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc_test/models/user.dart';

class UserService {
  final _client = HttpClient();

  Future<List<User>> randomUsers(int count) async {
    final uri = Uri.https('randomuser.me', 'api', <String, String>{
      'results': count.toString(),
      'inc': 'name,picture,login'
    });

    final json = await _get(uri);

    return (json['results'] as List)
        .map((json) => User.fromJson(json))
        .toList();
  }

  Future<dynamic> _get(Uri uri) async {
    final request = await _client.getUrl(uri);
    final response = await request.close();
    final result = await response.transform(utf8.decoder).join();

    return json.decode(result);
  }
}

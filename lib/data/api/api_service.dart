import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../model/story.dart';
import '../model/user.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1';

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 201) {
      throw Exception(data['message'] ?? 'Registration failed');
    }
    return data;
  }

  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Login failed');
    }
    return User.fromJson(data['loginResult'] as Map<String, dynamic>);
  }

  Future<List<Story>> getAllStories(String token) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/stories'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Failed to fetch stories');
    }

    final list = data['listStory'] as List;
    return list
        .map((json) => Story.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<Story> getStoryDetail(String token, String id) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/stories/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode != 200) {
      throw Exception(data['message'] ?? 'Failed to fetch story detail');
    }

    return Story.fromJson(data['story'] as Map<String, dynamic>);
  }

  Future<Map<String, dynamic>> addStory(
    String token,
    String description,
    Uint8List photoBytes,
    String fileName,
  ) async {
    final uri = Uri.parse('$_baseUrl/stories');
    final request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..fields['description'] = description
      ..files.add(
        http.MultipartFile.fromBytes(
          'photo',
          photoBytes,
          filename: fileName,
        ),
      );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode != 201) {
      throw Exception(data['message'] ?? 'Failed to upload story');
    }
    return data;
  }
}

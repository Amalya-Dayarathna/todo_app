import 'dart:convert';

import 'package:http/http.dart' as http;

// All todo api calls will be here

class TodoService {
  //! Submit data
  static Future<bool> addTodo(Map body) async {
    // Submit data to the server
    const url = 'https://api.nstack.in/v1/todos';

    final uri = Uri.parse(url);

    final response = await http.post(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 201;
  }

  //! Fetch items
  static Future<List?> fetchTodos() async {
    const url = 'https://api.nstack.in/v1/todos?page=1&limit=20';

    final uri = Uri.parse(url);

    final response = await http.get(uri);

    //Display data
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;

      return result;
    } else {
      return null;
    }
  }

  //! Update data
  static Future<bool> updateTodo(String id, Map body) async {
    // Submit updated data to the server
    final url = 'https://api.nstack.in/v1/todos/$id';

    final uri = Uri.parse(url);

    final response = await http.put(
      uri,
      body: jsonEncode(body),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200;
  }

  //! Delete the Item
  static Future<bool> deleteById(String id) async {
    final url = 'https://api.nstack.in/v1/todos/$id';

    final uri = Uri.parse(url);

    final respose = await http.delete(uri);

    return respose.statusCode == 200;
  }
}

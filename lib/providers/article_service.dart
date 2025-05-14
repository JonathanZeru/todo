import 'package:flutter_todo_app/models/article_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class ArticleService {
  final String _url = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<Article>> fetchArticles() async {
    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        final articles = jsonData.map((json) => Article.fromJson(json)).toList().cast<Article>();

        // Save to shared_preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('cached_articles', json.encode(jsonData));

        return articles;
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      return loadCachedArticles(); // fallback
    }
  }

  Future<List<Article>> loadCachedArticles() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cached = prefs.getString('cached_articles');
    if (cached != null) {
      final List<dynamic> jsonData = json.decode(cached);
      return jsonData.map((json) => Article.fromJson(json)).toList().cast<Article>();
    } else {
      return [];
    }
  }
}

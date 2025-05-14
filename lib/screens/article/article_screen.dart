import 'package:flutter/material.dart';
import 'package:flutter_todo_app/models/article_model.dart';
import 'package:flutter_todo_app/providers/article_service.dart';
import 'package:flutter_todo_app/widgets/custom_drawer.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  State<ArticleScreen> createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  late Future<List<Article>> _articlesFuture;

  @override
  void initState() {
    super.initState();
    _articlesFuture = ArticleService().fetchArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Articles")),
      drawer: const CustomDrawer(),
      body: FutureBuilder<List<Article>>(
        future: _articlesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No articles available."));
          } else {
            final articles = snapshot.data!;
            return ListView.builder(
              itemCount: articles.length,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final article = articles[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0, left: 4, right:4),
                  child: Card(
                    child: ListTile(
                      title: Text(article.title),
                      subtitle: Text(article.body),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

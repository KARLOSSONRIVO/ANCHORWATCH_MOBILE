import '../entities/article.dart';

abstract class ArticlesRepository {
  Future<List<Article>> getArticles();
}
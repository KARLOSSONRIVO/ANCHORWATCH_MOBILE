import 'package:injectable/injectable.dart';
import '../../models/article_model.dart';
import '../../endpoints/dashboard_endpoints.dart';
import '../../../services/dio_client.dart';

@injectable
class ArticlesRemoteDataSource {
  final DioClient _dioClient;

  ArticlesRemoteDataSource(this._dioClient);

  Future<List<ArticleModel>> getArticles() async {
    try {
      final response = await _dioClient.get(
        DashboardEndpoints.articles,
      );
      
      if (response.statusCode == 200) {
        final jsonData = response.data as Map<String, dynamic>;
        final articlesJson = jsonData['articles'] as List<dynamic>? ?? [];
        
        final articles = articlesJson
            .map((articleJson) => ArticleModel.fromJson(articleJson as Map<String, dynamic>))
            .toList();
            
        return articles;
      } else {
        throw Exception('Failed to load articles: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}

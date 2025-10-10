import 'package:injectable/injectable.dart';
import '../../domain/entities/article.dart';
import '../../domain/repositories/articles_repository.dart';
import '../datasources/remote/articles_remote_data_source.dart';

@Injectable(as: ArticlesRepository)
class ArticlesRepositoryImpl implements ArticlesRepository {
  final ArticlesRemoteDataSource _remoteDataSource;

  ArticlesRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Article>> getArticles() async {
    try {
      final models = await _remoteDataSource.getArticles();
      return models.map((model) => model.toEntity()).toList();
    } catch (e) {
      rethrow;
    }
  }
}
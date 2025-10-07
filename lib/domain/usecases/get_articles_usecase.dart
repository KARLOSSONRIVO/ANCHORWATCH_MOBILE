import 'package:injectable/injectable.dart';
import '../entities/article.dart';
import '../repositories/articles_repository.dart';

@injectable
class GetArticlesUseCase {
  final ArticlesRepository _repository;

  GetArticlesUseCase(this._repository);

  Future<List<Article>> call() async {
    return await _repository.getArticles();
  }
}
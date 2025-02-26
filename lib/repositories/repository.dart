import 'package:sudoku/errors/repository_exception.dart';

abstract class Repository {
  const Repository();

  T safeCode<T>(T Function() block) {
    try {
      return block();
    } catch (error) {
      throw RepositoryException(error.toString());
    }
  }
}

extension RepositoryStream<T> on Stream<T> {
  Stream<T> safeCode() =>
      handleError((Object error) => RepositoryException(error.toString()));
}

extension RepositoryFuture<T> on Future<T> {
  Future<T> safeCode(Future<T> Function() block) async {
    try {
      return await block();
    } catch (error) {
      throw RepositoryException(error.toString());
    }
  }
}

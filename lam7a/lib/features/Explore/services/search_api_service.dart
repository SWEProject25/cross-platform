import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/services/api_service.dart';
import 'account_api_service_implementation.dart';
import '../../../core/models/user_model.dart';
import 'search_api_service_mock.dart';

part 'search_api_service.g.dart';

@riverpod
SearchApiService searchApiServiceMock(Ref ref) {
  return searchApiServiceMock();
}

@riverpod
SearchApiService searchApiServiceImpl(Ref ref) {
  return searchApiServiceImpl(ref.read(apiServiceProvider));
}

abstract class SearchApiService {

  Future<List<String>> autocompleteSearch(String query);
  Future<List<
}

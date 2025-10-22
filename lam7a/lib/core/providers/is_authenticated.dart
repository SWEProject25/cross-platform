import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_authenticated.g.dart';

@riverpod
class  IsAuthenticated extends _$IsAuthenticated{
  @override
  bool build() {
    return false;
  }
  void setAuthenticated()
  {
    state = true;
  }
  void setNotAuthenticated()
  {
    state = false;
  }
  bool sAuthenticated()
  {
    return state;
  }  
}
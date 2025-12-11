import 'package:lam7a/core/models/user_dto.dart';
import 'package:lam7a/core/models/user_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_credentials_model.dart';
import 'package:lam7a/features/authentication/model/authentication_user_data_model.dart';
import 'package:lam7a/features/authentication/model/interest_dto.dart';
import 'package:lam7a/features/authentication/model/user_dto_model.dart';
import 'package:lam7a/features/authentication/model/user_to_follow_dto.dart';
import 'package:lam7a/features/authentication/service/authentication_api_service.dart';
import 'package:lam7a/features/authentication/utils/authentication_constants.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'authentication_impl_repository.g.dart';

@riverpod
AuthenticationRepositoryImpl authenticationImplRepository(Ref ref) {
  return AuthenticationRepositoryImpl(
    ref.read(authenticationApiServiceProvider),
  );
}

class AuthenticationRepositoryImpl {
  AuthenticationApiService apiService;
  AuthenticationRepositoryImpl(this.apiService);
  Future<bool> checkEmail(String email) async {
    Map<String, dynamic> body;
    body = await apiService.checkEmail(email);
    print(body);
    return (body[AuthenticationConstants.message].toString() ==
        AuthenticationConstants.emailExist);
  }

  Future<bool> verificationOTP(String email) async {
    final message = await apiService.verificationOTP(email);
    return (message[AuthenticationConstants.status].toString() ==
        AuthenticationConstants.success);
  }

  Future<bool> resendOTP(String email) async {
    final message = await apiService.resendOTP(email);
    return (message[AuthenticationConstants.status].toString() ==
        AuthenticationConstants.success);
  }

  Future<User?> register(AuthenticationUserDataModel user) async {
    final data = await apiService.register(user);
    User userModel = User.fromJson(data['data']['user']);
    return userModel;
  }

  Future<bool> verifyOTP(String email, String OTP) async {
    final message = await apiService.verifyOTP(email, OTP);
    return (message[AuthenticationConstants.status].toString() ==
        AuthenticationConstants.success);
  }

  Future<RootData> login(
    AuthenticationUserCredentialsModel userCredentials,
  ) async {
    final data = await apiService.Login(userCredentials);
    print(data);
    RootData userModel = RootData.fromJson(data['data']);
    return userModel;
  }

  Future<void> test() async {
    final data = await apiService.test();
  }

  Future<List<InterestDto>> getInterests() async {
    List<dynamic> interests = await apiService.getInterests();
    return interests.map((e) => InterestDto.fromJson(e)).toList();
  }

  Future<List<UserToFollowDto>> getUsersToFollow([int limit = 10]) async {
    List<dynamic> users = await apiService.getUsersToFollow(limit);
    return users.map((e) => UserToFollowDto.fromJson(e)).toList();
  }

  Future<void> selectInterests(List<int> interestIds) async {
    await apiService.selectInterests(interestIds);
  }

  Future<bool> followUser(int userId) async {
    final res = await apiService.followUsers(userId);
    return res[AuthenticationConstants.status] ==
        AuthenticationConstants.success;
  }

  Future<bool> unFollowUser(int userId) async {
    final res = await apiService.unFollowUsers(userId);
    return res[AuthenticationConstants.status] ==
        AuthenticationConstants.success;
  }

  Future<RootData> oAuthGoogleLogin(String idToken) async {
    Map<String, dynamic> res = await apiService.oAuthGoogleLogin(idToken);
    RootData userModel = RootData.fromJson(res['data']);
    return userModel;
  }

  Future<RootData> oAuthGithubLogin(String code) async {
    Map<String, dynamic> res = await apiService.oAuthGithubLogin(code);
    RootData userModel = RootData.fromJson(res['data']);
    return userModel;
  }

  Future<bool> forgotPassword(String email) async {
    final res = await apiService.forgotPassword(email);
    return res[AuthenticationConstants.status] ==
        AuthenticationConstants.success;
  }

  Future<bool> resetPassword({
    required String password,
    required String token,
    required String email,
    required int id,
  }) async {
    final res = await apiService.resetPassword(
      id: id,
      email: email,
      password: password,
      token: token,
    );
    return res[AuthenticationConstants.status] ==
        AuthenticationConstants.success;
  }
}

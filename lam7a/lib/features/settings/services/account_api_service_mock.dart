import 'dart:async';
import '../../../core/models/user_model.dart';
import 'account_api_service.dart';

class AccountApiServiceMock implements AccountApiService {
  final String password = "correct_password";

  UserModel _mockUser = UserModel(
    username: 'mockuser',
    email: 'mockuser@example.com',
    role: 'user',
    name: 'Mock User',
    birthDate: '2000-01-01',
    profileImageUrl: 'https://example.com/profile.jpg',
    bannerImageUrl: 'https://example.com/banner.jpg',
    bio: 'This is a mock user.',
    location: 'Mockland',
    website: 'https://example.com',
    createdAt: '2023-01-01',
  );

  @override
  Future<UserModel> getMyInfo() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockUser;
  }

  @override
  Future<void> changeEmail(String newEmail) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockUser = _mockUser.copyWith(email: newEmail);
  }

  @override // temporary mock implementation
  Future<void> changePassword(String oldPassword, String newPassword) async {
    await Future.delayed(const Duration(seconds: 1));
    // _mockUser = _mockUser.copyWith(password: newPassword);
  }

  @override
  Future<void> changeUsername(String newUsername) async {
    await Future.delayed(const Duration(seconds: 1));
    _mockUser = _mockUser.copyWith(username: newUsername);
  }

  @override
  Future<void> deactivateAccount() async {
    await Future.delayed(const Duration(seconds: 2));
    // In a real implementation, this would deactivate the account.
  }

  @override
  Future<bool> validatePassword(String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return password == this.password;
  }

  @override
  Future<bool> checkEmailExists(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return email == _mockUser.email;
  }

  @override
  Future<bool> validateOtp(String email, String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return true;
  }

  @override
  Future<void> sendOtp(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Future<void> resendOtp(String email) async {
    await Future.delayed(const Duration(seconds: 1));
  }
}

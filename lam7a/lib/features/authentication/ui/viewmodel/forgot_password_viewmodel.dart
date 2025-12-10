import 'package:lam7a/features/authentication/model/interest_dto.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/state/forgot_password_state.dart';
import 'package:lam7a/features/authentication/utils/authentication_validator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'forgot_password_viewmodel.g.dart';

@riverpod
class ForgotPasswordViewmodel extends _$ForgotPasswordViewmodel {
  late AuthenticationRepositoryImpl repo;

  Validator validator = Validator();
  ForgotPasswordState build() {
    repo = ref.read(authenticationImplRepositoryProvider);
    return ForgotPasswordState();
  }

  void gotoNextStep() {
    int currentIdx = state.currentForgotPasswordStep;
      state = state.copyWith(currentForgotPasswordStep: currentIdx + 1);
  }

  void updateEmail(String email) {
    state = state.copyWith(
      email: email,
      isValidEmail: validator.validateEmail(email),
    );
  }
  String EncryptEmail(String email)
  {
    List<String> parts = email.split("@");
    String local = parts[0];
    String domain = parts[1];
    String maskedLocal = local[0] + "*" * (local.length - 2);
    String maskedDomain = domain[0] + "*" * (domain.length - 1);
    return maskedLocal + "@" + maskedDomain;
  }
  Future<void> isInstructionSent(String email) async
  {
    repo = ref.read(authenticationImplRepositoryProvider);
      bool isSent = await repo.forgotPassword(email);
      if (isSent)
      {
        gotoNextStep();
      }
  }

}

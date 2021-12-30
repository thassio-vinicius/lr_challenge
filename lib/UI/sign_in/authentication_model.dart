import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lr_challenge/services/authentication_provider.dart';
import 'package:lr_challenge/utils/strings.dart';
import 'package:lr_challenge/utils/validator.dart';

enum AuthenticationState { signIn, signUp }

enum AuthenticationSubmitState { cantSubmit, authException, success }

class AuthenticationModel with TextFieldValidators, ChangeNotifier {
  AuthenticationModel({
    required this.authProvider,
    this.state = AuthenticationState.signIn,
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.isLoading = false,
    this.submitted = false,
    this.privacy = false,
    this.terms = false,
  });

  final AuthenticationProvider authProvider;
  String email;
  String password;
  String confirmPassword;
  AuthenticationState state;
  bool isLoading;
  bool submitted;
  bool privacy;
  bool terms;

  Future<AuthenticationSubmitState> submit() async {
    print('submit');

    try {
      updateWith(submitted: true);
      if (!canSubmit) {
        print('cant submit');
        return AuthenticationSubmitState.cantSubmit;
      }
      updateWith(isLoading: true);

      bool result;

      switch (state) {
        case AuthenticationState.signIn:
          result = await authProvider.signIn(email: email, password: password);

          updateWith(isLoading: false);
          return result ? AuthenticationSubmitState.success : AuthenticationSubmitState.authException;
        case AuthenticationState.signUp:
          result = await authProvider.signUp(
            email: email.trim(),
            password: password.trim(),
          );
          updateWith(isLoading: false);

          print('submit register');
          return result ? AuthenticationSubmitState.success : AuthenticationSubmitState.authException;
        default:
          return AuthenticationSubmitState.cantSubmit;
      }
    } catch (e, stackTrace) {
      print(stackTrace);
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateEmail(String email) => updateWith(email: email);

  void updatePrivacy(bool? privacy) => updateWith(privacy: privacy);

  void updateTerms(bool? terms) => updateWith(terms: terms);

  void updatePassword(String password) => updateWith(password: password);

  void updateConfirmPassword(String confirmPassword) => updateWith(confirmPassword: confirmPassword);

  void updateWith({
    String? email,
    String? password,
    String? confirmPassword,
    bool? isLoading,
    bool? submitted,
    AuthenticationState? formType,
    bool? privacy,
    bool? terms,
  }) {
    this.email = email ?? this.email;
    this.password = password ?? this.password;
    this.confirmPassword = confirmPassword ?? this.confirmPassword;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    this.state = formType ?? this.state;
    this.privacy = privacy ?? this.privacy;
    this.terms = terms ?? this.terms;
    notifyListeners();
  }

  void updateState(AuthenticationState? formType) {
    updateWith(
      email: '',
      password: '',
      confirmPassword: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  // Getters

  String? get primaryButtonText {
    return <AuthenticationState, String>{
      AuthenticationState.signUp: Strings.createAcc,
      AuthenticationState.signIn: Strings.confirm,
    }[state];
  }

  String? get errorAlertTitle {
    return <AuthenticationState, String>{
      AuthenticationState.signUp: Strings.signUpFailed,
      AuthenticationState.signIn: Strings.signInFailed,
    }[state];
  }

  String? get title {
    return <AuthenticationState, String>{
      AuthenticationState.signUp: Strings.welcome,
      AuthenticationState.signIn: Strings.welcomeBack,
    }[state];
  }

  String? get formTitle {
    return <AuthenticationState, String>{
      AuthenticationState.signUp: Strings.createAcc,
      AuthenticationState.signIn: Strings.signIn,
    }[state];
  }

  String? get secondaryButtonText {
    return <AuthenticationState, String>{
      AuthenticationState.signUp: Strings.signIn,
      AuthenticationState.signIn: Strings.noAccount,
    }[state];
  }

  AuthenticationState? get secondaryActionState {
    return <AuthenticationState, AuthenticationState>{
      AuthenticationState.signUp: AuthenticationState.signIn,
      AuthenticationState.signIn: AuthenticationState.signUp,
    }[state];
  }

  bool get canSubmitEmail {
    return emailSubmitValidator.isValid(email) && email.isNotEmpty;
  }

  bool get canSubmitPassword {
    return passwordSubmitValidator.isValid(password) && password.isNotEmpty;
  }

  bool get canSubmitConfirmPassword {
    return confirmPasswordSubmitValidator.isValid(confirmPassword) && password == confirmPassword;
  }

  bool get canSubmit {
    late bool canSubmitFields;

    switch (state) {
      case AuthenticationState.signIn:
        canSubmitFields = canSubmitEmail && canSubmitPassword;
        break;
      case AuthenticationState.signUp:
        canSubmitFields = canSubmitEmail && canSubmitPassword && canSubmitConfirmPassword && terms && privacy;
        break;
    }
    print(canSubmitFields);
    return canSubmitFields && !isLoading;
  }

  String? get emailErrorText {
    final bool showErrorText = submitted && !canSubmitEmail;
    final String errorText = email.isEmpty ? Strings.invalidEmailEmpty : Strings.invalidEmailErrorText;
    return showErrorText ? errorText : null;
  }

  String? get passwordErrorText {
    final bool showErrorText = submitted && !canSubmitPassword;
    final String errorText = password.isEmpty ? Strings.invalidPasswordEmpty : Strings.invalidPasswordTooShort;
    return showErrorText ? errorText : null;
  }

  String? get confirmPasswordErrorText {
    final bool showErrorText = submitted && !canSubmitConfirmPassword;
    final String errorText =
        confirmPassword.isEmpty ? Strings.invalidConfirmPasswordEmpty : Strings.invalidPasswordsNoMatch;
    return showErrorText ? errorText : null;
  }

  @override
  String toString() {
    return 'email: $email, password: $password, confirmPassword: $confirmPassword, isLoading: $isLoading, submitted: $submitted';
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lr_challenge/UI/home/home_screen.dart';
import 'package:lr_challenge/UI/shared/custom_alertdialog.dart';
import 'package:lr_challenge/UI/shared/custom_exceptiondialog.dart';
import 'package:lr_challenge/UI/shared/custom_primarybutton.dart';
import 'package:lr_challenge/UI/shared/custom_textfield.dart';
import 'package:lr_challenge/UI/sign_in/authentication_model.dart';
import 'package:lr_challenge/services/authentication_provider.dart';
import 'package:lr_challenge/utils/adapt.dart';
import 'package:lr_challenge/utils/strings.dart';
import 'package:provider/provider.dart';

class AuthenticationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    return ChangeNotifierProvider<AuthenticationModel>(
      create: (_) => AuthenticationModel(authProvider: authProvider),
      child: Consumer<AuthenticationModel>(
        builder: (_, model, __) => _EmailSignOptionScreen(model: model),
      ),
    );
  }
}

class _EmailSignOptionScreen extends StatefulWidget {
  const _EmailSignOptionScreen({required this.model});
  final AuthenticationModel model;

  @override
  _EmailSignOptionScreenState createState() => _EmailSignOptionScreenState();
}

class _EmailSignOptionScreenState extends State<_EmailSignOptionScreen> {
  final FocusScopeNode node = FocusScopeNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  AuthenticationModel get model => widget.model;

  bool initialState = true;

  @override
  void dispose() {
    node.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void showSignInError(AuthenticationModel model, dynamic exception) async {
    await showExceptionAlertDialog(
      context: context,
      title: model.errorAlertTitle,
      exception: exception,
    );
  }

  Future<void> submit() async {
    if (model.state == AuthenticationState.signUp && !(model.terms || model.privacy)) {
      showAlertDialog(
        context: context,
        title: Strings.signUpFailed,
        content: Strings.acceptPrivacyTermsFirst,
        defaultActionText: 'Ok',
      );
    } else {
      try {
        final AuthenticationSubmitState result = await model.submit();
        if (result == AuthenticationSubmitState.success) {
          Future.delayed(Duration.zero, () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => HomeScreen()),
            );
          });
        } else {
          if (result == AuthenticationSubmitState.authException) showSignInError(model, "unknown");
        }
      } catch (e, stackTrace) {
        print(e);
        print(stackTrace);
        showSignInError(model, e);
      }
    }
  }

  void updateState(AuthenticationState? state) {
    initialState = false;
    model.updateState(state);
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  void emailEditingComplete() {
    if (model.canSubmitEmail) {
      node.nextFocus();
    }
  }

  void passwordEditingComplete() {
    if (!model.canSubmitPassword) {
      node.nextFocus();
    }
  }

  void confirmPasswordEditingComplete() {
    if (!model.canSubmitPassword) {
      node.previousFocus();
      return;
    }
    submit();
  }

  Widget buildFields() {
    late List<Widget> children;

    switch (model.state) {
      case AuthenticationState.signIn:
        children = [
          CustomTextField(
              controller: emailController,
              hint: Strings.emailHint,
              errorText: model.emailErrorText,
              onChanged: model.updateEmail,
              keyboardType: TextInputType.emailAddress,
              enabled: !model.isLoading,
              onEditingComplete: emailEditingComplete,
              inputFormatters: <TextInputFormatter>[model.emailInputFormatter]),
          CustomTextField(
            controller: passwordController,
            hint: Strings.password,
            errorText: model.passwordErrorText,
            enabled: !model.isLoading,
            obscureText: true,
            onChanged: model.updatePassword,
            onEditingComplete: passwordEditingComplete,
          ),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(8)),
            child: CustomPrimaryButton(
              label: model.primaryButtonText!,
              loading: model.isLoading,
              onPressed: model.isLoading ? null : submit,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(12)),
            child: Align(
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () => model.updateState(AuthenticationState.signUp),
                child: Text(
                  model.secondaryButtonText!,
                  style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: Adapt.px(15)),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
          ),
        ];
        break;
      case AuthenticationState.signUp:
        children = <Widget>[
          CustomTextField(
              controller: emailController,
              hint: Strings.emailHint,
              errorText: model.emailErrorText,
              keyboardType: TextInputType.emailAddress,
              onChanged: model.updateEmail,
              enabled: !model.isLoading,
              onEditingComplete: emailEditingComplete,
              inputFormatters: <TextInputFormatter>[model.emailInputFormatter]),
          CustomTextField(
            controller: passwordController,
            hint: Strings.password,
            errorText: model.passwordErrorText,
            enabled: !model.isLoading,
            obscureText: true,
            onChanged: model.updatePassword,
            onEditingComplete: passwordEditingComplete,
          ),
          CustomTextField(
            controller: confirmPasswordController,
            hint: Strings.confirmPasswordHint,
            errorText: model.confirmPasswordErrorText,
            obscureText: true,
            enabled: !model.isLoading,
            textInputAction: TextInputAction.done,
            onChanged: model.updateConfirmPassword,
            onEditingComplete: confirmPasswordEditingComplete,
          ),
          CustomPrimaryButton(
            label: model.primaryButtonText,
            loading: model.isLoading,
            onPressed: model.isLoading ? null : submit,
          ),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(12)),
            child: Row(
              children: [
                Checkbox(
                  value: model.privacy,
                  onChanged: model.updatePrivacy,
                  checkColor: Colors.white,
                  activeColor: Theme.of(context).primaryColor,
                ),
                Flexible(
                  child: Row(
                    children: [
                      Text(
                        Strings.acceptConfirm,
                        style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: Adapt.px(12)),
                      ),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: Adapt.px(2)),
                          child: Text(
                            Strings.privacyPolicy,
                            style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: Adapt.px(12)),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              Checkbox(
                  value: model.terms,
                  checkColor: Colors.white,
                  activeColor: Theme.of(context).primaryColor,
                  onChanged: model.updateTerms),
              Flexible(
                child: Row(
                  children: [
                    Text(
                      Strings.acceptConfirm,
                      style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: Adapt.px(12)),
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(left: Adapt.px(2)),
                        child: Text(
                          Strings.termsConditions,
                          style: Theme.of(context).textTheme.headline1!.copyWith(fontSize: Adapt.px(12)),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: Adapt.px(12)),
            child: Text(Strings.alreadyHaveAcc,
                style: Theme.of(context).textTheme.headline2!.copyWith(fontSize: Adapt.px(20))),
          ),
        ];
        break;
    }
    return Column(children: children);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Adapt.px(16)),
          child: Center(
            child: ListView(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: Adapt.px(22.0)),
                    child: Text(
                      model.formTitle!,
                      style: Theme.of(context).textTheme.headline2,
                    ),
                  ),
                ),
                FocusScope(
                  node: node,
                  child: buildFields(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

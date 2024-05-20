import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../constants/constants.dart';
import '../../../../global_widgets/global_widgets.dart';
import '../../../../utils/utils.dart';
import '../../auth_module.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, required this.formType});

  final EmailPasswordSignInFormType formType;

  // * Keys for testing using find.byKey()
  static const emailKey = Key('email');
  static const passwordKey = Key('password');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            Constants.logoClima,
            height: 150,
            width: 150,
          ),
          EmailPasswordSignInContents(
            formType: formType,
          ),
        ],
      ),
    );
  }
}

class EmailPasswordSignInContents extends ConsumerStatefulWidget {
  const EmailPasswordSignInContents({
    super.key,
    this.onSignedIn,
    required this.formType,
  });

  final VoidCallback? onSignedIn;

  /// The default form type to use.
  final EmailPasswordSignInFormType formType;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EmailPasswordSignInContentsState();
}

class _EmailPasswordSignInContentsState
    extends ConsumerState<EmailPasswordSignInContents>
    with EmailAndPasswordValidators {
  final _formKey = GlobalKey<FormState>();
  final _node = FocusScopeNode();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String get email => _emailController.text;
  String get password => _passwordController.text;

  var _submitted = false;

  late var _formType = widget.formType;

  @override
  void dispose() {
    // * TextEditingControllers should be always disposed
    _node.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    // only submit the form if validation passes
    if (_formKey.currentState!.validate()) {
      final controller =
          ref.read(emailPasswordSignInControllerProvider.notifier);
      final success = await controller.submit(
        email: email,
        password: password,
        formType: _formType,
      );

      if (success) {
        widget.onSignedIn?.call();
      }
    }
  }

  void _emailEditingComplete() {
    if (canSubmitEmail(email)) {
      _node.nextFocus();
    }
  }

  void _passwordEditingComplete() {
    if (!canSubmitEmail(email)) {
      _node.previousFocus();
      return;
    }
    _submit();
  }

  void _updateFormType() {
    setState(() => _formType = _formType.secondaryActionFormType);

    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      emailPasswordSignInControllerProvider,
      (_, state) => state.showAlertDialogOnError(context),
    );
    final state = ref.watch(emailPasswordSignInControllerProvider);
    return FocusScope(
      node: _node,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const SizedBox(height: 8),
                  // Email field
                  TextFormField(
                    key: LoginScreen.emailKey,
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'test@test.com',
                      enabled: !state.isLoading,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (email) =>
                        !_submitted ? null : emailErrorText(email ?? ''),
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    keyboardAppearance: Brightness.light,
                    onEditingComplete: () => _emailEditingComplete(),
                    inputFormatters: <TextInputFormatter>[
                      ValidatorInputFormatter(
                          editingValidator: EmailEditingRegexValidator()),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Password field
                  TextFormField(
                    key: LoginScreen.passwordKey,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: _formType.passwordLabelText,
                      enabled: !state.isLoading,
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (password) => !_submitted
                        ? null
                        : passwordErrorText(password ?? '', _formType),
                    obscureText: true,
                    autocorrect: false,
                    textInputAction: TextInputAction.done,
                    keyboardAppearance: Brightness.light,
                    onEditingComplete: () => _passwordEditingComplete(),
                  ),
                  const SizedBox(height: 8),
                  PrimaryButton(
                    text: _formType.primaryButtonText,
                    isLoading: state.isLoading,
                    onPressed: state.isLoading ? null : () => _submit(),
                  ),
                  const SizedBox(height: 8),
                  CustomTextButton(
                    text: _formType.secondaryButtonText,
                    onPressed: state.isLoading ? null : _updateFormType,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

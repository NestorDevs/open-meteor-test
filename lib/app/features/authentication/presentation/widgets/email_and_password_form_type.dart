/// Form type for email & password authentication
enum EmailPasswordSignInFormType { signIn, register }

extension EmailPasswordSignInFormTypeX on EmailPasswordSignInFormType {
  String get passwordLabelText {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Password (8+ characters)';
    } else {
      return 'Password';
    }
  }

  // Getters
  String get primaryButtonText {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Registro';
    } else {
      return 'Iniciar Sesion';
    }
  }

  String get secondaryButtonText {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Ya tienes una cuenta? Inicia Sesion';
    } else {
      return 'Necesitas una cuenta? Registrate';
    }
  }

  EmailPasswordSignInFormType get secondaryActionFormType {
    if (this == EmailPasswordSignInFormType.register) {
      return EmailPasswordSignInFormType.signIn;
    } else {
      return EmailPasswordSignInFormType.register;
    }
  }

  String get errorAlertTitle {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Registration failed';
    } else {
      return 'Sign in failed';
    }
  }

  String get title {
    if (this == EmailPasswordSignInFormType.register) {
      return 'Register';
    } else {
      return 'Sign in';
    }
  }
}

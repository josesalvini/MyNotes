import 'package:flutter/foundation.dart' show immutable;
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class AuthState {
  final bool isLoading;
  final String? textLoading;
  const AuthState({
    required this.isLoading,
    this.textLoading = 'Por favor espere un momento.',
  });
}

class AuthStateUninitialized extends AuthState {
  const AuthStateUninitialized({
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateRegistering extends AuthState {
  final Exception? exception;
  const AuthStateRegistering({
    required this.exception,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedIn extends AuthState {
  final AuthUser user;
  const AuthStateLoggedIn({
    required this.user,
    required bool isLoading,
  }) : super(isLoading: isLoading);
}

class AuthStateNeedsVerification extends AuthState {
  const AuthStateNeedsVerification({required bool isLoading})
      : super(isLoading: isLoading);
}

class AuthStateLoggedOut extends AuthState with EquatableMixin {
  final Exception? exception;
  const AuthStateLoggedOut({
    required this.exception,
    required bool isLoading,
    String? textLoading,
  }) : super(isLoading: isLoading);

  @override
  List<Object?> get props => [
        exception,
        isLoading,
      ];
}

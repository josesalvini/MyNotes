import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:test/test.dart';

void main() {
  group('Mock Authentication', () {
    final provider = MockAuthProvider();
    test('No debe estar inicializado al iniciar.', () {
      expect(provider._isInitialized, false);
    });

    test(
      'No se puede hacer un log out si no esta inicializado',
      () {
        expect(
          provider.logOut(),
          throwsA(const TypeMatcher<NotInitializedExceptions>()),
        );
      },
    );

    test(
      'No se puede inicializar el proveedor de servicio',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
    );

    test(
      'El usuario no puede ser nulo despues de inicializar',
      () async {
        expect(provider.currentUser, null);
      },
    );

    test(
      'Se deberia inicializar en al menos 2 segundos',
      () async {
        await provider.initialize();
        expect(provider.isInitialized, true);
      },
      timeout: const Timeout(Duration(seconds: 2)),
    );

    test('Crea un usuario y realiza el login.', () async {
      final badEmailUser = provider.createUser(
        email: 'josesalvini@gmail.com',
        password: 'password',
      );
      expect(
        badEmailUser,
        throwsA(const TypeMatcher<UserNotFoundAuthException>()),
      );

      final badPassword = provider.createUser(
        email: 'jose@gmail.com',
        password: '123456',
      );

      expect(
        badPassword,
        throwsA(const TypeMatcher<WorngPasswordAuthException>()),
      );

      final user = await provider.createUser(
        email: 'josesalvini',
        password: '1234',
      );

      expect(provider.currentUser, user);
      expect(user.isEmailVerified, false);
    });

    test(
      'El usuario debe estar logueado para ser verficado',
      () {
        provider.sendEmailVerification();
        final user = provider.currentUser;
        expect(user, isNotNull);
        expect(user!.isEmailVerified, true);
      },
    );

    test(
      'Deberia cerrar sesion y volver a hacer login',
      () async {
        await provider.logOut();
        await provider.logIn(
          email: 'email',
          password: 'password',
        );
        final user = provider.currentUser;
        expect(user, isNotNull);
      },
    );
  });
}

class NotInitializedExceptions implements Exception {}

class MockAuthProvider implements AuthProvider {
  AuthUser? _user;
  var _isInitialized = false;
  bool get isInitialized => _isInitialized;

  @override
  Future<AuthUser> createUser({
    required String email,
    required String password,
  }) async {
    if (!isInitialized) throw NotInitializedExceptions();
    await Future.delayed(const Duration(seconds: 1));
    return logIn(
      email: email,
      password: password,
    );
  }

  @override
  AuthUser? get currentUser => _user;

  @override
  Future<void> initialize() async {
    await Future.delayed(const Duration(seconds: 1));
    _isInitialized = true;
  }

  @override
  Future<AuthUser> logIn({
    required String email,
    required String password,
  }) {
    if (!isInitialized) throw NotInitializedExceptions();
    if (email == 'josesalvini@gmail.com') throw UserNotFoundAuthException();
    if (password == '123456') throw WorngPasswordAuthException();
    const user = AuthUser(
      id: '1DSFSF',
      email: 'josesalvini@gmail.com',
      isEmailVerified: false,
    );
    _user = user;
    return Future.value(user);
  }

  @override
  Future<void> logOut() async {
    if (!isInitialized) throw NotInitializedExceptions();
    if (_user == null) throw UserNotFoundAuthException();
    await Future.delayed(const Duration(seconds: 1));
    _user = null;
  }

  @override
  Future<void> sendEmailVerification() async {
    if (!isInitialized) throw NotInitializedExceptions();
    final user = _user;
    if (user == null) throw UserNotFoundAuthException();
    const newUser = AuthUser(
      id: '1DSFSF',
      email: 'josesalvini@gmail.com',
      isEmailVerified: true,
    );
    _user = newUser;
  }

  @override
  Future<void> sendPasswordReset({required String toEmail}) {
    // TODO: implement sendPasswordReset
    throw UnimplementedError();
  }
}

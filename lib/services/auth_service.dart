import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthUser {
  final String displayName;
  final String email;
  final String? photoUrl;
  final bool isDemoFallback;

  const AuthUser({
    required this.displayName,
    required this.email,
    this.photoUrl,
    this.isDemoFallback = false,
  });
}

class AuthService {
  AuthService._internal();
  static final AuthService instance = AuthService._internal();

  static const String googleClientId =
      '243356426611-6plvbdqin8cnc726npop37l836462sf0.apps.googleusercontent.com';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? googleClientId : null,
    scopes: const <String>[
      'email',
      'https://www.googleapis.com/auth/userinfo.profile',
    ],
  );

  GoogleSignInAccount? _currentUser;
  GoogleSignInAccount? get currentUser => _currentUser;

  /// Trigger Google Sign-In flow client-side
  Future<AuthUser?> signInWithGoogle({bool fallbackIfUnavailable = true}) async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        _currentUser = account;
        return AuthUser(
          displayName: account.displayName ?? 'Google User',
          email: account.email,
          photoUrl: account.photoUrl,
          isDemoFallback: false,
        );
      }
      return null;
    } catch (e) {
      debugPrint('Google Sign-In caught error: $e');
      if (fallbackIfUnavailable) {
        // Fallback for local development or unauthorized origins on localhost
        debugPrint('Using demo Google profile fallback for local development');
        return const AuthUser(
          displayName: 'Google Demo User',
          email: 'demo.user@foodresq.org',
          photoUrl: null,
          isDemoFallback: true,
        );
      }
      rethrow;
    }
  }

  /// Sign out from Google
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      debugPrint('Sign-out error: $e');
    }
    _currentUser = null;
  }
}

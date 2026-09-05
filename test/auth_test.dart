import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/state/app_state.dart';
import 'package:flutter_application_1/services/auth_service.dart';
import 'package:flutter_application_1/theme/app_theme.dart';

void main() {
  group('Authentication & State Management Tests', () {
    test('AppState initializes unauthenticated by default', () {
      final state = AppState();
      expect(state.isAuthenticated, isFalse);
      expect(state.userDisplayName, isNull);
      expect(state.userEmail, isNull);
      expect(state.userPhotoUrl, isNull);
    });

    test('AppState setAuthenticatedUser correctly updates user profile and status', () {
      final state = AppState();
      bool listenerNotified = false;
      state.addListener(() {
        listenerNotified = true;
      });

      state.setAuthenticatedUser(
        name: 'Jane Doe',
        email: 'jane.doe@gmail.com',
        photoUrl: 'https://example.com/avatar.jpg',
      );

      expect(listenerNotified, isTrue);
      expect(state.isAuthenticated, isTrue);
      expect(state.userDisplayName, equals('Jane Doe'));
      expect(state.userEmail, equals('jane.doe@gmail.com'));
      expect(state.userPhotoUrl, equals('https://example.com/avatar.jpg'));
    });

    test('AppState signOutUser clears profile and resets status', () {
      final state = AppState();
      state.setAuthenticatedUser(
        name: 'John Smith',
        email: 'john@example.com',
      );
      expect(state.isAuthenticated, isTrue);

      state.signOutUser();
      expect(state.isAuthenticated, isFalse);
      expect(state.userDisplayName, isNull);
      expect(state.userEmail, isNull);
      expect(state.userPhotoUrl, isNull);
    });

    test('AuthUser model instantiates with demo and profile properties', () {
      const user = AuthUser(
        displayName: 'Google Demo User',
        email: 'demo.user@foodresq.org',
        isDemoFallback: true,
      );

      expect(user.displayName, equals('Google Demo User'));
      expect(user.email, equals('demo.user@foodresq.org'));
      expect(user.isDemoFallback, isTrue);
      expect(user.photoUrl, isNull);
    });

    test('AppState setRole updates activeRole and notifies listeners', () {
      final state = AppState();
      state.setRole(UserRole.restaurant);
      expect(state.activeRole, equals(UserRole.restaurant));

      state.setRole(UserRole.kirana);
      expect(state.activeRole, equals(UserRole.kirana));
    });
  });
}

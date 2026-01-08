import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<String?> register(String email, String password) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return 'Registration failed';
      }
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Unexpected error occurred';
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        return 'Login failed';
      }
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (_) {
      return 'Unexpected error occurred';
    }
  }

  Future<void> logout() async {
    await _client.auth.signOut();
  }

  bool isLoggedIn() {
    return _client.auth.currentSession != null;
  }

  String? currentUserEmail() {
    return _client.auth.currentUser?.email;
  }
}

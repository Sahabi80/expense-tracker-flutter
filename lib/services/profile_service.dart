import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  // ===============================
  // GET PROFILE (create if missing)
  // ===============================
  Future<Map<String, dynamic>> getProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final res = await _client
        .from('profiles')
        .select()
        .eq('user_id', user.id);

    if (res.isEmpty) {
      final created = await _client.from('profiles').insert({
        'user_id': user.id,
        'name': '',
        'avatar_url': null,
      }).select().single();

      return created;
    }

    return res.first;
  }

  // ===============================
  // UPDATE NAME
  // ===============================
  Future<void> updateName(String name) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client
        .from('profiles')
        .update({'name': name})
        .eq('user_id', user.id);
  }

  // ===============================
  // UPLOAD AVATAR (CACHE-SAFE)
  // ===============================
  Future<String> uploadAvatar(File file) async {
    final user = _client.auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final ext = file.path.split('.').last;

    // 🔥 timestamp avoids image caching
    final filePath =
        '${user.id}_${DateTime.now().millisecondsSinceEpoch}.$ext';

    await _client.storage.from('avatars').upload(
      filePath,
      file,
      fileOptions: const FileOptions(upsert: true),
    );

    final publicUrl =
    _client.storage.from('avatars').getPublicUrl(filePath);

    await _client
        .from('profiles')
        .update({'avatar_url': publicUrl})
        .eq('user_id', user.id);

    return publicUrl;
  }
}

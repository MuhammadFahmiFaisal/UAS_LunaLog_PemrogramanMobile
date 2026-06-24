import 'dart:io';
import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class SupabaseService {
  static final client = Supabase.instance.client;

  // CURRENT USER PROFILE
  static Future<UserProfile?> getUserProfile() async {
    final authUser = client.auth.currentUser;
    if (authUser == null) return null;

    final response = await client
        .from('user_profiles')
        .select()
        .eq('id', authUser.id)
        .maybeSingle();

    if (response == null) return null;
    return UserProfile.fromJson(response);
  }

  // UPDATE USER PROFILE
  static Future<void> updateUserProfile(UserProfile profile) async {
    final authUser = client.auth.currentUser;
    if (authUser == null) return;

    final data = <String, dynamic>{
      'name': profile.name,
      'email': profile.email,
      'avatar_url': profile.avatarUrl,
      'cycle_length': profile.cycleLength,
      'period_duration': profile.periodDuration,
    };

    if (profile.lastPeriodDate != null) {
      data['last_period_date'] = profile.lastPeriodDate!
          .toIso8601String()
          .split('T')[0];
    }
    if (profile.goal != null) {
      data['goal'] = profile.goal;
    }

    await client.from('user_profiles').update(data).eq('id', authUser.id);
  }

  // UPLOAD AVATAR TO SUPABASE STORAGE
  static Future<String?> uploadAvatar(File imageFile) async {
    final authUser = client.auth.currentUser;
    if (authUser == null) return null;

    final fileExt = imageFile.path.split('.').last;
    final fileName = '${authUser.id}/avatar.$fileExt';

    await client.storage
        .from('avatars')
        .upload(
          fileName,
          imageFile,
          fileOptions: const FileOptions(upsert: true),
        );

    final publicUrl = client.storage.from('avatars').getPublicUrl(fileName);
    return publicUrl;
  }

  // UPLOAD AVATAR FROM BYTES (Web-compatible)
  static Future<String?> uploadAvatarBytes(
    Uint8List bytes,
    String fileName,
  ) async {
    final authUser = client.auth.currentUser;
    if (authUser == null) return null;

    final fileExt = fileName.split('.').last;
    final storagePath = '${authUser.id}/avatar.$fileExt';

    await client.storage
        .from('avatars')
        .uploadBinary(
          storagePath,
          bytes,
          fileOptions: const FileOptions(
            upsert: true,
            contentType: 'image/jpeg',
          ),
        );

    final publicUrl = client.storage.from('avatars').getPublicUrl(storagePath);
    return publicUrl;
  }

  // PERIODS REPOSITORY
  static Future<List<Period>> getPeriods() async {
    final authUser = client.auth.currentUser;
    if (authUser == null) return [];

    final response = await client
        .from('periods')
        .select()
        .eq('user_profile_id', authUser.id)
        .order('start_date', ascending: false);

    return (response as List).map((e) => Period.fromJson(e)).toList();
  }

  static Future<Period?> getPeriod(String periodId) async {
    final response = await client
        .from('periods')
        .select()
        .eq('id', periodId)
        .maybeSingle();

    if (response == null) return null;
    return Period.fromJson(response);
  }

  static Future<void> addPeriod(Period period) async {
    final authUser = client.auth.currentUser;
    if (authUser == null) throw Exception('User not authenticated');

    final data = period.toJson();
    data.remove('id'); // Let Supabase generate ID if it's new
    data['user_profile_id'] = authUser.id;

    await client.from('periods').insert(data);
  }

  static Future<void> updatePeriod(String periodId, Period period) async {
    final data = period.toJson();
    data.remove('id');

    await client.from('periods').update(data).eq('id', periodId);
  }

  static Future<void> deletePeriod(String periodId) async {
    await client.from('periods').delete().eq('id', periodId);
  }

  // DAILY LOGS REPOSITORY
  static Future<List<DailyLog>> getDailyLogs() async {
    final authUser = client.auth.currentUser;
    if (authUser == null) return [];

    final response = await client
        .from('daily_logs')
        .select()
        .eq('user_profile_id', authUser.id)
        .order('log_date', ascending: false);

    return (response as List).map((e) => DailyLog.fromJson(e)).toList();
  }

  static Future<List<DailyLog>> getDailyLogsByDateRange(
    DateTime startDate,
    DateTime? endDate,
  ) async {
    final authUser = client.auth.currentUser;
    if (authUser == null) return [];

    var query = client
        .from('daily_logs')
        .select()
        .eq('user_profile_id', authUser.id)
        .gte('log_date', startDate.toIso8601String().split('T')[0]);

    if (endDate != null) {
      query = query.lte('log_date', endDate.toIso8601String().split('T')[0]);
    }

    final response = await query.order('log_date', ascending: true);
    return (response as List).map((e) => DailyLog.fromJson(e)).toList();
  }

  static Future<void> addDailyLog(DailyLog log) async {
    final authUser = client.auth.currentUser;
    if (authUser == null) throw Exception('User not authenticated');

    final data = log.toJson();
    data.remove('id');
    data['user_profile_id'] = authUser.id;

    // Upsert to handle unique constraint on (user_profile_id, log_date)
    await client
        .from('daily_logs')
        .upsert(data, onConflict: 'user_profile_id, log_date');
  }

  // ARTICLES REPOSITORY
  static Future<List<Article>> getArticles() async {
    final response = await client.from('articles').select();
    return (response as List).map((e) => Article.fromJson(e)).toList();
  }
}

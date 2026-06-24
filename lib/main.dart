import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await dotenv.load(fileName: ".env");
  
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']?.contains('YOUR_') == true 
        ? 'https://vghxvaezxrthiszhrale.supabase.co' 
        : (dotenv.env['SUPABASE_URL'] ?? 'https://vghxvaezxrthiszhrale.supabase.co'),
    publishableKey: dotenv.env['SUPABASE_ANON_KEY']?.contains('YOUR_') == true 
        ? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZnaHh2YWV6eHJ0aGlzemhyYWxlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE4MDY2MDQsImV4cCI6MjA5NzM4MjYwNH0.jkQG5Zo5hrkmD2qNva2RXvf3Gkdb4CfS3kUldSm8uhI' 
        : (dotenv.env['SUPABASE_ANON_KEY'] ?? 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZnaHh2YWV6eHJ0aGlzemhyYWxlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE4MDY2MDQsImV4cCI6MjA5NzM4MjYwNH0.jkQG5Zo5hrkmD2qNva2RXvf3Gkdb4CfS3kUldSm8uhI'),
  );

  // Auto-create user_profiles record for OAuth users (Google, Facebook, etc.)
  Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
    if (data.event == AuthChangeEvent.signedIn) {
      final user = data.session?.user;
      if (user != null) {
        try {
          final existing = await Supabase.instance.client
              .from('user_profiles')
              .select('id')
              .eq('id', user.id)
              .maybeSingle();

          if (existing == null) {
            await Supabase.instance.client.from('user_profiles').insert({
              'id': user.id,
              'name': user.userMetadata?['full_name'] ?? user.userMetadata?['name'] ?? '',
              'email': user.email ?? '',
              'avatar_url': user.userMetadata?['avatar_url'],
            });
          }
        } catch (_) {
          // Profile may already exist via trigger, ignore
        }
      }
    }
  });

  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LunaLog',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.routes,
    );
  }
}

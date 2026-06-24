import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/routes/app_routes.dart';
import '../../../shared/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(0);
      }
    });
    _floatController = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(reverse: true);

    // Listener untuk menangkap redirect balik dari browser OAuth
    Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
      if (!mounted) return;
      final event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        final prefs = await SharedPreferences.getInstance();
        final hasCompletedSetup = prefs.getBool('hasCompletedSetup') ?? false;
        if (!mounted) return;
        if (hasCompletedSetup) {
          final isPinEnabled = prefs.getBool('is_pin_enabled') ?? false;
          if (isPinEnabled) {
            Navigator.pushReplacementNamed(context, AppRoutes.lockScreen);
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.main);
          }
        } else {
          Navigator.pushReplacementNamed(context, AppRoutes.onboardingSetup);
        }
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final authResponse = await Supabase.instance.client.auth.signInWithPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        if (!mounted) return;

        if (authResponse.user != null) {
          final prefs = await SharedPreferences.getInstance();
          final hasCompletedSetup = prefs.getBool('hasCompletedSetup') ?? false;

          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login berhasil'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.green,
            ),
          );
          
          if (hasCompletedSetup) {
            final isPinEnabled = prefs.getBool('is_pin_enabled') ?? false;
            if (isPinEnabled) {
              Navigator.pushReplacementNamed(context, AppRoutes.lockScreen);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.main);
            }
          } else {
            Navigator.pushReplacementNamed(context, AppRoutes.onboardingSetup);
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Gagal login: email atau password salah'),
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
            ),
          );
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleOAuthLogin(OAuthProvider provider) async {
    setState(() => _isLoading = true);
    try {
      final redirectTo = kIsWeb
          ? '${Uri.base.origin}/'
          : 'io.lunalog.app://login-callback';

      await Supabase.instance.client.auth.signInWithOAuth(
        provider,
        redirectTo: redirectTo,
      );
      // Navigasi ditangani oleh onAuthStateChange listener di initState
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal masuk: $e'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthBackground(
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 40),
            _buildLogoHeader(),
            const SizedBox(height: 40),
            _buildLoginCard(),
            const SizedBox(height: 32),
            _buildFooterLink(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Column(
      children: [
        FloatingLogo(controller: _floatController),
        const SizedBox(height: 24),
        const Text(
          'Welcome Back',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF8B4A5F),
            letterSpacing: -0.01,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Senang melihatmu kembali di LunaLog.',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF524346),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginCard() {
    return AppCard(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              controller: _emailController,
              label: 'Email',
              hintText: 'nama@email.com',
              prefixIcon: Icons.mail_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Email tidak boleh kosong';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value.trim())) {
                  return 'Masukkan email yang valid';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Kata Sandi',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF311119),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.forgotPassword);
                  },
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Lupa sandi?',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF8B4A5F),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            AppTextField(
              controller: _passwordController,
              label: '',
              hintText: '••••••••',
              prefixIcon: Icons.lock_outlined,
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Kata sandi tidak boleh kosong';
                }
                if (value.trim().length < 6) {
                  return 'Kata sandi minimal 6 karakter';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF847376),
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 32),
            SubmitButton(
              label: 'Masuk',
              isLoading: _isLoading,
              onPressed: _handleLogin,
              icon: Icons.arrow_forward,
            ),
            const SocialLoginDivider(text: 'atau masuk dengan'),
            Row(
              children: [
                Expanded(
                  child: SocialButton(
                    label: 'Google',
                    onPressed: () => _handleOAuthLogin(OAuthProvider.google),
                    icon: SvgPicture.asset(
                      'assets/icons/google-logo.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF8B4A5F),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SocialButton(
                    label: 'Facebook',
                    onPressed: () => _handleOAuthLogin(OAuthProvider.facebook),
                    icon: const Icon(
                      Icons.facebook,
                      size: 20,
                      color: Color(0xFF8B4A5F),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Belum punya akun? ',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF524346),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, AppRoutes.register);
          },
          child: const Text(
            'Daftar di sini',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF8B4A5F),
            ),
          ),
        ),
      ],
    );
  }
}

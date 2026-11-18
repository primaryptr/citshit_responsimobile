// ============================================================
//  login_screen.dart
//  Halaman Login dengan SharedPreferences (Modul III).
//  Mendukung dua mode:
//    1. Mode Statis  -> AppConfig.useRegisterAuth = false
//    2. Mode Register -> AppConfig.useRegisterAuth = true
// ============================================================

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/app_config.dart';
import 'home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;
  String? _errorMessage;

  // ─── LIFECYCLE ─────────────────────────────────────────────────────────────
  @override
  void initState() {
    super.initState();
    _checkAlreadyLoggedIn();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── CHECK SESSION ─────────────────────────────────────────────────────────
  Future<void> _checkAlreadyLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool(AppConfig.prefKeyIsLoggedIn) ?? false;
    if (isLoggedIn && mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  // ─── LOGIN LOGIC ───────────────────────────────────────────────────────────
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    bool isValid = false;

    if (AppConfig.useRegisterAuth) {
      // ── Mode Register: Cek ke SharedPreferences ──────────────────────────
      // [GANTI SAAT RESPONSI: Mode ini aktif jika useRegisterAuth = true]
      final prefs = await SharedPreferences.getInstance();
      final savedPassword =
          prefs.getString('${AppConfig.prefKeyPasswordPrefix}$username');
      isValid = savedPassword == password;
    } else {
      // ── Mode Statis: Cek hardcoded credentials ───────────────────────────
      // [GANTI SAAT RESPONSI: Ganti AppConfig.staticUsername & staticPassword]
      isValid = username == AppConfig.staticUsername &&
          password == AppConfig.staticPassword;
    }

    if (isValid) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(AppConfig.prefKeyIsLoggedIn, true);
      await prefs.setString(AppConfig.prefKeyUsername, username);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      }
    } else {
      setState(() {
        _errorMessage = 'Username atau password salah!';
        _isLoading = false;
      });
    }

    if (_isLoading) setState(() => _isLoading = false);
  }

  // ─── BUILD UI ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // [GANTI SAAT RESPONSI: Warna background login screen]
      backgroundColor: AppConfig.primaryColor.shade50,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── Logo / Ikon ────────────────────────────────────────────
                // [GANTI SAAT RESPONSI: Ganti ikon sesuai tema aplikasi]
                // ignore: prefer_const_constructors
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppConfig.primaryColor,
                  child: const Icon(
                    Icons.lock_person_rounded, // [GANTI SAAT RESPONSI: ikon]
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // ── Judul ──────────────────────────────────────────────────
                Text(
                  AppConfig.appTitle,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppConfig.primaryColor.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  // [GANTI SAAT RESPONSI: Subtitle/deskripsi halaman login]
                  'Silakan masuk untuk melanjutkan',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 36),

                // ── Form Login ─────────────────────────────────────────────
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Username Field
                          TextFormField(
                            controller: _usernameController,
                            decoration: const InputDecoration(
                              // [GANTI SAAT RESPONSI: Label & hint username]
                              labelText: 'Username',
                              hintText: 'Masukkan username',
                              prefixIcon: Icon(Icons.person_outline),
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                          ),
                          const SizedBox(height: 16),

                          // Password Field
                          TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              // [GANTI SAAT RESPONSI: Label & hint password]
                              labelText: 'Password',
                              hintText: 'Masukkan password',
                              prefixIcon: const Icon(Icons.lock_outline),
                              border: const OutlineInputBorder(),
                              suffixIcon: IconButton(
                                icon: Icon(_obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () => setState(
                                    () => _obscurePassword = !_obscurePassword),
                              ),
                            ),
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                          ),

                          // Error Message
                          if (_errorMessage != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              _errorMessage!,
                              style: const TextStyle(
                                color: Colors.red,
                                fontSize: 13,
                              ),
                            ),
                          ],

                          const SizedBox(height: 20),

                          // Tombol Login
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConfig.primaryColor,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: _isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Masuk', // [GANTI SAAT RESPONSI: teks tombol]
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Link Register ──────────────────────────────────────────
                // [GANTI SAAT RESPONSI: Sembunyikan bagian ini jika soal tidak
                //  meminta Register (hanya login statis)]
                if (AppConfig.useRegisterAuth) ...[
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Belum punya akun? '),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const RegisterScreen()),
                          );
                        },
                        child: const Text('Daftar Sekarang'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

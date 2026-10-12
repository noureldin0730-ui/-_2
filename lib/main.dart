import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/map_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  runApp(const AlMusahehApp());
}

class AlMusahehApp extends StatelessWidget {
  const AlMusahehApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'المصحح',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF2B1D12),
      ),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            disableAnimations: true,
          ),
          child: child!,
        );
      },
      home: const StartScreen(),
    );
  }
}

// ═══════════ الألوان — ورق وخشب ═══════════
class P {
  static const wood = Color(0xFF2B1D12);
  static const woodLight = Color(0xFF3D2817);
  static const woodDark = Color(0xFF1A1109);

  static const paperWhite = Color(0xFFF0E8D8);
  static const paperBlue = Color(0xFFD8E0E8);
  static const paperGreen = Color(0xFFDDE8D8);
  static const paperYellow = Color(0xFFF0E8C8);

  static const paperLine = Color(0xFFB8B0A0);
  static const paperBorder = Color(0xFF8B7355);

  static const ink = Color(0xFF1A1A1A);
  static const inkBlue = Color(0xFF1E3A5F);
  static const inkRed = Color(0xFF8B1A1A);

  static const correct = Color(0xFF27AE60);
  static const partial = Color(0xFFE9B44C);
  static const wrong = Color(0xFFC0392B);

  static const dim = Color(0xFF8B7355);
  static const white = Color(0xFFF0E8D8);
}

// ═══════════ شاشة البداية — Landscape ═══════════
class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  void _start(BuildContext context) {
    HapticFeedback.lightImpact();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MapScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: P.wood,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [P.woodLight, P.wood, P.woodDark],
          ),
        ),
        child: SafeArea(
          child: Row(
            children: [
              // ────── الشمال: العنوان + الزر ──────
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ورقة عليها العنوان
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 20,
                        ),
                        decoration: BoxDecoration(
                          color: P.paperWhite,
                          border: Border.all(
                            color: P.paperBorder,
                            width: 1.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 14,
                              offset: const Offset(4, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 200,
                              height: 2,
                              color: P.paperLine,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'المصحح',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: P.ink,
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: 80,
                              height: 3,
                              color: P.inkRed,
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'صحّح ورق الطلاب... واحد واحد',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: P.inkBlue,
                                fontSize: 13,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              width: 200,
                              height: 2,
                              color: P.paperLine,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      // زر البدء
                      GestureDetector(
                        onTap: () => _start(context),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 48,
                            vertical: 18,
                          ),
                          decoration: BoxDecoration(
                            color: P.inkRed,
                            borderRadius: BorderRadius.circular(4),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(3, 5),
                              ),
                            ],
                          ),
                          child: const Text(
                            'ابدأ التصحيح',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: P.white,
                              fontSize: 20,
                              letterSpacing: 3,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        'Nour Developer',
                        style: TextStyle(
                          color: P.dim.withOpacity(0.7),
                          fontSize: 11,
                          letterSpacing: 3,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ────── اليمين: ورقة مصححة ──────
              Expanded(
                flex: 2,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // ورقة ورا (زرقاء)
                      Transform.translate(
                        offset: const Offset(15, 10),
                        child: Container(
                          width: 200,
                          height: 250,
                          decoration: BoxDecoration(
                            color: P.paperBlue,
                            border: Border.all(color: P.paperBorder),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(3, 5),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // ورقة أمام (عاجية)
                      Container(
                        width: 200,
                        height: 250,
                        decoration: BoxDecoration(
                          color: P.paperWhite,
                          border: Border.all(color: P.paperBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(3, 5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            ...List.generate(4, (i) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      i == 1
                                          ? Icons.close
                                          : Icons.check,
                                      color: i == 1
                                          ? P.inkRed
                                          : P.correct,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Container(
                                        height: 2,
                                        color: P.paperLine,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
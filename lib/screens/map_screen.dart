import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/exams_data.dart';
import '../data/save_manager.dart';
import 'exam_screen.dart';

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
  static const gold = Color(0xFFD4AF37);
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Map<int, int> _stars = {};
  int _currentPaper = 1;
  int _totalStars = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final stars = await SaveManager.getStars();
    final current = await SaveManager.getCurrentPaper();
    final total = await SaveManager.getTotalStars();
    if (!mounted) return;
    setState(() {
      _stars = stars;
      _currentPaper = current;
      _totalStars = total;
      _loading = false;
    });
  }

  Future<void> _openPaper(int id) async {
    final unlocked = await SaveManager.isUnlocked(id);
    if (!unlocked) {
      HapticFeedback.heavyImpact();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'صحّح الورقة اللي قبلها الأول',
            textDirection: TextDirection.rtl,
          ),
          backgroundColor: P.inkRed,
          duration: Duration(seconds: 1),
        ),
      );
      return;
    }
    HapticFeedback.mediumImpact();
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ExamScreen(paperId: id)),
    );
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: P.wood,
        body: Center(
          child: CircularProgressIndicator(color: P.inkRed),
        ),
      );
    }

    return Scaffold(
      backgroundColor: P.wood,
      body: Stack(
        children: [
          // خلفية خشب
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [P.woodLight, P.wood, P.woodDark],
              ),
            ),
          ),
          CustomPaint(
            size: MediaQuery.of(context).size,
            painter: _WoodGrainPainter(),
          ),

          SafeArea(
            child: Row(
              children: [
                // ────── العمود الأيسر: العنوان + النجوم ──────
                Container(
                  width: 220,
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.arrow_back_ios_new,
                              color: P.dim,
                              size: 14,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'رجوع',
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                color: P.dim,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      // ورقة صغيرة عليها العنوان
                      Transform.rotate(
                        angle: -0.04,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: P.paperWhite,
                            border: Border.all(color: P.paperBorder),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 16,
                                offset: const Offset(3, 5),
                              ),
                            ],
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'المصحح',
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  color: P.ink,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 3,
                                ),
                              ),
                              SizedBox(height: 4),
                              SizedBox(
                                width: 40,
                                height: 2,
                                child: ColoredBox(color: P.inkRed),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        '$_totalStars / ${kExams.length * 3} نجمة',
                        style: const TextStyle(
                          color: P.gold,
                          fontSize: 14,
                          letterSpacing: 2,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'الأوراق: ${kExams.length}',
                        style: const TextStyle(
                          color: P.dim,
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nour Developer',
                        style: TextStyle(
                          color: P.dim.withOpacity(0.6),
                          fontSize: 10,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),

                // ────── المنطقة اليمنى: الأوراق ──────
                Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    itemCount: kExams.length,
                    itemBuilder: (context, index) {
                      final exam = kExams[index];
                      final stars = _stars[exam.id] ?? 0;
                      final isCurrent = exam.id == _currentPaper;

                      return Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _PaperCard(
                          exam: exam,
                          stars: stars,
                          isCurrent: isCurrent,
                          onTap: () => _openPaper(exam.id),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════ كارت الورقة ═══════════════
class _PaperCard extends StatelessWidget {
  final ExamPaper exam;
  final int stars;
  final bool isCurrent;
  final VoidCallback onTap;

  const _PaperCard({
    required this.exam,
    required this.stars,
    required this.isCurrent,
    required this.onTap,
  });

  Color get _paperColor {
    switch (exam.id) {
      case 1:
        return P.paperWhite;
      case 2:
        return P.paperBlue;
      case 3:
        return P.paperYellow;
      case 4:
        return P.paperGreen;
      default:
        return P.paperWhite;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Transform.rotate(
        angle: (exam.id % 2 == 0 ? 0.02 : -0.02),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 260,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: _paperColor,
            border: Border.all(
              color: isCurrent ? P.inkRed : P.paperBorder,
              width: isCurrent ? 2.5 : 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isCurrent ? 0.65 : 0.45),
                blurRadius: isCurrent ? 28 : 18,
                offset: Offset(isCurrent ? 6 : 4, isCurrent ? 10 : 6),
              ),
              if (isCurrent)
                BoxShadow(
                  color: P.inkRed.withOpacity(0.3),
                  blurRadius: 40,
                  spreadRadius: 4,
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ───── رقم الورقة ─────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: P.inkRed,
                      borderRadius: BorderRadius.circular(2),
                    ),
                    child: Text(
                      'ورقة ${exam.id}',
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(
                        color: P.white,
                        fontSize: 11,
                        letterSpacing: 2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.edit_document,
                    color: isCurrent ? P.inkRed : P.dim,
                    size: 22,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // ───── اسم الطالب ─────
              Text(
                exam.studentName,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: P.ink,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                exam.className,
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: P.inkBlue,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 12),
              Container(height: 1, color: P.paperLine),
              const SizedBox(height: 10),
              // ───── عدد الأسئلة ─────
              Row(
                children: [
                  const Icon(Icons.quiz, color: P.inkBlue, size: 14),
                  const SizedBox(width: 6),
                  Text(
                    '${exam.questions.length} أسئلة',
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: P.inkBlue,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // ───── النجوم ─────
              Row(
                children: List.generate(3, (i) {
                  final filled = i < stars;
                  return Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Icon(
                      filled ? Icons.star : Icons.star_border,
                      color: filled ? P.gold : P.dim,
                      size: 18,
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════ خطوط الخشب ═══════════
class _WoodGrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.06)
      ..strokeWidth = 1.5;

    for (int i = 0; i < size.height; i += 40) {
      final path = Path();
      path.moveTo(0, i.toDouble());
      for (double x = 0; x < size.width; x += 60) {
        path.lineTo(x, i + (x % 120 == 0 ? 3 : -3));
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
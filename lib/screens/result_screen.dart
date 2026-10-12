import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/exams_data.dart';

class P {
  static const wood = Color(0xFF2B1D12);
  static const woodLight = Color(0xFF3D2817);
  static const woodDark = Color(0xFF1A1109);
  static const paperWhite = Color(0xFFF0E8D8);
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

class ResultScreen extends StatefulWidget {
  final ExamPaper exam;
  final int stars;
  final List<double?> playerMarks;
  final int correctCount;

  const ResultScreen({
    super.key,
    required this.exam,
    required this.stars,
    required this.playerMarks,
    required this.correctCount,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..forward();
    HapticFeedback.mediumImpact();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _back() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: P.wood,
      body: Stack(
        children: [
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
            child: FadeTransition(
              opacity: _ctrl,
              child: Row(
                children: [
                  // ────── الشمال: النتيجة ──────
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Transform.rotate(
                        angle: -0.02,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: P.paperWhite,
                            border: Border.all(
                              color: P.paperBorder,
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.6),
                                blurRadius: 24,
                                offset: const Offset(5, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: P.correct,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'خلصت التصحيح',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      color: P.ink,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Container(height: 2, color: P.inkRed),
                              const SizedBox(height: 16),
                              _infoRow('الطالب', widget.exam.studentName),
                              const SizedBox(height: 8),
                              _infoRow('الصف', widget.exam.className),
                              const SizedBox(height: 8),
                              _infoRow('المادة', widget.exam.subject),
                              const SizedBox(height: 20),
                              Container(height: 1, color: P.paperLine),
                              const SizedBox(height: 16),
                              // ───── النتيجة ─────
                              Row(
                                children: [
                                  const Icon(
                                    Icons.quiz,
                                    color: P.inkRed,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'صححت ${widget.correctCount} من ${widget.exam.questions.length} صح',
                                    textDirection: TextDirection.rtl,
                                    style: const TextStyle(
                                      color: P.ink,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // ───── النجوم ─────
                              Row(
                                children: List.generate(3, (i) {
                                  final filled = i < widget.stars;
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Icon(
                                      filled ? Icons.star : Icons.star_border,
                                      color: filled ? P.gold : P.dim,
                                      size: 48,
                                    ),
                                  );
                                }),
                              ),
                              const Spacer(),
                              // ───── زر التالي ─────
                              GestureDetector(
                                onTap: _back,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: P.correct,
                                    borderRadius: BorderRadius.circular(4),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.black.withOpacity(0.4),
                                        blurRadius: 10,
                                        offset: const Offset(2, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Text(
                                    'الورقة التالية',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                      color: P.white,
                                      fontSize: 16,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // ────── اليمين: تفاصيل التصحيح ──────
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'التصحيح الرسمي',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              color: P.gold,
                              fontSize: 18,
                              letterSpacing: 2,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.builder(
                              itemCount: widget.exam.questions.length,
                              itemBuilder: (context, i) {
                                final q = widget.exam.questions[i];
                                final playerMark = widget.playerMarks[i];
                                final isCorrect =
                                    playerMark == q.correctMark;
                                return _questionRow(
                                  index: i + 1,
                                  question: q,
                                  playerMark: playerMark,
                                  isCorrect: isCorrect,
                                );
                              },
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
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            '$label:',
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: P.inkBlue,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: P.ink,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _questionRow({
    required int index,
    required Question question,
    required double? playerMark,
    required bool isCorrect,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: P.paperWhite,
        border: Border.all(
          color: isCorrect ? P.correct : P.wrong,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(2, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isCorrect ? P.correct : P.wrong,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$index',
                  style: const TextStyle(
                    color: P.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  question.prompt,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: P.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _markChip(
                label: 'إجابة الطالب',
                value: question.answer,
                color: P.inkBlue,
              ),
              const SizedBox(width: 10),
              _markChip(
                label: 'تصحيحك',
                value: _markLabel(playerMark),
                color: isCorrect ? P.correct : P.wrong,
              ),
              const SizedBox(width: 10),
              _markChip(
                label: 'الصح',
                value: _markLabel(question.correctMark),
                color: P.gold,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _markChip({
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: P.wood,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: color.withOpacity(0.8),
                fontSize: 9,
                letterSpacing: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              value,
              textDirection: TextDirection.rtl,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: P.white,
                fontSize: 11,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _markLabel(double? mark) {
    if (mark == null) return '؟';
    if (mark == 1.0) return 'صح';
    if (mark == 0.5) return 'نص';
    return 'غلط';
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
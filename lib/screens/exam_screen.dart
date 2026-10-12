import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../data/exams_data.dart';
import '../data/save_manager.dart';
import 'result_screen.dart';

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

class ExamScreen extends StatefulWidget {
  final int paperId;
  const ExamScreen({super.key, required this.paperId});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late ExamPaper _exam;

  // لكل سؤال، اختيار اللاعب: 1 / 0.5 / 0 / null (لسه مختارش)
  late List<double?> _playerMarks;

  int _currentQ = 0;          // السؤال الحالي
  int _correctChoices = 0;    // عدد الأسئلة اللي اللاعب صححها صح
  int _wrongChoices = 0;      // عدد الأسئلة اللي اللاعب غلط فيها
  bool _showGameOver = false;

  @override
  void initState() {
    super.initState();
    _exam = kExams.firstWhere((e) => e.id == widget.paperId);
    _playerMarks = List<double?>.filled(_exam.questions.length, null);
  }

  // ═══════════ اختار درجة ═══════════
  void _chooseMark(double mark) {
    if (_currentQ >= _exam.questions.length) return;

    HapticFeedback.mediumImpact();

    setState(() {
      _playerMarks[_currentQ] = mark;
    });

    // استنى شوية بعدين انتقل للسؤال اللي بعده
    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      _nextQuestion();
    });
  }

  void _nextQuestion() {
    setState(() {
      _currentQ++;
    });
    if (_currentQ >= _exam.questions.length) {
      _finish();
    }
  }

  void _finish() {
    // احسب نتيجة اللاعب
    int correct = 0;
    for (int i = 0; i < _exam.questions.length; i++) {
      if (_playerMarks[i] == _exam.questions[i].correctMark) {
        correct++;
      }
    }
    _correctChoices = correct;
    _wrongChoices = _exam.questions.length - correct;

    // النجوم
    int stars;
    if (correct == 5) {
      stars = 3;
    } else if (correct == 4) {
      stars = 2;
    } else if (correct == 3) {
      stars = 1;
    } else {
      // فشل
      setState(() => _showGameOver = true);
      return;
    }

    // احفظ
    SaveManager.setStars(_exam.id, stars);
    if (_exam.id < kExams.length) {
      SaveManager.unlock(_exam.id + 1);
      SaveManager.setCurrentPaper(_exam.id + 1);
    }

    // روح لشاشة النتيجة
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => ResultScreen(
          exam: _exam,
          stars: stars,
          playerMarks: List<double?>.from(_playerMarks),
          correctCount: _correctChoices,
        ),
      ),
    );
  }

  void _retry() {
    setState(() {
      _currentQ = 0;
      _playerMarks = List<double?>.filled(_exam.questions.length, null);
      _correctChoices = 0;
      _wrongChoices = 0;
      _showGameOver = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showGameOver) {
      return _buildGameOver();
    }

    final q = _exam.questions[_currentQ];

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
            child: Column(
              children: [
                // ────── الشريط العلوي ──────
                _buildTopBar(),

                // ────── المحتوى ──────
                Expanded(
                  child: Row(
                    children: [
                      // ────── الشمال: معلومات الورقة ──────
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _buildPaperInfo(),
                        ),
                      ),
                      // ────── اليمين: السؤال الحالي ──────
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: _buildQuestionCard(q),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════ الشريط العلوي ═══════════
  Widget _buildTopBar() {
    final progress = (_currentQ + 1) / _exam.questions.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: P.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'ورقة ${_exam.id}',
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: P.white,
              fontSize: 14,
              letterSpacing: 2,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${_currentQ + 1} / ${_exam.questions.length}',
            style: const TextStyle(color: P.gold, fontSize: 13),
          ),
          const Spacer(),
          // شريط التقدم
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'التقدم',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(color: P.dim, fontSize: 10),
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: P.woodDark,
                    valueColor: const AlwaysStoppedAnimation(P.gold),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Text(
            'Nour Developer',
            style: TextStyle(
              color: P.dim.withOpacity(0.5),
              fontSize: 10,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  // ═══════════ معلومات الورقة (شمال) ═══════════
  Widget _buildPaperInfo() {
    return Transform.rotate(
      angle: -0.02,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: P.paperWhite,
          border: Border.all(color: P.paperBorder, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(4, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───── رأس الورقة ─────
            Row(
              children: [
                const Icon(Icons.school, color: P.inkRed, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'مدرسة النور الإعدادية',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    color: P.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Container(height: 1.5, color: P.inkRed),
            const SizedBox(height: 16),
            _infoLine('الاسم', _exam.studentName),
            const SizedBox(height: 8),
            _infoLine('الصف', _exam.className),
            const SizedBox(height: 8),
            _infoLine('المادة', _exam.subject),
            const SizedBox(height: 16),
            Container(height: 1, color: P.paperLine),
            const SizedBox(height: 12),
            const Text(
              'ملاحظة المعلم:',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: P.inkRed,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _exam.teacherNote,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: P.inkBlue,
                fontSize: 12,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
            const Spacer(),
            // ───── ختم ─────
            Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: P.inkRed, width: 2),
                ),
                child: const Center(
                  child: Text(
                    'مصحح',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: P.inkRed,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoLine(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 50,
          child: Text(
            '$label:',
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              color: P.inkBlue,
              fontSize: 11,
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

  // ═══════════ كارت السؤال (يمين) ═══════════
  Widget _buildQuestionCard(Question q) {
    return Transform.rotate(
      angle: 0.015,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: P.paperWhite,
          border: Border.all(color: P.paperBorder, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 20,
              offset: const Offset(4, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ───── رقم السؤال ─────
            Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: P.inkRed,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${_currentQ + 1}',
                    style: const TextStyle(
                      color: P.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'السؤال ${_currentQ + 1}',
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: P.ink,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(height: 1, color: P.paperLine),
            const SizedBox(height: 16),
            // ───── نص السؤال ─────
            Text(
              q.prompt,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: P.ink,
                fontSize: 18,
                fontWeight: FontWeight.w700,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            // ───── إجابة الطالب ─────
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: P.paperWhite,
                border: Border.all(color: P.paperLine),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'إجابة الطالب:',
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      color: P.inkBlue,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.edit, color: P.inkBlue, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          q.answer,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            color: P.inkBlue,
                            fontSize: 16,
                            height: 1.6,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
            // ───── الأزرار ─────
            const Text(
              'إيه التصحيح الصح؟',
              textDirection: TextDirection.rtl,
              style: TextStyle(
                color: P.ink,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _answerButton(
                    label: 'صح',
                    icon: Icons.check,
                    color: P.correct,
                    mark: 1.0,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _answerButton(
                    label: 'نص',
                    icon: Icons.percent,
                    color: P.partial,
                    mark: 0.5,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _answerButton(
                    label: 'غلط',
                    icon: Icons.close,
                    color: P.wrong,
                    mark: 0.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _answerButton({
    required String label,
    required IconData icon,
    required Color color,
    required double mark,
  }) {
    return GestureDetector(
      onTap: () => _chooseMark(mark),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: P.white, size: 24),
            const SizedBox(height: 6),
            Text(
              label,
              textDirection: TextDirection.rtl,
              style: const TextStyle(
                color: P.white,
                fontSize: 15,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ═══════════ شاشة الفشل ═══════════
  Widget _buildGameOver() {
    return Scaffold(
      backgroundColor: P.wood,
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(40),
          margin: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            color: P.paperWhite,
            border: Border.all(color: P.inkRed, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 30,
                offset: const Offset(6, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.cancel, color: P.inkRed, size: 60),
              const SizedBox(height: 16),
              const Text(
                'فشلت في التصحيح',
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  color: P.inkRed,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'صححت $_correctChoices من ${_exam.questions.length} صح',
                textDirection: TextDirection.rtl,
                style: const TextStyle(
                  color: P.inkBlue,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: P.wood,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'للخريطة',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: P.white, fontSize: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: _retry,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: P.inkRed,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'من جديد',
                        textDirection: TextDirection.rtl,
                        style: TextStyle(color: P.white, fontSize: 14),
                      ),
                    ),
                  ),
                ],
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
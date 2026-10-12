class Question {
  final String prompt;      // السؤال
  final String answer;      // إجابة الطالب
  final double correctMark; // الدرجة الصح (1 / 0.5 / 0)
  const Question({
    required this.prompt,
    required this.answer,
    required this.correctMark,
  });
}

class ExamPaper {
  final int id;
  final String studentName;
  final String className;
  final String subject;
  final List<Question> questions;
  final String teacherNote;
  const ExamPaper({
    required this.id,
    required this.studentName,
    required this.className,
    required this.subject,
    required this.questions,
    required this.teacherNote,
  });
}

const List<ExamPaper> kExams = [
  // ═══════ الورقة 1 — الطالب المجتهد ═══════
  ExamPaper(
    id: 1,
    studentName: 'أحمد محمود',
    className: 'الصف الثالث',
    subject: 'لغة عربية',
    teacherNote: 'ورقة نظيفة، الخط واضح.',
    questions: [
      Question(
        prompt: 'ما مفرد كلمة "كتب"؟',
        answer: 'كتاب',
        correctMark: 1.0,
      ),
      Question(
        prompt: 'ما جمع كلمة "قلم"؟',
        answer: 'أقلام',
        correctMark: 1.0,
      ),
      Question(
        prompt: 'ما مضاد كلمة "كبير"؟',
        answer: 'صغير',
        correctMark: 1.0,
      ),
      Question(
        prompt: 'ما مفرد كلمة "أشجار"؟',
        answer: 'شجرة',
        correctMark: 1.0,
      ),
      Question(
        prompt: 'ما جمع كلمة "بيت"؟',
        answer: 'بيوت',
        correctMark: 1.0,
      ),
    ],
  ),

  // ═══════ الورقة 2 — الطالب المتوسط ═══════
  ExamPaper(
    id: 2,
    studentName: 'سارة إبراهيم',
    className: 'الصف الثالث',
    subject: 'لغة عربية',
    teacherNote: 'خط مش مرتب، بس فيه إجابات كويسة.',
    questions: [
      Question(
        prompt: 'ما مفرد كلمة "تلاميذ"؟',
        answer: 'تلميذ',
        correctMark: 1.0,
      ),
      Question(
        prompt: 'ما جمع كلمة "معلمة"؟',
        answer: 'معلمين',
        correctMark: 0.5, // جمع مذكر، الصح "معلمات"
      ),
      Question(
        prompt: 'ما مضاد كلمة "فرح"؟',
        answer: 'حزن',
        correctMark: 1.0,
      ),
      Question(
        prompt: 'ما مفرد كلمة "مدارس"؟',
        answer: 'مدرسه',  // همزة ناقصة
        correctMark: 0.5,
      ),
      Question(
        prompt: 'ما جمع كلمة "قصة"؟',
        answer: 'قصص',
        correctMark: 1.0,
      ),
    ],
  ),

  // ═══════ الورقة 3 — الطالب الضعيف ═══════
  ExamPaper(
    id: 3,
    studentName: 'محمد عادل',
    className: 'الصف الثالث',
    subject: 'لغة عربية',
    teacherNote: 'الطالب مش مركز. نص الإجابات فاضية.',
    questions: [
      Question(
        prompt: 'ما مفرد كلمة "أقلام"؟',
        answer: 'قلم',
        correctMark: 1.0,
      ),
      Question(
        prompt: 'ما جمع كلمة "كتاب"؟',
        answer: 'مكتبة',  // غلط
        correctMark: 0.0,
      ),
      Question(
        prompt: 'ما مضاد كلمة "سعيد"؟',
        answer: 'حزين',
        correctMark: 1.0,
      ),
      Question(
        prompt: 'ما مفرد كلمة "أقمار"؟',
        answer: 'قمر',
        correctMark: 1.0,
      ),
      Question(
        prompt: 'ما جمع كلمة "ورقة"؟',
        answer: 'مش عارف',  // غلط
        correctMark: 0.0,
      ),
    ],
  ),

  // ═══════ الورقة 4 — الطالب اللي غش ═══════
  ExamPaper(
    id: 4,
    studentName: 'يوسف حسن',
    className: 'الصف الثالث',
    subject: 'لغة عربية',
    teacherNote:
        'الخط مش خطه. في ورق مطبوع تحت الورقة. إجاباته مطابقة لورقة زميله.',
    questions: [
      Question(
        prompt: 'ما مفرد كلمة "مُعلمون"؟',
        answer: 'معلم',
        correctMark: 1.0,
      ),
      Question(
        prompt: 'ما جمع كلمة "طالب"؟',
        answer: 'طلاب',
        correctMark: 1.0,
      ),
      Question(
        prompt: 'ما مضاد كلمة "قوي"؟',
        answer: 'ضعيف',
        correctMark: 1.0,
      ),
      Question(
        prompt: 'ما مفرد كلمة "أنهار"؟',
        answer: 'نهر',
        correctMark: 1.0,
      ),
      Question(
        prompt: 'ما جمع كلمة "مدينة"؟',
        answer: 'مدن',
        correctMark: 1.0,
      ),
    ],
  ),

  // ═══════ الورقة 5 — الطالب اللي كتب أغنية ═══════
  ExamPaper(
    id: 5,
    studentName: 'ليلى سمير',
    className: 'الصف الثالث',
    subject: 'لغة عربية',
    teacherNote: 'الطالبة كتبت أغنية بدل الإجابات.',
    questions: [
      Question(
        prompt: 'ما مفرد كلمة "أزهار"؟',
        answer: 'زهرة حلوة في الجناين بتضحك للشمس',
        correctMark: 0.0,
      ),
      Question(
        prompt: 'ما جمع كلمة "عصفور"؟',
        answer: 'عصافير بتغني فوق الشجر',
        correctMark: 0.0,
      ),
      Question(
        prompt: 'ما مضاد كلمة "ضحك"؟',
        answer: 'عيّاط من قلب مكسور',
        correctMark: 0.0,
      ),
      Question(
        prompt: 'ما مفرد كلمة "كواكب"؟',
        answer: 'كوكب في السما بيتوه',
        correctMark: 0.0,
      ),
      Question(
        prompt: 'ما جمع كلمة "نجمة"؟',
        answer: 'نجوم بتنور في الليل',
        correctMark: 0.0,
      ),
    ],
  ),
];
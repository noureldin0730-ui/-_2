import 'package:shared_preferences/shared_preferences.dart';

class SaveManager {
  static Future<Map<int, int>> getStars() async {
    final p = await SharedPreferences.getInstance();
    final map = <int, int>{};
    for (int i = 1; i <= 5; i++) {
      map[i] = p.getInt('stars_$i') ?? 0;
    }
    return map;
  }

  static Future<void> setStars(int paperId, int stars) async {
    final p = await SharedPreferences.getInstance();
    final current = p.getInt('stars_$paperId') ?? 0;
    if (stars > current) {
      await p.setInt('stars_$paperId', stars);
    }
  }

  static Future<bool> isUnlocked(int paperId) async {
    if (paperId == 1) return true;
    final p = await SharedPreferences.getInstance();
    return p.getBool('unlocked_$paperId') ?? false;
  }

  static Future<void> unlock(int paperId) async {
    final p = await SharedPreferences.getInstance();
    await p.setBool('unlocked_$paperId', true);
  }

  static Future<int> getCurrentPaper() async {
    final p = await SharedPreferences.getInstance();
    return p.getInt('current_paper') ?? 1;
  }

  static Future<void> setCurrentPaper(int paperId) async {
    final p = await SharedPreferences.getInstance();
    await p.setInt('current_paper', paperId);
  }

  static Future<int> getTotalStars() async {
    final stars = await getStars();
    return stars.values.fold<int>(0, (a, b) => a + b);
  }

  static Future<void> resetAll() async {
    final p = await SharedPreferences.getInstance();
    for (int i = 1; i <= 5; i++) {
      await p.remove('stars_$i');
      await p.remove('unlocked_$i');
    }
    await p.remove('current_paper');
  }
}
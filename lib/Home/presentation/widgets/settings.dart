import 'package:shared_preferences/shared_preferences.dart';

class AppSettings {
  static double volumeLevel = 0.5;
  static bool isSilentModeEnabled = false;
  static bool isSleepModeEnabled = false;
  static String selectedLanguage = "العربية";
  static bool isCustomModeEnabled = false;
  static List<String> customAzkar = [];

  // تحميل الإعدادات من SharedPreferences
  static Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    volumeLevel = prefs.getDouble('volumeLevel') ?? 0.5;
    isSilentModeEnabled = prefs.getBool('isSilentModeEnabled') ?? false;
    isSleepModeEnabled = prefs.getBool('isSleepModeEnabled') ?? false;
    selectedLanguage = prefs.getString('selectedLanguage') ?? "العربية";
    isCustomModeEnabled = prefs.getBool('isCustomModeEnabled') ?? false;
    customAzkar = prefs.getStringList('customAzkar') ?? [];
  }

  // حفظ قيمة معينة في SharedPreferences
  static Future<void> saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key, value);
    }
  }

  // مسح الأذكار المخصصة
  static Future<void> clearCustomAzkar() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('customAzkar');
    customAzkar = [];
    print("تم مسح الاذكار المخصصه");

  }

  // التحقق إذا كان التطبيق يُفتح لأول مرة
  static Future<void> checkFirstTimeOpen() async {
    final prefs = await SharedPreferences.getInstance();
    final isFirstTime = prefs.getBool('isFirstTimeOpen') ?? true;

    if (isFirstTime) {
      await prefs.remove('customAzkar'); // مسح الأذكار المخصصة
      await prefs.setBool('isFirstTimeOpen', false);
    }
  }

}

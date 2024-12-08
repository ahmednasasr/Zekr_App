import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:wakelock_plus/wakelock_plus.dart'; // تأكد من استيراد الحزمة

class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  final AudioPlayer audioPlayer = AudioPlayer();

  bool _isNotificationsActive = false; // حالة الإشعارات
  Timer? _notificationTimer;
  String audioPath = '';

  bool isSleepModeEnabled = false;

  String? selectedDhikr;
  int? selectedTime;
  String? randomZekr;

  factory NotificationService() {
    return instance;
  }

  NotificationService._internal();

  Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    await checkAndRequestPermission();
    await checkAndRequestExactAlarmPermission();

    // إعدادات التهيئة لنظام أندرويد
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    // إعدادات التهيئة لنظام iOS
    DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification, // لمعالجة الإشعارات القديمة
    );

    // إعدادات التهيئة العامة
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onSelectNotification, // لمعالجة النقر
    );

    tz.initializeTimeZones();
    await _loadSettings();

    await startBackgroundTask();
  }

// دالة لمعالجة الإشعارات المحلية عند تلقيها على iOS
  Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // يمكنك تنفيذ أي إجراء عند تلقي إشعار محلي
    print("Notification Received: $title - $body");
  }

// دالة لمعالجة الاستجابة عند تفاعل المستخدم مع الإشعار
  Future<void> onSelectNotification(NotificationResponse response) async {
    // التعامل مع النقر على الإشعار
    print("Notification clicked with payload: ${response.payload}");
  }


  Future<void> checkAndRequestPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
    if (await Permission.ignoreBatteryOptimizations.isDenied) {
      await Permission.ignoreBatteryOptimizations.request();
    }
  }

  Future<void> sendRandomZekr({
    required int intervalInSeconds,
    required int id,
  }) async {
    await startBackgroundTask();

    final List<String> dhikrs = [
      "سبحان الله",
      "سبحان الله العظيم",
      "لا إله إلا الله",
      "الله أكبر",
      "الحمد لله",
    ];

    final AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'dhikr_channel',
      'اذكار التنبيهات',
      importance: Importance.max,
      priority: Priority.max,
      playSound: false,
      enableVibration: true,
      visibility: NotificationVisibility.secret, // إخفاء الإشعار عن المستخدم
    );

    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    // إلغاء المؤقت القديم إذا كان موجودًا
    _notificationTimer?.cancel();

    // إشعارات دورية
    _notificationTimer =
        Timer.periodic(Duration(seconds: intervalInSeconds), (timer) async {
          // اختيار ذكر عشوائي من القائمة
          randomZekr = _getRandomZekr(dhikrs);

          // إرسال الإشعار مع الصوت
          await _sendNotificationWithAudio(id, randomZekr!, notificationDetails);
        });

    // حفظ الإعدادات الجديدة
    await _saveSettings('Random Zekr', intervalInSeconds);
  }

  String _getRandomZekr(List<String> dhikrs) {
    final random = Random();
    final randomIndex = random.nextInt(dhikrs.length); // اختيار عشوائي
    return dhikrs[randomIndex];
  }

  Future<void> checkAndRequestExactAlarmPermission() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      final deviceInfo = DeviceInfoPlugin();
      final androidInfo = await deviceInfo.androidInfo;

      if (androidInfo.version.sdkInt >= 31) {
        if (await Permission.notification.isDenied) {
          await Permission.notification.request();
        }
      }
    }
  }


  Future<void> _saveSettings(String? dhikr, int? time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('dhikr', dhikr ?? '');
    await prefs.setInt('time', time ?? 0);
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    selectedDhikr = prefs.getString('dhikr');
    selectedTime = prefs.getInt('time');
  }

  Future<void> startPeriodicNotifications({
    required String dhikr,
    required int intervalInSeconds,
    required int id,
  }) async {
    await startBackgroundTask();
    await WakelockPlus.enable();

    final AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      'dhikr_channel',
      'اذكار التنبيهات',
      importance: Importance.max,
      priority: Priority.max,
      playSound: false,
      enableVibration: true,
      visibility: NotificationVisibility.secret, // إخفاء الإشعار عن المستخدم
    );

    final NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    // إرسال الإشعار الأول مع الصوت
    await _sendNotificationWithAudio(id, dhikr, notificationDetails);

    // إلغاء المؤقت القديم إذا كان موجودًا
    _notificationTimer?.cancel();

    // إشعارات دورية
    _notificationTimer =
        Timer.periodic(Duration(seconds: intervalInSeconds), (timer) async {
          await _sendNotificationWithAudio(id, dhikr, notificationDetails);
        });

    // حفظ الإعدادات الجديدة
    await _saveSettings(dhikr, intervalInSeconds);
  }
  Future<void> _sendNotificationWithAudio(
      int id, String dhikr, NotificationDetails details) async {
    if (_isNotificationsActive) {
      print("فتحنا يعم ");
      // إيقاظ الشاشة عند إرسال الإشعار
      await WakelockPlus.enable();  // تفعيل إيقاظ الشاشة باستخدام wakelock_plus

      // تشغيل الصوت عند إرسال الإشعار
      await _playAudio(dhikr);

      // إرسال الإشعار
      await flutterLocalNotificationsPlugin.show(
        id,
        'تذكير: $dhikr',
        'هذا هو التذكير الخاص بك',
        details,
      );

    }
  }

  Future<void> _playAudio(String dhikr) async {
    // إعادة تعيين audioPath في كل مرة
    audioPath = '';

    switch (dhikr) {
      case "سبحان الله":
        audioPath = 'sound/subhan_allah.mp3';
        break;
      case "سبحان الله العظيم":
        audioPath = 'sound/subhan_allah_aleem.mp3';
        break;
      case "لا إله إلا الله وحده لا شريك له له الملك وله الحمد وهو علي كل شي قدير":
        audioPath = 'sound/la_ilah_illa_allah_wahdah.mp3';
        break;
      case "الله أكبر":
        audioPath = 'sound/allah_akbar.mp3';
        break;
      case "الحمد لله":
        audioPath = 'sound/alhamdulillah.mp3';
        break;
      case "لا اله الا انت سبحانك اني كنت من الظالمين":
        audioPath = 'sound/la_ilah_illa_anta_subhanaka.mp3';
        break;
      case "صلي علي محمد":
        audioPath = 'sound/sallu_ala_mohammad.mp3';
        break;
      case "تباركت يا ذا الجلال والإكرام":
        audioPath = 'sound/tabarakt_ya_dha_aljalal.mp3';
        break;
      case "سبحانك اللهم وبحمدك":
        audioPath = 'sound/subhanaka_allahuma.mp3';
        break;
      default:
        print("Unknown : $dhikr");
        return; // توقف العملية
    }

    try {
      // تشغيل الصوت باستخدام مكتبة Audioplayer
      await audioPlayer.play(AssetSource(audioPath));
    } catch (e) {
      print("Error playing audio: $e");
    }
  }

  Future<void> startBackgroundTask() async {
    await FlutterBackground.initialize();
    bool hasPermissions = await FlutterBackground.hasPermissions;
    if (!hasPermissions) {
      print("أذونات الخلفية غير ممنوحة");
    }

    await FlutterBackground.enableBackgroundExecution();
  }

  Future<void> refreshNotfication() async {
    await flutterLocalNotificationsPlugin.cancelAll(); // إلغاء جميع الإشعارات
    _isNotificationsActive = false; // تعطيل حالة الإشعارات
    _notificationTimer?.cancel(); // إلغاء أي مؤقت يعمل
    await audioPlayer.stop(); // إيقاف الصوت إذا كان يعمل
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll(); // إلغاء جميع الإشعارات
    _isNotificationsActive = false; // تعطيل حالة الإشعارات
    _notificationTimer?.cancel(); // إلغاء أي مؤقت يعمل
    await audioPlayer.stop(); // إيقاف الصوت إذا كان يعمل

    // إعادة تعيين audioPath إذا كانت معرّفة مسبقًا
    audioPath = '';

    // مسح الإعدادات المخزنة
    await clearSettings();
  }

  Future<void> clearSettings() async {
    // إعادة تعيين القيم الداخلية
    selectedDhikr = null;
    selectedTime = null;
    randomZekr = null;

    // مسح الإعدادات من SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('dhikr'); // حذف الذكر المخزن
    await prefs.remove('time'); // حذف الوقت المخزن
    await prefs.remove('Random Zekr');

    print("تم مسح الإعدادات المخزنة والإعدادات الحالية.");
  }

  void toggleNotifications(bool isActive) async {
    _isNotificationsActive = isActive;

    if (!isActive) {
      // إذا كانت الإشعارات غير مفعلة، نقوم بمسح كل الإعدادات
    } else {
      // إذا كانت الإشعارات مفعلة، نبدأ في إرسال الإشعارات إذا كان هناك بيانات مخزنة
      if (selectedDhikr != null && selectedTime != null) {
        await startPeriodicNotifications(
          dhikr: selectedDhikr!,
          intervalInSeconds: selectedTime!,
          id: 0, // ID افتراضي
        );
      }
    }
  }

  void toggleRandomNotifications(bool isActive) async {
    _isNotificationsActive = isActive;

    if (!isActive) {
      // إذا كانت الإشعارات غير مفعلة، نقوم بمسح كل الإعدادات
    } else {
      // إذا كانت الإشعارات مفعلة، نبدأ في إرسال الإشعارات إذا كان هناك بيانات مخزنة
      if (selectedDhikr != null && selectedTime != null) {
        await NotificationService.instance.sendRandomZekr(
          intervalInSeconds: selectedTime!,
          id: 999, // يمكن استخدام معرّف ثابت أو حسابي
        );
      }
    }
  }

  Future<void> handleSleepMode(bool isEnabled) async {
    print("تم استدعاء handleSleepMode: $isEnabled");

    // تحميل الإعدادات عند العودة من وضع النوم
    await _loadSettings();

    print("القيم المخزنة - Dhikr: $selectedDhikr, Time: $selectedTime");

    if (isEnabled) {
      // إيقاف الإشعارات أثناء النوم
      await refreshNotfication();
    } else {
      // عند تعطيل وضع النوم، استئناف الإشعارات
      if (selectedDhikr != null && selectedTime != null) {
        print("استئناف الإشعارات");

        if (selectedDhikr == "Random Zekr") {
          // استدعاء دالة sendRandomZekr
          NotificationService.instance.toggleRandomNotifications(true);
          NotificationService.instance.sendRandomZekr(
            intervalInSeconds: selectedTime!,
            id: 999, // يمكن استخدام معرّف ثابت أو حسابي
          );
          print("هنا هنا القوه");
        } else if (selectedDhikr == "مخصص") {
          // إذا كان الذكر مخصص، نرسل الأذكار من القائمة المخصصة واحدة تلو الأخرى
          List<String> customAzkar = await NotificationService.instance
              .loadCustomAzkar(); // تحميل الأذكار المخصصة من SharedPreferences
          if (customAzkar.isEmpty) {
            // إذا كانت القائمة فارغة، نعرض رسالة للمستخدم
          } else {
            NotificationService.instance.toggleNotifications(true);

            for (int i = 0; i < customAzkar.length; i++) {
              // إرسال الذكر مع تأخير معين بناءً على الوقت المحدد
              Future.delayed(Duration(seconds: selectedTime! * i), () {
                NotificationService.instance.startPeriodicNotifications(
                  dhikr: customAzkar[i],
                  intervalInSeconds: selectedTime!,
                  id: i,
                );
                print("تم إرسال الذكر: ${customAzkar[i]}");
              });
            }
          }
        } else {
          NotificationService.instance.toggleNotifications(true);
          await startPeriodicNotifications(
            dhikr: selectedDhikr!,
            intervalInSeconds: selectedTime!,
            id: 0,
          );
        }
      } else {
        print("القيم المخزنة غير موجودة أو غير صحيحة");
      }
    }
  }

  Future<List<String>> loadCustomAzkar() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> customAzkar = prefs.getStringList('customAzkar') ?? [];
    return customAzkar;
  }
// Future<void> handlePrayerNotifications(PrayerTimes prayerTimes) async {
//   final now = DateTime.now();
//   final prayerTimesList = [
//     prayerTimes.fajr,
//     prayerTimes.dhuhr,
//     prayerTimes.asr,
//     prayerTimes.maghrib,
//     prayerTimes.isha,
//   ];
//
//   for (final prayerTime in prayerTimesList) {
//     // حساب وقت الإيقاف والتشغيل
//     final stopNotificationsTime = prayerTime.subtract(const Duration(minutes: 10));
//     final resumeNotificationsTime = prayerTime.add(const Duration(minutes: 10));
//
//     // جدولة إيقاف الإشعارات
//     if (now.isBefore(stopNotificationsTime)) {
//       Timer(stopNotificationsTime.difference(now), () async {
//         print("إيقاف الإشعارات قبل الأذان بـ10 دقائق");
//         await refreshNotfication();
//       });
//     }
//
//     // جدولة إعادة تشغيل الإشعارات
//     if (now.isBefore(resumeNotificationsTime)) {
//       Timer(resumeNotificationsTime.difference(now), () async {
//         print("إعادة تشغيل الإشعارات بعد الأذان بـ10 دقائق");
//         toggleNotifications(true);
//       });
//     }
//   }
// }
}
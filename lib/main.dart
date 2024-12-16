import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:islamic_app_saudi/service/notification.dart';
import 'package:islamic_app_saudi/Home/presentation/screens/home_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_screenutil/flutter_screenutil.dart'; // استيراد الحزمة
import 'package:wakelock_plus/wakelock_plus.dart';

import 'Home/presentation/widgets/settings.dart';
import 'core/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await WakelockPlus.enable(); // تفعيل Wake Lock


  // تحميل الإعدادات عند بدء التطبيق
  await AppSettings.checkFirstTimeOpen(); // التحقق من فتح التطبيق لأول مرة
  await AppSettings.loadSettings(); // تحميل الإعدادات من SharedPreferences

  // تهيئة خدمة الإشعارات
  await NotificationService.instance.init();

  // تهيئة المنطقة الزمنية المحلية
  await _configureLocalTimeZone();
  await NotificationService.instance.startBackgroundTask();

  await enableBackgroundMode();
  await Permission.ignoreBatteryOptimizations.request();  // طلب إيقاف تحسينات البطارية

  runApp(const MyApp());
}

Future<void> enableBackgroundMode() async {
  if (Platform.isAndroid) {
    const androidConfig = FlutterBackgroundAndroidConfig(
      enableWifiLock: true,
      notificationImportance: AndroidNotificationImportance.max,
      shouldRequestBatteryOptimizationsOff: true,
    );
    bool success = await FlutterBackground.initialize(androidConfig: androidConfig);
    if (success) {
      await FlutterBackground.enableBackgroundExecution();
      print("تم تفعيل وضع الخلفية.");
    } else {
      print("فشل تفعيل وضع الخلفية.");
    }
  }
}

Future<void> ensurePermissions() async {
  final batteryPermission = await Permission.ignoreBatteryOptimizations.request();
  if (batteryPermission.isDenied) {
    print("يجب منح إذن تعطيل تحسينات البطارية لكي يعمل التطبيق بشكل صحيح.");
    // يمكنك عرض رسالة أو توجيه المستخدم لإعدادات الهاتف.
  }
}

// إعداد المنطقة الزمنية
Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Riyadh')); // اختر التوقيت المحلي المناسب
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // تهيئة ScreenUtil
    return ScreenUtilInit(
      designSize: const Size(375, 812), // الحجم الافتراضي الذي تم تصميمه عليه
      minTextAdapt: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: const HomeScreen(),
          routes: {
            HomeScreen.routename: (_) => HomeScreen()
          }, // الشاشة الرئيسية
        );
      },
    );
  }
}

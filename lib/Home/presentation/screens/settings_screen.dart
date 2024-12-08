import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // استيراد الحزمة
import 'package:islamic_app_saudi/service/notification.dart'; // تأكد من إضافة الاستيراد الصحيح لـ NotificationService
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/settings.dart'; // إضافة المكتبة

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveSettings(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is double) {
      await prefs.setDouble(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  Future<void> _showCustomModeDialog() async {
    List<String> allAzkar = [
      'سبحان الله',
      'الحمد لله',
      'الله أكبر',
    ]; // استبدلها بالأذكار الفعلية
    List<String> selectedAzkar = []; // الأذكار التي يتم اختيارها

    final prefs = await SharedPreferences.getInstance();
    final savedAzkar = prefs.getStringList('customAzkar') ?? [];

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('اختر الأذكار'),
          content: SingleChildScrollView(
            child: Column(
              children: allAzkar.map((azkar) {
                return CheckboxListTile(
                  title: Text(azkar),
                  value: savedAzkar.contains(azkar),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedAzkar.add(azkar); // إضافة الذكر إلى القائمة
                      } else {
                        selectedAzkar.remove(azkar); // إزالة الذكر من القائمة
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                // حفظ الأذكار المختارة في SharedPreferences
                await prefs.setStringList('customAzkar', selectedAzkar);
                Navigator.of(context).pop();
              },
              child: const Text('حفظ'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('إلغاء'),
            ),
          ],
        );
      },
    );
  }

  void _handleSleepMode(bool isEnabled) {
    final now = DateTime.now();
    final nightTime = DateTime(now.year, now.month, now.day, 22);
    final morningTime = DateTime(now.year, now.month, now.day + 1, 6);

    if (isEnabled) {
      if (now.isBefore(nightTime)) {
        final durationUntilNight = nightTime.difference(now);
        Future.delayed(durationUntilNight, () {
          NotificationService.instance.handleSleepMode(true);
        });
      } else {
        NotificationService.instance.handleSleepMode(true);
      }

      Future.delayed(morningTime.difference(now), () {
        NotificationService.instance.handleSleepMode(false);
      });
    } else {
      NotificationService.instance.handleSleepMode(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // الحجم الافتراضي الذي تم تصميمه عليه
      minTextAdapt: true,
      builder: (_, child) {
        return Scaffold(
          backgroundColor: const Color(0xff002B25), // أخضر غامق جداً
          body: Stack(
            children: [
              Positioned(
                top: 40.h,
                left: 16.w,
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(width: 8.w),
                     Text(
                      "الإعدادات",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: "messiri",
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 160.h,
                left: 16.w,
                right: 16.w,
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xff004D40),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.all(16.w),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(
                          "اختر اللغة :",
                          style: TextStyle(
                            color: Color(0xffFFD700), // ذهبي
                            fontSize: 18.sp,
                            fontFamily: "messiri",
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            _buildLanguageButton("العربية"),
                            SizedBox(width: 10.w),
                            _buildLanguageButton("English"),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        _buildVolumeControl(),
                        SizedBox(height: 20.h),
                        _buildSilentModeSwitch(),
                        SizedBox(height: 20.h),
                        _buildCustomModeSwitch(),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "إيقاف التذكير وقت النوم",
                                  style: TextStyle(
                                    color: Color(0xffFFD700),
                                    fontSize: 16.sp,
                                    fontFamily: "messiri",
                                  ),
                                ),
                                Text(
                                  "10:00 PM من ",
                                  style: TextStyle(
                                    color: Color(0xffFFD700),
                                    fontSize: 16.sp,
                                    fontFamily: "messiri",
                                  ),
                                ),
                                Text(
                                  "6:00 AM حتي",
                                  style: TextStyle(
                                    color: Color(0xffFFD700),
                                    fontSize: 16.sp,
                                    fontFamily: "messiri",
                                  ),
                                ),
                              ],
                            ),
                            Switch(
                              value: AppSettings.isSleepModeEnabled,
                              activeColor: const Color(0xffFFD700),
                              onChanged: (value) {
                                setState(() {
                                  AppSettings.isSleepModeEnabled = value;
                                  _saveSettings('isSleepModeEnabled', value);
                                  _handleSleepMode(value);
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLanguageButton(String language) {
    return Expanded(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppSettings.selectedLanguage == language
              ? const Color(0xff388E3C)
              : Colors.transparent,
          side: const BorderSide(color: Color(0xffFFD700)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
        ),
        onPressed: () {
          setState(() {
            AppSettings.selectedLanguage = language;
            _saveSettings('selectedLanguage', language);
          });
        },
        child: Text(
          language,
          style: TextStyle(color: Colors.white, fontFamily: "messiri"),
        ),
      ),
    );
  }

  Widget _buildVolumeControl() {
    return Row(
      children: [
         Text(
          "مستوى الصوت:",
          style: TextStyle(
            color: Color(0xffFFD700),
            fontSize: 16.sp,
            fontFamily: "messiri",
          ),
        ),
        Expanded(
          child: Slider(
            value: AppSettings.volumeLevel,
            min: 0,
            max: 1,
            onChanged: (value) {
              setState(() {
                AppSettings.volumeLevel = value;
                _saveSettings('volumeLevel', value);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSilentModeSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         Text(
          "تشغيل في الوضع الصامت",
          style: TextStyle(
            color: Color(0xffFFD700),
            fontSize: 16.sp,
            fontFamily: "messiri",
          ),
        ),
        Switch(
          value: AppSettings.isSilentModeEnabled,
          activeColor: const Color(0xffFFD700),
          onChanged: (value) {
            setState(() {
              AppSettings.isSilentModeEnabled = value;
              _saveSettings('isSilentModeEnabled', value);
            });
          },
        ),
      ],
    );
  }

  Widget _buildCustomModeSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
         Text(
          "الوضع المخصص",
          style: TextStyle(
            color: Color(0xffFFD700),
            fontSize: 16.sp,
            fontFamily: "messiri",
          ),
        ),
        Switch(
          value: AppSettings.isCustomModeEnabled,
          activeColor: const Color(0xffFFD700),
          onChanged: (value) {
            setState(() {
              AppSettings.isCustomModeEnabled = value;
              _saveSettings('isCustomModeEnabled', value);
              if (value) {
                _showCustomModeDialog();
              } else {
                AppSettings.clearCustomAzkar(); // مسح الأذكار عند إيقاف الوضع المخصص
              }
            });
          },
        ),
      ],
    );
  }
}

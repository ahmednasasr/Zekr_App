import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // استيراد المكتبة

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    // تهيئة ScreenUtil
    ScreenUtil.init(
      context,
      designSize: Size(360, 690), // الحجم الأساسي لتصميم الشاشات
      minTextAdapt: true,
      splitScreenMode: true,
    );

    return Scaffold(
      backgroundColor: const Color(0xff002B25), // أخضر غامق جداً
      body: Stack(
        children: [
          // عنوان الصفحة مع زر العودة
          Positioned(
            top: 40.h, // استخدم ScreenUtil لتحديد الموضع
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
                  "عن التطبيق",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp, // استخدام ScreenUtil لتحديد حجم النص
                    fontWeight: FontWeight.bold,
                    fontFamily: "messiri",
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: const Color(0xff004D40),
                borderRadius: BorderRadius.circular(16.r), // استخدام ScreenUtil لتحديد الحواف
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8.r, // استخدام ScreenUtil لتحديد الظل
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: EdgeInsets.all(16.w), // استخدام ScreenUtil لتحديد الحشو
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "عن التطبيق",
                    style: TextStyle(
                      color: const Color(0xffFFD700),
                      fontSize: 20.sp, // استخدام ScreenUtil لتحديد حجم النص
                      fontWeight: FontWeight.bold,
                      fontFamily: "messiri",
                    ),
                  ),
                  SizedBox(height: 12.h), // استخدام ScreenUtil لتحديد المسافة بين العناصر
                  Text(
                    "هذا التطبيق الإسلامي مصمم لتوفير مجموعة من الأدوات "
                        "والميزات المفيدة للمسلمين، بما في ذلك أوقات الصلاة، "
                        "تحديد اتجاه القبلة، التسبيح، والعديد من الميزات الأخرى "
                        "التي تهدف إلى تحسين التجربة الدينية اليومية.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp, // استخدام ScreenUtil لتحديد حجم النص
                      fontFamily: "messiri",
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
}
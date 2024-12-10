import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:islamic_app_saudi/Home/presentation/screens/media_selection_page.dart';
import 'package:islamic_app_saudi/Home/presentation/screens/settings_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../service/notification.dart';
import '../widgets/time_dialog.dart';
import 'about_app.dart';
import 'adaia_mokhtara.dart';
import 'moaket_salah-screen.dart';

class HomeScreen extends StatefulWidget {
  static const String routename = "home";
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String? selectedDhikr;
  final List<String> adhkar = [
    "سبحان الله",
    "لا إله إلا الله",
    "الحمد لله",
    "اللهم صلي علي نبينا محمد",
    "استغفر الله واتوب اليه",
    "حسبنا الله ونعم الوكيل",
    "لا حول ولا قوه الا بالله العلي العظيم",
    "لا اله الا الله وحده لا شريك له",
    "لا اله الا انت سبحانك",
    "صلي علي محمد",
    "سبحان الله وبحمده",
    "سبحان الله وبحمده سبحان الله العظيم",
    "عشوائي",
    "مخصص"
  ];

  bool isOn = false;
  int? selectedTime;
  final List<int> times = List.generate(240,
          (index) => (index + 1) * 60); // 240 تعني 4 ساعات (240 * 60 = 14400 ثانية)
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void resetValues() {
    setState(() {
      selectedDhikr = null;
      selectedTime = null;
    });
  }
  Future<void> checkBatteryOptimization() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

    if (isFirstRun) {
      await prefs.setBool('isFirstRun', false);
      showBatteryOptimizationDialog();
    } else {
      bool isIgnoring = await Permission.ignoreBatteryOptimizations.isGranted;
      if (!isIgnoring) {
        showBatteryOptimizationDialog();
      }
    }
  }


  void showBatteryOptimizationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تعطيل وضع توفير البطارية'),
        content: const Text(
            'يرجى تعطيل وضع توفير البطارية لضمان عمل التطبيق في الخلفية بشكل صحيح.'),
        actions: [
          TextButton(
            onPressed: () async {
              await Permission.ignoreBatteryOptimizations.request();
              Navigator.of(context).pop();
            },
            child: const Text('تعطيل الآن'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('إلغاء'),
          ),
        ],
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff002B25),
      drawer: Drawer(
        backgroundColor: const Color(0xff004D40),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xff388E3C),
              ),
              child: Text(
                ' الأقسام',
                style: TextStyle(
                    color: Colors.white, fontSize: 24, fontFamily: "messiri"),
              ),
            ),
            ListTile(
              title: const Text(
                'مواقيت الصلاه',
                style: TextStyle(color: Colors.white, fontFamily: "messiri"),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrayerTimesScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'أدعيه مختاره',
                style: TextStyle(color: Colors.white, fontFamily: "messiri"),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ad3yaMokhtara(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'تشغيل مخصص',
                style: TextStyle(color: Colors.white, fontFamily: "messiri"),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MediaSelectionPage(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'إعدادات',
                style: TextStyle(color: Colors.white, fontFamily: "messiri"),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text(
                'عن التطبيق',
                style: TextStyle(color: Colors.white, fontFamily: "messiri"),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AboutApp(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0.h), // استخدام ScreenUtil هنا
                  child: Center(
                    child: Text(
                      "هَٰذَا ذِكْرُ مَن مَّعِيَ وَذِكْرُ مَن قَبْلِي",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xffFFD700),
                        fontSize: 24.sp, // استخدام ScreenUtil هنا
                        fontWeight: FontWeight.bold,
                        fontFamily: "messiri",
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h), // استخدام ScreenUtil هنا
                Container(
                  padding: EdgeInsets.all(16.w), // استخدام ScreenUtil هنا
                  decoration: BoxDecoration(
                    color: const Color(0xff004D40),
                    borderRadius: BorderRadius.circular(16.r), // استخدام ScreenUtil هنا
                    border: Border.all(color: const Color(0xffFFD700), width: 4.w), // استخدام ScreenUtil هنا
                  ),
                  child: DropdownButton<String>(
                    value: selectedDhikr,
                    dropdownColor: Colors.transparent,
                    items: adhkar.map((String dhikr) {
                      return DropdownMenuItem<String>(
                        value: dhikr,
                        child: SizedBox(
                          width: 200.w,
                          child: Text(
                            dhikr,
                            style: TextStyle(fontFamily: "messiri", color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      NotificationService.instance.cancelAllNotifications();

                      setState(() {
                        selectedDhikr = newValue;
                        print('Selected dhikr: $selectedDhikr');
                      });
                    },
                  ),
                ),
                SizedBox(height: 40.h), // استخدام ScreenUtil هنا
                IconButton(
                  iconSize: 80.w, // استخدام ScreenUtil هنا
                  icon: Icon(
                    isOn ? Icons.power_settings_new : Icons.portable_wifi_off,
                    color: isOn ? Colors.green : Colors.red,
                  ),
                  onPressed: () {
                    setState(() {
                      isOn = !isOn;
                    });

                    if (isOn) {
                      showTimeSelectionDialog(
                        context,
                        times,
                            (selected) async {
                          setState(() {
                            selectedTime = selected;
                          });

                          if (selectedDhikr != null && selectedTime != null) {
                            if (selectedDhikr == "عشوائي") {
                              NotificationService.instance
                                  .toggleNotifications(true);

                              NotificationService.instance.sendRandomZekr(
                                intervalInSeconds: selectedTime!,
                                id: 999,
                              );
                            } else if (selectedDhikr == "مخصص") {
                              List<String> customAzkar = await NotificationService.instance.loadCustomAzkar();
                              if (customAzkar.isEmpty) {
                                isOn = false;
                                selectedDhikr = null;
                                selectedTime = null;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text(
                                      'قائمة الأذكار المخصصة فارغة. يرجى تعبئتها من الإعدادات قبل اختيار هذا الخيار.',
                                      style: TextStyle(fontFamily: "messiri"),
                                    ),
                                  ),
                                );
                              } else {
                                NotificationService.instance.toggleNotifications(true);

                                for (int i = 0; i < customAzkar.length; i++) {
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
                              int index = adhkar.indexOf(selectedDhikr!);
                              NotificationService.instance.toggleNotifications(true);
                              NotificationService.instance.startPeriodicNotifications(
                                dhikr: selectedDhikr!,
                                intervalInSeconds: selectedTime!,
                                id: index,
                              );
                              print("$selectedDhikr");
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'تم جدولة الذكر: "$selectedDhikr" ليتم تنبيهك بعد $selectedTime ثانية.',
                                  style: TextStyle(fontFamily: "messiri"),
                                ),
                              ),
                            );
                          }
                        },
                      );
                    } else {
                      NotificationService.instance.cancelAllNotifications();
                      resetValues();

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text(
                            'تم إيقاف التذكيرات.',
                            style: TextStyle(fontFamily: "messiri"),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
            Positioned(
              top: 30.h, // استخدام ScreenUtil هنا
              left: 10.w, // استخدام ScreenUtil هنا
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return FloatingActionButton(
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: ShaderMask(
                      shaderCallback: (rect) {
                        return LinearGradient(
                          colors: [Colors.amber, Colors.green],
                          tileMode: TileMode.mirror,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          stops: [0.0, _controller.value],
                        ).createShader(rect);
                      },
                      child: const Icon(
                        Icons.menu,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

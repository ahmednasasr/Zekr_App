import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Ad3yaMokhtara extends StatefulWidget {
  Ad3yaMokhtara({super.key});
  static const String routename = "ad3ya";

  @override
  _Ad3yaMokhtaraScreenState createState() => _Ad3yaMokhtaraScreenState();
}

class _Ad3yaMokhtaraScreenState extends State<Ad3yaMokhtara> {
  final List<String> ad3ya = [
    "اللَّهُمَّ يَا بَارِئَ البَرِيَّاتِ ، وَغَافِرَ الخَـطِيَّاتِ ، وَعَالِمَ الخَفِيَّاتِ ، المُطَّلِعُ عَلَى الضَّمَائِرِ وَالنِّيَّاتِ ، يَا مَنْ أَحَاطَ بِكُلِّ شَيءٍ عِلْماً ، وَوَسِعَ كُلّ شَيْءٍ رَحْمَةً ، وَقَهَرَ كُلّ مَخْلُوقٍ عِزَّةً وَحُكْماً ، اغْفِرْ لِي ذُنُوبِي ، وَاسْتُرْ عُيُوبِيَ ، وَتَجَاوَزْ عَنْ سَيِّئَاتِيَ إِنَّكَ أَنْتَ الْغَفُورُ الرَّحِيمُ.",
    "اللَّهُمَّ يَا سَمِيعَ الدَّعَوَاتِ ، يَا مُقِيلَ العَثَرَاتِ ، يَاقَاضِيَ الحَاجَاتِ ، يَا كَاشِفَ الكَرُبَاتِ ، يَا رَفِيعَ الدَّرَجَاتِ ، وَيَا غَافِرَ الزَّلاَّتِ ، اغْفِرْ لِلْمُسْلِمِينَ وَالمُسْلِمَاتِ ، وَالمُؤْمِنِينَ وَالمُؤْمِنَاتِ، الأحْيَاءِ مِنْهُم وَالأمْوَاتِ ، إِنَّكَ سَمِيعٌ قَرِيبٌ مُجِيبُ الدَّعَوَاتِ.",
    "اللَّهُمَّ إِنِّي أَسْأَلُكَ بِاسْمِكَ الأَعْظَمِ ، الَّذِي إِذَا دُعِيتَ بِهِ أَجَبْتَ ، وَإِذَا سُئِلْتَ بِهِ أَعْطَـيْتَ ، أَسْأَلُكَ بِأَنِّي أَشُهَدُ أَنَّكَ أَنْتَ اللهُ لا إِلَهَ إِلاَّ أَنْتَ ، الأَحَدُ الصَّمَدُ ، الَّذِي لَمْ يَلِدْ، وَلَمْ يَولَدْ ، وَلَمْ يَكُنْ لَهُ كُفُوًا أَحَدٌ ؛ أَنْ تَغْفِرَ لِي ذُنُوبِي ، إِنَّكَ أَنْتَ الغَفُورُ الرَّحِيمُ.",
    "اللَّهُمَّ إِنَّكَ عَفُوٌّ كَرِيمٌ تُحِبُّ العّفْوَ فَاعْفُ عَنِّي.",
    "اللَّهُمَّ رَبِّ اغْفِرْ لِي وَلِوَالِدَيَّ وَلِمَنْ دَخَلَ بَيْتِيَ مُؤْمِنًا وَلِلْمُؤْمِنِينَ وَالمُؤْمِنَاتِ.",
    "اللَّهُمَّ اغْفِرْ لِي خَطِيئَتِي وَجَهْلِي ، وَإِسْرَافِي فِي أَمْرِي ، وَمَا أَنْتَ أَعْـلَمُ بِهِ مِنّـِي ، اللَّهُمَّ اغْفِرْ لِي هَزْلِي وَجِدِّي ، وَخَطَئِي وَعَمْدِي ، وَكُلُّ ذَلِكَ عِنْدِي.",
    "اللَّهُمَّ رَبِّ إِنِّي ظَلَمْتُ نَفْسِي فَاغْفِرْ لِي.",
    "اللَّهُمَّ أَنْتَ رَبِّي لا إِلَهَ إِلاَّ أَنْتَ خَلَقْتَنِي وَأَنَا عَبْدُكَ ، وَأَنَا عَلَى عَهْدِكَ وَوَعْدِكَ مَااسْتَطَعْتُ، أَعُوذُ بِكَ مِنْ شَرِّ مَا صَنَعْتُ أَبُوءُ لَكَ بِنِعْمَتِكَ عَلَيَّ وَأَبُوءُ لَكَ بِذَنْبِي فَاغْفِرْ لِي فَإنَّهُ لا يَغْفِرُ الذُّنُوبَ إِلاَّ أَنْتَ.",
    "اللَّهُمَّ اغْفِرْ لِي ، وَارْحَمْنِي وَاهْدِنِي ، وَعَافِنِي وَارْزُقْنِي ، وَاجْبُرْنِي ، وَارْفَعْنِي.",
    "اللَّهُمَّ يَا مَنْ لا تَضُرُّهُ الذُّنُوبُ ، وَلا تُنْقِصُهُ المَغْفِرَةُ ، اغْفِرْ لَنَا مَا لا يَضُرُّكَ ، وَهَبْ لَنَا مَالا يُنْقِصُكَ.",
    "اللَّهُمَّ اغْفِرْ لِي ذَنْبِي كُلّهُ ، دِقَّهُ وَجُلَّهُ ، وَأَوَّلَهُ وَآخِرَهَ ، وَعَلاَنِيَتَهَ وَسِرَّهُ.",
    "اللَّهُمَّ إِنَّ ذُنُوبِي عِظَامٌ وَهِي صِغَارٌ فِي جَنْبِ عَفْوِكَ يَا كَرِيمُ ، فَاغْفِرْهَا لِي.",
    "اللَّهُمَّ اغْفِرْ لِي ذَنْبِي ، وَوَسِّعْ لِي فِي دَارِي ، وَبَارِكْ لِي فِي رِزْقِي.",
    "اللَّهُمَّ رَبَّنَا لا تُؤَاخِذْنَا إِنْ نَسِينَا أَوْ أَخْطَأْنَا ، رَبَّنَا وَلا تَحْمِلْ عَلَينَا إِصْرَاً كَمَا حَمَلْتَهَ عَلَى الَّذِينَ مِنْ قَبْلِنَا ، رَبَّنَا وَلا تُحَمِّلْنَا مَا لا طَاقَةَ لَنَا بِهِ ، وَاعْفُ عَنَّا وّاغْفِرْ لَنَا وَارْحَمْنَا أَنْتَ مَوْلانَا فَانْصُرْنَا عَلَى القَوْمِ الكَافِرِينَ.",
    "اللَّهُمَّ إِنَّا قَدْ أَطَعْنَاكَ فِي أَحَبِّ الأشْيَاءِ إِلَيْكَ أَنْ تُطَاعَ فِيْهِ ، الإيمَانِ بِكَ ، وَالإِقْرَارِ بِكَ ، وَلَمْ نَعْصِكَ فِي أَبْغَضِ الأَشْيَاءِ أَنْ تُعْصَى فِيْهِ ؛ الكُفْرِ وَالجَحْدِ بِكَ ، اللَّهُمَّ فَاغْفِرْ لَنَا مَا بَيْنَهُمَا.",
    "اللَّهُمَّ اغْفِرْ لِي مَا قَدَّمْتُ وَمَا أَخَّرْتُ ، وَمَا أَعْلَنْتُ وَمَا أَسْرَرْتُ ، وما أنت أعلم به مني ، أَنْتَ المُقَدِّمُ وَأَنْتَ المُؤَخِّرُ لا إِلَهَ إِلاَّ أَنْـتَ.",
    "اللَّهُمَّ رَبَّنَا اغْفِرْ لَنَا ذُنُوبَنَا وَكَفِّرْ عَنَّا سَيِّئَاتِنَا وَتَوَفَّنَا مَعَ الأَبْرَارِ.",
    "اللَّهُمَّ رَبَّنَا اغْفِرْ لَنَا وَلإخْوَانِنَا الَّذِينَ سَبَقُونَا بِالإِيْمَانِ ، رَبَّنَا وَسِعْتَ كُلّ شَيءٍ رَحْمَةً وَعِلْماً فَاغْفِرْ لِلَّذِينَ تَابُوا وَاتَّبَعُوا سَبِيلَكَ وَقِهِمْ عَذَاب الجَحِيمِ.",
    "اللَّهُمَّ اغْفِرْ لَنَا وَلِآبَائِنَا وَأُمَّهَاتِنَا وَلأَزْوَاجِنَا وَذُرِّيَاتِنَا وَلِقَرَابَتِنَا وَلِمَنْ أَحَبَّنَا فِيكَ وَلِمَنْ أَحْسَنَ إِلَيْنَا وَالمُسْلِمِينَ وَالمُسْلِمَاتِ الأَحْيَاءِ مِنْهُم وَالأمْوَاتِ ، إِنَّكَ سَمِيعٌ قَرِيبٌ مُجِيبُ الدَّعَوَاتِ.",
    "اللَّهُمَّ اجْعَلْ نَوَافِلَنَا كَفَّارَاتِ زَلاَّتِنَا وَاجْعَلْ أَوَّلَنَا رَشَداً ، وَآخِرَنَا فَلاحاً ، وَأَعْتِقْ رِقَابَنَا وَرِقَابَ آبَائِنَا وَأُمَّهَاتِنَا وَمَشَايِخِنَا وَعُلَمَائِنَا مِنَ النَّارِ ، يَا عَزِيزُ يَا غَفَّارُ يَا قَيُّومُ يَا مَنَّانُ.",
    "اللَّهُمَّ اغْفِرْ لَنَا فِي لَيْلَتِنَا هَذِهِ أَجْمَعِينَ ، وَهَبِ المُسِيءَ مِنَّا لِلْمُحْسِنِينَ ، وَوَفِّقْنَا فِيهَا لِمَا تُحِبُّ وَتَرْضَى ، وَارْزُقْنَا زِيَارَةَ قَبْرِ نَبِيِّكَ صَلَّى اللهُ عَلَيْهِ وَسَلَّمَ ، يَا أَرْحَمَ الرَّاحِمِينَ.",
    "اللَّهُمَّ إِنَّا ظَلَمْنَا أَنْفُسَنَا فَاغْفِرْ لَنَا.",
  ];


  final List<int> requiredCounts = List.generate(20, (index) => 1); // عدد مرات التكرار لكل دعاء
  int currentIndex = 0;
  int currentCount = 0;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    // تهيئة ScreenUtil
    ScreenUtil.init(context, designSize: Size(360, 690), minTextAdapt: true);

    return Scaffold(
      backgroundColor: const Color(0xff002B25),
      body: Column(
        children: [
          SizedBox(height: 40.h),  // استخدم ScreenUtil لتحديد المسافة
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),  // تحديد الحواف باستخدام ScreenUtil
            child: Text(
              "ادعية مختارة",
              style: TextStyle(
                fontSize: 24.sp,  // استخدام ScreenUtil لتحديد حجم الخط
                color: Color(0xffFFD700),
                fontFamily: "messiri",
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 20.h),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                  currentCount = 0;
                });
              },
              itemCount: ad3ya.length,
              itemBuilder: (context, index) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(16.w),  // تحديد المسافة باستخدام ScreenUtil
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ad3ya[index],
                          style: TextStyle(
                            fontSize: 20.sp,  // استخدام ScreenUtil لتحديد حجم الخط
                            color: Colors.white,
                            fontFamily: "messiri",
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 20.h),
                        Text(
                          '${currentCount}/${requiredCounts[currentIndex]}',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 16.sp,  // استخدام ScreenUtil لتحديد حجم الخط
                            fontFamily: "messiri",
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            color: const Color(0xff004D40),
            padding: EdgeInsets.all(8.0.w),  // استخدام ScreenUtil لتحديد المسافة
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous, color: Color(0xffFFD700), size: 24.sp),
                  onPressed: () {
                    if (currentIndex > 0) {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: currentCount < requiredCounts[currentIndex]
                      ? incrementCounter
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: currentCount < requiredCounts[currentIndex]
                        ? const Color(0xffFFD700)
                        : Colors.grey,
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(20.sp),  // تحديد الحجم باستخدام ScreenUtil
                  ),
                  child: Text(
                    '$currentCount',
                    style: TextStyle(fontSize: 20.sp, color: Colors.black),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, color: Color(0xffFFD700), size: 24.sp),
                  onPressed: () {
                    if (currentIndex < ad3ya.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void incrementCounter() {
    if (currentCount < requiredCounts[currentIndex]) {
      setState(() {
        currentCount++;
      });
      if (currentCount == requiredCounts[currentIndex]) {
        if (currentIndex < ad3ya.length - 1) {
          Future.delayed(const Duration(seconds: 1), () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          });
        }
      }
    }
  }
}

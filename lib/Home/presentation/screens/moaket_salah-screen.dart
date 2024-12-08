import 'package:adhan/adhan.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../location/location.dart';
import '../../../service/notification.dart';

class PrayerTimesScreen extends StatefulWidget {
  @override
  _PrayerTimesScreenState createState() => _PrayerTimesScreenState();
}

class _PrayerTimesScreenState extends State<PrayerTimesScreen> {
  late Future<PrayerTimes> _prayerTimesFuture;
  final LocationService _locationService = LocationService();

  @override
  void initState() {
    super.initState();
    _prayerTimesFuture = _getPrayerTimes();
  }

  Future<PrayerTimes> _getPrayerTimes() async {
    try {
      Position? position = await _locationService.getCurrentLocation();

      if (position == null) {
        throw Exception('Unable to get location');
      }

      final myCoordinates = Coordinates(position.latitude, position.longitude);
      final params = CalculationMethod.egyptian.getParameters();
      params.madhab = Madhab.hanafi;

      final prayerTimes = PrayerTimes.today(myCoordinates, params);

      return prayerTimes;
    } catch (e) {
      print('Error getting prayer times: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff002B25),
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 16,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  "مواقيت الصلاة",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: "messiri",
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 160,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xff004D40),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: FutureBuilder<PrayerTimes>(
                future: _prayerTimesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xffFFD700)),
                    );
                  } else if (snapshot.hasError) {
                    return Text(
                      'حدث خطأ: ${snapshot.error}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: "messiri",
                      ),
                    );
                  } else if (snapshot.hasData) {
                    final prayerTimes = snapshot.data!;
                    final prayerNames = [
                      'الفجر',
                      'الشروق',
                      'الظهر',
                      'العصر',
                      'المغرب',
                      'العشاء'
                    ];
                    final prayerTimesFormatted = [
                      DateFormat.jm().format(prayerTimes.fajr),
                      DateFormat.jm().format(prayerTimes.sunrise),
                      DateFormat.jm().format(prayerTimes.dhuhr),
                      DateFormat.jm().format(prayerTimes.asr),
                      DateFormat.jm().format(prayerTimes.maghrib),
                      DateFormat.jm().format(prayerTimes.isha),
                    ];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "مواعيد الصلاة:",
                          style: TextStyle(
                            color: Color(0xffFFD700),
                            fontSize: 20, // تحسين حجم النص
                            fontWeight: FontWeight.bold,
                            fontFamily: "messiri",
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0xff00695C),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.all(16),
                          child: Table(
                            border: TableBorder.all(
                              color: const Color(0xffFFD700),
                              width: 2,
                            ),
                            children: List.generate(prayerNames.length, (index) {
                              return TableRow(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      prayerNames[index],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18, // تحسين حجم النص
                                        color: Colors.white,
                                        fontFamily: "messiri",
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Text(
                                      prayerTimesFormatted[index],
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 18, // تحسين حجم النص
                                        color: Color(0xffFFD700),
                                        fontFamily: "messiri",
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text(
                      "لا توجد بيانات لعرضها",
                      style: TextStyle(color: Colors.white),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

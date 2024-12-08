import 'package:flutter/material.dart';

void showTimeSelectionDialog(BuildContext context, List<int> timesInSeconds, Function(int) onTimeSelected) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: const Color(0xFF004D40), // أخضر غامق كخلفية
        title: Text(
          'اختر الوقت بين الأذكار',
          style: const TextStyle(color: Color(0xFFFFD700)), // ذهبي للنص
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButton<int>(
              dropdownColor: const Color(0xFF004D40), // خلفية القائمة بنفس الأخضر الغامق
              hint: Text(
                'اختر الوقت (دقائق)',
                style: const TextStyle(color: Color(0xFFFFD700)), // ذهبي
              ),
              items: timesInSeconds.map((int timeInSeconds) {
                int timeInMinutes = (timeInSeconds / 60).round(); // تحويل إلى دقائق
                return DropdownMenuItem<int>(
                  value: timeInSeconds, // الإبقاء على القيمة الأصلية بالثواني
                  child: Text(
                    '$timeInMinutes دقيقة${timeInMinutes > 1 ? "ً" : ""}',
                    style: const TextStyle(color: Colors.white), // أبيض للنصوص
                  ),
                );
              }).toList(),
              onChanged: (int? selectedTime) {
                if (selectedTime != null) {
                  onTimeSelected(selectedTime); // إرجاع القيمة بالثواني
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'إغلاق',
              style: TextStyle(color: Color(0xFFFFD700)), // ذهبي للنص
            ),
          ),
        ],
      );
    },
  );
}

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // استيراد المكتبة

class MediaSelectionPage extends StatefulWidget {
  const MediaSelectionPage({super.key});

  @override
  State<MediaSelectionPage> createState() => _MediaSelectionPageState();
}

class _MediaSelectionPageState extends State<MediaSelectionPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _audioFilePath;
  bool _isPlaying = false;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // دالة لإعادة ضبط القيم عند اختيار أو إلغاء الملف
  Future<void> _resetAudioState() async {
    await _audioPlayer.stop();
    setState(() {
      _audioFilePath = null;
      _isPlaying = false;
    });
  }

  // دالة لاختيار ملف صوتي وتشغيله
  Future<void> _pickAndPlayAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      // إعادة ضبط الحالة قبل تحميل الملف الجديد
      await _resetAudioState();

      String filePath = result.files.single.path!;
      setState(() {
        _audioFilePath = filePath;
      });

      await _playAudio(filePath);
    }
  }

  // دالة لتشغيل الملف الصوتي
  Future<void> _playAudio(String filePath) async {
    try {
      await _audioPlayer.play(DeviceFileSource(filePath));
      setState(() {
        _isPlaying = true;
      });
    } catch (e) {
      print('حدث خطأ أثناء تشغيل الصوت: $e');
    }
  }

  // دالة للإيقاف المؤقت
  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlaying = false;
    });
  }

  // دالة لإيقاف التشغيل
  Future<void> _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlaying = false;
    });
  }

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
      appBar: AppBar(
        foregroundColor: Colors.white,
        title:  Text(
          'تشغيل مخصص',
          style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp, // استخدام ScreenUtil لتحديد الحجم
              fontFamily: "messiri"
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: const Color(0xff002B25),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.w), // استخدام ScreenUtil لتحديد الهامش
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: _pickAndPlayAudio,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff388E3C),
                  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 24.w), // تحسين الحواف باستخدام ScreenUtil
                  textStyle: TextStyle(
                    fontSize: 18.sp, // تغيير حجم النص باستخدام ScreenUtil
                    fontFamily: "messiri",
                  ),
                ),
                child: const Text(
                  'فتح وتشغيل ملف صوتي (MP3)',
                  style: TextStyle(fontFamily: "messiri"),
                ),
              ),
              SizedBox(height: 20.h), // تحسين المسافة بين الأزرار باستخدام ScreenUtil

              if (_audioFilePath != null) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        'الملف الصوتي: ${_audioFilePath!.split('/').last}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp, // استخدام ScreenUtil لتحديد الحجم
                          fontFamily: "messiri",
                        ),
                        overflow: TextOverflow.ellipsis, // لمنع تجاوز النص
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: _resetAudioState, // إزالة الملف المختار
                    ),
                  ],
                ),
                SizedBox(height: 20.h), // تحسين المسافة بين الأزرار باستخدام ScreenUtil

                // أزرار التحكم في التشغيل
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isPlaying ? Icons.pause : Icons.play_arrow,
                        color: Colors.white,
                        size: 30.sp, // استخدام ScreenUtil لتحديد الحجم
                      ),
                      onPressed: () {
                        if (_isPlaying) {
                          _pauseAudio();
                        } else {
                          _playAudio(_audioFilePath!);
                        }
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.stop, color: Colors.white, size: 30.sp), // استخدام ScreenUtil لتحديد الحجم
                      onPressed: _stopAudio,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

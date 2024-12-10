import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// شاشة الفيديو الرئيسية
class MediaSelectionPage extends StatefulWidget {
  @override
  _MediaSelectionPageState createState() => _MediaSelectionPageState();
}

class _MediaSelectionPageState extends State<MediaSelectionPage>
    with SingleTickerProviderStateMixin {
  VideoPlayerController? _videoController;
  YoutubePlayerController? _youtubeController;
  AudioPlayer? _audioPlayer;
  String errorMessage = '';
  bool isAudioPlaying = false;
  bool isVideoPlaying = false;

  TextEditingController audioUrlController = TextEditingController(); // للتحكم في النص المدخل

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  void _stopCurrentPlayback() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      _videoController!.pause();
      _videoController = null;
      isVideoPlaying = false;
    }
    if (_youtubeController != null) {
      _youtubeController!.pause();
      _youtubeController = null;
    }
    if (_audioPlayer != null) {
      _audioPlayer!.stop();
      isAudioPlaying = false;
    }
  }

  // تشغيل الصوت من رابط URL
  void _playAudioFromUrl(String url) async {
    _stopCurrentPlayback();

    if (url.isNotEmpty) {
      try {
        await _audioPlayer!.play(UrlSource(url)); // استخدام UrlSource بدلاً من String
        setState(() {
          isAudioPlaying = true;
          errorMessage = '';
        });
      } catch (e) {
        setState(() {
          errorMessage = 'حدث خطأ أثناء تشغيل الصوت';
        });
      }
    } else {
      setState(() {
        errorMessage = 'يرجى إدخال رابط صوتي صالح';
      });
    }
  }

  // تشغيل الفيديو من رابط
  void _playFromUrl(String url) async {
    _stopCurrentPlayback();
    String? videoId = YoutubePlayer.convertUrlToId(url);
    if (videoId != null) {
      setState(() {
        errorMessage = '';
        _youtubeController = YoutubePlayerController(
          initialVideoId: videoId,
          flags: YoutubePlayerFlags(autoPlay: true, mute: false,showLiveFullscreenButton: false)
        );
      });
    } else {
      Uri? uri = Uri.tryParse(url);
      if (uri == null || !(uri.scheme == 'http' || uri.scheme == 'https')) {
        setState(() {
          errorMessage = 'رابط غير صالح أو غير مدعوم';
        });
        return;
      }

      try {
        setState(() {
          _videoController = VideoPlayerController.network(url)
            ..initialize().then((_) {
              setState(() {});
              _videoController!.play();
              isVideoPlaying = true;
            }).catchError((error) {
              setState(() {
                errorMessage = 'حدث خطأ أثناء تحميل الفيديو';
              });
            });
        });
      } catch (e) {
        setState(() {
          errorMessage = 'حدث خطأ أثناء تشغيل الفيديو: $e';
        });
      }
    }
  }

  // تشغيل الصوت من ملف
  void _playOrPauseAudio() async {
    if (!isAudioPlaying) {
      FilePickerResult? result =
      await FilePicker.platform.pickFiles(type: FileType.audio);
      if (result != null) {
        String path = result.files.single.path!;
        try {
          await _audioPlayer!.play(DeviceFileSource(path));
          setState(() {
            isAudioPlaying = true;
            errorMessage = '';
          });
        } catch (e) {
          setState(() {
            errorMessage = 'حدث خطأ أثناء تشغيل الملف الصوتي';
          });
        }
      }
    } else {
      await _audioPlayer!.stop();
      setState(() {
        isAudioPlaying = false;
      });
    }
  }

  void _togglePlayPause() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      if (isVideoPlaying) {
        _videoController!.pause();
      } else {
        _videoController!.play();
      }
      setState(() {
        isVideoPlaying = !isVideoPlaying;
      });
    }
  }

  void _stopVideo() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      _videoController!.pause();
      setState(() {
        isVideoPlaying = false;
      });
    }
  }

  void _removeMedia() {
    if (_videoController != null && _videoController!.value.isInitialized) {
      _videoController!.dispose();
      _videoController = null; // إزالة الـ controller
      setState(() {
        isVideoPlaying = false; // تحديث حالة اللعب
      });
    }
    if (_youtubeController != null) {
      _youtubeController!.dispose(); // تأكد من التخلص من YoutubeController
      _youtubeController = null;
    }
    if (_audioPlayer != null) {
      _audioPlayer!.stop();
      setState(() {
        isAudioPlaying = false; // تحديث حالة الصوت
      });
    }
    setState(() {}); // تحديث الواجهة لإخفاء الفيديو أو الصوت
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _youtubeController?.dispose();
    _audioPlayer?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff002B25),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color(0xff002B25),
        title: Text(
          'عرض الفيديوهات والصوتيات',
          style: TextStyle(fontSize: 18.sp, color: Color(0xffFFD700),fontFamily: "messiri"),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // خانة لإدخال رابط صوتي وتشغيله
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h),
                child: TextField(
                  controller: audioUrlController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'أدخل رابط الصوت هنا',
                    labelStyle: TextStyle(color: Colors.white,fontFamily: "messiri"),
                    hintText: 'رابط صوتي (مثل رابط MP3)',
                    hintStyle: TextStyle(color: Colors.grey,fontFamily: "messiri"),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _playAudioFromUrl(audioUrlController.text);
                },
                child: Text(
                  isAudioPlaying ? 'إيقاف الصوت' : 'تشغيل الصوت',
                  style: TextStyle(color: Colors.white,fontFamily: "messiri"),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAudioPlaying ? Colors.red : Colors.green,
                ),
              ),
              SizedBox(height: 20.h),
              VideoOptionCard(
                icon: Icons.link,
                color: Color(0xff002B25),
                title: 'تشغيل فيديو من رابط',
                onTap: () {
                  _showUrlDialog(context);
                },
              ),
              SizedBox(height: 20.h),
              AudioOptionCard(
                isAudioPlaying: isAudioPlaying,
                onTap: _playOrPauseAudio,
              ),
              SizedBox(height: 20.h),
              _youtubeController != null
                  ? Column(
                children: [
                  YoutubePlayer(controller: _youtubeController!),
                  VideoControlButtons(
                    isPlaying: isVideoPlaying,
                    onPlayPause: _togglePlayPause,
                    onStop: _stopVideo,
                    onRemove: _removeMedia,
                  ),
                ],
              )
                  : Container(),
              _videoController != null && _videoController!.value.isInitialized
                  ? Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Color(0xffFFD700), width: 3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AspectRatio(
                      aspectRatio: _videoController!.value.aspectRatio,
                      child: VideoPlayer(_videoController!),
                    ),
                  ),
                  VideoControlButtons(
                    isPlaying: isVideoPlaying,
                    onPlayPause: _togglePlayPause,
                    onStop: _stopVideo,
                    onRemove: _removeMedia,
                  ),
                ],
              )
                  : Container(),
              if (errorMessage.isNotEmpty)
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Text(
                    errorMessage,
                    style: TextStyle(color: Colors.red, fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showUrlDialog(BuildContext context) {
    TextEditingController urlController = TextEditingController();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Color(0xff002B25),
          title: Text('أدخل رابط الفيديو',
              style: TextStyle(fontSize: 16.sp, color: Color(0xffFFD700),fontFamily: "messiri")),
          content: TextField(
            controller: urlController,
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'أدخل رابط الفيديو هنا...',
              hintStyle: TextStyle(color: Colors.grey,fontFamily: "messiri"),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء', style: TextStyle(color: Colors.white,fontFamily: "messiri")),
            ),
            TextButton(
              onPressed: () {
                _playFromUrl(urlController.text);
                Navigator.pop(context);
              },
              child: Text('تشغيل', style: TextStyle(color: Color(0xffFFD700),fontFamily: "messiri")),
            ),
          ],
        );
      },
    );
  }
}

// Card لتشغيل الفيديو من رابط
class VideoOptionCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final VoidCallback onTap;

  const VideoOptionCard({
    Key? key,
    required this.icon,
    required this.color,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      color: color,
      child: ListTile(
        leading: Icon(icon, color: Color(0xffFFD700)),
        title: Text(
          title,
          style: TextStyle(fontSize: 16.sp, color: Color(0xffFFD700),fontFamily: "messiri"),
        ),
        onTap: onTap,
      ),
    );
  }
}

// Card لتشغيل الصوت
class AudioOptionCard extends StatelessWidget {
  final bool isAudioPlaying;
  final VoidCallback onTap;

  const AudioOptionCard({
    Key? key,
    required this.isAudioPlaying,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(vertical: 10.h),
      color: isAudioPlaying ? Color(0xff002B25) : Colors.orange.shade900,
      child: ListTile(
        leading: Icon(
          isAudioPlaying ? Icons.pause : Icons.play_arrow,
          color: Color(0xffFFD700),
        ),
        title: Text(
          isAudioPlaying ? 'إيقاف الصوت' : 'تشغيل الصوت',
          style: TextStyle(fontSize: 16.sp, color: Color(0xffFFD700),fontFamily: "messiri"),
        ),
        onTap: onTap,
      ),
    );
  }
}

// أزرار التحكم في الفيديو
class VideoControlButtons extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onStop;
  final VoidCallback onRemove;

  const VideoControlButtons({
    Key? key,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onStop,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow,
              color: Color(0xffFFD700)),
          onPressed: onPlayPause,
        ),
        IconButton(
          icon: Icon(Icons.stop, color: Color(0xffFFD700)),
          onPressed: onStop,
        ),
        IconButton(
          icon: Icon(Icons.delete, color: Color(0xffFFD700)),
          onPressed: onRemove,
        ),
      ],
    );
  }
}

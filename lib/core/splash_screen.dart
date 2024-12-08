import 'dart:async';
import 'package:flutter/material.dart';
import 'package:islamic_app_saudi/Home/presentation/screens/home_screen.dart';


class SplashScreen extends StatefulWidget {
  static const String routename = 'splashscreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..forward();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);

    Timer(Duration(seconds: 2), () {
      Navigator.pushNamedAndRemoveUntil(context, HomeScreen.routename, (route) => false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/DALL·E 2024-12-06 17.27.05 - A vertical splash screen design for an Islamic app that represents audio azkars (remembrance of Allah). The design should feature a solid dark green b.jpg"),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
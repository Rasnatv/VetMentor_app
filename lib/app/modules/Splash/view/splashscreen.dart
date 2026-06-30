
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/constants/appcolors.dart';
import '../../onbaoarding/view/openscreen.dart';
import '../../landingview/view/Landingview.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;
  late Animation<double> _slideAnim;
  late Animation<double> _taglineAnim;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );

    _scaleAnim = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.55, curve: Curves.elasticOut)),
    );

    _slideAnim = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.35, 0.7, curve: Curves.easeOut)),
    );

    _taglineAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.5, 0.85, curve: Curves.easeOut)),
    );

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      _navigateNext();
    });
  }



  Future<void> _navigateNext() async {
    final box = GetStorage();
    final bool seenOnboarding = box.read('seen_onboarding') ?? false;

    print('seen_onboarding value: $seenOnboarding'); // ← ADD THIS

    if (seenOnboarding) {
      Get.offAll(
            () => const LandingView(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 600),
      );
    } else {
      Get.offAll(
            () => const OpenScreen(),
        transition: Transition.fade,
        duration: const Duration(milliseconds: 600),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: AppColors.cardGradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              top: -60,
              left: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              right: -50,
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              top: 120,
              right: -40,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.04),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Paw print watermark
            Positioned(
              bottom: 180,
              left: 30,
              child: Opacity(
                opacity: 0.07,
                child:
                Icon(Icons.pets_rounded, color: Colors.white, size: 60),
              ),
            ),
            Positioned(
              top: 100,
              right: 40,
              child: Opacity(
                opacity: 0.07,
                child:
                Icon(Icons.pets_rounded, color: Colors.white, size: 40),
              ),
            ),
            Positioned(
              bottom: 250,
              right: 100,
              child: Opacity(
                opacity: 0.07,
                child:
                Icon(Icons.school_sharp, color: Colors.white, size: 40),
              ),
            ),
            Positioned(
              top: 180,
              left: 30,
              child: Opacity(
                opacity: 0.07,
                child:
                Icon(Icons.school_sharp, color: Colors.white, size: 60),
              ),
            ),

            // Center content
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo icon
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) => FadeTransition(
                      opacity: _fadeAnim,
                      child: ScaleTransition(
                        scale: _scaleAnim,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.15),
                                blurRadius: 30,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Image.asset(
                            "assets/images/vetmentorlogo.jpeg",
                            width: 100,
                            height: 100,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // App name
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) => FadeTransition(
                      opacity: _fadeAnim,
                      child: Transform.translate(
                        offset: Offset(0, _slideAnim.value),
                        child: Column(
                          children: [
                            Text(
                              'Vet MenTor',
                              style: TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 42,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: -0.5,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 4),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Tagline
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (_, __) => FadeTransition(
                      opacity: _taglineAnim,
                      child: Text(
                        'Your journey in veterinary science\nstarts here',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.white.withOpacity(0.80),
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 60,
              left: 0,
              right: 0,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (_, __) => FadeTransition(
                  opacity: _taglineAnim,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Loading...',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.55),
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

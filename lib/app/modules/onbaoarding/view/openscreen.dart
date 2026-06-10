
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:veterinaryapp/app/core/constants/appimages.dart';
import '../../../core/constants/appcolors.dart';
import '../../landingview/view/Landingview.dart';

class OpenScreen extends StatefulWidget {
  const OpenScreen({super.key});

  @override
  State<OpenScreen> createState() => _OpenScreenState();
}

class _OpenScreenState extends State<OpenScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _imageFade;
  late Animation<Offset> _imageSlide;
  late Animation<double> _bottomFade;
  late Animation<Offset> _bottomSlide;

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _headerFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );
    _headerSlide =
        Tween<Offset>(begin: const Offset(0, -0.3), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _controller,
              curve: const Interval(0.0, 0.55, curve: Curves.easeOut)),
        );

    _imageFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.25, 0.65, curve: Curves.easeOut)),
    );
    _imageSlide =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _controller,
              curve: const Interval(0.25, 0.7, curve: Curves.easeOut)),
        );

    _bottomFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.55, 1.0, curve: Curves.easeOut)),
    );
    _bottomSlide =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
              parent: _controller,
              curve: const Interval(0.55, 1.0, curve: Curves.easeOut)),
        );

    _controller.forward();
  }


  Future<void> _completeOnboarding() async {
    final box = GetStorage();
    box.write('seen_onboarding', true);
    Get.offAll(
          () => const LandingView(),
      transition: Transition.fade,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Green curved background blob at top
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: ClipPath(
              clipper: _TopBlobClipper(),
              child: Container(
                height: size.height * 0.62,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F7F0),
                ),
              ),
            ),
          ),

          // Paw watermarks
          Positioned(
            top: 50,
            right: 30,
            child: Opacity(
              opacity: 0.12,
              child:
              Icon(Icons.pets_rounded, color: AppColors.primary, size: 50),
            ),
          ),
          Positioned(
            top: 130,
            left: 20,
            child: Opacity(
              opacity: 0.08,
              child:
              Icon(Icons.pets_rounded, color: AppColors.primary, size: 35),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Header text
                Padding(
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
                  child: SlideTransition(
                    position: _headerSlide,
                    child: FadeTransition(
                      opacity: _headerFade,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontFamily: 'Georgia',
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                                color: Color(0xFF1A1A1A),
                              ),
                              children: [
                                const TextSpan(text: 'Your Journey in\n'),
                                TextSpan(
                                  text: 'Veterinary Science',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                const TextSpan(text: '\nStarts Here'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Explore top veterinary colleges,\ncourses and build your future in\nanimal care and research.',
                            style: TextStyle(
                              fontSize: 14,
                              color:
                              const Color(0xFF1A1A1A).withOpacity(0.55),
                              height: 1.6,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 22),

                          // CTA Button
                          SlideTransition(
                            position: _bottomSlide,
                            child: FadeTransition(
                              opacity: _bottomFade,
                              child: GestureDetector(
                                onTap: _completeOnboarding,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 14,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary
                                            .withOpacity(0.35),
                                        blurRadius: 16,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        'Explore Colleges',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white,
                                          letterSpacing: 0.3,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color:
                                          Colors.white.withOpacity(0.25),
                                          borderRadius:
                                          BorderRadius.circular(6),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Hero image area
                Expanded(
                  child: SlideTransition(
                    position: _imageSlide,
                    child: FadeTransition(
                      opacity: _imageFade,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: _buildHeroImage(size),
                      ),
                    ),
                  ),
                ),

                // Bottom feature pills
                SlideTransition(
                  position: _bottomSlide,
                  child: FadeTransition(
                    opacity: _bottomFade,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildFeaturePill(
                            icon: Icons.verified_rounded,
                            label: 'Trusted\nInformation',
                          ),
                          _buildDivider(),
                          _buildFeaturePill(
                            icon: Icons.school_rounded,
                            label: 'Top Veterinary\nColleges',
                          ),
                          _buildDivider(),
                          _buildFeaturePill(
                            icon: Icons.favorite_rounded,
                            label: 'Better Future\nfor Animals',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroImage(Size size) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Icon(Icons.cruelty_free_rounded,
                        color: AppColors.primary.withOpacity(0.2), size: 70),
                  ),
                ],
              ),
            ),
          ),
          Image.asset(
            AppImages.openscreenimage,
            fit: BoxFit.contain,
            height: 600,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturePill(
      {required IconData icon, required String label}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF555555),
            height: 1.4,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 36,
      width: 1,
      color: Colors.grey.withOpacity(0.2),
    );
  }
}

class _TopBlobClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height * 0.82);
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height,
      size.width * 0.5,
      size.height * 0.9,
    );
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.8,
      0,
      size.height * 0.88,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(_TopBlobClipper old) => false;
}
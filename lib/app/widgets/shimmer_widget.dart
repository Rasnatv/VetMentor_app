
import 'package:flutter/material.dart';

class ShimmerWrapper extends StatefulWidget {
  final Widget child;
  const ShimmerWrapper({super.key, required this.child});

  @override
  State<ShimmerWrapper> createState() => _ShimmerWrapperState();
}

class _ShimmerWrapperState extends State<ShimmerWrapper>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    )..repeat();
    _anim = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, child) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: const [
            Color(0xFFE0E0E0),
            Color(0xFFF0F0F0),
            Color(0xFFE0E0E0),
          ],
          stops: const [0.0, 0.5, 1.0],
          transform: _SlideTransform(_anim.value),
        ).createShader(bounds),
        child: child,
      ),
      child: widget.child,
    );
  }
}

class _SlideTransform extends GradientTransform {
  final double v;
  const _SlideTransform(this.v);
  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * v, 0, 0);
}

// Atomic grey block
class _SBox extends StatelessWidget {
  final double? w;
  final double h;
  final double r;
  const _SBox({this.w, required this.h, this.r = 8});

  @override
  Widget build(BuildContext context) => Container(
    width: w,
    height: h,
    decoration: BoxDecoration(
      color: const Color(0xFFE0E0E0),
      borderRadius: BorderRadius.circular(r),
    ),
  );
}

class ShimmerAppBar extends StatelessWidget {
  const ShimmerAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _SBox(w: 210, h: 20, r: 6),  // "Hello, Vet Aspirant! 👋"
                SizedBox(height: 8),
                _SBox(w: 250, h: 14, r: 6),  // subtitle
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Notification bell placeholder
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFFE0E0E0),
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerSearchBar extends StatelessWidget {
  const ShimmerSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }
}

class ShimmerHeroBanner extends StatelessWidget {
  const ShimmerHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Container(
        height: 200, // matches image height (112–148) + text/padding
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(26),
        ),
      ),
    );
  }
}

// Mock Test banner — matches _buildMockTestSection
class ShimmerMockTestBanner extends StatelessWidget {
  const ShimmerMockTestBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Row(
          children: [
            const _SBox(w: 56, h: 56, r: 16), // icon badge
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  _SBox(w: 150, h: 15, r: 6),
                  SizedBox(height: 8),
                  _SBox(w: 190, h: 12, r: 6),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const _SBox(w: 40, h: 40, r: 20), // circular arrow chip
          ],
        ),
      ),
    );
  }
}

class ShimmerSectionHeader extends StatelessWidget {
  const ShimmerSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _SBox(w: 190, h: 18, r: 6),
        _SBox(w: 58, h: 14, r: 6),
      ],
    );
  }
}

class ShimmerCourseCard extends StatelessWidget {
  const ShimmerCourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: 88,
            decoration: const BoxDecoration(
              color: Color(0xFFE8E8E8),
              borderRadius: BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  _SBox(w: double.infinity, h: 14, r: 6),
                  SizedBox(height: 8),
                  _SBox(w: 160, h: 14, r: 6),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 14),
            child: _SBox(w: 16, h: 16, r: 4),
          ),
        ],
      ),
    );
  }
}

// Temporary / Permanent affiliation buttons — matches _AffiliationButton
class ShimmerAffiliationButtons extends StatelessWidget {
  const ShimmerAffiliationButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SBox(w: 170, h: 17, r: 6), // "Affiliated Colleges"
          const SizedBox(height: 8),
          const _SBox(w: 220, h: 13, r: 6), // subtitle
          const SizedBox(height: 14),
          Row(
            children: const [
              Expanded(child: _AffiliationButtonShimmer()),
              SizedBox(width: 14),
              Expanded(child: _AffiliationButtonShimmer()),
            ],
          ),
        ],
      ),
    );
  }
}

class _AffiliationButtonShimmer extends StatelessWidget {
  const _AffiliationButtonShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SBox(w: 46, h: 46, r: 14),
              _SBox(w: 26, h: 26, r: 13),
            ],
          ),
          SizedBox(height: 14),
          _SBox(w: 90, h: 15, r: 6),
          SizedBox(height: 6),
          _SBox(w: 110, h: 11, r: 6),
        ],
      ),
    );
  }
}

class ShimmerCollegeCard extends StatelessWidget {
  const ShimmerCollegeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFEEEEEE)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFFE8E8E8),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _SBox(w: double.infinity, h: 14, r: 6),
                const SizedBox(height: 6),
                const _SBox(w: 180, h: 14, r: 6),
                const SizedBox(height: 10),
                Row(
                  children: const [
                    _SBox(w: 12, h: 12, r: 6),
                    SizedBox(width: 5),
                    _SBox(w: 120, h: 12, r: 6),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Greeting + bell ───────────────────────────
              const ShimmerAppBar(),

              // ── Search ───────────────────────────────────
              const ShimmerSearchBar(),

              // ── Hero banner ──────────────────────────────
              const ShimmerHeroBanner(),

              // ── Mock test banner ──────────────────────────
              const ShimmerMockTestBanner(),

              // ── Recommended For You ──────────────────────
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: ShimmerSectionHeader(),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: ShimmerCourseCard(),
              ),

              // ── Affiliated colleges buttons ───────────────
              const ShimmerAffiliationButtons(),

              // ── Top Veterinary Colleges ───────────────────
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 28, 20, 0),
                child: ShimmerSectionHeader(),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: ShimmerCollegeCard(),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: ShimmerCollegeCard(),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 12, 20, 0),
                child: ShimmerCollegeCard(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
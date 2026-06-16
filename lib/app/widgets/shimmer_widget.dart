import 'package:flutter/material.dart';

// ═══════════════════════════════════════════════════════════════
//  SHIMMER BASE
//  All shimmer widgets build on this single animated gradient.
// ═══════════════════════════════════════════════════════════════

class ShimmerBase extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;

  const ShimmerBase({
    super.key,
    required this.child,
    this.baseColor    = const Color(0xFFE0E0E0),
    this.highlightColor = const Color(0xFFF5F5F5),
  });

  @override
  State<ShimmerBase> createState() => _ShimmerBaseState();
}

class _ShimmerBaseState extends State<ShimmerBase>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _anim = Tween<double>(begin: -1, end: 2).animate(
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
      builder: (_, __) => ShaderMask(
        blendMode: BlendMode.srcATop,
        shaderCallback: (bounds) => LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            widget.baseColor,
            widget.highlightColor,
            widget.baseColor,
          ],
          stops: [
            (_anim.value - 0.3).clamp(0.0, 1.0),
            _anim.value.clamp(0.0, 1.0),
            (_anim.value + 0.3).clamp(0.0, 1.0),
          ],
        ).createShader(bounds),
        child: widget.child,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHIMMER BOX  –  the atomic building block
// ═══════════════════════════════════════════════════════════════

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHIMMER CIRCLE
// ═══════════════════════════════════════════════════════════════

class ShimmerCircle extends StatelessWidget {
  final double size;

  const ShimmerCircle({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Color(0xFFE0E0E0),
        shape: BoxShape.circle,
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHIMMER COLLEGE CARD
//  Matches your CollegeCard widget layout
// ═══════════════════════════════════════════════════════════════

class ShimmerCollegeCard extends StatelessWidget {
  const ShimmerCollegeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBase(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Row(
          children: [
            // left icon placeholder
            ShimmerBox(width: 48, height: 48, radius: 12),
            const SizedBox(width: 12),
            // text lines
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: double.infinity, height: 14, radius: 6),
                  const SizedBox(height: 8),
                  ShimmerBox(width: 160, height: 11, radius: 6),
                  const SizedBox(height: 6),
                  ShimmerBox(width: 100, height: 11, radius: 6),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // arrow placeholder
            ShimmerBox(width: 20, height: 20, radius: 4),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHIMMER COURSE CARD
//  Matches your horizontal course card layout (icon left, text right)
// ═══════════════════════════════════════════════════════════════

class ShimmerCourseCard extends StatelessWidget {
  const ShimmerCourseCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBase(
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Row(
          children: [
            // left image/icon block
            Container(
              width: 100,
              decoration: const BoxDecoration(
                color: Color(0xFFE0E0E0),
                borderRadius: BorderRadius.horizontal(
                  left: Radius.circular(16),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // text block
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: double.infinity, height: 13, radius: 6),
                  const SizedBox(height: 8),
                  ShimmerBox(width: 120, height: 11, radius: 6),
                ],
              ),
            ),
            const SizedBox(width: 12),
            ShimmerBox(width: 20, height: 20, radius: 4),
            const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHIMMER HERO BANNER
//  Matches your gradient hero banner block
// ═══════════════════════════════════════════════════════════════

class ShimmerHeroBanner extends StatelessWidget {
  const ShimmerHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBase(
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShimmerBox(width: 180, height: 16, radius: 6),
                  const SizedBox(height: 8),
                  ShimmerBox(width: 140, height: 16, radius: 6),
                  const SizedBox(height: 12),
                  ShimmerBox(width: 120, height: 11, radius: 6),
                  const SizedBox(height: 6),
                  ShimmerBox(width: 100, height: 11, radius: 6),
                ],
              ),
            ),
            ShimmerCircle(size: 64),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHIMMER SECTION HEADER
//  Matches your SectionHeader (title + action text)
// ═══════════════════════════════════════════════════════════════

class ShimmerSectionHeader extends StatelessWidget {
  const ShimmerSectionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBase(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ShimmerBox(width: 160, height: 14, radius: 6),
          ShimmerBox(width: 60, height: 12, radius: 6),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHIMMER PROFILE HEADER
//  Avatar + name + subtitle stacked
// ═══════════════════════════════════════════════════════════════

class ShimmerProfileHeader extends StatelessWidget {
  const ShimmerProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBase(
      child: Column(
        children: [
          ShimmerCircle(size: 80),
          const SizedBox(height: 12),
          ShimmerBox(width: 140, height: 16, radius: 6),
          const SizedBox(height: 8),
          ShimmerBox(width: 100, height: 12, radius: 6),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHIMMER PROFILE ROW
//  A single info row (icon + label + value) for profile sections
// ═══════════════════════════════════════════════════════════════

class ShimmerProfileRow extends StatelessWidget {
  const ShimmerProfileRow({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBase(
      child: Row(
        children: [
          ShimmerCircle(size: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(width: 80, height: 11, radius: 5),
                const SizedBox(height: 6),
                ShimmerBox(width: 160, height: 13, radius: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHIMMER STAT CARD
//  Small box with a number + label (used in college detail / profile)
// ═══════════════════════════════════════════════════════════════

class ShimmerStatCard extends StatelessWidget {
  const ShimmerStatCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBase(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Column(
          children: [
            ShimmerBox(width: 40, height: 18, radius: 5),
            const SizedBox(height: 6),
            ShimmerBox(width: 50, height: 11, radius: 5),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHIMMER MENTOR CARD
//  Avatar left, name + specialty + rating right
// ═══════════════════════════════════════════════════════════════

class ShimmerMentorCard extends StatelessWidget {
  const ShimmerMentorCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerBase(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Row(
          children: [
            ShimmerCircle(size: 52),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerBox(width: 130, height: 14, radius: 6),
                  const SizedBox(height: 7),
                  ShimmerBox(width: 100, height: 11, radius: 6),
                  const SizedBox(height: 7),
                  ShimmerBox(width: 70,  height: 11, radius: 6),
                ],
              ),
            ),
            ShimmerBox(width: 60, height: 28, radius: 20),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHIMMER LIST
//  Convenience wrapper — renders N shimmer cards with spacing
// ═══════════════════════════════════════════════════════════════

class ShimmerList extends StatelessWidget {
  final Widget Function() itemBuilder;
  final int count;
  final double spacing;
  final EdgeInsetsGeometry padding;

  const ShimmerList({
    super.key,
    required this.itemBuilder,
    this.count   = 4,
    this.spacing = 12,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Column(
        children: List.generate(count, (i) => Padding(
          padding: EdgeInsets.only(bottom: i < count - 1 ? spacing : 0),
          child: itemBuilder(),
        )),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHIMMER HOME SCREEN  –  full home skeleton
// ═══════════════════════════════════════════════════════════════

class ShimmerHomeScreen extends StatelessWidget {
  final EdgeInsets padding;

  const ShimmerHomeScreen({
    super.key,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Search bar
          ShimmerBase(
            child: ShimmerBox(
              width: double.infinity, height: 48, radius: 12,
            ),
          ),
          const SizedBox(height: 16),

          // Hero banner
          const ShimmerHeroBanner(),
          const SizedBox(height: 24),

          // "Recommended" section header
          const ShimmerSectionHeader(),
          const SizedBox(height: 12),

          // Course cards
          const ShimmerCourseCard(),
          const SizedBox(height: 12),
          const ShimmerCourseCard(),
          const SizedBox(height: 24),

          // "Top Colleges" section header
          const ShimmerSectionHeader(),
          const SizedBox(height: 12),

          // College cards
          const ShimmerCollegeCard(),
          const SizedBox(height: 12),
          const ShimmerCollegeCard(),
          const SizedBox(height: 12),
          const ShimmerCollegeCard(),
          const SizedBox(height: 12),
          const ShimmerCollegeCard(),
          const SizedBox(height: 12),
          const ShimmerCollegeCard(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../core/constants/appcolors.dart';
import '../core/style/dimens.dart';

class ProfileShimmer extends StatefulWidget {
  const ProfileShimmer({super.key});

  @override
  State<ProfileShimmer> createState() => _ProfileShimmerState();
}

class _ProfileShimmerState extends State<ProfileShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
    _anim = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // ── shimmer gradient box ─────────────────────────────────────
  Widget _box({
    double width = double.infinity,
    double height = 14,
    double radius = 8,
    EdgeInsets? margin,
  }) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        margin: margin,
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            begin: Alignment(_anim.value - 1, 0),
            end: Alignment(_anim.value + 1, 0),
            colors: const [
              Color(0xFFE4E7EB),
              Color(0xFFF2F4F7),
              Color(0xFFE4E7EB),
            ],
          ),
        ),
      ),
    );
  }

  // ── shimmer circle ───────────────────────────────────────────
  Widget _circle(double size) => AnimatedBuilder(
    animation: _anim,
    builder: (_, __) => Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment(_anim.value - 1, 0),
          end: Alignment(_anim.value + 1, 0),
          colors: const [
            Color(0xFFE4E7EB),
            Color(0xFFF2F4F7),
            Color(0xFFE4E7EB),
          ],
        ),
      ),
    ),
  );

  // ── hero banner skeleton ─────────────────────────────────────
  Widget _heroBanner() => AnimatedBuilder(
    animation: _anim,
    builder: (_, __) => Container(
      height: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        gradient: LinearGradient(
          begin: Alignment(_anim.value - 1, 0),
          end: Alignment(_anim.value + 1, 0),
          colors: const [
            Color(0xFFD5DAE0),
            Color(0xFFEBEEF2),
            Color(0xFFD5DAE0),
          ],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [_circle(64), _circle(50)],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _box(width: 150, height: 16, radius: 6),
                const SizedBox(height: 8),
                _box(width: 190, height: 11, radius: 5),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _box(width: 62, height: 24, radius: 20),
                    const SizedBox(width: 8),
                    _box(width: 76, height: 24, radius: 20),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  // ── section label skeleton ───────────────────────────────────
  Widget _sectionLabel() => Padding(
    padding: const EdgeInsets.fromLTRB(0, 24, 0, 12),
    child: Row(
      children: [
        _box(width: 4, height: 16, radius: 2),
        const SizedBox(width: 8),
        _box(width: 120, height: 12, radius: 6),
      ],
    ),
  );

  // ── single info row skeleton ─────────────────────────────────
  Widget _infoRow({bool divider = true}) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            _box(width: 36, height: 36, radius: 10),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(width: 80, height: 10, radius: 5),
                  const SizedBox(height: 7),
                  _box(width: 160, height: 13, radius: 5),
                ],
              ),
            ),
          ],
        ),
      ),
      if (divider)
        Divider(
          height: 1,
          indent: 16 + 36.0 + 12,
          color: AppColors.borderLight,
        ),
    ],
  );

  // ── breadcrumb header skeleton ───────────────────────────────
  Widget _breadcrumbHeader() => Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFF5F5F5),
      border: Border(bottom: BorderSide(color: AppColors.borderLight)),
    ),
    child: Row(
      children: [
        _box(width: 32, height: 32, radius: 8),
        const SizedBox(width: 10),
        _box(width: 180, height: 12, radius: 6),
      ],
    ),
  );

  // ── card wrapper ─────────────────────────────────────────────
  Widget _card({required List<Widget> children, bool hasBreadcrumb = false}) =>
      Container(
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (hasBreadcrumb) _breadcrumbHeader(),
              ...children,
            ],
          ),
        ),
      );

  // ── saved colleges button skeleton ───────────────────────────
  Widget _savedCollegesBtn() => _card(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            _box(width: 40, height: 40, radius: 10),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(width: 120, height: 13, radius: 5),
                  const SizedBox(height: 6),
                  _box(width: 180, height: 10, radius: 5),
                ],
              ),
            ),
            _box(width: 14, height: 14, radius: 4),
          ],
        ),
      ),
    ],
  );

  // ── neet score card skeleton ─────────────────────────────────
  Widget _neetCard() => _card(
    children: [
      Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            _circle(64),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _box(width: 80, height: 11, radius: 5),
                  const SizedBox(height: 8),
                  _box(width: 100, height: 28, radius: 6),
                ],
              ),
            ),
            _box(width: 84, height: 30, radius: 20),
          ],
        ),
      ),
    ],
  );

  // ── privacy note skeleton ────────────────────────────────────
  Widget _privacyNote() => _box(
    height: 46,
    radius: AppDimens.radiusMD,
    margin: const EdgeInsets.only(top: 24),
  );

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero banner
          _heroBanner(),

          // My Collections
          _sectionLabel(),
          _savedCollegesBtn(),

          // Contact Details
          _sectionLabel(),
          _card(children: [
            _infoRow(),
            _infoRow(divider: false),
          ]),

          // Location Details — has breadcrumb + 5 rows (Country→State→District→Address→Pincode)
          _sectionLabel(),
          _card(
            hasBreadcrumb: true,
            children: [
              _infoRow(),   // Country
              _infoRow(),   // State
              _infoRow(),   // District
              _infoRow(),   // Address
              _infoRow(divider: false), // Pincode
            ],
          ),

          // Academic Details
          _sectionLabel(),
          _card(children: [
            _infoRow(divider: false),
          ]),

          // NEET Score
          _sectionLabel(),
          _neetCard(),

          _privacyNote(),
        ],
      ),
    );
  }
}
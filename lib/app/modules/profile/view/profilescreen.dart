
import 'package:flutter/material.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../widgets/commonwidget.dart';
import '../../../data/models/modelclass.dart';
import '../../Saved/view/SavedScreen.dart';


class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Map<String, dynamic> _enquiryData = {
    'firstName': 'Arjun',
    'lastName': 'Kumar',
    'gender': 'Male',
    'email': 'arjun@email.com',
    'phone': '9876543210',
    'state': 'Kerala',
    'category': 'General',
    'course': 'PCB – Physics, Chemistry, Biology',
    'neet': '520',
    'college': 'Amrita School of Medicine, Kochi',
  };

  // Pass your real saved list here from parent/state management
  static final List<College> _savedColleges = MockData.colleges.take(2).toList();

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: VetAppBar(
          title: 'My Profile',
          showBack: false,
          actions: [
            Padding(
              padding: EdgeInsets.only(right: r.spacing(AppDimens.paddingMD)),
              child: Container(
                width: r.spacing(AppDimens.avatarSM),
                height: r.spacing(AppDimens.avatarSM),
                decoration: BoxDecoration(
                  color: AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                  border: Border.all(color: AppColors.border),
                ),
                child: Icon(
                  Icons.edit_outlined,
                  color: AppColors.textPrimary,
                  size: r.fontSize(AppDimens.iconSM),
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Hero Banner ──────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                  r.spacing(AppDimens.paddingLG),
                  r.spacing(AppDimens.paddingLG),
                  r.spacing(AppDimens.paddingLG),
                  0,
                ),
                child: _ProfileHeroBanner(data: _enquiryData),
              ),

              // ── Saved Colleges ───────────────────────────────────────
              _SectionHeader(title: 'Saved Colleges'),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  r.spacing(AppDimens.paddingLG),
                  0,
                  r.spacing(AppDimens.paddingLG),
                  0,
                ),
                child: _SavedCollegesCard(
                  r: r,
                  savedColleges: _savedColleges,
                ),
              ),

              // ── Contact Details ──────────────────────────────────────
              _SectionHeader(title: 'Contact Details'),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  r.spacing(AppDimens.paddingLG),
                  0,
                  r.spacing(AppDimens.paddingLG),
                  0,
                ),
                child: _InfoCard(rows: [
                  _InfoRow(
                    icon: Icons.email_outlined,
                    iconColor: AppColors.primary,
                    iconBg: AppColors.primarySurface,
                    label: 'Email address',
                    value: _enquiryData['email'],
                  ),
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    iconColor: const Color(0xFF0F6E56),
                    iconBg: const Color(0xFFE1F5EE),
                    label: 'Phone number',
                    value: '+91 ${_enquiryData['phone']}',
                  ),
                ]),
              ),

              // ── Academic Details ─────────────────────────────────────
              _SectionHeader(title: 'Academic Details'),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  r.spacing(AppDimens.paddingLG),
                  0,
                  r.spacing(AppDimens.paddingLG),
                  0,
                ),
                child: _InfoCard(rows: [
                  _InfoRow(
                    icon: Icons.menu_book_outlined,
                    iconColor: const Color(0xFF534AB7),
                    iconBg: const Color(0xFFEEEDFE),
                    label: 'Course studied (12th / UG)',
                    value: _enquiryData['course'],
                  ),
                  _InfoRow(
                    icon: Icons.school_outlined,
                    iconColor: const Color(0xFF854F0B),
                    iconBg: const Color(0xFFFAEEDA),
                    label: 'Category',
                    value: _enquiryData['category'],
                  ),
                  _InfoRow(
                    icon: Icons.public_outlined,
                    iconColor: const Color(0xFF993C1D),
                    iconBg: const Color(0xFFFAECE7),
                    label: 'State',
                    value: _enquiryData['state'],
                  ),
                ]),
              ),

              // ── NEET Score ───────────────────────────────────────────
              _SectionHeader(title: 'NEET Score'),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  r.spacing(AppDimens.paddingLG),
                  0,
                  r.spacing(AppDimens.paddingLG),
                  0,
                ),
                child: _NeetCard(score: _enquiryData['neet']),
              ),

              // ── Enquiry For ──────────────────────────────────────────
              _SectionHeader(title: 'Enquiry For'),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  r.spacing(AppDimens.paddingLG),
                  0,
                  r.spacing(AppDimens.paddingLG),
                  0,
                ),
                child: _CollegeCard(college: _enquiryData['college']),
              ),

              // ── Privacy note ─────────────────────────────────────────
              Padding(
                padding: EdgeInsets.fromLTRB(
                  r.spacing(AppDimens.paddingLG),
                  r.spacing(AppDimens.paddingXL),
                  r.spacing(AppDimens.paddingLG),
                  0,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: r.fontSize(AppDimens.iconXS - 1),
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: r.spacing(AppDimens.paddingXS + 2)),
                    Expanded(
                      child: Text(
                        'Your information is safe and never shared with third parties.',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: r.fontSize(11),
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Saved Colleges Card ──────────────────────────────────────────────────────

class _SavedCollegesCard extends StatelessWidget {
  final Responsive r;
  final List<College> savedColleges;

  const _SavedCollegesCard({
    required this.r,
    required this.savedColleges,
  });

  @override
  Widget build(BuildContext context) {
    final isEmpty = savedColleges.isEmpty;

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SavedScreen(
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(color: AppColors.borderLight),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
          child: Row(
            children: [
              // Icon box
              Container(
                width: r.spacing(AppDimens.avatarSM),
                height: r.spacing(AppDimens.avatarSM),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppDimens.radiusMD - 2),
                ),
                child: Icon(
                  Icons.bookmark_rounded,
                  size: r.fontSize(AppDimens.iconSM),
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: r.spacing(AppDimens.paddingMD)),

              // Label + preview
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saved Colleges',
                      style: AppTextStyles.titleLarge.copyWith(
                        fontSize: r.fontSize(14),
                      ),
                    ),
                    SizedBox(height: r.spacing(2)),


                ]),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: r.fontSize(AppDimens.iconXS),
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Profile Hero Banner ──────────────────────────────────────────────────────

class _ProfileHeroBanner extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ProfileHeroBanner({required this.data});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final initials =
    '${data['firstName'][0]}${data['lastName'].isNotEmpty ? data['lastName'][0] : ''}'
        .toUpperCase();

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.cardGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20,
            right: -20,
            child: Container(
              width: r.spacing(100),
              height: r.spacing(100),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            right: 60,
            child: Container(
              width: r.spacing(80),
              height: r.spacing(80),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(r.spacing(AppDimens.paddingXL)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: r.spacing(30),
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Text(
                    initials,
                    style: AppTextStyles.displayWhite.copyWith(
                      fontSize: r.fontSize(20),
                    ),
                  ),
                ),
                SizedBox(width: r.spacing(AppDimens.paddingMD)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${data['firstName']} ${data['lastName']}',
                        style: AppTextStyles.displayWhite.copyWith(
                          fontSize: r.fontSize(17),
                        ),
                      ),
                      SizedBox(height: r.spacing(AppDimens.paddingXS)),
                      Text(
                        'Enquiry submitted · 21 May 2026',
                        style: AppTextStyles.bodyWhite.copyWith(
                          color: Colors.white70,
                          fontSize: r.fontSize(12),
                        ),
                      ),
                      SizedBox(height: r.spacing(AppDimens.paddingSM + 2)),
                      Wrap(
                        spacing: r.spacing(AppDimens.paddingXS + 2),
                        runSpacing: r.spacing(AppDimens.paddingXS + 2),
                        children: [
                          _WhiteChip(label: data['gender'], icon: Icons.male_rounded),
                          _WhiteChip(label: data['state'], icon: Icons.location_on_outlined),
                          _WhiteChip(label: data['category'], icon: Icons.label_outline_rounded),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WhiteChip extends StatelessWidget {
  final String label;
  final IconData icon;
  const _WhiteChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.spacing(AppDimens.paddingSM),
        vertical: r.spacing(AppDimens.paddingXS),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: r.fontSize(AppDimens.iconXS - 2), color: Colors.white),
          SizedBox(width: r.spacing(AppDimens.paddingXS)),
          Text(
            label,
            style: AppTextStyles.bodyWhite.copyWith(
              fontSize: r.fontSize(11),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Header ───────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingXL),
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingSM + 2),
      ),
      child: Text(
        title,
        style: AppTextStyles.titleLarge.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: r.fontSize(14),
        ),
      ),
    );
  }
}

// ─── Info Card ────────────────────────────────────────────────────────────────

class _InfoRow {
  final IconData icon;
  final Color iconColor, iconBg;
  final String label, value;
  const _InfoRow({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });
}

class _InfoCard extends StatelessWidget {
  final List<_InfoRow> rows;
  const _InfoCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: rows.asMap().entries.map((e) {
          final row = e.value;
          final last = e.key == rows.length - 1;
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: r.spacing(AppDimens.paddingLG),
                  vertical: r.spacing(AppDimens.paddingMD + 1),
                ),
                child: Row(
                  children: [
                    Container(
                      width: r.spacing(AppDimens.avatarSM),
                      height: r.spacing(AppDimens.avatarSM),
                      decoration: BoxDecoration(
                        color: row.iconBg,
                        borderRadius:
                        BorderRadius.circular(AppDimens.radiusMD - 2),
                      ),
                      child: Icon(row.icon,
                          size: r.fontSize(AppDimens.iconSM),
                          color: row.iconColor),
                    ),
                    SizedBox(width: r.spacing(AppDimens.paddingMD)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            row.label,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: r.fontSize(12),
                              color: AppColors.textSecondary,
                            ),
                          ),
                          SizedBox(height: r.spacing(2)),
                          Text(row.value,
                              style: AppTextStyles.titleLarge),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!last)
                Divider(
                  height: 1,
                  indent: r.spacing(
                      AppDimens.paddingLG + AppDimens.avatarSM),
                  endIndent: 0,
                  color: AppColors.borderLight,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─── NEET Card ────────────────────────────────────────────────────────────────

class _NeetCard extends StatelessWidget {
  final String score;
  const _NeetCard({required this.score});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppDimens.radiusLG),
              ),
              child: Container(
                width: r.value(
                    mobile: r.spacing(100), tablet: r.spacing(120)),
                color: AppColors.primarySurface,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart_rounded,
                        color: AppColors.primary,
                        size: r.fontSize(AppDimens.iconLG - 4)),
                    SizedBox(height: r.spacing(AppDimens.paddingXS)),
                    Text(
                      'NEET',
                      style: AppTextStyles.bodyGreen.copyWith(
                        fontSize: r.fontSize(11),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Your Score',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: r.fontSize(12),
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(height: r.spacing(2)),
                        Text(
                          score,
                          style: AppTextStyles.bodyGreen.copyWith(
                            fontSize: r.fontSize(26),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: r.spacing(2)),
                        Text(
                          'out of 720',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: r.fontSize(11),
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.spacing(AppDimens.paddingMD),
                        vertical: r.spacing(AppDimens.paddingXS + 2),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF3DE),
                        borderRadius:
                        BorderRadius.circular(AppDimens.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline_rounded,
                              size: r.fontSize(AppDimens.iconXS),
                              color: const Color(0xFF3B6D11)),
                          SizedBox(width: r.spacing(AppDimens.paddingXS)),
                          Text(
                            'Eligible',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: r.fontSize(12),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF3B6D11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── College Card ─────────────────────────────────────────────────────────────

class _CollegeCard extends StatelessWidget {
  final String college;
  const _CollegeCard({required this.college});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppDimens.radiusLG),
              ),
              child: Container(
                width: r.value(
                    mobile: r.spacing(100), tablet: r.spacing(120)),
                color: const Color(0xFFEEEDFE),
                child: Icon(Icons.account_balance_outlined,
                    color: const Color(0xFF534AB7),
                    size: r.fontSize(AppDimens.iconXL)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      college,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: r.fontSize(14),
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: r.spacing(AppDimens.paddingXS)),
                    Text(
                      'Quick Enquiry',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: r.fontSize(12),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: r.spacing(AppDimens.paddingSM)),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.spacing(AppDimens.paddingSM + 2),
                        vertical: r.spacing(AppDimens.paddingXS),
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF3DE),
                        borderRadius:
                        BorderRadius.circular(AppDimens.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.check_circle_outline_rounded,
                              size: r.fontSize(AppDimens.iconXS - 2),
                              color: const Color(0xFF3B6D11)),
                          SizedBox(width: r.spacing(AppDimens.paddingXS)),
                          Text(
                            'Submitted',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: r.fontSize(11),
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF3B6D11),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

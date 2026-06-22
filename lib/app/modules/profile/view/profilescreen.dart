import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../Saved/view/SavedScreen.dart';
import '../controller/profilecontroller.dart';
import '../../../data/models/studentprofilemodel.dart';
import '../../Colleges/controller/enquirycontroller.dart';
import 'updateprofilescreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {

  late final ProfileController ctrl;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    Get.delete<ProfileController>(force: true);
    ctrl = Get.put(ProfileController());
  }

  int get _studentId {
    try {
      final enquiry = Get.find<EnquiryController>();
      final id = enquiry.studentId;
      if (id != 0) return id;
    } catch (_) {}
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Responsive r = Responsive.of(context);

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.backgroundGrey,
        appBar: VetAppBar(
          title: 'My Profile',
          showBack: false,
          actions: [
            Obx(() {
              if (!ctrl.isSuccess) return const SizedBox.shrink();
              return Padding(
                padding: EdgeInsets.only(right: r.spacing(AppDimens.paddingMD)),
                child: GestureDetector(
                  onTap: () {
                    if (ctrl.profile.value != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => UpdateProfileScreen(
                            profile: ctrl.profile.value!,
                          ),
                        ),
                      ).then((_) => ctrl.fetchProfile());
                    }
                  },
                  child: Container(
                    width: r.spacing(AppDimens.avatarSM),
                    height: r.spacing(AppDimens.avatarSM),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundGrey,
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                      border: Border.all(color: AppColors.borderLight),
                    ),
                    child: Icon(
                      Icons.edit_outlined,
                      color: AppColors.textPrimary,
                      size: r.fontSize(AppDimens.iconSM),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        body: Obx(() {
          if (ctrl.isLoading) return _buildLoading();
          if (ctrl.hasError) return _buildError(r, ctrl);
          if (ctrl.isSuccess && ctrl.profile.value != null) {
            return _buildProfile(context, r, ctrl.profile.value!);
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  Widget _buildLoading() => const Center(
    child: CircularProgressIndicator(
      color: AppColors.primary,
      strokeWidth: 2,
    ),
  );

  Widget _buildError(Responsive r, ProfileController ctrl) => Center(
    child: Padding(
      padding: EdgeInsets.all(r.spacing(AppDimens.paddingXL)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/lottie/not-found.json',
            width: r.value(mobile: 180.0, tablet: 220.0),
            height: r.value(mobile: 180.0, tablet: 220.0),
            fit: BoxFit.contain,
            repeat: true,
          ),
          SizedBox(height: r.spacing(AppDimens.paddingMD)),
          Text(
            'Could not load profile',
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: r.fontSize(15),
            ),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingXS)),
          Text(
            ctrl.profileError.value,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: r.fontSize(13),
            ),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingMD)),

        ],
      ),
    ),
  );

  Widget _buildProfile(
      BuildContext context,
      Responsive r,
      StudentProfileModel p,
      ) =>
      SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Hero Banner ──────────────────────────────────
            Padding(
              padding: EdgeInsets.fromLTRB(
                r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingLG),
                0,
              ),
              child: _ProfileHeroBanner(profile: p),
            ),

            // ── My Collections ───────────────────────────────
            _SectionHeader(title: 'My Collections'),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: r.spacing(AppDimens.paddingLG)),
              child: _SavedCollegesButton(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WishlistScreen(studentId: _studentId),
                    ),
                  );
                },
              ),
            ),

            // ── Contact Details ──────────────────────────────
            _SectionHeader(title: 'Contact Details'),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: r.spacing(AppDimens.paddingLG)),
              child: _InfoCard(rows: [
                _InfoRowData(
                  icon: Icons.email_outlined,
                  iconColor: const Color(0xFF185FA5),
                  iconBg: const Color(0xFFE6F1FB),
                  label: 'Email address',
                  value: p.email.isNotEmpty ? p.email : '—',
                ),
                _InfoRowData(
                  icon: Icons.phone_outlined,
                  iconColor: const Color(0xFF0F6E56),
                  iconBg: const Color(0xFFE1F5EE),
                  label: 'Phone number',
                  value: p.phoneNo.isNotEmpty
                      ? '${p.countryCode} ${p.phoneNo}'
                      : '—',
                ),
              ]),
            ),

            // ── Location Details ─────────────────────────────
            _SectionHeader(title: 'Location Details'),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: r.spacing(AppDimens.paddingLG)),
              child: _InfoCard(rows: [
                _InfoRowData(
                  icon: Icons.location_city_outlined,
                  iconColor: const Color(0xFF534AB7),
                  iconBg: const Color(0xFFEEEDFE),
                  label: 'District',
                  value: p.district.isNotEmpty ? p.district : '—',
                ),
                _InfoRowData(
                  icon: Icons.map_outlined,
                  iconColor: const Color(0xFF993C1D),
                  iconBg: const Color(0xFFFAECE7),
                  label: 'State',
                  value: p.state.isNotEmpty ? p.state : '—',
                ),
                _InfoRowData(
                  icon: Icons.public_outlined,
                  iconColor: const Color(0xFF0F6E56),
                  iconBg: const Color(0xFFE1F5EE),
                  label: 'Country',
                  value: p.country.isNotEmpty ? p.country : '—',
                ),
                _InfoRowData(
                  icon: Icons.home_outlined,
                  iconColor: const Color(0xFF185FA5),
                  iconBg: const Color(0xFFE6F1FB),
                  label: 'Address',
                  value: p.address.isNotEmpty ? p.address : '—',
                ),
                _InfoRowData(
                  icon: Icons.pin_drop_outlined,
                  iconColor: const Color(0xFFBA7517),
                  iconBg: const Color(0xFFFAEEDA),
                  label: 'Pincode',
                  value: p.pincode.isNotEmpty ? p.pincode : '—',
                ),
              ]),
            ),

            // ── Academic Details ─────────────────────────────
            _SectionHeader(title: 'Academic Details'),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: r.spacing(AppDimens.paddingLG)),
              child: _InfoCard(rows: [
                _InfoRowData(
                  icon: Icons.menu_book_outlined,
                  iconColor: const Color(0xFF534AB7),
                  iconBg: const Color(0xFFEEEDFE),
                  label: 'Program',
                  value: p.program.isNotEmpty ? p.program : '—',
                ),
              ]),
            ),

            // ── NEET Score ───────────────────────────────────
            _SectionHeader(title: 'NEET Score'),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: r.spacing(AppDimens.paddingLG)),
              child: _NeetCard(score: p.netScore),
            ),

            // ── Privacy note ─────────────────────────────────
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
      );
}

// ─────────────────────────────────────────────────────────────
// Saved Colleges Button
// ─────────────────────────────────────────────────────────────
class _SavedCollegesButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SavedCollegesButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Padding(
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
                  color: const Color(0xFFE8F5E9),
                  borderRadius:
                  BorderRadius.circular(AppDimens.radiusMD - 2),
                ),
                child: Icon(
                  Icons.bookmark_rounded,
                  size: r.fontSize(AppDimens.iconSM),
                  color: const Color(0xFF1D9E75),
                ),
              ),
              SizedBox(width: r.spacing(AppDimens.paddingMD)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Saved Colleges',
                      style: AppTextStyles.titleLarge
                          .copyWith(fontSize: r.fontSize(14)),
                    ),
                    SizedBox(height: r.spacing(2)),
                    Text(
                      'View your bookmarked colleges',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: r.fontSize(12),
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
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

// ─────────────────────────────────────────────────────────────
// Hero Banner
// ─────────────────────────────────────────────────────────────
class _ProfileHeroBanner extends StatelessWidget {
  final StudentProfileModel profile;
  const _ProfileHeroBanner({required this.profile});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final initials =
    '${profile.firstName.isNotEmpty ? profile.firstName[0] : ''}${profile.lastName.isNotEmpty ? profile.lastName[0] : ''}'
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
                    initials.isNotEmpty ? initials : '?',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
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
                        profile.fullName.isNotEmpty
                            ? profile.fullName
                            : 'Student',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: r.spacing(AppDimens.paddingXS)),
                      Text(
                        profile.email,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: r.spacing(AppDimens.paddingSM + 2)),
                      Wrap(
                        spacing: r.spacing(AppDimens.paddingXS + 2),
                        runSpacing: r.spacing(AppDimens.paddingXS + 2),
                        children: [
                          if (profile.gender.isNotEmpty)
                            _WhiteChip(
                              label: profile.gender,
                              icon: profile.gender.toLowerCase() == 'female'
                                  ? Icons.female_rounded
                                  : Icons.male_rounded,
                            ),
                          if (profile.district.isNotEmpty)
                            _WhiteChip(
                              label: profile.district,
                              icon: Icons.location_on_outlined,
                            ),
                          if (profile.state.isNotEmpty)
                            _WhiteChip(
                              label: profile.state,
                              icon: Icons.map_outlined,
                            ),
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
          Icon(icon,
              size: r.fontSize(AppDimens.iconXS - 2), color: Colors.white),
          SizedBox(width: r.spacing(AppDimens.paddingXS)),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Section Header
// ─────────────────────────────────────────────────────────────
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

// ─────────────────────────────────────────────────────────────
// Info Card
// ─────────────────────────────────────────────────────────────
class _InfoRowData {
  final IconData icon;
  final Color iconColor, iconBg;
  final String label, value;
  const _InfoRowData({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
  });
}

class _InfoCard extends StatelessWidget {
  final List<_InfoRowData> rows;
  const _InfoCard({required this.rows});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Container(
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
      child: Column(
        children: rows.asMap().entries.map((e) {
          final row = e.value;
          final isLast = e.key == rows.length - 1;
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
                          Text(
                            row.value,
                            style: AppTextStyles.titleLarge.copyWith(
                              fontSize: r.fontSize(14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Divider(
                  height: 1,
                  indent: r.spacing(AppDimens.paddingLG + AppDimens.avatarSM),
                  color: AppColors.borderLight,
                ),
            ],
          );
        }).toList(),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// NEET Score Card
// ─────────────────────────────────────────────────────────────
class _NeetCard extends StatelessWidget {
  final String score;
  const _NeetCard({required this.score});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final hasScore = score.isNotEmpty;

    return Container(
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
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(AppDimens.radiusLG),
              ),
              child: Container(
                width: r.value(mobile: 88.0, tablet: 104.0),
                color: const Color(0xFFE1F5EE),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.bar_chart_rounded,
                        color: Color(0xFF1D9E75), size: 28),
                    const SizedBox(height: 4),
                    Text(
                      'NEET',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: r.fontSize(11),
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0F6E56),
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
                        const SizedBox(height: 2),
                        Text(
                          hasScore ? score : '—',
                          style: TextStyle(
                            fontSize: r.fontSize(28),
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1D9E75),
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    if (hasScore)
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
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 14,
                              color: Color(0xFF3B6D11),
                            ),
                            SizedBox(width: r.spacing(AppDimens.paddingXS)),
                            Text(
                              'Recorded',
                              style: TextStyle(
                                fontSize: r.fontSize(11),
                                color: const Color(0xFF3B6D11),
                                fontWeight: FontWeight.w500,
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
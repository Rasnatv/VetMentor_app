import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../widgets/profileshimmer.dart';
import '../../Saved/view/SavedScreen.dart';
import '../../landingview/controller/landingcontroller.dart';
import '../controller/profilecontroller.dart';
import '../../../data/models/studentprofilemodel.dart';
import '../../Colleges/controller/enquirycontroller.dart';
import 'updateprofilescreen.dart';

const Color _kAccent = Color(0xFF1D9E75);
const Color _kAccentDark = Color(0xFF0F6E56);

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with AutomaticKeepAliveClientMixin {
  late final ProfileController ctrl;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    ctrl = Get.put(ProfileController());
    ever(Get.find<LandingController>().currentIndex, (index) {
      if (index == 4) ctrl.fetchProfile();
    });
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
                child: _EditProfilePill(
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
                ),
              );
            }),
          ],
        ),
        body: Obx(() {
          if (ctrl.isLoading) return const ProfileShimmer();
          if (ctrl.hasError) return _buildError(r, ctrl);
          if (ctrl.isSuccess && ctrl.profile.value != null) {
            return RefreshIndicator(
              color: _kAccent,
              onRefresh: () async => ctrl.fetchProfile(),
              child: _buildProfile(context, r, ctrl.profile.value!),
            );
          }
          return const SizedBox.shrink();
        }),
      ),
    );
  }

  // ── Error ──────────────────────────────────────────────────
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
          SizedBox(height: r.spacing(AppDimens.paddingLG)),
        ],
      ),
    ),
  );

  // ── Loaded profile ─────────────────────────────────────────
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
            // Hero Banner
            Padding(
              padding: EdgeInsets.fromLTRB(
                r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingLG),
                0,
              ),
              child: _ProfileHeroBanner(profile: p),
            ),

            // My Collections
            const _SectionHeader(title: 'My Collections'),
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

            // Contact Details
            const _SectionHeader(title: 'Contact Details'),
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
                  onTap: p.email.isNotEmpty
                      ? () => _copyToClipboard(context, p.email, 'Email')
                      : null,
                ),
                _InfoRowData(
                  icon: Icons.phone_outlined,
                  iconColor: const Color(0xFF0F6E56),
                  iconBg: const Color(0xFFE1F5EE),
                  label: 'Phone number',
                  value: p.phoneNo.isNotEmpty
                      ? '${p.countryCode} ${p.phoneNo}'
                      : '—',
                  onTap: p.phoneNo.isNotEmpty
                      ? () => _copyToClipboard(
                      context,
                      '${p.countryCode} ${p.phoneNo}',
                      'Phone number')
                      : null,
                ),
              ]),
            ),

            // Location Details
            const _SectionHeader(title: 'Location Details'),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: r.spacing(AppDimens.paddingLG)),
              child: _LocationCard(profile: p),
            ),

            // Academic Details
            const _SectionHeader(title: 'Academic Details'),
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

            // NEET Score
            const _SectionHeader(title: 'NEET Score'),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: r.spacing(AppDimens.paddingLG)),
              child: _NeetCard(score: p.netScore),
            ),

            // Privacy note
            Padding(
              padding: EdgeInsets.fromLTRB(
                r.spacing(AppDimens.paddingLG),
                r.spacing(AppDimens.paddingXL),
                r.spacing(AppDimens.paddingLG),
                0,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: r.spacing(AppDimens.paddingMD),
                  vertical: r.spacing(AppDimens.paddingSM + 2),
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6F1FB),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline_rounded,
                      size: r.fontSize(AppDimens.iconXS),
                      color: const Color(0xFF185FA5),
                    ),
                    SizedBox(width: r.spacing(AppDimens.paddingXS + 2)),
                    Expanded(
                      child: Text(
                        'Your information is safe and never shared with third parties.',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: r.fontSize(11.5),
                          color: const Color(0xFF185FA5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}

void _copyToClipboard(BuildContext context, String value, String label) {
  Clipboard.setData(ClipboardData(text: value));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: _kAccentDark,
      duration: const Duration(seconds: 2),
      content: Text('$label copied to clipboard'),
    ),
  );
}

class _EditProfilePill extends StatelessWidget {
  final VoidCallback onTap;
  const _EditProfilePill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: r.spacing(AppDimens.paddingMD),
            vertical: r.spacing(AppDimens.paddingXS + 2),
          ),
          decoration: BoxDecoration(
            color: AppColors.backgroundGrey,
            borderRadius: BorderRadius.circular(AppDimens.radiusFull),
            border: Border.all(color: AppColors.borderLight),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_outlined,
                  color: AppColors.textPrimary,
                  size: r.fontSize(AppDimens.iconXS)),
              SizedBox(width: r.spacing(AppDimens.paddingXS)),
              Text(
                'Edit',
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: r.fontSize(12),
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SavedCollegesButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SavedCollegesButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(AppDimens.radiusLG),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        child: Container(
          decoration: BoxDecoration(
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
                  child: Icon(Icons.bookmark_rounded,
                      size: r.fontSize(AppDimens.iconSM), color: _kAccent),
                ),
                SizedBox(width: r.spacing(AppDimens.paddingMD)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Saved Colleges',
                          style: AppTextStyles.titleLarge
                              .copyWith(fontSize: r.fontSize(14))),
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
                Icon(Icons.arrow_forward_ios_rounded,
                    size: r.fontSize(AppDimens.iconXS),
                    color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
class _ProfileHeroBanner extends StatelessWidget {
  final StudentProfileModel profile;
  const _ProfileHeroBanner({required this.profile});

  double get _completeness {
    final fields = <String>[
      profile.firstName, profile.lastName, profile.email,
      profile.phoneNo, profile.district, profile.state,
      profile.country, profile.address, profile.pincode,
      profile.program, profile.netScore, profile.gender,
    ];
    if (fields.isEmpty) return 0;
    return fields.where((f) => f.isNotEmpty).length / fields.length;
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final initials =
    '${profile.firstName.isNotEmpty ? profile.firstName[0] : ''}${profile.lastName.isNotEmpty ? profile.lastName[0] : ''}'
        .toUpperCase();
    final completeness = _completeness;
    final completenessPct = (completeness * 100).round();

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: AppColors.cardGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimens.radiusXL),
        boxShadow: [
          BoxShadow(
            color: _kAccent.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: -20, right: -20,
            child: Container(
              width: r.spacing(100), height: r.spacing(100),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Positioned(
            bottom: -30, right: 60,
            child: Container(
              width: r.spacing(80), height: r.spacing(80),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(r.spacing(AppDimens.paddingXL)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: r.spacing(64), height: r.spacing(64),
                          child: CircularProgressIndicator(
                            value: completeness == 0 ? null : completeness,
                            strokeWidth: 2.5,
                            backgroundColor: Colors.white.withOpacity(0.18),
                            valueColor:
                            const AlwaysStoppedAnimation(Colors.white),
                          ),
                        ),
                        CircleAvatar(
                          radius: r.spacing(27),
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
                      ],
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
                            overflow: TextOverflow.ellipsis,
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
                if (completenessPct < 100) ...[
                  SizedBox(height: r.spacing(AppDimens.paddingMD)),
                  Container(height: 1, color: Colors.white.withOpacity(0.15)),
                  SizedBox(height: r.spacing(AppDimens.paddingSM)),
                  Row(
                    children: [
                      Icon(Icons.info_outline_rounded,
                          size: r.fontSize(14),
                          color: Colors.white.withOpacity(0.85)),
                      SizedBox(width: r.spacing(AppDimens.paddingXS + 2)),
                      Expanded(
                        child: Text(
                          'Profile $completenessPct% complete',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
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
              color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

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
      child: Row(
        children: [
          Container(
            width: r.spacing(4), height: r.spacing(14),
            decoration: BoxDecoration(
              color: _kAccent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: r.spacing(AppDimens.paddingSM)),
          Text(
            title.toUpperCase(),
            style: AppTextStyles.titleLarge.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: r.fontSize(12.5),
              letterSpacing: 0.6,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Info Card (generic rows)
// ─────────────────────────────────────────────────────────────
class _InfoRowData {
  final IconData icon;
  final Color iconColor, iconBg;
  final String label, value;
  final VoidCallback? onTap;
  const _InfoRowData({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.label,
    required this.value,
    this.onTap,
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        child: Column(
          children: rows.asMap().entries.map((e) {
            final row = e.value;
            final isLast = e.key == rows.length - 1;
            final content = Padding(
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
                        Text(row.label,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: r.fontSize(12),
                              color: AppColors.textSecondary,
                            )),
                        SizedBox(height: r.spacing(2)),
                        Text(row.value,
                            style: AppTextStyles.titleLarge
                                .copyWith(fontSize: r.fontSize(14))),
                      ],
                    ),
                  ),
                  if (row.onTap != null)
                    Icon(Icons.copy_rounded,
                        size: r.fontSize(15),
                        color: AppColors.textSecondary.withOpacity(0.6)),
                ],
              ),
            );
            return Column(
              children: [
                row.onTap != null
                    ? InkWell(onTap: row.onTap, child: content)
                    : content,
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: r.spacing(
                        AppDimens.paddingLG + AppDimens.avatarSM),
                    color: AppColors.borderLight,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final StudentProfileModel profile;
  const _LocationCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    final rows = <_InfoRowData>[
      _InfoRowData(
        icon: Icons.public_outlined,
        iconColor: const Color(0xFF0F6E56),
        iconBg: const Color(0xFFE1F5EE),
        label: 'Country',
        value: profile.country.isNotEmpty ? profile.country : '—',
      ),
      _InfoRowData(
        icon: Icons.map_outlined,
        iconColor: const Color(0xFF993C1D),
        iconBg: const Color(0xFFFAECE7),
        label: 'State',
        value: profile.state.isNotEmpty ? profile.state : '—',
      ),
      _InfoRowData(
        icon: Icons.location_city_outlined,
        iconColor: const Color(0xFF534AB7),
        iconBg: const Color(0xFFEEEDFE),
        label: 'District',
        value: profile.district.isNotEmpty ? profile.district : '—',
      ),
      _InfoRowData(
        icon: Icons.home_outlined,
        iconColor: const Color(0xFF185FA5),
        iconBg: const Color(0xFFE6F1FB),
        label: 'Address',
        value: profile.address.isNotEmpty ? profile.address : '—',
      ),
      _InfoRowData(
        icon: Icons.pin_drop_outlined,
        iconColor: const Color(0xFFBA7517),
        iconBg: const Color(0xFFFAEEDA),
        label: 'Pincode',
        value: profile.pincode.isNotEmpty ? profile.pincode : '—',
      ),
    ];

    // breadcrumb parts
    final breadcrumb = <String>[
      if (profile.country.isNotEmpty) profile.country,
      if (profile.state.isNotEmpty) profile.state,
      if (profile.district.isNotEmpty) profile.district,
    ];

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── breadcrumb header ──────────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: r.spacing(AppDimens.paddingLG),
                vertical: r.spacing(AppDimens.paddingMD),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FBF6),
                border: Border(
                  bottom: BorderSide(color: AppColors.borderLight),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: r.spacing(32),
                    height: r.spacing(32),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1F5EE),
                      borderRadius:
                      BorderRadius.circular(AppDimens.radiusMD - 2),
                    ),
                    child: const Icon(Icons.location_on_rounded,
                        color: Color(0xFF1D9E75), size: 18),
                  ),
                  SizedBox(width: r.spacing(AppDimens.paddingSM + 2)),
                  Expanded(
                    child: breadcrumb.isEmpty
                        ? Text('Location not set',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: r.fontSize(12),
                          color: AppColors.textSecondary,
                        ))
                        : Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 2,
                      children: [
                        for (int i = 0; i < breadcrumb.length; i++) ...[
                          Text(
                            breadcrumb[i],
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: r.fontSize(12.5),
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0F6E56),
                            ),
                          ),
                          if (i < breadcrumb.length - 1)
                            Icon(
                              Icons.chevron_right_rounded,
                              size: r.fontSize(14),
                              color: const Color(0xFF0F6E56)
                                  .withOpacity(0.45),
                            ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── rows ──────────────────────────────────────
            ...rows.asMap().entries.map((e) {
              final row = e.value;
              final isLast = e.key == rows.length - 1;
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.spacing(AppDimens.paddingLG),
                      vertical: r.spacing(AppDimens.paddingMD + 1),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                              Text(row.label,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: r.fontSize(11.5),
                                    color: AppColors.textSecondary,
                                  )),
                              SizedBox(height: r.spacing(2)),
                              Text(row.value,
                                  style: AppTextStyles.titleLarge.copyWith(
                                    fontSize: r.fontSize(14),
                                    height: 1.4,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: r.spacing(
                          AppDimens.paddingLG + AppDimens.avatarSM),
                      color: AppColors.borderLight,
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _NeetCard extends StatelessWidget {
  final String score;
  const _NeetCard({required this.score});

  static const double _maxScore = 720;

  double? get _numericScore {
    final cleaned = score.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleaned.isEmpty) return null;
    return double.tryParse(cleaned);
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final hasScore = score.isNotEmpty;
    final numeric = _numericScore;
    final progress =
    numeric == null ? 0.0 : (numeric / _maxScore).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimens.radiusLG),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD + 2)),
        child: Row(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: r.value(mobile: 64.0, tablet: 76.0),
                  height: r.value(mobile: 64.0, tablet: 76.0),
                  child: CircularProgressIndicator(
                    value: numeric == null ? 0 : progress,
                    strokeWidth: 6,
                    backgroundColor: const Color(0xFFE1F5EE),
                    valueColor: const AlwaysStoppedAnimation(_kAccent),
                  ),
                ),
                Icon(Icons.bar_chart_rounded,
                    color: _kAccent, size: r.fontSize(AppDimens.iconSM)),
              ],
            ),
            SizedBox(width: r.spacing(AppDimens.paddingMD + 2)),
            Expanded(
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('NEET Score',
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: r.fontSize(12),
                            color: AppColors.textSecondary,
                          )),
                      const SizedBox(height: 2),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            hasScore ? score : '—',
                            style: TextStyle(
                              fontSize: r.fontSize(26),
                              fontWeight: FontWeight.w700,
                              color: _kAccent,
                              height: 1.1,
                            ),
                          ),
                          if (numeric != null) ...[
                            SizedBox(width: r.spacing(4)),
                            Text('/ 720',
                                style: TextStyle(
                                  fontSize: r.fontSize(13),
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                )),
                          ],
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),

      ]))],
        ),
      ),
    );
  }
}
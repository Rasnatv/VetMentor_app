
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:veterinaryapp/app/widgets/appsnackbar.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/whishlistmodel.dart';
import '../../Colleges/controller/enquirycontroller.dart';
import '../../Colleges/view/collegedtailscreen.dart';
import '../../home/bindings/home_binding.dart';
import '../controller/whishlist_controller.dart';

class WishlistScreen extends StatefulWidget {
  final int studentId;
  const WishlistScreen({super.key, required this.studentId});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen>
    with AutomaticKeepAliveClientMixin {

  late final WishlistController ctrl;

  @override
  bool get wantKeepAlive => false;

  @override
  void initState() {
    super.initState();
    ctrl = Get.isRegistered<WishlistController>()
        ? Get.find<WishlistController>()
        : Get.put(WishlistController());
    ctrl.fetchWishlist(widget.studentId);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final Responsive r = Responsive.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundGrey,
      appBar: VetAppBar(title: 'Saved Colleges', showBack: true),
      body: Obx(() {
        if (ctrl.isFetching.value) return _buildLoading();
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => ctrl.fetchWishlist(widget.studentId),
          child: ctrl.wishlist.isEmpty ? _buildEmpty(r) : _buildContent(r),
        );
      }),
    );
  }

  Widget _buildLoading() => const Center(
    child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
  );

  Widget _buildEmpty(Responsive r) => ListView(
    children: [
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(r.spacing(AppDimens.paddingXL)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset(
                  'assets/lottie/Search File.json',
                  width: r.value(mobile: 180.0, tablet: 220.0),
                  height: r.value(mobile: 180.0, tablet: 220.0),
                  fit: BoxFit.contain,
                  repeat: true,
                ),
                SizedBox(height: r.spacing(AppDimens.paddingMD)),
                Text(
                  'No saved colleges yet',
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: r.fontSize(15),
                  ),
                ),
                SizedBox(height: r.spacing(AppDimens.paddingXS)),
                Text(
                  'Colleges you bookmark while browsing\nwill appear here.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: r.fontSize(13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );

  Widget _buildContent(Responsive r) => SingleChildScrollView(
    physics: const AlwaysScrollableScrollPhysics(),
    padding: const EdgeInsets.only(bottom: 100),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: r.spacing(AppDimens.paddingLG)),
          child: Column(
            children: ctrl.wishlist
                .map((college) => _SavedCollegeCard(
              college: college,
              studentId: widget.studentId,
              ctrl: ctrl,
            ))
                .toList(),
          ),
        ),
      ],
    ),
  );
}

class _SavedCollegeCard extends StatelessWidget {
  final WishlistCollege college;
  final int studentId;
  final WishlistController ctrl;

  const _SavedCollegeCard({
    required this.college,
    required this.studentId,
    required this.ctrl,
  });

  void _onCardTap() {
    final isRegistered = Get.isRegistered<EnquiryController>()
        ? Get.find<EnquiryController>().isAlreadyRegistered
        : false;

    if (!isRegistered) {
      AppSnackbar.warning('Please complete the enquiry form to view college details.');
      return;
    }

    Get.to(
          () => CollegeDetailScreen(
        collegeId: college.collegeId,
        showBookmark: false,
      ),
      binding: CollegeDetailBinding(), // ✅ only this line added
      transition: Transition.rightToLeft,
    );
  }
  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return GestureDetector(
      onTap: _onCardTap,
      child: Container(
        margin: EdgeInsets.only(bottom: r.spacing(AppDimens.paddingSM + 4)),
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
          padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD + 1)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CollegeAvatar(name: college.collegeName, size: 48),
              SizedBox(width: r.spacing(AppDimens.paddingMD)),

              // ── Name + Location ──────────────────────────
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      college.collegeName,
                      style: AppTextStyles.titleLarge.copyWith(
                          fontSize: r.fontSize(14)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: r.spacing(4)),
                    if (college.location.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 13, color: AppColors.textSecondary),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              college.location,
                              style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: r.fontSize(12)),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              SizedBox(width: r.spacing(AppDimens.paddingSM)),

              // ── Remove Button ────────────────────────────
              Obx(() {
                final busy = ctrl.isLoading(college.collegeId);
                return GestureDetector(
                  // Absorb tap so it doesn't bubble up to card's onTap
                  onTap: busy
                      ? null
                      : () async {
                    final confirmed = await _confirmRemove(
                        context, college.collegeName);
                    if (confirmed) {
                      ctrl.removeFromWishlist(studentId, college.collegeId);
                    }
                  },
                  child: Container(
                    width: r.spacing(AppDimens.avatarSM),
                    height: r.spacing(AppDimens.avatarSM),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF0F0),
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                      border: Border.all(color: const Color(0xFFFFCDD2)),
                    ),
                    child: busy
                        ? const Padding(
                      padding: EdgeInsets.all(8),
                      child: CircularProgressIndicator(
                        strokeWidth: 1.8,
                        color: Color(0xFFE53935),
                      ),
                    )
                        : const Icon(Icons.bookmark_remove_outlined,
                        size: 18, color: Color(0xFFE53935)),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _confirmRemove(BuildContext context, String name) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _RemoveConfirmSheet(collegeName: name),
    );
    return result ?? false;
  }
}

// ── Remove Confirmation Bottom Sheet ──────────────────────────
class _RemoveConfirmSheet extends StatelessWidget {
  final String collegeName;
  const _RemoveConfirmSheet({required this.collegeName});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingXL),
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingXL),
        r.spacing(AppDimens.paddingXL) + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(AppDimens.radiusXL)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36, height: 4,
            decoration: BoxDecoration(
              color: AppColors.borderLight,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingLG)),
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFFFF0F0),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFCDD2)),
            ),
            child: const Icon(Icons.bookmark_remove_rounded,
                color: Color(0xFFE53935), size: 26),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingMD)),
          Text(
            'Remove from Saved?',
            style: AppTextStyles.titleSmall.copyWith(
                fontWeight: FontWeight.w600, fontSize: r.fontSize(16)),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingXS + 2)),
          Text(
            collegeName,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary, fontSize: r.fontSize(13)),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: r.spacing(AppDimens.paddingXL)),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                        vertical: r.spacing(AppDimens.paddingMD)),
                    side: const BorderSide(color: AppColors.borderLight),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusMD)),
                  ),
                  child: Text('Cancel',
                      style: AppTextStyles.bodySmall.copyWith(
                          fontSize: r.fontSize(14),
                          fontWeight: FontWeight.w500,
                          color: AppColors.textPrimary)),
                ),
              ),
              SizedBox(width: r.spacing(AppDimens.paddingMD)),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.textGreen,
                    padding: EdgeInsets.symmetric(
                        vertical: r.spacing(AppDimens.paddingMD)),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppDimens.radiusMD)),
                  ),
                  child: Text('Remove',
                      style: AppTextStyles.bodySmall.copyWith(
                          fontSize: r.fontSize(14),
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
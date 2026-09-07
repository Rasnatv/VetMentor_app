

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../controller/astraaddcontroller.dart';

/// Advertisement carousel meant to sit directly ABOVE the bottom
/// navigation bar. Rotates through multiple ads with dot indicators,
/// mirrors the _AdCarousel reference style but wired to GetX/AdController.
///
/// Renders nothing at all if there's no ad to show or the user has
/// already closed it — so it never reserves empty space.
class BottomAdBanner extends StatefulWidget {
  const BottomAdBanner({super.key});

  @override
  State<BottomAdBanner> createState() => _BottomAdBannerState();
}

class _BottomAdBannerState extends State<BottomAdBanner> {
  int _currentPage = 0;

  static Future<void> _openLink(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  static void _showAdDetail(BuildContext context, dynamic ad) {
    final String coverImage =
    (ad.poster != null && ad.poster.toString().isNotEmpty)
        ? ad.poster.toString()
        : ad.image.toString();

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Cover image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width - 72,
                          maxHeight: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: Image.network(
                          coverImage,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => AspectRatio(
                            aspectRatio: 13 / 5,
                            child: Container(
                              color: AppColors.cardBackground,
                              alignment: Alignment.center,
                              child: const Icon(Icons.broken_image_outlined),
                            ),
                          ),
                          loadingBuilder: (context, child, progress) {
                            if (progress == null) return child;
                            return AspectRatio(
                              aspectRatio: 13 / 5,
                              child: Container(
                                color: AppColors.cardBackground,
                                alignment: Alignment.center,
                                child: const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    if (ad.link.toString().isNotEmpty) ...[
                      const SizedBox(height: 20),
                      const Text(
                        'Open this link?',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'You will be redirected to an external website.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.link, size: 18, color: Colors.blue),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                ad.link.toString(),
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(dialogContext).pop();
                            _openLink(ad.link);
                          },
                          icon: const Icon(Icons.open_in_new, size: 18),
                          label: const Text(
                            'Open link',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

        ]));
      },
    );
  }
  Widget _buildAdItem(BuildContext context, dynamic ad, double height, double width) {
    return GestureDetector(
      onTap: () => _showAdDetail(context, ad),
      child: Image.network(
        ad.image,
        fit: BoxFit.fill,               // was BoxFit.cover
        width: width,
        height: height,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            width: width,
            height: height,
            color: AppColors.cardBackground,
            alignment: Alignment.center,
            child: const SizedBox(
              width: 20,                // was 22, reference uses 20
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => Container(
          width: width,
          height: height,
          color: AppColors.cardBackground,
          alignment: Alignment.center,
          child: const Icon(Icons.image_not_supported_rounded),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AdController adCtrl = Get.find<AdController>();
    final r = Responsive.of(context);

    return Obx(() {
      if (!adCtrl.hasAd) return const SizedBox.shrink();

      final ads = adCtrl.ads;


      return Container(
        height: 100,
        margin: const EdgeInsets.fromLTRB(16, 10, 16, 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 8),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              ads.length > 1
                  ? CarouselSlider.builder(
                itemCount: ads.length,
                itemBuilder: (context, index, realIndex) =>
                    _buildAdItem(context, ads[index], 100,double.infinity),
                options: CarouselOptions(
                  height: 100,
                  viewportFraction: 1,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 700),
                  autoPlayCurve: Curves.easeInOut,
                  enlargeCenterPage: false,
                  enableInfiniteScroll: true,
                  onPageChanged: (index, reason) {
                    setState(() => _currentPage = index);
                  },
                ),
              )
                  : _buildAdItem(context, ads.first, 100,double.infinity),

              // dot indicators + close button stay here (see #2 and #3 below)


                  // Dot indicators — only when there's more than one ad.if (ads.length > 1)
                    Positioned(
                      bottom: r.spacing(8),
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          ads.length,
                              (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 3),
                            width: _currentPage == index ? 18 : 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? Colors.white
                                  : Colors.white54,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Close button.
                  Positioned(
                    top: r.spacing(6),
                    right: r.spacing(6),
                    child: GestureDetector(
                      onTap: adCtrl.dismissAd,
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: EdgeInsets.all(r.spacing(4)),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.55),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: r.fontSize(15),
                        ),
                      ),
                    ),
                  ),


            ])));
          },


    );
  }
}

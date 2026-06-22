import 'package:flutter/material.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import '../../core/constants/appcolors.dart';
import '../../core/style/dimens.dart';
import '../../core/style/textstyle.dart';
import '../../core/utils/responsive utiliteclass.dart';
import '../../widgets/commonwidget.dart';


class CareerPath {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;

  const CareerPath({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class CareerData {
  static const List<CareerPath> paths = [
    CareerPath(
      id: '1',
      title: 'Govt Vet Officer / LDO',
      subtitle: 'State PSC · ₹50,000–80,000/mo',
      icon: Icons.account_balance_outlined,
    ),
    CareerPath(
      id: '2',
      title: 'Private Pet Practice',
      subtitle: 'Clinics & Hospitals · ₹40,000–1L/mo',
      icon: Icons.favorite_border_rounded,
    ),
    CareerPath(
      id: '3',
      title: 'Dairy, Poultry & Food Safety',
      subtitle: 'Industry & Pharma · FSSAI roles',
      icon: Icons.factory_outlined,
    ),
    CareerPath(
      id: '4',
      title: 'Wildlife, Zoo & Animal Welfare',
      subtitle: 'NGOs · Conservation organisations',
      icon: Icons.park_outlined,
    ),
    CareerPath(
      id: '5',
      title: 'Research / M.V.Sc / PhD',
      subtitle: 'ICAR, Universities · Stipend + growth',
      icon: Icons.science_outlined,
    ),
    CareerPath(
      id: '6',
      title: 'UPSC IFS / ICAR / State PSC',
      subtitle: 'Civil services · Govt research roles',
      icon: Icons.workspace_premium_outlined,
    ),
    CareerPath(
      id: '7',
      title: 'Startups in Pet Care & Tech',
      subtitle: 'Nutrition, health tech · Equity growth',
      icon: Icons.rocket_launch_outlined,
    ),
    CareerPath(
      id: '8',
      title: 'USA/Canada — NAVLE / ECFVG',
      subtitle: 'International licensing path',
      icon: Icons.public_outlined,
    ),
  ];

}


class CareersScreen extends StatelessWidget {
  const CareersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: VetAppBar(
          showBack: false,
          title: 'Career Roadmap',
        ),
        body: ListView(
          padding: EdgeInsets.fromLTRB(
            r.spacing(AppDimens.paddingLG),
            r.spacing(AppDimens.paddingMD),
            r.spacing(AppDimens.paddingLG),
            100,
          ),
          children: [
            // ── Subtitle ────────────────────────────────────────────────
            Text(
              'After B.V.Sc & A.H — what\'s next?',
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: r.fontSize(13),
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: r.spacing(AppDimens.paddingMD)),

            // ── Career cards ─────────────────────────────────────────────
            ...CareerData.paths.map((path) => _CareerCard(
              r: r,
              path: path, onTap: () {  },

              ),
            ),

            SizedBox(height: r.spacing(AppDimens.paddingLG)),

          ],
        ),
      ),
    );
  }
}


class _CareerCard extends StatelessWidget {
  final Responsive r;
  final CareerPath path;
  final VoidCallback onTap;

  const _CareerCard({
    required this.r,
    required this.path,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: r.spacing(AppDimens.paddingSM + 2)),
        padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
        decoration: BoxDecoration(
          color: AppColors.backgroundWhite,
          borderRadius: BorderRadius.circular(AppDimens.radiusLG),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // icon
            Container(
              width: r.spacing(44),
              height: r.spacing(44),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(AppDimens.radiusMD),
              ),
              child: Icon(
                path.icon,
                size: r.fontSize(AppDimens.iconSM + 2),
                color: AppColors.primary,
              ),
            ),
            SizedBox(width: r.spacing(AppDimens.paddingMD)),
            // text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    path.title,
                    style:  AppTextStyles.titleLarge,
                  ),
                  SizedBox(height: r.spacing(AppDimens.paddingXS - 2)),
                  Text(
                    path.subtitle,
                     style: AppTextStyles.bodySmall
            ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}


class CareerDetailScreen extends StatelessWidget {
  final CareerPath path;

  const CareerDetailScreen({super.key, required this.path});

  static const Map<String, String> _descriptions = {
    '1':
    'Veterinary Officers under State PSC manage livestock health, disease surveillance, and public health at government hospitals and dispensaries. Roles include Livestock Development Officer (LDO), Veterinary Assistant Surgeon, and Animal Husbandry Officer.',
    '2':
    'Set up or join small-animal clinics, multi-specialty hospitals, or mobile vet services. Growing pet ownership in India drives strong demand for companion-animal practitioners, dermatologists, and surgeons.',
    '3':
    'Roles in quality control, food safety inspections, and R&D at dairy cooperatives, poultry integrators, feed manufacturers, and veterinary pharma companies. FSSAI and APEDA offer regulatory career tracks.',
    '4':
    'Work with the Forest Department, Central Zoo Authority, WWF, WCS, TRAFFIC, or international NGOs on wildlife health, population management, and one-health initiatives.',
    '5':
    'Pursue M.V.Sc or PhD at ICAR universities (IVRI, TANUVAS, KVAFSU). JRF and SRF fellowships fund your studies. A doctorate opens teaching, research, and policy careers.',
    '6':
    'Crack UPSC IFS for Indian Forest Service or appear for ICAR ARS/NET for agricultural research. State PSC combined competitive exams also recruit veterinarians for senior government positions.',
    '7':
    'Join or launch startups in telemedicine, pet nutrition, veterinary diagnostics, insect protein, or precision livestock farming. Venture capital interest in animal health tech is growing rapidly in India.',
    '8':
    'Graduate from an AVMA-accredited program equivalent or clear ECFVG/PAVE to qualify for NAVLE. Work authorization pathways include H-1B, TN visa (Canada/Mexico), and skilled-worker visas for the UK and Australia.',
  };

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final description = _descriptions[path.id] ?? 'More details coming soon.';

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: VetAppBar(
          showBack: true,
          title: 'Career Detail',
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(r.spacing(AppDimens.paddingLG)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(r.spacing(AppDimens.paddingLG)),
                decoration: BoxDecoration(
                  color: AppColors.primarySurface,
                  borderRadius: BorderRadius.circular(AppDimens.radiusLG),
                  border: Border.all(
                    color: AppColors.primary.withOpacity(0.25),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: r.spacing(52),
                      height: r.spacing(52),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                      ),
                      child: Icon(
                        path.icon,
                        size: r.fontSize(AppDimens.iconMD),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: r.spacing(AppDimens.paddingMD)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            path.title,
                            style: AppTextStyles.headlineMedium.copyWith(
                              fontSize: r.fontSize(15),
                            ),
                          ),
                          SizedBox(height: r.spacing(AppDimens.paddingXS - 1)),
                          Text(
                            path.subtitle,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: r.fontSize(12),
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: r.spacing(AppDimens.paddingLG)),

              // Description heading
              Text(
                'About this career',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontSize: r.fontSize(14),
                ),
              ),
              SizedBox(height: r.spacing(AppDimens.paddingSM)),
              Text(
                description,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: r.fontSize(13),
                  height: 1.6,
                  color: AppColors.textSecondary,
                ),
              ),

              SizedBox(height: r.spacing(AppDimens.paddingXL)),

              // Connect CTA
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: navigate to mentors screen
                  },
                  icon: Icon(
                    Icons.people_outline_rounded,
                    size: r.fontSize(AppDimens.iconXS + 2),
                  ),
                  label: Text(
                    'Connect with a Mentor',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontSize: r.fontSize(13),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(
                      vertical: r.spacing(AppDimens.paddingMD),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

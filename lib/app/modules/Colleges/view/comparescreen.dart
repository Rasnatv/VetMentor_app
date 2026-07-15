// features/Compare/view/compare_colleges_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../Colleges/controller/college_controller.dart' show CollegeDetailBinding;
import '../../Colleges/view/collegedtailscreen.dart';
import '../../home/bindings/home_binding.dart';
import '../controller/comparecontroller.dart';


class CompareCollegesScreen extends StatelessWidget {
  const CompareCollegesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CompareController>();
    final r = context.responsive;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VetAppBar(title: 'Compare Colleges'),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (ctrl.hasError.value) {
          return Center(child: Text(ctrl.errorMessage.value));
        }
        if (ctrl.colleges.isEmpty) {
          return const Center(child: Text('No colleges to compare'));
        }

        return SingleChildScrollView(
          padding: r.pagePadding,
          child: Column(
            children: [
              _buildHeaderCards(context, ctrl),
              SizedBox(height: r.spacing(16)),
              _buildComparisonTable(context, ctrl),
              SizedBox(height: r.spacing(16)),
              _buildDetailButtons(context, ctrl),
              SizedBox(height: r.spacing(30)),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCards(BuildContext context, CompareController ctrl) {
    final r = context.responsive;
    final count = ctrl.colleges.length;

    // If more than 2 colleges on a small phone, let the row scroll
    // horizontally instead of squeezing cards until text overflows.
    final needsScroll = r.isMobile && count > 2;

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ctrl.colleges
          .asMap()
          .entries
          .map((entry) => needsScroll
          ? SizedBox(
        width: r.wp(42), // fixed card width when scrollable
        child: _headerCard(context, ctrl, entry.key + 1, entry.value),
      )
          : Expanded(
        child: _headerCard(context, ctrl, entry.key + 1, entry.value),
      ))
          .toList(),
    );

    return Container(
      padding: r.cardPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          needsScroll
              ? SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: row,
          )
              : row,
          Container(
            width: r.isMobile ? 32 : 40,
            height: r.isMobile ? 32 : 40,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                'VS',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: r.fontSize(11),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCard(
      BuildContext context, CompareController ctrl, int index, college) {
    final r = context.responsive;
    final imageHeight = r.value(mobile: 90.0, tablet: 110.0, desktop: 130.0);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.spacing(6)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  college.logo,
                  height: imageHeight,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: imageHeight,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.school),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                left: 4,
                child: CircleAvatar(
                  radius: r.isMobile ? 11 : 13,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    '$index',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: r.fontSize(11),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => ctrl.removeCollege(college.id),
                  child: CircleAvatar(
                    radius: r.isMobile ? 11 : 13,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.close, size: 13, color: Colors.black54),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: r.spacing(6)),
          // College name: maxLines 3 so longer names aren't cut off,
          // with a slightly reduced, responsive font size.
          Text(
            college.collegeName,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: r.fontSize(12.5),
              height: 1.2,
            ),
          ),
          SizedBox(height: r.spacing(2)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on, size: r.fontSize(12), color: Colors.grey),
              const SizedBox(width: 2),
              Expanded(
                child: Text(
                  college.location,
                  maxLines: 2,
                  style: TextStyle(fontSize: r.fontSize(11), color: Colors.grey),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: r.spacing(2)),
          Row(
            children: [
              Icon(Icons.star, size: r.fontSize(13), color: Colors.amber),
              const SizedBox(width: 2),
              Text(college.rating, style: TextStyle(fontSize: r.fontSize(12))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable(BuildContext context, CompareController ctrl) {
    final r = context.responsive;
    final c = ctrl.colleges;
    final rows = <_CompareRow>[
      _CompareRow('Years', Icons.timeline, c.map((e) => e.years).toList()),
      _CompareRow('Faculty', Icons.person, c.map((e) => e.faculty).toList()),
      _CompareRow('Students', Icons.groups, c.map((e) => e.students).toList()),
      _CompareRow('Affiliation', Icons.verified,
          c.map((e) => e.affiliationType).toList()),
      _CompareRow('Facilities', Icons.apartment,
          c.map((e) => e.facilities.join(', ')).toList()),
      _CompareRow(
          'Courses', Icons.menu_book, c.map((e) => e.courses.join(', ')).toList()),
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: rows
            .map((row) => Container(
          padding: EdgeInsets.symmetric(
            vertical: r.spacing(12),
            horizontal: r.spacing(12),
          ),
          decoration: const BoxDecoration(
            border:
            Border(bottom: BorderSide(color: Color(0xFFEFEFEF))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(row.icon,
                      size: r.fontSize(16), color: AppColors.primary),
                  SizedBox(width: r.spacing(6)),
                  Text(
                    row.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: r.fontSize(13),
                    ),
                  ),
                ],
              ),
              SizedBox(height: r.spacing(6)),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: row.values
                    .map((v) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: r.spacing(4)),
                    child: Text(
                      v.isEmpty ? '-' : v,
                      style: TextStyle(fontSize: r.fontSize(12)),
                    ),
                  ),
                ))
                    .toList(),
              ),
            ],
          ),
        ))
            .toList(),
      ),
    );
  }

  Widget _buildDetailButtons(BuildContext context, CompareController ctrl) {
    final r = context.responsive;

    return Row(
      children: ctrl.colleges
          .map((college) => Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: r.spacing(4)),
          child: OutlinedButton(
            onPressed: () {
              Get.to(
                    () => CollegeDetailScreen(collegeId: college.id),
                binding: CollegeDetailBinding(),
                transition: Transition.rightToLeft,
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primary),
              padding: EdgeInsets.symmetric(
                vertical: r.spacing(10),
              ),
            ),
            child: Text(
              'View Details',
              style: TextStyle(fontSize: r.fontSize(13)),
            ),
          ),
        ),
      ))
          .toList(),
    );
  }
}

class _CompareRow {
  final String label;
  final IconData icon;
  final List<String> values;
  _CompareRow(this.label, this.icon, this.values);
}
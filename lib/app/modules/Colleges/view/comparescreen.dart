// features/Compare/view/compare_colleges_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';
import '../../../core/constants/appcolors.dart';
import '../../Colleges/controller/college_controller.dart' show CollegeDetailBinding;
import '../../Colleges/view/collegedtailscreen.dart';
import '../../home/bindings/home_binding.dart';
import '../controller/comparecontroller.dart';

class CompareCollegesScreen extends StatelessWidget {
  const CompareCollegesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<CompareController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: VetAppBar(title: 'Compare Colleges',),

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
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildHeaderCards(ctrl),
              const SizedBox(height: 16),
              _buildComparisonTable(ctrl),
              const SizedBox(height: 16),
              _buildDetailButtons(ctrl),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeaderCards(CompareController ctrl) {
    return Container(
      padding: const EdgeInsets.all(12),
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
          Row(
            children: ctrl.colleges
                .asMap()
                .entries
                .map((entry) => Expanded(
              child: _headerCard(ctrl, entry.key + 1, entry.value),
            ))
                .toList(),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('VS',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerCard(CompareController ctrl, int index, college) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  college.logo,
                  height: 90,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 90,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.school),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                left: 4,
                child: CircleAvatar(
                  radius: 11,
                  backgroundColor: AppColors.primary,
                  child: Text('$index',
                      style: const TextStyle(
                          color: Colors.white, fontSize: 11)),
                ),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: GestureDetector(
                  onTap: () => ctrl.removeCollege(college.id), // ✅ String
                  child: const CircleAvatar(
                    radius: 11,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, size: 13, color: Colors.black54),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            college.collegeName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.location_on, size: 12, color: Colors.grey),
              Expanded(
                child: Text(college.location,
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                    overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(Icons.star, size: 13, color: Colors.amber),
              const SizedBox(width: 2),
              Text(college.rating, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonTable(CompareController ctrl) {
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
          padding:
          const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Color(0xFFEFEFEF))),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(row.icon, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(row.label,
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: row.values
                    .map((v) => Expanded(
                  child: Text(
                    v.isEmpty ? '-' : v,
                    style: const TextStyle(fontSize: 12),
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

  Widget _buildDetailButtons(CompareController ctrl) {
    return Row(
      children: ctrl.colleges
          .map((college) => Expanded(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: OutlinedButton(
            onPressed: () {
              Get.to(
                    () => CollegeDetailScreen(collegeId: college.id), // ✅ String
                binding: CollegeDetailBinding(),
                transition: Transition.rightToLeft,
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppColors.primary),
            ),
            child: const Text('View Details'),
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
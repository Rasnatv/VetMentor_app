// import 'package:flutter/material.dart';
//
// import '../../../core/constants/appcolors.dart';
// import '../../../core/style/dimens.dart';
// import '../../../core/style/textstyle.dart';
// import '../../../core/utils/responsive utiliteclass.dart';
// import '../../../data/models/modelclass.dart';
// import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
// import '../../../widgets/commonwidget.dart';
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Screen
// // ─────────────────────────────────────────────────────────────────────────────
//
// class CollegesListScreen extends StatefulWidget {
//   /// The course whose offering colleges are being listed.
//   final Course course;
//
//   /// All colleges that offer [course].
//   final List<College> colleges;
//
//   const CollegesListScreen({
//     super.key,
//     required this.course,
//     required this.colleges,
//   });
//
//   @override
//   State<CollegesListScreen> createState() => _CollegesListScreenState();
// }
//
// class _CollegesListScreenState extends State<CollegesListScreen> {
//   String _selectedState = 'All';
//   final _searchController = TextEditingController();
//   String _searchQuery = '';
//
//   // ── Derived data ────────────────────────────────────────────────────────────
//
//   List<String> get _stateFilters {
//     final states = widget.colleges.map((c) => c.state).toSet().toList()
//       ..sort();
//     return ['All', ...states];
//   }
//
//   List<College> get _filtered {
//     List<College> list = widget.colleges;
//     if (_selectedState != 'All') {
//       list = list.where((c) => c.state == _selectedState).toList();
//     }
//     if (_searchQuery.isNotEmpty) {
//       final q = _searchQuery.toLowerCase();
//       list = list
//           .where((c) =>
//       c.name.toLowerCase().contains(q) ||
//           c.state.toLowerCase().contains(q) ||
//           c.location.toLowerCase().contains(q))
//           .toList();
//     }
//     return list;
//   }
//
//   /// Sum of intake seats across all colleges for this course.
//   int get _totalSeats {
//     return widget.colleges.fold(0, (sum, college) {
//       final intake = college.allCourses
//           .where((c) => c.id == widget.course.id)
//           .fold(0, (s, c) => s + c.intake);
//       return sum + intake;
//     });
//   }
//
//   // ── Level helpers ────────────────────────────────────────────────────────────
//
//   static const _levelColors = {
//     'UG': Color(0xFF1B5E20),
//     'PG': Color(0xFF1565C0),
//     'Diploma': Color(0xFF6A1B9A),
//     'PhD': Color(0xFFE65100),
//   };
//
//   static const _levelIcons = {
//     'UG': Icons.school_rounded,
//     'PG': Icons.auto_stories_rounded,
//     'Diploma': Icons.workspace_premium_rounded,
//     'PhD': Icons.psychology_rounded,
//   };
//
//   Color get _levelColor =>
//       _levelColors[widget.course.level] ?? AppColors.primary;
//
//   IconData get _levelIcon =>
//       _levelIcons[widget.course.level] ?? Icons.school_rounded;
//
//   // ── Lifecycle ────────────────────────────────────────────────────────────────
//
//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }
//
//   // ── Build ────────────────────────────────────────────────────────────────────
//
//   @override
//   Widget build(BuildContext context) {
//     final r = Responsive.of(context);
//     final filtered = _filtered;
//
//     return NetworkAwareWrapper(
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//         appBar: VetAppBar(title: 'Colleges Offering'),
//         body: Column(
//           children: [
//             // Course hero banner
//             _CourseHeroBanner(
//               course: widget.course,
//               totalSeats: _totalSeats,
//               levelColor: _levelColor,
//               levelIcon: _levelIcon,
//             ),
//
//             // Search bar
//             _SearchBar(
//               controller: _searchController,
//               query: _searchQuery,
//               onChanged: (v) => setState(() => _searchQuery = v),
//               onClear: () {
//                 _searchController.clear();
//                 setState(() => _searchQuery = '');
//               },
//             ),
//
//             // State filter chips
//             _StateFilterBar(
//               filters: _stateFilters,
//               selected: _selectedState,
//               onSelect: (s) => setState(() => _selectedState = s),
//             ),
//
//             // College list
//             Expanded(
//               child: filtered.isEmpty
//                   ? const _EmptyState()
//                   : ListView.builder(
//                 padding: EdgeInsets.fromLTRB(
//                   r.spacing(AppDimens.paddingLG),
//                   r.spacing(AppDimens.paddingSM),
//                   r.spacing(AppDimens.paddingLG),
//                   100,
//                 ),
//                 itemCount: filtered.length,
//                 itemBuilder: (_, i) => _CollegeListCard(
//                   college: filtered[i],
//                   course: widget.course,
//                   isHighlighted: i == 0,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar(Responsive r, int count) {
//     return AppBar(
//       backgroundColor: AppColors.backgroundWhite,
//       elevation: 0,
//       surfaceTintColor: Colors.transparent,
//       leading: IconButton(
//         icon: const Icon(Icons.arrow_back_ios_new_rounded),
//         color: AppColors.primary,
//         onPressed: () => Navigator.pop(context),
//       ),
//       title: Text(
//         'Colleges Offering',
//         style: AppTextStyles.titleLarge.copyWith(fontSize: r.fontSize(16)),
//       ),
//       actions: [
//         Container(
//           margin: EdgeInsets.only(right: r.spacing(AppDimens.paddingMD)),
//           padding: EdgeInsets.symmetric(
//             horizontal: r.spacing(AppDimens.paddingSM + 2),
//             vertical: r.spacing(4),
//           ),
//           decoration: BoxDecoration(
//             color: AppColors.primarySurface,
//             borderRadius: BorderRadius.circular(AppDimens.radiusFull),
//           ),
//           child: Text(
//             '$count ${count == 1 ? 'College' : 'Colleges'}',
//             style: AppTextStyles.labelSmall.copyWith(
//               color: AppColors.primary,
//               fontWeight: FontWeight.w600,
//               fontSize: r.fontSize(12),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Course Hero Banner
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _CourseHeroBanner extends StatelessWidget {
//   final Course course;
//   final int totalSeats;
//   final Color levelColor;
//   final IconData levelIcon;
//
//   const _CourseHeroBanner({
//     required this.course,
//     required this.totalSeats,
//     required this.levelColor,
//     required this.levelIcon,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final r = Responsive.of(context);
//
//     return Container(
//       width: double.infinity,
//       color: AppColors.primary,
//       padding: EdgeInsets.all(r.spacing(AppDimens.paddingLG)),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Icon box
//               Container(
//                 width: r.value(mobile: 48.0, tablet: 56.0),
//                 height: r.value(mobile: 48.0, tablet: 56.0),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.18),
//                   borderRadius: BorderRadius.circular(AppDimens.radiusMD),
//                 ),
//                 child: Icon(
//                   levelIcon,
//                   color: Colors.white,
//                   size: r.value(
//                     mobile: AppDimens.iconLG,
//                     tablet: AppDimens.iconXL,
//                   ),
//                 ),
//               ),
//               SizedBox(width: r.spacing(AppDimens.paddingMD)),
//               // Course name + full name
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       course.name,
//                       style: AppTextStyles.headlineMedium.copyWith(
//                         color: Colors.white,
//                         fontSize: r.fontSize(18),
//                       ),
//                     ),
//                     SizedBox(height: r.spacing(3)),
//                     Text(
//                       course.fullName,
//                       style: AppTextStyles.bodySmall.copyWith(
//                         color: Colors.white70,
//                         fontSize: r.fontSize(11),
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: r.spacing(AppDimens.paddingMD)),
//           // Pill row
//           Wrap(
//             spacing: r.spacing(AppDimens.paddingSM),
//             runSpacing: r.spacing(AppDimens.paddingXS),
//             children: [
//               _HeroPill(
//                 icon: Icons.workspace_premium_rounded,
//                 label: course.level == 'PhD'
//                     ? 'Ph.D.'
//                     : '${course.level} Degree',
//               ),
//               _HeroPill(
//                 icon: Icons.schedule_rounded,
//                 label: course.duration,
//               ),
//               if (totalSeats > 0)
//                 _HeroPill(
//                   icon: Icons.group_rounded,
//                   label: '$totalSeats Total Seats',
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _HeroPill extends StatelessWidget {
//   final IconData icon;
//   final String label;
//
//   const _HeroPill({required this.icon, required this.label});
//
//   @override
//   Widget build(BuildContext context) {
//     final r = Responsive.of(context);
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: r.spacing(AppDimens.paddingSM + 2),
//         vertical: r.spacing(AppDimens.paddingXS + 2),
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.18),
//         borderRadius: BorderRadius.circular(AppDimens.radiusFull),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(icon, size: 13, color: Colors.white),
//           SizedBox(width: r.spacing(AppDimens.paddingXS)),
//           Text(
//             label,
//             style: AppTextStyles.labelSmall.copyWith(
//               color: Colors.white,
//               fontSize: r.fontSize(11),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Search Bar
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _SearchBar extends StatelessWidget {
//   final TextEditingController controller;
//   final String query;
//   final ValueChanged<String> onChanged;
//   final VoidCallback onClear;
//
//   const _SearchBar({
//     required this.controller,
//     required this.query,
//     required this.onChanged,
//     required this.onClear,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final r = Responsive.of(context);
//     return Container(
//       color: AppColors.backgroundWhite,
//       padding: EdgeInsets.fromLTRB(
//         r.spacing(AppDimens.paddingLG),
//         r.spacing(AppDimens.paddingSM + 2),
//         r.spacing(AppDimens.paddingLG),
//         0,
//       ),
//       child: Container(
//         height: r.value(mobile: 42.0, tablet: 48.0),
//         decoration: BoxDecoration(
//           color: AppColors.backgroundGrey,
//           borderRadius: BorderRadius.circular(AppDimens.radiusFull),
//         ),
//         child: TextField(
//           controller: controller,
//           onChanged: onChanged,
//           style: AppTextStyles.bodyLarge.copyWith(fontSize: r.fontSize(14)),
//           decoration: InputDecoration(
//             hintText: 'Search colleges or states...',
//             hintStyle: AppTextStyles.bodyMedium.copyWith(
//               fontSize: r.fontSize(13),
//             ),
//             prefixIcon: Icon(
//               Icons.search_rounded,
//               size: r.value(
//                 mobile: AppDimens.iconXS + 6,
//                 tablet: AppDimens.iconSM,
//               ),
//               color: AppColors.iconSecondary,
//             ),
//             suffixIcon: query.isNotEmpty
//                 ? GestureDetector(
//               onTap: onClear,
//               child: Icon(
//                 Icons.close_rounded,
//                 size: r.value(
//                   mobile: AppDimens.iconXS + 4,
//                   tablet: AppDimens.iconSM,
//                 ),
//                 color: AppColors.iconSecondary,
//               ),
//             )
//                 : null,
//             border: InputBorder.none,
//             contentPadding: EdgeInsets.symmetric(vertical: r.spacing(11)),
//             isDense: true,
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // State Filter Bar
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _StateFilterBar extends StatelessWidget {
//   final List<String> filters;
//   final String selected;
//   final ValueChanged<String> onSelect;
//
//   const _StateFilterBar({
//     required this.filters,
//     required this.selected,
//     required this.onSelect,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final r = Responsive.of(context);
//     return Container(
//       color: AppColors.backgroundWhite,
//       padding: EdgeInsets.fromLTRB(
//         r.spacing(AppDimens.paddingLG),
//         r.spacing(AppDimens.paddingSM + 2),
//         r.spacing(AppDimens.paddingLG),
//         r.spacing(AppDimens.paddingMD),
//       ),
//       child: SingleChildScrollView(
//         scrollDirection: Axis.horizontal,
//         child: Row(
//           children: filters.map((state) {
//             final isSelected = state == selected;
//             final label = state == 'All' ? 'All Colleges' : state;
//             return GestureDetector(
//               onTap: () => onSelect(state),
//               child: AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 margin: EdgeInsets.only(right: r.spacing(AppDimens.paddingSM)),
//                 padding: EdgeInsets.symmetric(
//                   horizontal: r.spacing(AppDimens.paddingLG),
//                   vertical: r.spacing(AppDimens.paddingXS + 4),
//                 ),
//                 decoration: BoxDecoration(
//                   color: isSelected
//                       ? AppColors.primary
//                       : AppColors.backgroundGrey,
//                   borderRadius:
//                   BorderRadius.circular(AppDimens.radiusFull),
//                 ),
//                 child: Text(
//                   label,
//                   style: AppTextStyles.titleSmall.copyWith(
//                     color: isSelected
//                         ? Colors.white
//                         : AppColors.textSecondary,
//                     fontWeight:
//                     isSelected ? FontWeight.w600 : FontWeight.w400,
//                     fontSize: r.fontSize(13),
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // College List Card
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _CollegeListCard extends StatelessWidget {
//   final College college;
//   final Course course;
//   final bool isHighlighted;
//
//   const _CollegeListCard({
//     required this.college,
//     required this.course,
//     this.isHighlighted = false,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final r = Responsive.of(context);
//
//     // Find the intake for this specific course in the college
//     final matchedCourse = college.allCourses
//         .where((c) => c.id == course.id)
//         .firstOrNull;
//     final intake = matchedCourse?.intake ?? 0;
//     final intakeLabel =
//     intake == 0 ? 'Intake: As per ICAR' : 'Intake: $intake Seats';
//
//     return Container(
//       margin: EdgeInsets.only(bottom: r.spacing(AppDimens.paddingMD)),
//       decoration: BoxDecoration(
//         color: isHighlighted
//             ? AppColors.primarySurface
//             : AppColors.backgroundWhite,
//         borderRadius: BorderRadius.circular(AppDimens.radiusLG),
//         border: Border.all(
//           color: isHighlighted
//               ? AppColors.primary.withOpacity(0.3)
//               : AppColors.borderLight,
//           width: isHighlighted ? 1.5 : 1,
//         ),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD + 2)),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // ── Top row ──────────────────────────────────────────────────
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Avatar (logo or initials)
//                 CollegeAvatar(
//                   name: college.name,
//                   imageUrl: college.logoUrl,
//                   size: r.value(mobile: 44.0, tablet: 52.0),
//                 ),
//                 SizedBox(width: r.spacing(AppDimens.paddingSM + 2)),
//                 // Name + location
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         college.name,
//                         style: AppTextStyles.titleLarge.copyWith(
//                           fontSize: r.fontSize(13),
//                         ),
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       SizedBox(height: r.spacing(3)),
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.location_on_outlined,
//                             size: 12,
//                             color: AppColors.textSecondary,
//                           ),
//                           SizedBox(width: r.spacing(3)),
//                           Expanded(
//                             child: Text(
//                               college.location,
//                               style: AppTextStyles.bodySmall.copyWith(
//                                 fontSize: r.fontSize(11),
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: r.spacing(AppDimens.paddingXS)),
//                 // Type badge
//                 _TypeBadge(type: college.type),
//               ],
//             ),
//
//             Padding(
//               padding: EdgeInsets.symmetric(
//                 vertical: r.spacing(AppDimens.paddingSM + 2),
//               ),
//               child: const Divider(height: 1, color: AppColors.borderLight),
//             ),
//
//             // ── Tags row ─────────────────────────────────────────────────
//             Wrap(
//               spacing: r.spacing(AppDimens.paddingSM),
//               runSpacing: r.spacing(AppDimens.paddingXS),
//               children: [
//                 // Reuse existing TagBadge from commonwidget.dart
//                 TagBadge(
//                   label: intakeLabel,
//                   backgroundColor: AppColors.backgroundGrey,
//                   textColor: AppColors.textSecondary,
//                 ),
//                 TagBadge(
//                   label: college.state,
//                   backgroundColor: AppColors.backgroundGrey,
//                   textColor: AppColors.textSecondary,
//                 ),
//                 ...college.tags.map((tag) => _buildTag(tag)),
//               ],
//             ),
//
//             SizedBox(height: r.spacing(AppDimens.paddingSM + 2)),
//
//             // ── Bottom row ───────────────────────────────────────────────
//             Row(
//               children: [
//                 Icon(
//                   Icons.calendar_today_outlined,
//                   size: 11,
//                   color: AppColors.textSecondary,
//                 ),
//                 SizedBox(width: r.spacing(AppDimens.paddingXS)),
//                 Text(
//                   college.established,
//                   style: AppTextStyles.bodySmall.copyWith(
//                     fontSize: r.fontSize(10),
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//                 const Spacer(),
//                 // Apply button
//                 GestureDetector(
//                   onTap: () {
//                     // TODO: Navigate to college detail / apply flow
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(
//                       horizontal: r.spacing(AppDimens.paddingMD),
//                       vertical: r.spacing(AppDimens.paddingXS + 2),
//                     ),
//                     decoration: BoxDecoration(
//                       color: AppColors.primarySurface,
//                       borderRadius:
//                       BorderRadius.circular(AppDimens.radiusMD),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           'Apply',
//                           style: AppTextStyles.labelSmall.copyWith(
//                             color: AppColors.primary,
//                             fontWeight: FontWeight.w600,
//                             fontSize: r.fontSize(11),
//                           ),
//                         ),
//                         SizedBox(width: r.spacing(3)),
//                         Icon(
//                           Icons.arrow_forward_rounded,
//                           color: AppColors.primary,
//                           size: r.value(mobile: 13.0, tablet: 15.0),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTag(String tag) {
//     if (tag == 'ICAR') return TagBadge.icar(tag);
//     if (tag == 'Public') return TagBadge.public();
//     if (tag == 'State') return TagBadge.state();
//     return TagBadge(
//       label: tag,
//       backgroundColor: const Color(0xFFEDE7F6),
//       textColor: const Color(0xFF6A1B9A),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Type Badge  (Public / Private / Deemed)
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _TypeBadge extends StatelessWidget {
//   final String type;
//
//   const _TypeBadge({required this.type});
//
//   @override
//   Widget build(BuildContext context) {
//     final r = Responsive.of(context);
//
//     Color bg, fg;
//     switch (type) {
//       case 'Private':
//         bg = const Color(0xFFFAEEDA);
//         fg = const Color(0xFF854F0B);
//         break;
//       case 'Deemed':
//         bg = const Color(0xFFEEEDFE);
//         fg = const Color(0xFF534AB7);
//         break;
//       default: // Public
//         bg = const Color(0xFFEAF3DE);
//         fg = const Color(0xFF3B6D11);
//     }
//
//     return Container(
//       padding: EdgeInsets.symmetric(
//         horizontal: r.spacing(AppDimens.paddingSM),
//         vertical: r.spacing(3),
//       ),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(AppDimens.radiusXS + 2),
//       ),
//       child: Text(
//         type,
//         style: AppTextStyles.labelSmall.copyWith(
//           color: fg,
//           fontWeight: FontWeight.w600,
//           fontSize: r.fontSize(10),
//         ),
//       ),
//     );
//   }
// }
//
// // ─────────────────────────────────────────────────────────────────────────────
// // Empty State
// // ─────────────────────────────────────────────────────────────────────────────
//
// class _EmptyState extends StatelessWidget {
//   const _EmptyState();
//
//   @override
//   Widget build(BuildContext context) {
//     final r = Responsive.of(context);
//     return Center(
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.school_outlined,
//             size: r.value(mobile: 48.0, tablet: 60.0),
//             color: AppColors.iconSecondary,
//           ),
//           SizedBox(height: r.spacing(AppDimens.paddingMD)),
//           Text(
//             'No colleges found',
//             style: AppTextStyles.bodyLarge.copyWith(
//               color: AppColors.textSecondary,
//               fontSize: r.fontSize(14),
//             ),
//           ),
//           SizedBox(height: r.spacing(AppDimens.paddingXS)),
//           Text(
//             'Try a different search or filter',
//             style: AppTextStyles.bodySmall.copyWith(
//               color: AppColors.textSecondary,
//               fontSize: r.fontSize(12),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/modelclass.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import '../../../widgets/commonwidget.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────────────────────────────────────

class CollegesListScreen extends StatefulWidget {
  final Course course;
  final List<College> colleges;

  const CollegesListScreen({
    super.key,
    required this.course,
    required this.colleges,
  });

  @override
  State<CollegesListScreen> createState() => _CollegesListScreenState();
}

class _CollegesListScreenState extends State<CollegesListScreen> {
  String _selectedState = 'All';
  final _searchController = TextEditingController();
  String _searchQuery = '';

  // ── Derived data ─────────────────────────────────────────────────────────

  List<String> get _stateFilters {
    final states = widget.colleges.map((c) => c.state).toSet().toList()
      ..sort();
    return ['All', ...states];
  }

  List<College> get _filtered {
    List<College> list = widget.colleges;
    if (_selectedState != 'All') {
      list = list.where((c) => c.state == _selectedState).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list = list
          .where((c) =>
      c.name.toLowerCase().contains(q) ||
          c.state.toLowerCase().contains(q) ||
          c.location.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  int get _totalSeats {
    return widget.colleges.fold(0, (sum, college) {
      final intake = college.allCourses
          .where((c) => c.id == widget.course.id)
          .fold(0, (s, c) => s + c.intake);
      return sum + intake;
    });
  }

  // ── Level helpers ──────────────────────────────────────────────────────────

  static const _levelColors = {
    'UG': Color(0xFF1B5E20),
    'PG': Color(0xFF1565C0),
    'Diploma': Color(0xFF6A1B9A),
    'PhD': Color(0xFFE65100),
  };

  static const _levelIcons = {
    'UG': Icons.school_rounded,
    'PG': Icons.auto_stories_rounded,
    'Diploma': Icons.workspace_premium_rounded,
    'PhD': Icons.psychology_rounded,
  };

  Color get _levelColor =>
      _levelColors[widget.course.level] ?? AppColors.primary;

  IconData get _levelIcon =>
      _levelIcons[widget.course.level] ?? Icons.school_rounded;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    final filtered = _filtered;

    return NetworkAwareWrapper(
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: VetAppBar(title: 'Colleges Offering'),
        body: Column(
          children: [
            // Course hero banner — unchanged
            _CourseHeroBanner(
              course: widget.course,
              totalSeats: _totalSeats,
              levelColor: _levelColor,
              levelIcon: _levelIcon,
            ),

            // Search bar — unchanged
            _SearchBar(
              controller: _searchController,
              query: _searchQuery,
              onChanged: (v) => setState(() => _searchQuery = v),
              onClear: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            ),

            // State filter chips — unchanged
            _StateFilterBar(
              filters: _stateFilters,
              selected: _selectedState,
              onSelect: (s) => setState(() => _selectedState = s),
            ),

            // Result count note
            if (filtered.isNotEmpty)
              Padding(
                padding: EdgeInsets.fromLTRB(
                  r.spacing(AppDimens.paddingLG),
                  r.spacing(4),
                  r.spacing(AppDimens.paddingLG),
                  0,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Showing ${filtered.length} ${filtered.length == 1 ? 'college' : 'colleges'}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: r.fontSize(12),
                    ),
                  ),
                ),
              ),

            // College list
            Expanded(
              child: filtered.isEmpty
                  ? const _EmptyState()
                  : ListView.builder(
                padding: EdgeInsets.fromLTRB(
                  r.spacing(AppDimens.paddingMD),
                  r.spacing(AppDimens.paddingSM),
                  r.spacing(AppDimens.paddingMD),
                  100,
                ),
                itemCount: filtered.length,
                itemBuilder: (_, i) => _CollegeListCard(
                  college: filtered[i],
                  course: widget.course,
                  isHighlighted: i == 0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Course Hero Banner  (unchanged)
// ─────────────────────────────────────────────────────────────────────────────

class _CourseHeroBanner extends StatelessWidget {
  final Course course;
  final int totalSeats;
  final Color levelColor;
  final IconData levelIcon;

  const _CourseHeroBanner({
    required this.course,
    required this.totalSeats,
    required this.levelColor,
    required this.levelIcon,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    return Container(
      width: double.infinity,
      color: AppColors.primary,
      padding: EdgeInsets.all(r.spacing(AppDimens.paddingLG)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: r.value(mobile: 48.0, tablet: 56.0),
                height: r.value(mobile: 48.0, tablet: 56.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                ),
                child: Icon(
                  levelIcon,
                  color: Colors.white,
                  size: r.value(
                    mobile: AppDimens.iconLG,
                    tablet: AppDimens.iconXL,
                  ),
                ),
              ),
              SizedBox(width: r.spacing(AppDimens.paddingMD)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      course.name,
                      style: AppTextStyles.headlineMedium.copyWith(
                        color: Colors.white,
                        fontSize: r.fontSize(18),
                      ),
                    ),
                    SizedBox(height: r.spacing(3)),
                    Text(
                      course.fullName,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                        fontSize: r.fontSize(11),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: r.spacing(AppDimens.paddingMD)),
          Wrap(
            spacing: r.spacing(AppDimens.paddingSM),
            runSpacing: r.spacing(AppDimens.paddingXS),
            children: [
              _HeroPill(
                icon: Icons.workspace_premium_rounded,
                label: course.level == 'PhD'
                    ? 'Ph.D.'
                    : '${course.level} Degree',
              ),
              _HeroPill(
                icon: Icons.schedule_rounded,
                label: course.duration,
              ),
              if (totalSeats > 0)
                _HeroPill(
                  icon: Icons.group_rounded,
                  label: '$totalSeats Total Seats',
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final IconData icon;
  final String label;

  const _HeroPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.spacing(AppDimens.paddingSM + 2),
        vertical: r.spacing(AppDimens.paddingXS + 2),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.18),
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: Colors.white),
          SizedBox(width: r.spacing(AppDimens.paddingXS)),
          Text(
            label,
            style: AppTextStyles.labelSmall.copyWith(
              color: Colors.white,
              fontSize: r.fontSize(11),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Search Bar  (unchanged)
// ─────────────────────────────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchBar({
    required this.controller,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Container(
      color: AppColors.backgroundWhite,
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingSM + 2),
        r.spacing(AppDimens.paddingLG),
        0,
      ),
      child: Container(
        height: r.value(mobile: 42.0, tablet: 48.0),
        decoration: BoxDecoration(
          color: AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        ),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          style: AppTextStyles.bodyLarge.copyWith(fontSize: r.fontSize(14)),
          decoration: InputDecoration(
            hintText: 'Search colleges or states...',
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              fontSize: r.fontSize(13),
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              size: r.value(mobile: AppDimens.iconXS + 6, tablet: AppDimens.iconSM),
              color: AppColors.iconSecondary,
            ),
            suffixIcon: query.isNotEmpty
                ? GestureDetector(
              onTap: onClear,
              child: Icon(
                Icons.close_rounded,
                size: r.value(mobile: AppDimens.iconXS + 4, tablet: AppDimens.iconSM),
                color: AppColors.iconSecondary,
              ),
            )
                : null,
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: r.spacing(11)),
            isDense: true,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// State Filter Bar  (unchanged)
// ─────────────────────────────────────────────────────────────────────────────

class _StateFilterBar extends StatelessWidget {
  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelect;

  const _StateFilterBar({
    required this.filters,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Container(
      color: AppColors.backgroundWhite,
      padding: EdgeInsets.fromLTRB(
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingSM + 2),
        r.spacing(AppDimens.paddingLG),
        r.spacing(AppDimens.paddingMD),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((state) {
            final isSelected = state == selected;
            final label = state == 'All' ? 'All Colleges' : state;
            return GestureDetector(
              onTap: () => onSelect(state),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(right: r.spacing(AppDimens.paddingSM)),
                padding: EdgeInsets.symmetric(
                  horizontal: r.spacing(AppDimens.paddingLG),
                  vertical: r.spacing(AppDimens.paddingXS + 4),
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.backgroundGrey,
                  borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                ),
                child: Text(
                  label,
                  style: AppTextStyles.titleSmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    fontSize: r.fontSize(13),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// College List Card  — FULLY REDESIGNED
// ─────────────────────────────────────────────────────────────────────────────

class _CollegeListCard extends StatelessWidget {
  final College college;
  final Course course;
  final bool isHighlighted;

  const _CollegeListCard({
    required this.college,
    required this.course,
    this.isHighlighted = false,
  });

  // ── Type-based theming ─────────────────────────────────────────────────────

  Color _accentColor(String type) {
    switch (type) {
      case 'Private':
        return const Color(0xFF854F0B);
      case 'Deemed':
        return const Color(0xFF534AB7);
      default:
        return const Color(0xFF1B5E20);
    }
  }

  Color _avatarBg(String type) {
    switch (type) {
      case 'Private':
        return const Color(0xFFFAEEDA);
      case 'Deemed':
        return const Color(0xFFEEEDFE);
      default:
        return const Color(0xFFEAF3DE);
    }
  }

  Color _avatarFg(String type) {
    switch (type) {
      case 'Private':
        return const Color(0xFF854F0B);
      case 'Deemed':
        return const Color(0xFF534AB7);
      default:
        return const Color(0xFF3B6D11);
    }
  }

  Color _typeBadgeBg(String type) {
    switch (type) {
      case 'Private':
        return const Color(0xFFFAEEDA);
      case 'Deemed':
        return const Color(0xFFEEEDFE);
      default:
        return const Color(0xFFEAF3DE);
    }
  }

  Color _typeBadgeFg(String type) => _avatarFg(type);

  // ── Avatar initials ────────────────────────────────────────────────────────

  String _initials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);

    final matchedCourse =
        college.allCourses.where((c) => c.id == course.id).firstOrNull;
    final intake = matchedCourse?.intake ?? 0;
    final intakeDisplay = intake == 0 ? 'As per ICAR' : '$intake';

    final accentColor = _accentColor(college.type);
    final avatarBg = _avatarBg(college.type);
    final avatarFg = _avatarFg(college.type);

    return Container(
      margin: EdgeInsets.only(bottom: r.spacing(AppDimens.paddingMD)),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted
              ? accentColor.withOpacity(0.35)
              : AppColors.borderLight,
          width: isHighlighted ? 1.5 : 0.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Coloured accent bar ────────────────────────────────────────
          Container(height: 3, color: accentColor),

          Padding(
            padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── "Top ranked" badge (only for first card) ─────────────
                if (isHighlighted) ...[
                  Container(
                    margin: EdgeInsets.only(bottom: r.spacing(8)),
                    padding: EdgeInsets.symmetric(
                      horizontal: r.spacing(AppDimens.paddingSM + 2),
                      vertical: r.spacing(3),
                    ),
                    decoration: BoxDecoration(
                      color: accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppDimens.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          size: 11,
                          color: accentColor,
                        ),
                        SizedBox(width: r.spacing(4)),
                        Text(
                          'Top ranked',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: accentColor,
                            fontSize: r.fontSize(10),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // ── Header row: avatar + name/location + type badge ───────
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar
                    Container(
                      width: r.value(mobile: 44.0, tablet: 52.0),
                      height: r.value(mobile: 44.0, tablet: 52.0),
                      decoration: BoxDecoration(
                        color: avatarBg,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: accentColor.withOpacity(0.15),
                          width: 0.5,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: college.logoUrl != null && college.logoUrl!.isNotEmpty
                          ? ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.network(
                          college.logoUrl!,
                          width: r.value(mobile: 44.0, tablet: 52.0),
                          height: r.value(mobile: 44.0, tablet: 52.0),
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Text(
                            _initials(college.name),
                            style: TextStyle(
                              fontSize: r.fontSize(14),
                              fontWeight: FontWeight.w600,
                              color: avatarFg,
                            ),
                          ),
                        ),
                      )
                          : Text(
                        _initials(college.name),
                        style: TextStyle(
                          fontSize: r.fontSize(14),
                          fontWeight: FontWeight.w600,
                          color: avatarFg,
                        ),
                      ),
                    ),
                    SizedBox(width: r.spacing(AppDimens.paddingSM + 2)),

                    // Name + location
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            college.name,
                            style: AppTextStyles.titleLarge.copyWith(
                              fontSize: r.fontSize(13),
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: r.spacing(4)),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                size: 11,
                                color: AppColors.textSecondary,
                              ),
                              SizedBox(width: r.spacing(3)),
                              Expanded(
                                child: Text(
                                  college.location,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: r.fontSize(11),
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: r.spacing(AppDimens.paddingXS)),

                    // Type badge
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.spacing(AppDimens.paddingSM),
                        vertical: r.spacing(3),
                      ),
                      decoration: BoxDecoration(
                        color: _typeBadgeBg(college.type),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        college.type,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: _typeBadgeFg(college.type),
                          fontWeight: FontWeight.w600,
                          fontSize: r.fontSize(10),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: r.spacing(AppDimens.paddingMD)),

                // ── Stats row ───────────────────────────────────────────
                Row(
                  children: [
                    _StatBox(
                      label: 'Intake',
                      value: intakeDisplay,
                      r: r,
                    ),
                    SizedBox(width: r.spacing(AppDimens.paddingXS + 2)),
                    _StatBox(
                      label: 'State',
                      value: college.state,
                      r: r,
                    ),
                    SizedBox(width: r.spacing(AppDimens.paddingXS + 2)),
                    _StatBox(
                      label: 'Est.',
                      value: college.established,
                      r: r,
                    ),
                  ],
                ),

                SizedBox(height: r.spacing(AppDimens.paddingSM + 2)),

                // ── Tags ────────────────────────────────────────────────
                Wrap(
                  spacing: r.spacing(AppDimens.paddingXS + 2),
                  runSpacing: r.spacing(AppDimens.paddingXS),
                  children: [
                    ...college.tags.map((tag) => _buildTag(tag, r)),
                  ],
                ),

                SizedBox(height: r.spacing(AppDimens.paddingMD)),

                // ── Footer: established + Apply button ─────────────────
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 11,
                      color: AppColors.textSecondary,
                    ),
                    SizedBox(width: r.spacing(3)),
                    Text(
                      'Est. ${college.established}',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: r.fontSize(10),
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        // TODO: Navigate to college detail / apply flow
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: r.spacing(AppDimens.paddingMD),
                          vertical: r.spacing(AppDimens.paddingXS + 3),
                        ),
                        decoration: BoxDecoration(
                          color: accentColor,
                          borderRadius: BorderRadius.circular(AppDimens.radiusMD),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View Details',
                              style: AppTextStyles.labelSmall.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: r.fontSize(12),
                              ),
                            ),
                            SizedBox(width: r.spacing(4)),
                            Icon(
                              Icons.arrow_forward_rounded,
                              color: Colors.white,
                              size: r.value(mobile: 13.0, tablet: 15.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag, Responsive r) {
    if (tag == 'ICAR') {
      return _Tag(
        label: 'ICAR Affiliated',
        bg: const Color(0xFFE6F1FB),
        fg: const Color(0xFF185FA5),
        r: r,
      );
    }
    if (tag == 'Public') {
      return _Tag(
        label: 'Public',
        bg: const Color(0xFFEAF3DE),
        fg: const Color(0xFF3B6D11),
        r: r,
      );
    }
    if (tag == 'State') {
      return _Tag(
        label: 'State Univ.',
        bg: const Color(0xFFEAF3DE),
        fg: const Color(0xFF3B6D11),
        r: r,
      );
    }
    return _Tag(
      label: tag,
      bg: const Color(0xFFEDE7F6),
      fg: const Color(0xFF6A1B9A),
      r: r,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Stat Box  (mini info cell inside the card)
// ─────────────────────────────────────────────────────────────────────────────

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final Responsive r;

  const _StatBox({
    required this.label,
    required this.value,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: r.spacing(AppDimens.paddingSM),
          vertical: r.spacing(AppDimens.paddingXS + 2),
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundGrey,
          borderRadius: BorderRadius.circular(AppDimens.radiusSM),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: r.fontSize(10),
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: r.spacing(2)),
            Text(
              value,
              style: AppTextStyles.titleSmall.copyWith(
                fontSize: r.fontSize(12),
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tag pill
// ─────────────────────────────────────────────────────────────────────────────

class _Tag extends StatelessWidget {
  final String label;
  final Color bg;
  final Color fg;
  final Responsive r;

  const _Tag({
    required this.label,
    required this.bg,
    required this.fg,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.spacing(AppDimens.paddingSM + 2),
        vertical: r.spacing(3),
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppDimens.radiusFull),
        border: Border.all(color: fg.withOpacity(0.2), width: 0.5),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: fg,
          fontSize: r.fontSize(10),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Empty State
// ─────────────────────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final r = Responsive.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.school_outlined,
            size: r.value(mobile: 48.0, tablet: 60.0),
            color: AppColors.iconSecondary,
          ),
          SizedBox(height: r.spacing(AppDimens.paddingMD)),
          Text(
            'No colleges found',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
              fontSize: r.fontSize(14),
            ),
          ),
          SizedBox(height: r.spacing(AppDimens.paddingXS)),
          Text(
            'Try a different search or filter',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: r.fontSize(12),
            ),
          ),
        ],
      ),
    );
  }
}

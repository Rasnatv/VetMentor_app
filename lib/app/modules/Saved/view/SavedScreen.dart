// import 'package:flutter/material.dart';
// import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
// import '../../../core/constants/appcolors.dart';
// import '../../../core/style/textstyle.dart';
// import '../../../data/models/modelclass.dart';
// import '../../../widgets/collegecard.dart';
// import '../../../widgets/commonwidget.dart';
//
//
// class SavedScreen extends StatefulWidget {
//   const SavedScreen({super.key});
//
//   @override
//   State<SavedScreen> createState() => _SavedScreenState();
// }
//
// class _SavedScreenState extends State<SavedScreen> {
//   // Reuse the same saved IDs list — ideally lift this to a provider/state manager
//   final List<String> _savedIds = [
//     MockData.colleges[0].id,
//     MockData.colleges[1].id,
//     MockData.colleges[2].id,
//     MockData.colleges[3].id,
//   ];
//
//   List<College> get _savedColleges =>
//       MockData.colleges.where((c) => _savedIds.contains(c.id)).toList();
//
//   void _toggleSave(String id) {
//     setState(() {
//       if (_savedIds.contains(id)) {
//         _savedIds.remove(id);
//       } else {
//         _savedIds.add(id);
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colleges = _savedColleges;
//
//     return NetworkAwareWrapper(
//       child: Scaffold(
//         backgroundColor: AppColors.background,
//         appBar: VetAppBar(
//           title: 'Saved Colleges',
//           showBack: false,
//         ),
//         body: colleges.isEmpty
//             ? const EmptyState(
//           title: 'No Saved Colleges',
//           subtitle: 'Colleges you bookmark will appear here',
//           icon: Icons.bookmark_border_rounded,
//         )
//             : Column(
//           children: [
//             // ── Summary strip ──────────────────────
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: 12, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: AppColors.primarySurface,
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     child: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         const Icon(Icons.bookmark_rounded,
//                             size: 14, color: AppColors.primary),
//                         const SizedBox(width: 5),
//                         Text(
//                           '${colleges.length} colleges saved',
//                           style: AppTextStyles.bodySmall.copyWith(
//                               fontWeight: FontWeight.w600,
//                               color: AppColors.primary),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const Spacer(),
//                   // Sort button (wire up as needed)
//                   GestureDetector(
//                     onTap: () {},
//                     child: Row(
//                       children: [
//                         const Icon(Icons.tune_rounded,
//                             size: 16, color: AppColors.primary),
//                         const SizedBox(width: 4),
//                         Text('Sort',
//                             style: AppTextStyles.bodyGreen.copyWith(
//                                 fontWeight: FontWeight.w600)),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//
//             // ── List ───────────────────────────────
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
//                 itemCount: colleges.length,
//                 itemBuilder: (ctx, i) {
//                   final college = colleges[i];
//                   return CollegeCard(
//                     college: college,
//                     isSaved: _savedIds.contains(college.id),
//                     onSave: () => _toggleSave(college.id),
//                     onTap: () {},
//
//
//                   );}))
//                   ] ),
//       ),
//     );
//   }
// }
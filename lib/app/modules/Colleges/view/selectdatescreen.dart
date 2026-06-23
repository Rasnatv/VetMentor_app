// import 'package:flutter/material.dart';
//
// import '../../../core/constants/appcolors.dart';
// import '../../../core/style/textstyle.dart';
// import '../../../widgets/commonwidget.dart';
//
//
// class SelectDateScreen extends StatefulWidget {
//   const SelectDateScreen({super.key});
//
//   @override
//   State<SelectDateScreen> createState() => _SelectDateScreenState();
// }
//
// class _SelectDateScreenState extends State<SelectDateScreen> {
//   DateTime _focusedDate = DateTime(2024, 5, 17);
//   DateTime? _selectedDate = DateTime(2024, 5, 17);
//   String _selectedTime = '09:00 AM';
//
//   final _timeSlots = ['09:00 AM', '10:30 AM', '12:00 PM', '02:00 PM', '03:30 PM', '05:00 PM'];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: VetAppBar(title: 'Select Date & Time'),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Calendar
//             Container(
//               decoration: BoxDecoration(
//                 color: AppColors.backgroundWhite,
//                 borderRadius: BorderRadius.circular(20),
//                 border: Border.all(color: AppColors.borderLight),
//               ),
//               child: Column(
//                 children: [
//                   // Month header
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         GestureDetector(
//                           onTap: () => setState(() {
//                             _focusedDate = DateTime(_focusedDate.year, _focusedDate.month - 1);
//                           }),
//                           child: const Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary),
//                         ),
//                         Text(
//                           _monthYear(_focusedDate),
//                           style: AppTextStyles.headlineMedium,
//                         ),
//                         GestureDetector(
//                           onTap: () => setState(() {
//                             _focusedDate = DateTime(_focusedDate.year, _focusedDate.month + 1);
//                           }),
//                           child: const Icon(Icons.chevron_right_rounded, color: AppColors.textPrimary),
//                         ),
//                       ],
//                     ),
//                   ),
//                   // Day headers
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceAround,
//                       children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
//                           .map((d) => SizedBox(
//                         width: 36,
//                         child: Text(
//                           d,
//                           style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600),
//                           textAlign: TextAlign.center,
//                         ),
//                       ))
//                           .toList(),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   // Calendar grid
//                   _buildCalendar(),
//                   const SizedBox(height: 16),
//                 ],
//               ),
//             ),
//
//             const SizedBox(height: 20),
//
//             Text('Available Time Slots', style: AppTextStyles.headlineMedium),
//             const SizedBox(height: 12),
//             _buildTimeSlots(),
//
//             const SizedBox(height: 80),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Container(
//         padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
//         decoration: const BoxDecoration(
//           color: AppColors.backgroundWhite,
//           border: Border(top: BorderSide(color: AppColors.borderLight)),
//         ),
//         child: AppButton(
//           text: 'Continue',
//           onTap: () => Navigator.pop(context),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildCalendar() {
//     final firstDay = DateTime(_focusedDate.year, _focusedDate.month, 1);
//     final lastDay = DateTime(_focusedDate.year, _focusedDate.month + 1, 0);
//     final startOffset = firstDay.weekday % 7;
//
//     final days = <Widget>[];
//     for (int i = 0; i < startOffset; i++) {
//       days.add(const SizedBox(width: 36));
//     }
//     for (int day = 1; day <= lastDay.day; day++) {
//       final date = DateTime(_focusedDate.year, _focusedDate.month, day);
//       final isSelected = _selectedDate != null &&
//           _selectedDate!.day == day &&
//           _selectedDate!.month == _focusedDate.month;
//       final isToday = date.day == DateTime.now().day &&
//           date.month == DateTime.now().month;
//       days.add(GestureDetector(
//         onTap: () => setState(() => _selectedDate = date),
//         child: Container(
//           width: 36,
//           height: 36,
//           decoration: BoxDecoration(
//             color: isSelected ? AppColors.primary : Colors.transparent,
//             shape: BoxShape.circle,
//             border: isToday && !isSelected ? Border.all(color: AppColors.primary, width: 1.5) : null,
//           ),
//           child: Center(
//             child: Text(
//               '$day',
//               style: AppTextStyles.titleMedium.copyWith(
//                 color: isSelected ? Colors.white : AppColors.textPrimary,
//               ),
//             ),
//           ),
//         ),
//       ));
//     }
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8),
//       child: Wrap(
//         spacing: 6,
//         runSpacing: 6,
//         children: days,
//       ),
//     );
//   }
//
//   Widget _buildTimeSlots() {
//     return GridView.count(
//       crossAxisCount: 3,
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       crossAxisSpacing: 10,
//       mainAxisSpacing: 10,
//       childAspectRatio: 2.5,
//       children: _timeSlots.map((time) {
//         final isSelected = time == _selectedTime;
//         return GestureDetector(
//           onTap: () => setState(() => _selectedTime = time),
//           child: Container(
//             decoration: BoxDecoration(
//               color: isSelected ? AppColors.primary : AppColors.backgroundWhite,
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(
//                 color: isSelected ? AppColors.primary : AppColors.border,
//               ),
//             ),
//             child: Center(
//               child: Text(
//                 time,
//                 style: AppTextStyles.titleSmall.copyWith(
//                   color: isSelected ? Colors.white : AppColors.textPrimary,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
//
//   String _monthYear(DateTime date) {
//     const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
//     return '${months[date.month - 1]} ${date.year}';
//   }
// }
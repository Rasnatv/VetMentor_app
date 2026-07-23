import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';

import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../data/models/questionmodel.dart';
class QuizScreen extends StatefulWidget {
final List<QuestionModel> questions;
const QuizScreen({super.key, required this.questions});

@override
State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
late final List<int?> _selected =
List<int?>.filled(widget.questions.length, null);
int _currentIndex = 0;

void _select(int optionIndex) {
setState(() => _selected[_currentIndex] = optionIndex);
}

void _next() {
if (_currentIndex < widget.questions.length - 1) {
setState(() => _currentIndex++);
} else {
_submit();
}
}

void _previous() {
if (_currentIndex > 0) setState(() => _currentIndex--);
}

void _submit() {
int score = 0;
for (int i = 0; i < widget.questions.length; i++) {
if (_selected[i] == widget.questions[i].correctIndex) score++;
}
Get.off(() => QuizResultScreen(
questions: widget.questions,
selectedAnswers: _selected,
score: score,
));
}

@override
Widget build(BuildContext context) {
final q = widget.questions[_currentIndex];
final progress = (_currentIndex + 1) / widget.questions.length;
final answeredCount = _selected.where((a) => a != null).length;

return Scaffold(
backgroundColor: AppColors.background,
appBar: VetAppBar(title: 'Mock Test'),
body: SafeArea(
child: Padding(
padding: const EdgeInsets.all(AppDimens.paddingLG),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
'Question ${_currentIndex + 1} of ${widget.questions.length}',
style: AppTextStyles.bodyMedium.copyWith(
fontWeight: FontWeight.w700,
color: AppColors.textSecondary,
),
),
Text(
'$answeredCount answered',
style: AppTextStyles.bodyMedium.copyWith(
color: AppColors.textSecondary,
fontSize: 12,
),
),
],
),
const SizedBox(height: 10),
ClipRRect(
borderRadius: BorderRadius.circular(6),
child: LinearProgressIndicator(
value: progress,
minHeight: 6,
backgroundColor: AppColors.borderLight,
valueColor: AlwaysStoppedAnimation(AppColors.primary),
),
),
const SizedBox(height: AppDimens.paddingXL),
Expanded(
child: SingleChildScrollView(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
q.question,
style: AppTextStyles.headlineLarge.copyWith(fontSize: 17, height: 1.35),
),
const SizedBox(height: AppDimens.paddingLG),
...List.generate(q.options.length, (i) {
final isSelected = _selected[_currentIndex] == i;
return Padding(
padding: const EdgeInsets.only(bottom: AppDimens.paddingSM),
child: GestureDetector(
onTap: () => _select(i),
child: Container(
padding: const EdgeInsets.symmetric(
horizontal: AppDimens.paddingMD, vertical: 14),
decoration: BoxDecoration(
color: isSelected
? AppColors.primarySurface
    : AppColors.cardBackground,
borderRadius: BorderRadius.circular(AppDimens.radiusMD),
border: Border.all(
color: isSelected
? AppColors.primary
    : AppColors.borderLight,
width: isSelected ? 1.5 : 1,
),
),
child: Row(
children: [
Icon(
isSelected
? Icons.radio_button_checked_rounded
    : Icons.radio_button_off_rounded,
color: isSelected
? AppColors.primary
    : AppColors.textSecondary,
size: 20,
),
const SizedBox(width: 12),
Expanded(
child: Text(
q.options[i],
style: AppTextStyles.bodyMedium.copyWith(
fontWeight:
isSelected ? FontWeight.w700 : FontWeight.w500,
),
),
),
],
),
),
),
);
}),
],
),
),
),
Row(
children: [
if (_currentIndex > 0)
Expanded(
child: OutlinedButton(
onPressed: _previous,
style: OutlinedButton.styleFrom(
padding: const EdgeInsets.symmetric(vertical: 14),
side: BorderSide(color: AppColors.borderLight),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(AppDimens.radiusMD),
),
),
child: const Text('Previous'),
),
),
if (_currentIndex > 0) const SizedBox(width: AppDimens.paddingMD),
Expanded(
flex: 2,
child: ElevatedButton(
onPressed: _next,
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primary,
foregroundColor: Colors.white,
elevation: 0,
padding: const EdgeInsets.symmetric(vertical: 14),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(AppDimens.radiusMD),
),
),
child: Text(
_currentIndex == widget.questions.length - 1
? 'Submit Test'
    : 'Next',
style: const TextStyle(fontWeight: FontWeight.w700),
),
),
),
],
),
],
),
),
),
);
}
}

class QuizResultScreen extends StatelessWidget {
final List<QuestionModel> questions;
final List<int?> selectedAnswers;
final int score;

const QuizResultScreen({
super.key,
required this.questions,
required this.selectedAnswers,
required this.score,
});

@override
Widget build(BuildContext context) {
final total = questions.length;
final percentage = ((score / total) * 100).round();

return Scaffold(
backgroundColor: AppColors.background,
appBar: AppBar(
title: const Text('Test Result'),
backgroundColor: AppColors.background,
elevation: 0,
foregroundColor: AppColors.textPrimary,
automaticallyImplyLeading: false,
),
body: SafeArea(
child: ListView(
padding: const EdgeInsets.all(AppDimens.paddingLG),
children: [
Container(
width: double.infinity,
padding: const EdgeInsets.symmetric(vertical: AppDimens.paddingXL),
decoration: BoxDecoration(
color: AppColors.cardBackground,
borderRadius: BorderRadius.circular(AppDimens.radiusXL),
border: Border.all(color: AppColors.borderLight),
boxShadow: [
BoxShadow(
color: AppColors.shadowLight,
blurRadius: 10,
offset: const Offset(0, 4)),
],
),
child: Column(
children: [
Icon(
percentage >= 50
? Icons.emoji_events_rounded
    : Icons.refresh_rounded,
color: AppColors.primary,
size: 48,
),
const SizedBox(height: AppDimens.paddingMD),
Text('Your Marks',
style: AppTextStyles.bodyMedium
    .copyWith(color: AppColors.textSecondary)),
const SizedBox(height: 4),
Text(
'$score / $total',
style: AppTextStyles.headlineLarge.copyWith(
fontSize: 34,
fontWeight: FontWeight.w900,
color: AppColors.primary,
),
),
const SizedBox(height: 4),
Text('$percentage% Score',
style: AppTextStyles.bodyMedium
    .copyWith(color: AppColors.textSecondary)),
],
),
),
const SizedBox(height: AppDimens.paddingXL),
Text('Answer Review',
style: AppTextStyles.titleLarge.copyWith(fontSize: 15, fontWeight: FontWeight.w800)),
const SizedBox(height: AppDimens.paddingMD),
...List.generate(questions.length, (i) {
final q = questions[i];
final selected = selectedAnswers[i];
final isCorrect = selected == q.correctIndex;
return Container(
margin: const EdgeInsets.only(bottom: AppDimens.paddingMD),
padding: const EdgeInsets.all(AppDimens.paddingMD),
decoration: BoxDecoration(
color: AppColors.cardBackground,
borderRadius: BorderRadius.circular(AppDimens.radiusLG),
border: Border.all(
color: isCorrect
? Colors.green.withOpacity(0.4)
    : Colors.red.withOpacity(0.35),
),
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Row(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Icon(
isCorrect
? Icons.check_circle_rounded
    : Icons.cancel_rounded,
color: isCorrect ? Colors.green : Colors.red,
size: 18,
),
const SizedBox(width: 8),
Expanded(
child: Text('${i + 1}. ${q.question}',
style: AppTextStyles.bodyMedium
    .copyWith(fontWeight: FontWeight.w700)),
),
],
),
const SizedBox(height: 8),
Text(
'Your answer: ${selected != null ? q.options[selected] : 'Not answered'}',
style: AppTextStyles.bodyMedium.copyWith(
fontSize: 12.5,
color: isCorrect ? Colors.green[700] : Colors.red[700],
),
),
if (!isCorrect)
Padding(
padding: const EdgeInsets.only(top: 3),
child: Text(
'Correct answer: ${q.options[q.correctIndex]}',
style: AppTextStyles.bodyMedium.copyWith(
fontSize: 12.5, color: Colors.green[700]),
),
),
],
),
);
}),
const SizedBox(height: AppDimens.paddingMD),
SizedBox(
width: double.infinity,
child: ElevatedButton(
onPressed: () => Get.back(),
style: ElevatedButton.styleFrom(
backgroundColor: AppColors.primary,
foregroundColor: Colors.white,
elevation: 0,
padding: const EdgeInsets.symmetric(vertical: 14),
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(AppDimens.radiusMD),
),
),
child: const Text('Back to Home', style: TextStyle(fontWeight: FontWeight.w700)),
),
),
],
),
),
);
}
}
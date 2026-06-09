

import 'package:flutter/material.dart';
import 'package:veterinaryapp/app/no%20internetconnection/no_connection.dart';
import '../../../core/constants/appcolors.dart';
import '../../../core/style/dimens.dart';
import '../../../core/style/textstyle.dart';
import '../../../core/utils/responsive utiliteclass.dart';
import '../../../data/models/modelclass.dart';
import '../../../widgets/collegecard.dart';
import '../../../widgets/commonwidget.dart';

import 'collegedtailscreen.dart';

class CollegesScreen extends StatefulWidget {
const CollegesScreen({super.key});

@override
State<CollegesScreen> createState() => _CollegesScreenState();
}

class _CollegesScreenState extends State<CollegesScreen> {
final _searchCtrl = TextEditingController();
String _selectedState = 'All States';
final List<String> _savedIds = [];

// null = show selector, 'temporary' or 'permanent' = show list
String? _affiliationFilter;

List<College> get _filteredColleges {
var colleges = MockData.colleges;
if (_selectedState != 'All States') {
colleges = colleges.where((c) => c.state == _selectedState).toList();
}
if (_searchCtrl.text.isNotEmpty) {
final q = _searchCtrl.text.toLowerCase();
colleges = colleges
    .where((c) =>
c.name.toLowerCase().contains(q) ||
c.location.toLowerCase().contains(q))
    .toList();
}
return colleges;
}

void _toggleSave(String id) {
setState(() {
if (_savedIds.contains(id)) {
_savedIds.remove(id);
} else {
_savedIds.add(id);
}
});
}

void _showStateFilter() {
showModalBottomSheet(
context: context,
isScrollControlled: true,
backgroundColor: Colors.transparent,
builder: (_) => _StateFilterSheet(
states: MockData.indianStates,
selected: _selectedState,
onSelect: (state) {
setState(() => _selectedState = state);
Navigator.pop(context);
},
),
);
}

@override
Widget build(BuildContext context) {
final r = Responsive.of(context);
final colleges = _filteredColleges;

return NetworkAwareWrapper(
child: Scaffold(
backgroundColor: AppColors.background,
appBar: VetAppBar(
showBack: false,
title: 'Veterinary Colleges',
),
body: _affiliationFilter == null
? _AffiliationSelector(
r: r,
onSelect: (type) =>
setState(() => _affiliationFilter = type),
)
    : Column(
children: [
// ── Active affiliation chip (tap × to go back) ──────────
Padding(
padding: EdgeInsets.fromLTRB(
r.spacing(AppDimens.paddingLG),
r.spacing(AppDimens.paddingMD),
r.spacing(AppDimens.paddingLG),
0,
),
child: Row(
children: [
GestureDetector(
onTap: () => setState(() {
_affiliationFilter = null;
_selectedState = 'All States';
_searchCtrl.clear();
}),
child: Container(
padding: EdgeInsets.symmetric(
horizontal: r.spacing(AppDimens.paddingMD),
vertical: r.spacing(AppDimens.paddingXS + 2),
),
decoration: BoxDecoration(
color: AppColors.primarySurface,
borderRadius: BorderRadius.circular(
AppDimens.radiusFull),
border: Border.all(color: AppColors.primary),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Icon(
_affiliationFilter == 'temporary'
? Icons.access_time_rounded
    : Icons.verified_outlined,
size: r.fontSize(AppDimens.iconXS),
color: AppColors.primary,
),
SizedBox(
width: r.spacing(AppDimens.paddingXS)),
Text(
_affiliationFilter == 'temporary'
? 'Temporary Affiliated'
    : 'Permanent Affiliated',
// Poppins w600 — same as titleMedium family
style: AppTextStyles.bodyGreen.copyWith(
fontWeight: FontWeight.w600,
fontSize: r.fontSize(12),
),
),
SizedBox(
width: r.spacing(AppDimens.paddingXS)),
Icon(
Icons.close_rounded,
size: r.fontSize(AppDimens.iconXS),
color: AppColors.primary,
),
],
),
),
),
],
),
),

// ── Search + Filter ─────────────────────────────────────
Padding(
padding: EdgeInsets.fromLTRB(
r.spacing(AppDimens.paddingLG),
r.spacing(AppDimens.paddingMD),
r.spacing(AppDimens.paddingLG),
0,
),
child: AppSearchBar(
hintText: 'Search colleges...',
controller: _searchCtrl,
onChanged: (_) => setState(() {}),
showFilter: true,
onFilterTap: _showStateFilter,
),
),

// ── State filter chip ───────────────────────────────────
if (_selectedState != 'All States')
Padding(
padding: EdgeInsets.fromLTRB(
r.spacing(AppDimens.paddingLG),
r.spacing(AppDimens.paddingSM + 2),
r.spacing(AppDimens.paddingLG),
0,
),
child: Row(
children: [
Container(
padding: EdgeInsets.symmetric(
horizontal: r.spacing(AppDimens.paddingMD),
vertical: r.spacing(AppDimens.paddingXS + 2),
),
decoration: BoxDecoration(
color: AppColors.primarySurface,
borderRadius: BorderRadius.circular(
AppDimens.radiusFull),
border: Border.all(color: AppColors.primary),
),
child: Row(
mainAxisSize: MainAxisSize.min,
children: [
Text(
_selectedState,
// Inter w500 green — bodyGreen
style: AppTextStyles.bodyGreen.copyWith(
fontWeight: FontWeight.w600,
fontSize: r.fontSize(13),
),
),
SizedBox(
width:
r.spacing(AppDimens.paddingXS + 2)),
GestureDetector(
onTap: () => setState(
() => _selectedState = 'All States'),
child: Icon(
Icons.close_rounded,
size: r.fontSize(AppDimens.iconXS),
color: AppColors.primary,
),
),
],
),
),
],
),
),

// ── Count row ───────────────────────────────────────────
Padding(
padding: EdgeInsets.fromLTRB(
r.spacing(AppDimens.paddingLG),
r.spacing(AppDimens.paddingMD),
r.spacing(AppDimens.paddingLG),
0,
),
child: Row(
children: [
Text(
'${colleges.length} Colleges Found',
// Inter w400 secondary — bodyMedium
style: AppTextStyles.bodyMedium.copyWith(
fontSize: r.fontSize(13),
),
),
const Spacer(),
GestureDetector(
onTap: _showStateFilter,
child: Row(
children: [
Icon(
Icons.map_outlined,
size: r.fontSize(AppDimens.iconXS + 2),
color: AppColors.primary,
),
SizedBox(
width: r.spacing(AppDimens.paddingXS)),
Text(
'State Wise',
// Inter w500 green — bodyGreen
style: AppTextStyles.bodyGreen.copyWith(
fontWeight: FontWeight.w600,
fontSize: r.fontSize(13),
),
),
],
),
),
],
),
),

// ── College list ────────────────────────────────────────
Expanded(
child: colleges.isEmpty
? const EmptyState(
title: 'No Colleges Found',
subtitle: 'Try adjusting your search or filter',
icon: Icons.school_outlined,
)
    : ListView.builder(
padding: EdgeInsets.fromLTRB(
r.spacing(AppDimens.paddingLG),
r.spacing(AppDimens.paddingMD),
r.spacing(AppDimens.paddingLG),
100,
),
itemCount: colleges.length,
itemBuilder: (ctx, i) {
final college = colleges[i];
return CollegeCard(
college: college,
isSaved: _savedIds.contains(college.id),
onSave: () => _toggleSave(college.id),
onTap: () => Navigator.push(
context,
MaterialPageRoute(
builder: (_) => CollegeDetailScreen(
college: college,
isSaved:
_savedIds.contains(college.id),
onSave: () =>
_toggleSave(college.id),
),
),
),
);
},
),
),
],
),
),
);
}
}

// ─── Affiliation Selector ─────────────────────────────────────────────────────

class _AffiliationSelector extends StatelessWidget {
final Responsive r;
final ValueChanged<String> onSelect;

const _AffiliationSelector({
required this.r,
required this.onSelect,
});

@override
Widget build(BuildContext context) {
return Padding(
padding: EdgeInsets.fromLTRB(
r.spacing(AppDimens.paddingLG),
r.spacing(AppDimens.paddingMD),
r.spacing(AppDimens.paddingLG),
0,
),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Inter w400 secondary
Text(
'Select Affiliation Type',
style: AppTextStyles.bodyMedium.copyWith(
fontSize: r.fontSize(13),
),
),
SizedBox(height: r.spacing(AppDimens.paddingMD)),

_AffiliationCard(
r: r,
icon: Icons.access_time_rounded,
title: 'Temporary Affiliated',
subtitle: 'Colleges with provisional recognition',
badgeLabel: 'Temporary',
iconBgColor: AppColors.primarySurface,
iconColor: AppColors.primary,
badgeBgColor: AppColors.primarySurface,
badgeTextColor: AppColors.primary,
onTap: () => onSelect('temporary'),
),

SizedBox(height: r.spacing(AppDimens.paddingSM + 2)),

_AffiliationCard(
r: r,
icon: Icons.verified_outlined,
title: 'Permanent Affiliated',
subtitle: 'Colleges with full & permanent recognition',
badgeLabel: 'Permanent',
iconBgColor: const Color(0xFFE8F0FB),
iconColor: const Color(0xFF185FA5),
badgeBgColor: const Color(0xFFE8F0FB),
badgeTextColor: const Color(0xFF185FA5),
onTap: () => onSelect('permanent'),
),
],
),
);
}
}

// ─── Affiliation Card ─────────────────────────────────────────────────────────

class _AffiliationCard extends StatelessWidget {
final Responsive r;
final IconData icon;
final String title;
final String subtitle;
final String badgeLabel;
final Color iconBgColor;
final Color iconColor;
final Color badgeBgColor;
final Color badgeTextColor;
final VoidCallback onTap;

const _AffiliationCard({
required this.r,
required this.icon,
required this.title,
required this.subtitle,
required this.badgeLabel,
required this.iconBgColor,
required this.iconColor,
required this.badgeBgColor,
required this.badgeTextColor,
required this.onTap,
});

@override
Widget build(BuildContext context) {
return GestureDetector(
onTap: onTap,
child: Container(
padding: EdgeInsets.all(r.spacing(AppDimens.paddingMD)),
decoration: BoxDecoration(
color: AppColors.backgroundWhite,
borderRadius: BorderRadius.circular(AppDimens.radiusLG),
border: Border.all(color: AppColors.border),
),
child: Row(
children: [
// icon box
Container(
width: r.spacing(48),
height: r.spacing(48),
decoration: BoxDecoration(
color: iconBgColor,
borderRadius: BorderRadius.circular(AppDimens.radiusMD),
),
child: Icon(
icon,
size: r.fontSize(AppDimens.iconMD),
color: iconColor,
),
),
SizedBox(width: r.spacing(AppDimens.paddingMD)),

Expanded(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
// Poppins w600 14px — titleLarge
Text(
title,
  style: AppTextStyles.titleLarge,
),
SizedBox(height: r.spacing(AppDimens.paddingXS - 2)),
// Inter w400 12px secondary — bodySmall
Text(
subtitle, style: AppTextStyles.bodySmall
),
SizedBox(height: r.spacing(AppDimens.paddingXS + 2)),
// Poppins w500 10px — labelSmall tinted
Container(
padding: EdgeInsets.symmetric(
horizontal: r.spacing(AppDimens.paddingSM + 2),
vertical: r.spacing(AppDimens.paddingXS - 1),
),
decoration: BoxDecoration(
color: badgeBgColor,
borderRadius:
BorderRadius.circular(AppDimens.radiusFull),
),
child: Text(
badgeLabel,
style: AppTextStyles.labelSmall.copyWith(
fontSize: r.fontSize(10),
color: badgeTextColor,
fontWeight: FontWeight.w600,
),
),
),
],
),
),

SizedBox(width: r.spacing(AppDimens.paddingXS)),
Icon(
Icons.arrow_forward_ios_rounded,
size: r.fontSize(AppDimens.iconXS),
color: AppColors.textSecondary,
),
],
),
),
);
}
}

// ─── State Filter Bottom Sheet ────────────────────────────────────────────────

class _StateFilterSheet extends StatelessWidget {
final List<String> states;
final String selected;
final ValueChanged<String> onSelect;

const _StateFilterSheet({
required this.states,
required this.selected,
required this.onSelect,
});

@override
Widget build(BuildContext context) {
final r = Responsive.of(context);

return Container(
decoration: const BoxDecoration(
color: AppColors.backgroundWhite,
borderRadius: BorderRadius.vertical(
top: Radius.circular(AppDimens.radiusXXL),
),
),
child: Column(
mainAxisSize: MainAxisSize.min,
children: [
// Handle
Container(
margin: EdgeInsets.only(top: r.spacing(AppDimens.paddingMD)),
width: r.spacing(40),
height: r.spacing(4),
decoration: BoxDecoration(
color: AppColors.border,
borderRadius: BorderRadius.circular(AppDimens.radiusXS),
),
),

// Header — Poppins w700 — headlineLarge
Padding(
padding: EdgeInsets.fromLTRB(
r.spacing(AppDimens.paddingXL),
r.spacing(AppDimens.paddingLG),
r.spacing(AppDimens.paddingXL),
r.spacing(AppDimens.paddingSM),
),
child: Row(
children: [
Text(
'Filter by State',
style: AppTextStyles.headlineLarge.copyWith(
fontSize: r.fontSize(16),
),
),
const Spacer(),
GestureDetector(
onTap: () => Navigator.pop(context),
child: Icon(
Icons.close_rounded,
color: AppColors.textSecondary,
size: r.fontSize(AppDimens.iconMD),
),
),
],
),
),

const AppDivider(),

// States list
ConstrainedBox(
constraints: BoxConstraints(
maxHeight: MediaQuery.of(context).size.height * 0.55,
),
child: ListView.builder(
shrinkWrap: true,
padding: EdgeInsets.symmetric(
vertical: r.spacing(AppDimens.paddingSM),
),
itemCount: states.length,
itemBuilder: (ctx, i) {
final state = states[i];
final isSelected = state == selected;
return ListTile(
dense: true,
contentPadding: EdgeInsets.symmetric(
horizontal: r.spacing(AppDimens.paddingXL),
vertical: r.spacing(AppDimens.paddingXS),
),
title: Text(
state,
// Poppins w500/w600 — titleMedium
style: AppTextStyles.titleMedium.copyWith(
fontSize: r.fontSize(14),
color: isSelected
? AppColors.primary
    : AppColors.textPrimary,
fontWeight: isSelected
? FontWeight.w600
    : FontWeight.w400,
),
),
trailing: isSelected
? Icon(
Icons.check_circle_rounded,
color: AppColors.primary,
size: r.fontSize(AppDimens.iconSM),
)
    : null,
onTap: () => onSelect(state),
);
},
),
),

SizedBox(
height: MediaQuery.of(context).padding.bottom +
r.spacing(AppDimens.paddingLG),
),
],
),
);
}
}


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../configs/app_theme.dart';
import '../controller/proposal_controller.dart';
import '../models/service_models.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildPackagesScreen extends StatefulWidget {
const BuildPackagesScreen({super.key});

@override
State<BuildPackagesScreen> createState() => _BuildPackagesScreenState();
}

class _BuildPackagesScreenState extends State<BuildPackagesScreen> {
final ProposalController controller = Get.find();

@override
Widget build(BuildContext context) {
return Scaffold(
body: Container(
decoration: const BoxDecoration(
gradient: LinearGradient(
begin: Alignment.topCenter,
end: Alignment.bottomCenter,
colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue],
),
),
child: SafeArea(
child: Column(
children: [
_buildHeader(),
Expanded(
child: Container(
margin: const EdgeInsets.symmetric(horizontal: 16),
decoration: BoxDecoration(
color: AppTheme.lightGray,
borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
boxShadow: [
BoxShadow(
color: Colors.black.withOpacity(0.05),
blurRadius: 20,
offset: const Offset(0, -10),
),
],
),
child: Obx(() => controller.clientInfo.value.numberOfPackages == 0
? Center(
child: Text(
'Please specify number of packages in Client Info',
style: GoogleFonts.inter(fontSize: 18, color: AppTheme.darkGray),
),
)
    : AnimationLimiter(
child: ListView.builder(
padding: const EdgeInsets.all(16),
itemCount: controller.clientInfo.value.numberOfPackages,
itemBuilder: (context, index) {
final packageName = 'Package ${index + 1}';
// Initialize with a default tier if not set
if (!controller.selectedPackages.containsKey(packageName) ||
controller.selectedPackages[packageName]!.name == null) {
controller.selectedPackages[packageName] = ServicePackage(
name: controller.packageTiers.isNotEmpty ? controller.packageTiers.first : '',
description: controller.getPackageDescription(controller.packageTiers.first),
serviceLevels: [],
);
controller.selectedPackages.refresh();
}
return AnimationConfiguration.staggeredList(
position: index,
duration: const Duration(milliseconds: 600),
child: SlideAnimation(
verticalOffset: 50.0,
child: FadeInAnimation(
child: Card(
color: Colors.white,
elevation: 2,
shape: RoundedRectangleBorder(
borderRadius: BorderRadius.circular(16),
side: BorderSide(color: AppTheme.neutralGray.withOpacity(0.2)),
),
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
DropdownButtonFormField<String>(
value: controller.selectedPackages[packageName]!.name.isEmpty
? null
    : controller.selectedPackages[packageName]!.name,
hint: Text('Select Package Tier', style: GoogleFonts.inter(fontSize: 16)),
items: controller.packageTiers.map((tier) {
return DropdownMenuItem(
value: tier,
child: Text(tier, style: GoogleFonts.inter(fontSize: 16)),
);
}).toList(),
onChanged: (value) {
if (value != null) {
controller.selectedPackages[packageName]?.serviceLevels.clear();
controller.selectedPackages[packageName] = ServicePackage(
name: value,
description: controller.getPackageDescription(value),
serviceLevels: [],
);
controller.selectedPackages.refresh();
setState(() {});
}
},
decoration: InputDecoration(
labelText: 'Package Tier',
filled: true,
fillColor: Colors.white,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide.none,
),
enabledBorder: OutlineInputBorder(
borderSide: BorderSide(color: AppTheme.neutralGray.withOpacity(0.3)),
),
focusedBorder: OutlineInputBorder(
borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
),
),
),
const SizedBox(height: 16),
Text(
'Service Levels',
style: GoogleFonts.inter(
fontSize: 18,
fontWeight: FontWeight.w600,
color: AppTheme.darkGray,
),
),
const SizedBox(height: 8),
...controller.availableServices.keys.map((serviceId) {
final isSelected = controller.selectedPackages[packageName]?.serviceLevels.any((s) => s.id == serviceId) ?? false;
return ListTile(
contentPadding: const EdgeInsets.symmetric(vertical: 4),
title: Text(
controller.availableServices[serviceId]!.name,
style: GoogleFonts.inter(fontSize: 16, color: AppTheme.neutralGray),
),
trailing: Checkbox(
value: isSelected,
onChanged: (val) {
if (val == true) {
controller.addServiceToPackage(packageName, serviceId);
} else {
controller.removeServiceFromPackage(packageName, serviceId);
}
setState(() {});
},
activeColor: AppTheme.primaryBlue,
),
);
}).toList(),
],
),
),
),
),
),
);
},
),
)),
),
),
_buildActionButtons(),
],
),
),
),
);
}

Widget _buildHeader() => Padding(
padding: const EdgeInsets.all(24),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
Text(
'Build Packages',
style: GoogleFonts.inter(
color: Colors.white,
fontSize: 24,
fontWeight: FontWeight.w700,
),
),
Text(
'Step 2 of 4',
style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
),
],
),
);

Widget _buildActionButtons() => Padding(
padding: const EdgeInsets.all(16),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
OutlinedButton(
onPressed: () {
controller.previousStep();
Get.toNamed('/client-info');
},
style: OutlinedButton.styleFrom(
side: const BorderSide(color: AppTheme.primaryBlue),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
),
child: Text(
'Previous',
style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontSize: 16),
),
),
ElevatedButton(
onPressed: () {
if (controller.selectedPackages.isEmpty ||
controller.selectedPackages.values.any((p) => p.serviceLevels.isEmpty || p.name.isEmpty)) {
Get.snackbar(
'Error',
'Please select a tier and at least one service for each package',
backgroundColor: Colors.red,
colorText: Colors.white,
snackPosition: SnackPosition.BOTTOM,
);
return;
}
controller.nextStep();
Get.toNamed('/preview');
},
style: ElevatedButton.styleFrom(
backgroundColor: AppTheme.primaryBlue,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
),
child: Text(
'Next',
style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
),
),
],
),
);
}

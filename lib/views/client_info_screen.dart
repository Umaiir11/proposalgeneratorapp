
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../configs/app_theme.dart';
import '../controller/proposal_controller.dart';

class ClientInfoScreen extends StatefulWidget {

const ClientInfoScreen({super.key});

  @override
  State<ClientInfoScreen> createState() => _ClientInfoScreenState();
}

class _ClientInfoScreenState extends State<ClientInfoScreen> {
final ProposalController controller = Get.find();

final _formKey = GlobalKey<FormState>();

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
child: SingleChildScrollView(
padding: const EdgeInsets.all(24),
child: Form(
key: _formKey,
child: AnimationLimiter(
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Client Information',
style: GoogleFonts.inter(
fontSize: 28,
fontWeight: FontWeight.w700,
color: AppTheme.darkGray,
),
).animate().fadeIn(duration: 600.ms),
const SizedBox(height: 8),
Text(
'Enter details to create a personalized proposal.',
style: GoogleFonts.inter(
fontSize: 16,
color: AppTheme.neutralGray,
),
).animate().fadeIn(duration: 600.ms, delay: 200.ms),
const SizedBox(height: 24),
_buildTextField(
label: 'Client Name',
hint: 'Enter client name',
onChanged: (v) => controller.updateClientInfo(clientName: v),
validator: (v) => v?.isEmpty ?? true ? 'Client name is required' : null,
),
const SizedBox(height: 16),
_buildTextField(
label: 'Business Name',
hint: 'Enter business name',
onChanged: (v) => controller.updateClientInfo(businessName: v),
validator: (v) => v?.isEmpty ?? true ? 'Business name is required' : null,
),
const SizedBox(height: 16),
_buildTextField(
label: 'Email Address',
hint: 'Enter email address',
onChanged: (v) => controller.updateClientInfo(email: v),
validator: (v) {
if (v?.isEmpty ?? true) return 'Email is required';
if (!GetUtils.isEmail(v!)) return 'Invalid email format';
return null;
},
keyboardType: TextInputType.emailAddress,
),
const SizedBox(height: 16),
_buildTextField(
label: 'Phone Number',
hint: 'Enter phone number',
onChanged: (v) => controller.updateClientInfo(phone: v),
validator: (v) => v?.isEmpty ?? true ? 'Phone number is required' : null,
keyboardType: TextInputType.phone,
),
const SizedBox(height: 16),
_buildDropdown(
label: 'Number of Package Options',
value: controller.clientInfo.value.numberOfPackages,
items: [1, 2, 3, 4, 5],
onChanged: (v) => controller.updateClientInfo(numberOfPackages: v ?? 1),
),
const SizedBox(height: 24),
],
),
),
),
),
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
'Client Info',
style: GoogleFonts.inter(
color: Colors.white,
fontSize: 24,
fontWeight: FontWeight.w700,
),
),
Text(
'Step 1 of 4',
style: GoogleFonts.inter(
color: Colors.white,
fontSize: 16,
),
),
],
),
);

Widget _buildTextField({
required String label,
required String hint,
required Function(String) onChanged,
String? Function(String?)? validator,
TextInputType? keyboardType,
}) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
label,
style: GoogleFonts.inter(
fontSize: 16,
fontWeight: FontWeight.w600,
color: AppTheme.darkGray,
),
),
const SizedBox(height: 8),
TextFormField(
decoration: InputDecoration(
hintText: hint,
filled: true,
fillColor: Colors.white,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide.none,
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide(color: AppTheme.neutralGray.withOpacity(0.3)),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
),
contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
),
onChanged: onChanged,
validator: validator,
keyboardType: keyboardType,
),
],
).animate().fadeIn(duration: 400.ms);
}

Widget _buildDropdown({
required String label,
required int value,
required List<int> items,
required Function(int?) onChanged,
}) {
return Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
label,
style: GoogleFonts.inter(
fontSize: 16,
fontWeight: FontWeight.w600,
color: AppTheme.darkGray,
),
),
const SizedBox(height: 8),
DropdownButtonFormField<int>(
value: value,
items: items
    .map((v) => DropdownMenuItem(
value: v,
child: Text(
'$v Package${v > 1 ? 's' : ''}',
style: GoogleFonts.inter(fontSize: 16),
),
))
    .toList(),
onChanged: onChanged,
decoration: InputDecoration(
filled: true,
fillColor: Colors.white,
border: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide.none,
),
enabledBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: BorderSide(color: AppTheme.neutralGray.withOpacity(0.3)),
),
focusedBorder: OutlineInputBorder(
borderRadius: BorderRadius.circular(12),
borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
),
contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
),
dropdownColor: Colors.white,
icon: const Icon(Icons.arrow_drop_down, color: AppTheme.primaryBlue),
),
],
).animate().fadeIn(duration: 400.ms);
}

Widget _buildActionButtons() => Padding(
padding: const EdgeInsets.all(16),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
children: [
OutlinedButton(
onPressed: () => Get.toNamed('/dashboard'),
style: OutlinedButton.styleFrom(
side: const BorderSide(color: AppTheme.primaryBlue),
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
),
child: Text(
'Cancel',
style: GoogleFonts.inter(color: AppTheme.primaryBlue, fontSize: 16),
),
),
ElevatedButton(
onPressed: () {
if (_formKey.currentState!.validate()) {
controller.nextStep();
Get.toNamed('/build-packages');
} else {
Get.snackbar('Error', 'Please fill all required fields correctly',
backgroundColor: Colors.red, colorText: Colors.white);
}
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

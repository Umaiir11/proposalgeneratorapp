import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:google_fonts/google_fonts.dart';
import '../configs/app_theme.dart';
import '../controller/proposal_controller.dart';
import '../models/service_models.dart';

class PreviewScreen extends StatefulWidget {

const PreviewScreen({super.key});

  @override
  State<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
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
child: SingleChildScrollView(
padding: const EdgeInsets.all(24),
child: Obx(() => Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'Proposal Preview',
style: GoogleFonts.inter(
fontSize: 28,
fontWeight: FontWeight.w700,
color: AppTheme.darkGray,
),
),
const SizedBox(height: 16),
Text(
'Client Information',
style: GoogleFonts.inter(
fontSize: 18,
fontWeight: FontWeight.w600,
color: AppTheme.darkGray,
),
),
const SizedBox(height: 8),
_buildClientInfo(),
const SizedBox(height: 24),
Text(
'Selected Packages',
style: GoogleFonts.inter(
fontSize: 18,
fontWeight: FontWeight.w600,
color: AppTheme.darkGray,
),
),
const SizedBox(height: 8),
...controller.selectedPackages.entries.map((entry) => _buildPackageCard(entry)),
const SizedBox(height: 32),
Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: [
ElevatedButton(
onPressed: _generatePDF,
style: ElevatedButton.styleFrom(
backgroundColor: AppTheme.primaryBlue,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
),
child: Text(
'Generate PDF',
style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
),
),
// ElevatedButton(
//   onPressed: controller.exportToClipboard,
//   style: ElevatedButton.styleFrom(
//     backgroundColor: AppTheme.successGreen,
//     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//   ),
//   child: Text(
//     'Export to Excel',
//     style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
//   ),
// ),
],
),
],
)),
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
'Preview & Export',
style: GoogleFonts.inter(
color: Colors.white,
fontSize: 24,
fontWeight: FontWeight.w700,
),
),
Text(
'Step 3 of 4',
style: GoogleFonts.inter(
color: Colors.white,
fontSize: 16,
),
),
],
),
);

Widget _buildClientInfo() => Card(
color: Colors.white,
elevation: 2,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text('Name: ${controller.clientInfo.value.clientName}', style: GoogleFonts.inter(fontSize: 16)),
Text('Business: ${controller.clientInfo.value.businessName}', style: GoogleFonts.inter(fontSize: 16)),
Text('Email: ${controller.clientInfo.value.email}', style: GoogleFonts.inter(fontSize: 16)),
Text('Phone: ${controller.clientInfo.value.phone}', style: GoogleFonts.inter(fontSize: 16)),
],
),
),
);

Widget _buildPackageCard(MapEntry<String, ServicePackage> entry) => Card(
color: Colors.white,
elevation: 2,
shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
margin: const EdgeInsets.only(bottom: 16),
child: Padding(
padding: const EdgeInsets.all(16),
child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
children: [
Text(
'${entry.key}: ${entry.value.description}',
style: GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.darkGray),
),
const SizedBox(height: 8),
...entry.value.serviceLevels.map((service) => Text(
'- ${service.name} (${service.frequency})',
style: GoogleFonts.inter(fontSize: 16, color: AppTheme.neutralGray),
)),
],
),
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
Get.toNamed('/build-packages');
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
onPressed: () => Get.toNamed('/settings'),
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

void _generatePDF() async {
final doc = pw.Document();
final font = await PdfGoogleFonts.interRegular();
final boldFont = await PdfGoogleFonts.interBold();

doc.addPage(
pw.MultiPage(
pageFormat: PdfPageFormat.a4,
margin: const pw.EdgeInsets.all(32),
build: (pw.Context context) => [
pw.Header(
level: 0,
child: pw.Text(
controller.brandingText.value,
style: pw.TextStyle(font: boldFont, fontSize: 24, color: PdfColors.blue800),
),
),
pw.SizedBox(height: 20),
pw.Text(
'Service Proposal',
style: pw.TextStyle(font: boldFont, fontSize: 18, color: PdfColors.black),
),
pw.SizedBox(height: 20),
pw.Text(
'Prepared for:',
style: pw.TextStyle(font: boldFont, fontSize: 14, color: PdfColors.grey800),
),
pw.Text(
controller.clientInfo.value.clientName,
style: pw.TextStyle(font: font, fontSize: 14, color: PdfColors.black),
),
pw.Text(
controller.clientInfo.value.businessName,
style: pw.TextStyle(font: font, fontSize: 14, color: PdfColors.black),
),
pw.Text(
controller.clientInfo.value.email,
style: pw.TextStyle(font: font, fontSize: 14, color: PdfColors.black),
),
pw.Text(
controller.clientInfo.value.phone,
style: pw.TextStyle(font: font, fontSize: 14, color: PdfColors.black),
),
pw.SizedBox(height: 30),
pw.Text(
'Proposed Packages:',
style: pw.TextStyle(font: boldFont, fontSize: 16, color: PdfColors.grey800),
),
pw.SizedBox(height: 10),
...controller.selectedPackages.entries.map((entry) => pw.Column(
crossAxisAlignment: pw.CrossAxisAlignment.start,
children: [
pw.Text(
'${entry.key}: ${entry.value.description}',
style: pw.TextStyle(font: boldFont, fontSize: 14, color: PdfColors.black),
),
pw.SizedBox(height: 5),
pw.Bullet(
text: entry.value.serviceLevels
    .map((service) => '${service.name} (${service.frequency})')
    .join('\n'),
style: pw.TextStyle(font: font, fontSize: 12, color: PdfColors.black),
),
pw.SizedBox(height: 15),
],
)),
pw.SizedBox(height: 20),
pw.Text(
'Total Estimated Cost: \$${controller.selectedPackages.values.fold(0.0, (sum, p) => sum + p.serviceLevels.fold(0.0, (s, l) => s + l.price)).toStringAsFixed(2)}',
style: pw.TextStyle(font: boldFont, fontSize: 14, color: PdfColors.black),
),
],
),
);

await Printing.layoutPdf(
onLayout: (PdfPageFormat format) async => doc.save(),
name: 'Proposal_${controller.clientInfo.value.clientName}.pdf',
);
}
}

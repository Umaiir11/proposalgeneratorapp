import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../configs/app_theme.dart';
import '../controller/proposal_controller.dart';

class PreviewScreen extends StatelessWidget {
  final ProposalController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue])),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(32),
                    child: Obx(() => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Preview', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                        SizedBox(height: 16),
                        Text('Client Info:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        Text('Name: ${controller.clientInfo.value.clientName}'),
                        Text('Business: ${controller.clientInfo.value.businessName}'),
                        Text('Email: ${controller.clientInfo.value.email}'),
                        Text('Phone: ${controller.clientInfo.value.phone}'),
                        SizedBox(height: 16),
                        ...controller.selectedPackages.entries.map((entry) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${entry.key}: ${entry.value.description}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                            ...entry.value.serviceLevels.map((service) => Text('- ${service.name} (${service.frequency})')),
                          ],
                        )).toList(),
                        SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(onPressed: _generatePDF, child: Text('Generate PDF')),
                            // ElevatedButton(onPressed: controller.exportToClipboard, child: Text('Export to Excel')),
                          ],
                        ),
                      ],
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generatePDF() async {
    final doc = pw.Document();
    doc.addPage(pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(controller.brandingText.value, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.Text('Service Proposal', style: pw.TextStyle(fontSize: 18)),
          pw.SizedBox(height: 20),
          pw.Text('Client Info:'),
          pw.Text('Name: ${controller.clientInfo.value.clientName}'),
          pw.Text('Business: ${controller.clientInfo.value.businessName}'),
          pw.Text('Email: ${controller.clientInfo.value.email}'),
          pw.Text('Phone: ${controller.clientInfo.value.phone}'),
          pw.SizedBox(height: 20),
          ...controller.selectedPackages.entries.map((entry) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('${entry.key}: ${entry.value.description}', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
              ...entry.value.serviceLevels.map((service) => pw.Text('- ${service.name} (${service.frequency})')),
            ],
          )).toList(),
        ],
      ),
    ));
    await Printing.layoutPdf(onLayout: (format) => doc.save());
  }

  Widget _buildHeader() => Padding(
    padding: EdgeInsets.all(24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Preview & Print', style: TextStyle(color: Colors.white, fontSize: 24)),
        Row(children: [Text('Step 3 of 4', style: TextStyle(color: Colors.white))]),
      ],
    ),
  );
}
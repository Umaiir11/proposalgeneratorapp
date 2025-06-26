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
                          'Financial Statements',
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.darkGray,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...controller.selectedPackages.entries.map((entry) => _buildFinancialStatement(entry)),
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

  Widget _buildFinancialStatement(MapEntry<String, ServicePackage> entry) => Card(
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
          Table(
            border: TableBorder.all(color: AppTheme.neutralGray.withOpacity(0.3)),
            columnWidths: {
              0: const FlexColumnWidth(2),
              1: const FlexColumnWidth(1),
              2: const FlexColumnWidth(1),
              3: const FlexColumnWidth(2),
            },
            children: [
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Service', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Frequency', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Price', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Custom Fields', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              ...entry.value.serviceLevels.map((service) => TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(service.name, style: GoogleFonts.inter(fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(service.frequency, style: GoogleFonts.inter(fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('\$${service.price.toStringAsFixed(2)}', style: GoogleFonts.inter(fontSize: 16)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      service.serviceItems
                          .map((item) => '${item.name}: ${item.selectedValue ?? "Not set"}')
                          .join(', '),
                      style: GoogleFonts.inter(fontSize: 16),
                    ),
                  ),
                ],
              )),
            ],
          ),
          if (entry.value.retainerAmount != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Retainer Amount: \$${entry.value.retainerAmount!.toStringAsFixed(2)}',
                style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Total: \$${controller.getTotalPrice(entry.key, "All").toStringAsFixed(2)}',
              style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
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
            'Financial Statements:',
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
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                columnWidths: {
                  0: const pw.FractionColumnWidth(0.4),
                  1: const pw.FractionColumnWidth(0.2),
                  2: const pw.FractionColumnWidth(0.2),
                  3: const pw.FractionColumnWidth(0.4),
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Service', style: pw.TextStyle(font: boldFont, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Frequency', style: pw.TextStyle(font: boldFont, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Price', style: pw.TextStyle(font: boldFont, fontWeight: pw.FontWeight.bold)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('Custom Fields', style: pw.TextStyle(font: boldFont, fontWeight: pw.FontWeight.bold)),
                      ),
                    ],
                  ),
                  ...entry.value.serviceLevels.map((service) => pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(service.name, style: pw.TextStyle(font: font)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(service.frequency, style: pw.TextStyle(font: font)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text('\$${service.price.toStringAsFixed(2)}', style: pw.TextStyle(font: font)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Text(
                          service.serviceItems
                              .map((item) => '${item.name}: ${item.selectedValue ?? "Not set"}')
                              .join(', '),
                          style: pw.TextStyle(font: font),
                        ),
                      ),
                    ],
                  )),
                ],
              ),
              if (entry.value.retainerAmount != null)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 8),
                  child: pw.Text(
                    'Retainer Amount: \$${entry.value.retainerAmount!.toStringAsFixed(2)}',
                    style: pw.TextStyle(font: boldFont, fontSize: 12),
                  ),
                ),
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 8),
                child: pw.Text(
                  'Total: \$${controller.getTotalPrice(entry.key, "All").toStringAsFixed(2)}',
                  style: pw.TextStyle(font: boldFont, fontSize: 12),
                ),
              ),
              pw.SizedBox(height: 15),
            ],
          )),
          pw.SizedBox(height: 20),
          pw.Text(
            'Total Estimated Cost: \$${controller.selectedPackages.values.fold(0.0, (sum, p) => sum + p.serviceLevels.fold(0.0, (s, l) => s + l.price) + (p.retainerAmount ?? 0.0)).toStringAsFixed(2)}',
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
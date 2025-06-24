import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../configs/app_theme.dart';
import '../controller/proposal_controller.dart';

class ClientInfoScreen extends StatelessWidget {
  final ProposalController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
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
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(32),
                    child: Form(
                      key: _formKey,
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
                          ).animate().fadeIn(duration: 500.ms),
                          SizedBox(height: 8),
                          Text(
                            'Let\'s start by gathering some basic information about your client.',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              color: AppTheme.neutralGray,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 32),
                          _buildTextField(
                            label: 'Client Name',
                            hint: 'Enter client name',
                            onChanged: (v) => controller.updateClientInfo(clientName: v),
                            validator: (v) => v?.isEmpty ?? true ? 'Client name is required' : null,
                          ),
                          SizedBox(height: 20),
                          _buildTextField(
                            label: 'Business Name',
                            hint: 'Enter business name',
                            onChanged: (v) => controller.updateClientInfo(businessName: v),
                            validator: (v) => v?.isEmpty ?? true ? 'Business name is required' : null,
                          ),
                          SizedBox(height: 20),
                          _buildTextField(
                            label: 'Email Address',
                            hint: 'Enter email address',
                            onChanged: (v) => controller.updateClientInfo(email: v),
                            validator: (v) {
                              if (v?.isEmpty ?? true) return 'Email is required';
                              if (!GetUtils.isEmail(v!)) return 'Please enter a valid email address';
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                          ),
                          SizedBox(height: 20),
                          _buildTextField(
                            label: 'Phone Number',
                            hint: 'Enter phone number',
                            onChanged: (v) => controller.updateClientInfo(phone: v),
                            validator: (v) => v?.isEmpty ?? true ? 'Phone number is required' : null,
                            keyboardType: TextInputType.phone,
                          ),
                          SizedBox(height: 20),
                          _buildDropdown(
                            label: 'Number of Package Options',
                            value: controller.clientInfo.value.numberOfPackages,
                            items: [1, 2, 3, 4, 5],
                            onChanged: (v) => controller.updateClientInfo(numberOfPackages: v ?? 1),
                          ),
                          SizedBox(height: 48),
                        ],
                      ).animate().fadeIn(duration: 600.ms),
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
    padding: EdgeInsets.all(24),
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
        Row(
          children: [
            Text(
              'Step 1 of 4',
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
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
        SizedBox(height: 8),
        TextFormField(
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.neutralGray.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.neutralGray.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          onChanged: onChanged,
          validator: validator,
          keyboardType: keyboardType,
        ),
      ],
    );
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
        SizedBox(height: 8),
        DropdownButtonFormField<int>(
          value: value,
          items: items.map((v) => DropdownMenuItem(
            value: v,
            child: Text(
              '$v Package${v > 1 ? 's' : ''}',
              style: GoogleFonts.inter(fontSize: 16),
            ),
          )).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.neutralGray.withOpacity(0.3)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.neutralGray.withOpacity(0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          dropdownColor: Colors.white,
          icon: Icon(Icons.arrow_drop_down, color: AppTheme.primaryBlue),
        ),
      ],
    );
  }

  Widget _buildActionButtons() => Padding(
    padding: EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: Get.back,
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(
              color: AppTheme.primaryBlue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppTheme.primaryBlue),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
        SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              print('Form validated, moving to next step: ${controller.currentStep.value + 1}');
              controller.nextStep();
              Get.toNamed('/build-packages'); // Explicit navigation to next screen
            }
          },
          child: Text(
            'Next',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
      ],
    ),
  );
}
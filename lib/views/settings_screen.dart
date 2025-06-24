import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../configs/app_theme.dart';
import '../controller/proposal_controller.dart';

class SettingsScreen extends StatelessWidget {
  final ProposalController controller = Get.find();
  final _formKey = GlobalKey<FormState>();
  final _newTierController = TextEditingController();

  SettingsScreen({super.key});

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
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(30),
                    ),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Settings',
                            style: GoogleFonts.inter(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.darkGray,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Branding',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkGray,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => TextFormField(
                              initialValue: controller.brandingText.value,
                              decoration: InputDecoration(
                                labelText: 'Branding Text',
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppTheme.neutralGray.withOpacity(
                                      0.3,
                                    ),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: AppTheme.primaryBlue,
                                    width: 2,
                                  ),
                                ),
                              ),
                              onChanged: (v) =>
                                  controller.brandingText.value = v,
                              validator: (v) => v?.isEmpty ?? true
                                  ? 'Branding text is required'
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Package Tiers',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkGray,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Obx(
                            () => Column(
                              children: controller.packageTiers
                                  .map(
                                    (tier) => ListTile(
                                      title: Text(
                                        tier,
                                        style: GoogleFonts.inter(fontSize: 16),
                                      ),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          Icons.delete,
                                          color: AppTheme.primaryBlue,
                                        ),
                                        onPressed: () {
                                          controller.packageTiers.remove(tier);
                                          controller.saveSettings();
                                        },
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _newTierController,
                            decoration: InputDecoration(
                              labelText: 'Add New Tier',
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppTheme.neutralGray.withOpacity(0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: AppTheme.primaryBlue,
                                  width: 2,
                                ),
                              ),
                            ),
                            onFieldSubmitted: (v) {
                              if (v.isNotEmpty &&
                                  !controller.packageTiers.contains(v)) {
                                controller.packageTiers.add(v);
                                controller.saveSettings();
                                _newTierController.clear();
                              } else if (controller.packageTiers.contains(v)) {
                                Get.snackbar(
                                  'Error',
                                  'Tier already exists',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              }
                            },
                          ),
                          const SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                controller.saveSettings();
                                Get.snackbar(
                                  'Success',
                                  'Settings saved',
                                  backgroundColor: AppTheme.successGreen,
                                  colorText: Colors.white,
                                );
                                Get.toNamed('/dashboard');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primaryBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: Text(
                              'Save Settings',
                              style: GoogleFonts.inter(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
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
          'Settings',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          'Step 4 of 4',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
        ),
      ],
    ),
  );
}

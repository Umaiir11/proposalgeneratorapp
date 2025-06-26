import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../configs/app_theme.dart';
import '../controller/proposal_controller.dart';
import '../models/service_models.dart';

class BuildPackagesScreen extends StatefulWidget {
  const BuildPackagesScreen({super.key});

  @override
  State<BuildPackagesScreen> createState() => _BuildPackagesScreenState();
}

class _BuildPackagesScreenState extends State<BuildPackagesScreen> {
  final ProposalController controller = Get.find();
  final Map<String, TextEditingController> _packageNameControllers = {};
  final Map<String, TextEditingController> _retainerControllers = {};
  final Map<String, String?> _selectedTiers = {};
  final Map<String, bool> _isExpanded = {};

  @override
  void initState() {
    super.initState();
    for (int i = 1; i <= controller.clientInfo.value.numberOfPackages; i++) {
      final packageName = 'Package $i';
      _packageNameControllers[packageName] = TextEditingController(text: packageName);
      _retainerControllers[packageName] = TextEditingController();
      _selectedTiers[packageName] = null;
      _isExpanded[packageName] = true; // Default to expanded
    }
  }

  @override
  void dispose() {
    _packageNameControllers.forEach((_, controller) => controller.dispose());
    _retainerControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

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
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.transparent,
                flexibleSpace: _buildHeader(),
                automaticallyImplyLeading: false,
              ),
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: Obx(() {
                    if (controller.clientInfo.value.numberOfPackages == 0) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.info_outline, size: 48, color: AppTheme.neutralGray),
                              const SizedBox(height: 16),
                              Text(
                                'Please specify number of packages in Client Info',
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  color: AppTheme.darkGray,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return AnimationLimiter(
                      child: Column(
                        children: List.generate(
                          controller.clientInfo.value.numberOfPackages,
                              (index) {
                            final packageKey = 'Package ${index + 1}';
                            final packageName = _packageNameControllers[packageKey]?.text ?? packageKey;
                            if (!controller.selectedPackages.containsKey(packageName)) {
                              controller.selectedPackages[packageName] = ServicePackage(
                                name: packageName,
                                description: controller.getPackageDescription(
                                    _selectedTiers[packageKey] ?? controller.packageTiers.first),
                                serviceLevels: [],
                                tier: _selectedTiers[packageKey],
                              );
                            }
                            return AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                verticalOffset: 30.0,
                                child: FadeInAnimation(
                                  child: _buildPackageCard(packageKey, packageName, isMobile),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildActionButtons(isMobile),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: isMobile ? 80 : 40),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: 1.0,
        child: FloatingActionButton(
          onPressed: controller.loadServicesFromFile,
          child: const Icon(
            Icons.upload_file,
            semanticLabel: 'Upload Services File',
            color: Colors.white,
          ),
          backgroundColor: AppTheme.primaryBlue,
          tooltip: 'Upload CSV or XLSX file',
          elevation: 6,
          hoverElevation: 12,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildHeader() => Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Build Packages',
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            'Step 2 of 4',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _buildPackageCard(String packageKey, String packageName, bool isMobile) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ExpansionTile(
        initiallyExpanded: _isExpanded[packageKey] ?? true,
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded[packageKey] = expanded;
          });
        },
        title: Text(
          packageName,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppTheme.darkGray,
          ),
        ),
        trailing: Icon(
          _isExpanded[packageKey] ?? true ? Icons.expand_less : Icons.expand_more,
          color: AppTheme.primaryBlue,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Package Name
                TextFormField(
                  controller: _packageNameControllers[packageKey],
                  decoration: _inputDecoration('Package Name'),
                  style: GoogleFonts.inter(fontSize: 16),
                  onChanged: (value) {
                    final oldName = packageKey;
                    if (value.isNotEmpty && value != oldName) {
                      final package = controller.selectedPackages[oldName]!;
                      controller.selectedPackages.remove(oldName);
                      controller.selectedPackages[value] = package.copyWith(name: value);
                      _packageNameControllers[value] = _packageNameControllers[oldName]!;
                      _packageNameControllers.remove(oldName);
                      _retainerControllers[value] = _retainerControllers[oldName]!;
                      _retainerControllers.remove(oldName);
                      _selectedTiers[value] = _selectedTiers[oldName];
                      _selectedTiers.remove(oldName);
                      _isExpanded[value] = _isExpanded[oldName] ?? true;
                      _isExpanded.remove(oldName);
                      controller.selectedPackages.refresh();
                      setState(() {});
                    }
                  },
                ),
                const SizedBox(height: 12),
                // Package Tier
                DropdownButtonFormField<String>(
                  value: _selectedTiers[packageKey],
                  hint: Text('Select Tier', style: GoogleFonts.inter(fontSize: 16)),
                  items: controller.packageTiers.map((tier) {
                    return DropdownMenuItem<String>(
                      value: tier,
                      child: Text(tier, style: GoogleFonts.inter(fontSize: 16)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.updatePackageTier(packageName, value);
                      _selectedTiers[packageKey] = value;
                      setState(() {});
                    }
                  },
                  decoration: _inputDecoration('Package Tier'),
                ),
                const SizedBox(height: 12),
                // Retainer Amount
                TextFormField(
                  controller: _retainerControllers[packageKey],
                  decoration: _inputDecoration('Retainer Amount', prefixText: '\$ '),
                  style: GoogleFonts.inter(fontSize: 16),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    controller.updateRetainerAmount(packageName, double.tryParse(value));
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Services',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.darkGray,
                  ),
                ),
                const SizedBox(height: 8),
                // Service Selection
                ...controller.availableServices.keys.map((serviceId) {
                  final isSelected = controller.selectedPackages[packageName]?.serviceLevels.any((s) => s.id == serviceId) ?? false;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          if (value == true) {
                            controller.addServiceToPackage(packageName, serviceId);
                          } else {
                            controller.removeServiceFromPackage(packageName, serviceId);
                          }
                          setState(() {});
                        },
                        title: Text(
                          controller.availableServices[serviceId]!.name,
                          style: GoogleFonts.inter(fontSize: 16, color: AppTheme.darkGray),
                        ),
                        activeColor: AppTheme.primaryBlue,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      ),
                      if (isSelected)
                        Padding(
                          padding: const EdgeInsets.only(left: 32, bottom: 8),
                          child: Column(
                            children: controller.availableServices[serviceId]!.serviceItems.map((item) {
                              if (item.optionType == 'dropdown') {
                                return DropdownButtonFormField<String>(
                                  value: item.selectedValue as String?,
                                  hint: Text('Select ${item.name}', style: GoogleFonts.inter(fontSize: 14)),
                                  items: item.options.map((option) {
                                    return DropdownMenuItem<String>(
                                      value: option,
                                      child: Text(option, style: GoogleFonts.inter(fontSize: 14)),
                                    );
                                  }).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      controller.updateServiceItemValue(packageName, serviceId, item.name, value);
                                      setState(() {});
                                    }
                                  },
                                  decoration: _inputDecoration(item.name, fontSize: 14),
                                );
                              } else {
                                return TextFormField(
                                  initialValue: item.selectedValue?.toString(),
                                  decoration: _inputDecoration(item.name, fontSize: 14),
                                  style: GoogleFonts.inter(fontSize: 14),
                                  onChanged: (value) {
                                    controller.updateServiceItemValue(packageName, serviceId, item.name, value);
                                  },
                                );
                              }
                            }).toList(),
                          ),
                        ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String label, {String? prefixText, double fontSize = 16}) {
    return InputDecoration(
      labelText: label,
      labelStyle: GoogleFonts.inter(color: AppTheme.darkGray, fontSize: fontSize),
      prefixText: prefixText,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppTheme.neutralGray.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppTheme.primaryBlue, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  Widget _buildActionButtons(bool isMobile) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        OutlinedButton(
          onPressed: () {
            controller.previousStep();
            Get.toNamed('/client-info');
          },
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppTheme.primaryBlue, width: 2),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            backgroundColor: Colors.white.withOpacity(0.1),
          ),
          child: Text(
            'Back',
            style: GoogleFonts.inter(
              color: AppTheme.primaryBlue,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.selectedPackages.isEmpty ||
                controller.selectedPackages.values.any((p) => p.serviceLevels.isEmpty || p.name.isEmpty)) {
              Get.snackbar(
                'Error',
                'Please select at least one service for each package',
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
                snackPosition: SnackPosition.TOP,
                margin: const EdgeInsets.all(16),
                borderRadius: 12,
                duration: const Duration(seconds: 3),
              );
              return;
            }
            controller.nextStep();
            Get.toNamed('/preview');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.primaryBlue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            elevation: 4,
            shadowColor: Colors.black.withOpacity(0.3),
          ),
          child: Text(
            'Next',
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
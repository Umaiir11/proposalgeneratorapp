import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../configs/app_theme.dart';
import '../controller/proposal_controller.dart';
import '../models/service_models.dart';

class BuildPackagesScreen extends StatelessWidget {
  final ProposalController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [AppTheme.primaryBlue, AppTheme.secondaryBlue]),
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
                  ),
                  child: Obx(() => AnimationLimiter(
                    child: ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: controller.clientInfo.value.numberOfPackages,
                      itemBuilder: (context, index) {
                        final packageName = 'Package ${index + 1}';
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Card(
                                elevation: 4,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                child: Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      DropdownButtonFormField<String>(
                                        value: controller.selectedPackages.keys.contains(packageName)
                                            ? controller.selectedPackages.keys.firstWhere((k) => k == packageName, orElse: () => '')
                                            : null,
                                        hint: Text('Select Package Tier'),
                                        items: controller.packageTiers.map((tier) => DropdownMenuItem(
                                          value: tier,
                                          child: Text(tier, style: TextStyle(fontSize: 16)),
                                        )).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            // Ensure atomic update to prevent multiple rebuilds
                                            controller.selectedPackages[packageName]?.serviceLevels.clear(); // Clear existing services
                                            controller.selectedPackages[packageName] = ServicePackage(
                                              name: value,
                                              description: controller.getPackageDescription(value),
                                            );
                                            controller.selectedPackages.removeWhere((key, _) => key != value && key.startsWith('Package ${index + 1}'));
                                            controller.selectedPackages.refresh(); // Manually trigger refresh
                                          }
                                        },
                                        decoration: InputDecoration(
                                          labelText: 'Package Tier',
                                          filled: true,
                                          fillColor: Colors.white,
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: AppTheme.neutralGray.withOpacity(0.3)),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(color: AppTheme.primaryBlue, width: 2),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Service Levels',
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppTheme.darkGray),
                                      ),
                                      SizedBox(height: 8),
                                      ...controller.availableServices.keys.map((serviceId) {
                                        final isSelected = controller.selectedPackages[packageName]?.serviceLevels.any((s) => s.id == serviceId) ?? false;
                                        return ListTile(
                                          contentPadding: EdgeInsets.symmetric(vertical: 4),
                                          title: Text(
                                            controller.availableServices[serviceId]!.name,
                                            style: TextStyle(fontSize: 16, color: AppTheme.neutralGray),
                                          ),
                                          trailing: Checkbox(
                                            value: isSelected,
                                            onChanged: (val) {
                                              if (val == true) {
                                                controller.addServiceToPackage(packageName, serviceId);
                                              } else {
                                                controller.removeServiceFromPackage(packageName, serviceId);
                                              }
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
    padding: EdgeInsets.all(24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Build Packages',
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w700),
        ),
        Row(children: [Text('Step 2 of 4', style: TextStyle(color: Colors.white, fontSize: 16))]),
      ],
    ),
  );

  Widget _buildActionButtons() => Padding(
    padding: EdgeInsets.all(16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        OutlinedButton(
          onPressed: controller.previousStep,
          child: Text('Previous', style: TextStyle(color: AppTheme.primaryBlue, fontSize: 16)),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: AppTheme.primaryBlue),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
        ),
        SizedBox(width: 16),
        ElevatedButton(
          onPressed: () {
            print('Next button pressed, current step: ${controller.currentStep.value}');
            controller.nextStep();
            Get.toNamed('/preview'); // Navigate to preview screen
          },
          child: Text('Next', style: TextStyle(color: Colors.white, fontSize: 16)),
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
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../configs/app_theme.dart';
import '../controller/proposal_controller.dart';


class SettingsScreen extends StatelessWidget {
  final ProposalController controller = Get.find();
  final _formKey = GlobalKey<FormState>();

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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Settings', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700)),
                          SizedBox(height: 16),
                          Text('Branding', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          TextFormField(
                            initialValue: controller.brandingText.value,
                            decoration: InputDecoration(labelText: 'Branding Text'),
                            onChanged: (v) => controller.brandingText.value = v,
                          ),
                          SizedBox(height: 16),
                          Text('Package Tiers', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                          Obx(() => Column(
                            children: controller.packageTiers.map((tier) => ListTile(
                              title: Text(tier),
                              trailing: IconButton(icon: Icon(Icons.delete), onPressed: () => controller.packageTiers.remove(tier)),
                            )).toList(),
                          )),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Add New Tier'),
                            onFieldSubmitted: (v) {
                              if (v.isNotEmpty && !controller.packageTiers.contains(v)) {
                                controller.packageTiers.add(v);
                                controller.saveSettings();
                              }
                            },
                          ),
                          SizedBox(height: 32),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                controller.saveSettings();
                                Get.back();
                              }
                            },
                            child: Text('Save Settings'),
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
    padding: EdgeInsets.all(24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Settings', style: TextStyle(color: Colors.white, fontSize: 24)),
        Row(children: [Text('Step 4 of 4', style: TextStyle(color: Colors.white))]),
      ],
    ),
  );
}
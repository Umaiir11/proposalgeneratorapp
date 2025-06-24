import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:proposalgeneratorapp/views/build_packages_screen.dart';
import 'package:proposalgeneratorapp/views/client_info_screen.dart';
import 'package:proposalgeneratorapp/views/dashboard_screen.dart';
import 'package:proposalgeneratorapp/views/preview_screen.dart';
import 'package:proposalgeneratorapp/views/settings_screen.dart';

import 'configs/app_theme.dart';
import 'controller/proposal_controller.dart';


void main() async {
  await GetStorage.init();
  runApp(ProposalGeneratorApp());
}

class ProposalGeneratorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(ProposalController());
    return GetMaterialApp(
      title: 'Performance Financial - Proposal Generator',
      theme: AppTheme.lightTheme,
      initialRoute: '/dashboard',
      getPages: [
        GetPage(name: '/dashboard', page: () => DashboardScreen()),
        GetPage(name: '/client-info', page: () => ClientInfoScreen()),
        GetPage(name: '/build-packages', page: () => BuildPackagesScreen()),
        GetPage(name: '/preview', page: () => PreviewScreen()),
        GetPage(name: '/settings', page: () => SettingsScreen()),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
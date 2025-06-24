import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'views/client_info_screen.dart';
import 'views/build_packages_screen.dart';
import 'views/preview_screen.dart';
import 'views/settings_screen.dart';
import 'views/dashboard_screen.dart';
import 'controller/proposal_controller.dart';
import 'configs/app_theme.dart';

void main() async {
  await GetStorage.init();
  Get.put(ProposalController());
  runApp(const ProposalGeneratorApp());
}

class ProposalGeneratorApp extends StatelessWidget {
  const ProposalGeneratorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Performance Financial - Proposal Generator',
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.interTextTheme(
          Theme
              .of(context)
              .textTheme
              .apply(
            bodyColor: AppTheme.darkGray,
            displayColor: AppTheme.darkGray,
          ),
        ),
      ),
      initialRoute: '/dashboard',
      getPages: [
        GetPage(name: '/dashboard',
            page: () =>  DashboardScreen(),
            transition: Transition.fadeIn),
        GetPage(name: '/client-info',
            page: () =>  ClientInfoScreen(),
            transition: Transition.rightToLeft),
        GetPage(name: '/build-packages',
            page: () =>  BuildPackagesScreen(),
            transition: Transition.rightToLeft),
        GetPage(name: '/preview',
            page: () =>  PreviewScreen(),
            transition: Transition.rightToLeft),
        GetPage(name: '/settings',
            page: () =>  SettingsScreen(),
            transition: Transition.rightToLeft),
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}

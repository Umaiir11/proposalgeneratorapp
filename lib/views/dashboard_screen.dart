import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../configs/app_theme.dart';

class DashboardScreen extends StatelessWidget {
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
              Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text('Performance Financial', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white)),
                    Text('Proposal Generator', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.9))),
                  ],
                ).animate().fadeIn(),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.description_outlined, size: 80, color: AppTheme.primaryBlue).animate().scale(),
                        SizedBox(height: 32),
                        Text('Create Professional Proposals', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: AppTheme.darkGray)),
                        SizedBox(height: 16),
                        Text('Build customized service packages with our intuitive proposal generator.', style: TextStyle(fontSize: 16, color: AppTheme.neutralGray)),
                        SizedBox(height: 48),
                        ElevatedButton.icon(
                          onPressed: () => Get.toNamed('/client-info'),
                          icon: Icon(Icons.add_circle_outline),
                          label: Text('Create New Proposal'),
                        ),
                      ],
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
}
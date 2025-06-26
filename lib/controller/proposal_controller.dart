import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../configs/app_theme.dart';
import '../models/service_models.dart';

class ProposalController extends GetxController {
  final clientInfo = ClientInfo().obs;
  final selectedPackages = <String, ServicePackage>{}.obs;
  final currentStep = 0.obs;
  final availableServices = <String, ServiceLevel>{}.obs;
  final box = GetStorage();
  final packageTiers = <String>['Bronze', 'Silver', 'Gold'].obs;
  final brandingText = 'Performance Financial'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadSettings();
    _loadClientInfo();
    _loadServices(); // Load default services or from storage
  }

  // Load client info from storage
  void _loadClientInfo() {
    if (box.read('clientInfo') != null) {
      clientInfo.value = ClientInfo.fromJson(box.read('clientInfo'));
    }
  }

  // Load services (default or from storage)
  void _loadServices() {
    if (box.read('services') != null) {
      availableServices.value = (box.read('services') as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, ServiceLevel.fromJson(value)),
      );
    } else {
      // Default services as fallback
      availableServices.addAll({
        'bookkeeping': ServiceLevel(
          id: 'bookkeeping',
          name: 'Bookkeeping',
          description: 'Recurring bookkeeping service',
          frequency: 'Monthly',
          price: 500.0,
          serviceItems: [
            ServiceItem(
              name: 'Transaction Volume',
              explanation: 'Number of transactions per month',
              optionType: 'dropdown',
              options: ['0-50', '51-100', '101-200'],
              selectedValue: null,
            ),
          ],
        ),
        'cleanup_bookkeeping': ServiceLevel(
          id: 'cleanup_bookkeeping',
          name: 'Cleanup Bookkeeping',
          description: 'One-time cleanup of prior bookkeeping',
          frequency: 'One-Time',
          price: 1000.0,
          serviceItems: [
            ServiceItem(
              name: 'Period to Clean',
              explanation: 'Specify the period for cleanup',
              optionType: 'text',
              options: [],
              selectedValue: null,
            ),
          ],
        ),
      });
      saveServices();
    }
  }

  // Load services from CSV or XLSX
  Future<void> loadServicesFromFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'xlsx'],
        withData: true, // Read file bytes directly
      );
      if (result != null && result.files.single.bytes != null) {
        final file = result.files.single;
        final extension = file.extension?.toLowerCase();

        if (extension != 'csv' && extension != 'xlsx') {
          Get.snackbar(
            'Error',
            'Please select a .csv or .xlsx file',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }

        availableServices.clear();

        if (extension == 'csv') {
          // Parse CSV
          final csvString = utf8.decode(file.bytes!);
          final csvData = const CsvToListConverter().convert(csvString, eol: '\n');

          for (var row in csvData.skip(1)) {
            // Skip header
            if (row.length < 5) continue; // Skip malformed rows
            final serviceId = row[0].toString();
            final service = ServiceLevel(
              id: serviceId,
              name: row[1].toString(),
              description: row[2].toString(),
              frequency: row[3].toString(),
              price: double.tryParse(row[4].toString()) ?? 0.0,
              serviceItems: _parseServiceItems(row.length > 5 ? row[5].toString() : '[]'),
            );
            availableServices[serviceId] = service;
          }
        } else if (extension == 'xlsx') {
          // Parse XLSX
          final excel = Excel.decodeBytes(file.bytes!);
          final sheet = excel.tables.keys.firstOrNull;
          if (sheet == null) {
            Get.snackbar(
              'Error',
              'No valid sheets found in the Excel file',
              backgroundColor: Colors.red,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
            );
            return;
          }

          final rows = excel.tables[sheet]!.rows;
          for (var row in rows.skip(1)) {
            // Skip header
            if (row.length < 5) continue; // Skip malformed rows
            final serviceId = row[0]?.value?.toString() ?? '';
            if (serviceId.isEmpty) continue;
            final service = ServiceLevel(
              id: serviceId,
              name: row[1]?.value?.toString() ?? '',
              description: row[2]?.value?.toString() ?? '',
              frequency: row[3]?.value?.toString() ?? '',
              price: double.tryParse(row[4]?.value?.toString() ?? '0.0') ?? 0.0,
              serviceItems: _parseServiceItems(row.length > 5 && row[5]?.value != null ? row[5]!.value.toString() : '[]'),
            );
            availableServices[serviceId] = service;
          }
        }

        saveServices();
        Get.snackbar(
          'Success',
          'Services loaded from ${file.name}',
          backgroundColor: AppTheme.successGreen,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        Get.snackbar(
          'Error',
          'No file selected',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load file: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Parse custom fields from CSV or XLSX (JSON or comma-separated)
  List<ServiceItem> _parseServiceItems(String customFields) {
    try {
      final decoded = jsonDecode(customFields) as List;
      return decoded.map((item) => ServiceItem(
        name: item['name']?.toString() ?? '',
        explanation: item['explanation']?.toString() ?? '',
        optionType: item['type']?.toString() ?? 'text',
        options: item['options'] != null ? List<String>.from(item['options']) : [],
        selectedValue: null,
      )).toList();
    } catch (e) {
      // Fallback for comma-separated fields
      return customFields.split(',').map((field) => ServiceItem(
        name: field.trim(),
        explanation: '',
        optionType: 'text',
        options: [],
        selectedValue: null,
      )).toList().where((item) => item.name.isNotEmpty).toList();
    }
  }

  // Save services to storage
  void saveServices() {
    box.write('services', availableServices.map((key, value) => MapEntry(key, value.toJson())));
  }

  // Load settings from storage
  void _loadSettings() {
    packageTiers.value = (box.read('packageTiers') ?? ['Bronze', 'Silver', 'Gold']).cast<String>();
    brandingText.value = box.read('brandingText') ?? 'Performance Financial';
  }

  // Save settings to storage
  void saveSettings() {
    box.write('packageTiers', packageTiers.toList());
    box.write('brandingText', brandingText.value);
  }

  // Update client information
  void updateClientInfo({
    String? clientName,
    String? businessName,
    String? email,
    String? phone,
    int? numberOfPackages,
  }) {
    final info = clientInfo.value;
    if (clientName?.isNotEmpty ?? false) info.clientName = clientName!;
    if (businessName?.isNotEmpty ?? false) info.businessName = businessName!;
    if (email?.isNotEmpty ?? false) info.email = email!;
    if (phone?.isNotEmpty ?? false) info.phone = phone!;
    if (numberOfPackages != null && numberOfPackages > 0) info.numberOfPackages = numberOfPackages;
    clientInfo.value = ClientInfo(
      clientName: info.clientName,
      businessName: info.businessName,
      email: info.email,
      phone: info.phone,
      numberOfPackages: info.numberOfPackages,
    );
    box.write('clientInfo', clientInfo.value.toJson());
    clientInfo.refresh();
  }

  // Add a service to a package
  void addServiceToPackage(String packageName, String serviceId) {
    if (!selectedPackages.containsKey(packageName)) {
      selectedPackages[packageName] = ServicePackage(
        name: packageName,
        description: getPackageDescription(packageTiers.first),
        serviceLevels: [],
        retainerAmount: null,
        tier: null,
      );
    }
    if (availableServices.containsKey(serviceId)) {
      final package = selectedPackages[packageName]!;
      final service = ServiceLevel(
        id: availableServices[serviceId]!.id,
        name: availableServices[serviceId]!.name,
        description: availableServices[serviceId]!.description,
        frequency: availableServices[serviceId]!.frequency,
        price: availableServices[serviceId]!.price,
        serviceItems: availableServices[serviceId]!.serviceItems.map((item) => ServiceItem(
          name: item.name,
          explanation: item.explanation,
          optionType: item.optionType,
          options: List.from(item.options),
          selectedValue: null,
        )).toList(),
      );
      package.serviceLevels.add(service);
      selectedPackages[packageName] = package;
      selectedPackages.refresh();
    }
  }

  // Remove a service from a package
  void removeServiceFromPackage(String packageName, String serviceId) {
    if (selectedPackages.containsKey(packageName)) {
      final package = selectedPackages[packageName]!;
      package.serviceLevels.removeWhere((s) => s.id == serviceId);
      selectedPackages[packageName] = package;
      selectedPackages.refresh();
    }
  }

  // Update a service item's value
  void updateServiceItemValue(String packageName, String serviceId, String itemName, dynamic value) {
    if (selectedPackages.containsKey(packageName)) {
      final package = selectedPackages[packageName]!;
      final service = package.serviceLevels.firstWhereOrNull((s) => s.id == serviceId);
      if (service != null) {
        final item = service.serviceItems.firstWhereOrNull((i) => i.name == itemName);
        if (item != null) {
          item.selectedValue = value;
          selectedPackages[packageName] = package;
          selectedPackages.refresh();
        }
      }
    }
  }

  // Update retainer amount for a package
  void updateRetainerAmount(String packageName, double? retainerAmount) {
    if (selectedPackages.containsKey(packageName)) {
      final package = selectedPackages[packageName]!;
      package.retainerAmount = retainerAmount;
      selectedPackages[packageName] = package;
      selectedPackages.refresh();
    }
  }

  // Update package tier
  void updatePackageTier(String packageName, String tier) {
    if (selectedPackages.containsKey(packageName)) {
      final package = selectedPackages[packageName]!;
      package.tier = tier;
      package.description = getPackageDescription(tier);
      selectedPackages[packageName] = package;
      selectedPackages.refresh();
    }
  }

  // Get package description based on tier
  String getPackageDescription(String tier) {
    switch (tier.toLowerCase()) {
      case 'bronze':
        return 'Essential services for growing businesses';
      case 'silver':
        return 'Comprehensive services for established businesses';
      case 'gold':
        return 'Premium services for complex business needs';
      default:
        return 'Custom package tailored to your needs';
    }
  }

  // Navigate to next step
  void nextStep() {
    if (currentStep.value < 3) currentStep.value++;
  }

  // Navigate to previous step
  void previousStep() {
    if (currentStep.value > 0) currentStep.value--;
  }

  // Calculate total price for a package by frequency
  double getTotalPrice(String packageName, String frequency) {
    if (!selectedPackages.containsKey(packageName)) return 0.0;
    final package = selectedPackages[packageName]!;
    double total = package.serviceLevels
        .where((s) => frequency == 'All' || s.frequency == frequency)
        .fold(0.0, (sum, s) => sum + s.price);
    if (package.retainerAmount != null) {
      total += package.retainerAmount!;
    }
    return total;
  }

  // Generate Excel string for export
  String generateExcelString() {
    final buffer = StringBuffer();
    buffer.writeln('Client Name\tBusiness Name\tEmail\tPhone\tPackage\tTier\tService\tFrequency\tPrice\tRetainer Amount\tCustom Fields');
    selectedPackages.forEach((packageName, package) {
      for (final service in package.serviceLevels) {
        final customFields = service.serviceItems
            .map((item) => '${item.name}: ${item.selectedValue ?? "Not set"}')
            .join(', ');
        buffer.writeln(
          '${clientInfo.value.clientName}\t'
              '${clientInfo.value.businessName}\t'
              '${clientInfo.value.email}\t'
              '${clientInfo.value.phone}\t'
              '$packageName\t'
              '${package.tier ?? "N/A"}\t'
              '${service.name}\t'
              '${service.frequency}\t'
              '${service.price}\t'
              '${package.retainerAmount ?? "N/A"}\t'
              '$customFields',
        );
      }
    });
    return buffer.toString();
  }
}
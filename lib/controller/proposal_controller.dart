import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/service_models.dart';

class ProposalController extends GetxController {
  final clientInfo = ClientInfo().obs;
  final selectedPackages = <String, ServicePackage>{}.obs;
  final currentStep = 0.obs;
  final availableServices = <String, ServiceLevel>{}.obs;
  final box = GetStorage();
  final RxList<String> packageTiers = <String>['Bronze', 'Silver', 'Gold'].obs;
  final RxString brandingText = 'Performance Financial'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadServices();
    _loadSettings();
  }

  void _loadServices() {
    if (box.read('services') != null) {
      availableServices.value = (box.read('services') as Map<String, dynamic>).map(
            (key, value) => MapEntry(key, ServiceLevel.fromJson(value)),
      );
    } else {
      availableServices.addAll({
        'bookkeeping': ServiceLevel(
          id: 'bookkeeping',
          name: 'Bookkeeping',
          description: 'Recurring bookkeeping service',
          frequency: 'Monthly',
          price: 0,
          serviceItems: [
            ServiceItem(name: 'Frequency', explanation: 'Frequency we\'ll close the books', optionType: 'single', options: ['Quarterly', 'Monthly']),
            ServiceItem(name: 'Platform', explanation: 'Accounting software we\'re using', optionType: 'single', options: ['QBO', 'QBD', 'NetSuite', 'Excel', 'Other']),
          ],
        ),
        'cleanup_bookkeeping': ServiceLevel(
          id: 'cleanup_bookkeeping',
          name: 'Cleanup Bookkeeping',
          description: 'One time cleanup of prior bookkeeping',
          frequency: 'One-Time',
          price: 0,
          serviceItems: [
            ServiceItem(name: 'Months to review', explanation: 'Months of past bkpg to be reviewed', optionType: 'number'),
          ],
        ),
      });
      saveSettings();
    }
  }

  void saveServices() {
    box.write('services', availableServices.map((key, value) => MapEntry(key, value.toJson())));
  }

  void _loadSettings() {
    packageTiers.value = (box.read('packageTiers') ?? ['Bronze', 'Silver', 'Gold']).cast<String>();
    brandingText.value = box.read('brandingText') ?? 'Performance Financial';
  }

  void saveSettings() {
    box.write('packageTiers', packageTiers);
    box.write('brandingText', brandingText.value);
  }

  void updateClientInfo({String? clientName, String? businessName, String? email, String? phone, int? numberOfPackages}) {
    if (clientName != null) clientInfo.value.clientName = clientName;
    if (businessName != null) clientInfo.value.businessName = businessName;
    if (email != null) clientInfo.value.email = email;
    if (phone != null) clientInfo.value.phone = phone;
    if (numberOfPackages != null) clientInfo.value.numberOfPackages = numberOfPackages;
    clientInfo.refresh();
  }

  void addServiceToPackage(String packageName, String serviceId) {
    if (!selectedPackages.containsKey(packageName)) {
      selectedPackages[packageName] = ServicePackage(name: packageName, description: getPackageDescription(packageName));
    }
    if (availableServices.containsKey(serviceId)) {
      selectedPackages[packageName]!.serviceLevels.add(availableServices[serviceId]!);
      selectedPackages.refresh();
    }
  }

  void removeServiceFromPackage(String packageName, String serviceId) {
    if (selectedPackages.containsKey(packageName)) {
      selectedPackages[packageName]!.serviceLevels.removeWhere((s) => s.id == serviceId);
      selectedPackages.refresh();
    }
  }

  void updateServiceItemValue(String packageName, String serviceId, String itemName, dynamic value) {
    if (selectedPackages.containsKey(packageName)) {
      var package = selectedPackages[packageName]!;
      var service = package.serviceLevels.firstWhere((s) => s.id == serviceId);
      var item = service.serviceItems.firstWhere((i) => i.name == itemName);
      item.selectedValue = value;
      selectedPackages.refresh();
    }
  }

  String getPackageDescription(String packageName) {
    switch (packageName.toLowerCase()) {
      case 'bronze': return 'Good - Essential services for growing businesses';
      case 'silver': return 'Better - Comprehensive services for established businesses';
      case 'gold': return 'Best - Premium services for complex business needs';
      default: return 'Custom package tailored to your needs';
    }
  }

  void nextStep() => currentStep.value < 3 ? currentStep.value++ : null;
  void previousStep() => currentStep.value > 0 ? currentStep.value-- : null;

  double getTotalPrice(String packageName, String frequency) {
    if (!selectedPackages.containsKey(packageName)) return 0.0;
    return selectedPackages[packageName]!.serviceLevels
        .where((s) => s.frequency == frequency)
        .fold(0.0, (sum, s) => sum + s.price);
  }

  String generateExcelString() {
    StringBuffer buffer = StringBuffer();
    buffer.writeln('Client Name\tBusiness Name\tEmail\tPhone\tPackage\tService\tFrequency\tPrice');
    selectedPackages.forEach((packageName, package) {
      for (var service in package.serviceLevels) {
        buffer.writeln('${clientInfo.value.clientName}\t${clientInfo.value.businessName}\t${clientInfo.value.email}\t${clientInfo.value.phone}\t$packageName\t${service.name}\t${service.frequency}\t${service.price}');
      }
    });
    return buffer.toString();
  }

  // Future<void> exportToClipboard() async {
  //   await Get.context!.clipboard.setData(ClipboardData(text: generateExcelString()));
  //   Get.snackbar('Success', 'Exported to clipboard!', snackPosition: SnackPosition.BOTTOM);
  // }
}
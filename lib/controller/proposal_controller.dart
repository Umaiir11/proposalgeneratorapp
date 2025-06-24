import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
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
_loadServices();
_loadSettings();
_loadClientInfo();
}

void _loadClientInfo() {
if (box.read('clientInfo') != null) {
clientInfo.value = ClientInfo.fromJson(box.read('clientInfo'));
}
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
price: 500.0,
serviceItems: [],
),
'cleanup_bookkeeping': ServiceLevel(
id: 'cleanup_bookkeeping',
name: 'Cleanup Bookkeeping',
description: 'One time cleanup of prior bookkeeping',
frequency: 'One-Time',
price: 1000.0,
serviceItems: [],
),
});
saveServices();
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
box.write('packageTiers', packageTiers.toList());
box.write('brandingText', brandingText.value);
}

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

void addServiceToPackage(String packageName, String serviceId) {
if (!selectedPackages.containsKey(packageName)) {
selectedPackages[packageName] = ServicePackage(
name: packageName,
description: getPackageDescription(packageName),
serviceLevels: [], // Ensure serviceLevels is a mutable list
);
}
if (availableServices.containsKey(serviceId)) {
final package = selectedPackages[packageName]!;
package.serviceLevels.add(availableServices[serviceId]!); // Add to mutable list
selectedPackages[packageName] = package; // Update the map with the modified package
selectedPackages.refresh();
}
}

void removeServiceFromPackage(String packageName, String serviceId) {
if (selectedPackages.containsKey(packageName)) {
final package = selectedPackages[packageName]!;
package.serviceLevels.removeWhere((s) => s.id == serviceId);
selectedPackages[packageName] = package; // Update the map with the modified package
selectedPackages.refresh();
}
}

void updateServiceItemValue(String packageName, String serviceId, String itemName, dynamic value) {
if (selectedPackages.containsKey(packageName)) {
final package = selectedPackages[packageName]!;
final service = package.serviceLevels.firstWhere((s) => s.id == serviceId);
final item = service.serviceItems.firstWhere((i) => i.name == itemName);
item.selectedValue = value;
selectedPackages.refresh();
}
}

String getPackageDescription(String packageName) {
switch (packageName.toLowerCase()) {
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

void nextStep() {
if (currentStep.value < 3) currentStep.value++;
}

void previousStep() {
if (currentStep.value > 0) currentStep.value--;
}

double getTotalPrice(String packageName, String frequency) {
if (!selectedPackages.containsKey(packageName)) return 0.0;
return selectedPackages[packageName]!.serviceLevels
    .where((s) => s.frequency == frequency)
    .fold(0.0, (sum, s) => sum + s.price);
}

String generateExcelString() {
final buffer = StringBuffer();
buffer.writeln('Client Name\tBusiness Name\tEmail\tPhone\tPackage\tService\tFrequency\tPrice');
selectedPackages.forEach((packageName, package) {
for (final service in package.serviceLevels) {
buffer.writeln(
'${clientInfo.value.clientName}\t${clientInfo.value.businessName}\t${clientInfo.value.email}\t${clientInfo.value.phone}\t$packageName\t${service.name}\t${service.frequency}\t${service.price}');
}
});
return buffer.toString();
}
}

class ServicePackage {
  String name;
  String description;
  List<ServiceLevel> serviceLevels;
  double? retainerAmount;

  ServicePackage({required this.name, required this.description, this.serviceLevels = const [], this.retainerAmount});

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'serviceLevels': serviceLevels.map((s) => s.toJson()).toList(),
    'retainerAmount': retainerAmount,
  };
}

class ServiceLevel {
  String id;
  String name;
  String description;
  String frequency;
  double price;
  List<ServiceItem> serviceItems;

  ServiceLevel({required this.id, required this.name, required this.description, required this.frequency, required this.price, this.serviceItems = const []});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'frequency': frequency,
    'price': price,
    'serviceItems': serviceItems.map((i) => i.toJson()).toList(),
  };

  factory ServiceLevel.fromJson(Map<String, dynamic> json) => ServiceLevel(
    id: json['id'],
    name: json['name'],
    description: json['description'],
    frequency: json['frequency'],
    price: json['price'],
    serviceItems: (json['serviceItems'] as List).map((i) => ServiceItem.fromJson(i)).toList(),
  );
}

class ServiceItem {
  String name;
  String explanation;
  String optionType;
  List<String> options;
  dynamic selectedValue;

  ServiceItem({required this.name, required this.explanation, required this.optionType, this.options = const [], this.selectedValue});

  Map<String, dynamic> toJson() => {
    'name': name,
    'explanation': explanation,
    'optionType': optionType,
    'options': options,
    'selectedValue': selectedValue,
  };

  factory ServiceItem.fromJson(Map<String, dynamic> json) => ServiceItem(
    name: json['name'],
    explanation: json['explanation'],
    optionType: json['optionType'],
    options: List<String>.from(json['options']),
    selectedValue: json['selectedValue'],
  );
}

class ClientInfo {
  String clientName;
  String businessName;
  String email;
  String phone;
  int numberOfPackages;

  ClientInfo({this.clientName = '', this.businessName = '', this.email = '', this.phone = '', this.numberOfPackages = 3});
}
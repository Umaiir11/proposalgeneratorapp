class ServicePackage {
  String name;
  String description;
  List<ServiceLevel> serviceLevels;
  double? retainerAmount;
  String? tier; // New field to store the selected tier

  ServicePackage({
    required this.name,
    required this.description,
    this.serviceLevels = const [],
    this.retainerAmount,
    this.tier,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'description': description,
    'serviceLevels': serviceLevels.map((s) => s.toJson()).toList(),
    'retainerAmount': retainerAmount,
    'tier': tier,
  };

  factory ServicePackage.fromJson(Map<String, dynamic> json) => ServicePackage(
    name: json['name'],
    description: json['description'],
    serviceLevels: (json['serviceLevels'] as List).map((s) => ServiceLevel.fromJson(s)).toList(),
    retainerAmount: json['retainerAmount'],
    tier: json['tier'],
  );

  ServicePackage copyWith({
    String? name,
    String? description,
    List<ServiceLevel>? serviceLevels,
    double? retainerAmount,
    String? tier,
  }) {
    return ServicePackage(
      name: name ?? this.name,
      description: description ?? this.description,
      serviceLevels: serviceLevels ?? this.serviceLevels,
      retainerAmount: retainerAmount ?? this.retainerAmount,
      tier: tier ?? this.tier,
    );
  }
}class ServiceLevel {
  String id;
  String name;
  String description;
  String frequency;
  double price;
  List<ServiceItem> serviceItems;

  ServiceLevel({
    required this.id,
    required this.name,
    required this.description,
    required this.frequency,
    required this.price,
    this.serviceItems = const [],
  });

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
    price: json['price']?.toDouble() ?? 0.0,
    serviceItems: (json['serviceItems'] as List)
        .map((i) => ServiceItem.fromJson(i))
        .toList(),
  );
}

class ServiceItem {
  String name;
  String explanation;
  String optionType;
  List<String> options;
  dynamic selectedValue;

  ServiceItem({
    required this.name,
    required this.explanation,
    required this.optionType,
    this.options = const [],
    this.selectedValue,
  });

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

  ClientInfo({
    this.clientName = '',
    this.businessName = '',
    this.email = '',
    this.phone = '',
    this.numberOfPackages = 1,
  });

  Map<String, dynamic> toJson() => {
    'clientName': clientName,
    'businessName': businessName,
    'email': email,
    'phone': phone,
    'numberOfPackages': numberOfPackages,
  };

  factory ClientInfo.fromJson(Map<String, dynamic> json) => ClientInfo(
    clientName: json['clientName'] ?? '',
    businessName: json['businessName'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    numberOfPackages: json['numberOfPackages'] ?? 1,
  );
}

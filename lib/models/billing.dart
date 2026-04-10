import 'subscription.dart';

class BillingInfo {
  final Subscription? subscription;
  final StripeCustomer? customer;
  final List<PaymentMethod> paymentMethods;
  final List<Invoice> invoices;

  const BillingInfo({
    this.subscription,
    this.customer,
    required this.paymentMethods,
    required this.invoices,
  });

  factory BillingInfo.fromJson(Map<String, dynamic> json) {
    return BillingInfo(
      subscription: json['subscription'] != null
          ? Subscription.fromJson(json['subscription'] as Map<String, dynamic>)
          : null,
      customer: json['customer'] != null
          ? StripeCustomer.fromJson(json['customer'] as Map<String, dynamic>)
          : null,
      paymentMethods: (json['paymentMethods'] as List<dynamic>?)
              ?.map((e) => PaymentMethod.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      invoices: (json['invoices'] as List<dynamic>?)
              ?.map((e) => Invoice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (subscription != null) 'subscription': subscription!.toJson(),
      if (customer != null) 'customer': customer!.toJson(),
      'paymentMethods': paymentMethods.map((e) => e.toJson()).toList(),
      'invoices': invoices.map((e) => e.toJson()).toList(),
    };
  }
}

class StripeCustomer {
  final String id;
  final String email;
  final String? name;
  final String created;

  const StripeCustomer({
    required this.id,
    required this.email,
    this.name,
    required this.created,
  });

  factory StripeCustomer.fromJson(Map<String, dynamic> json) {
    return StripeCustomer(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String?,
      created: json['created'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      if (name != null) 'name': name,
      'created': created,
    };
  }
}

class PaymentMethod {
  final String id;
  final String type;
  final Card? card;
  final String created;

  const PaymentMethod({
    required this.id,
    required this.type,
    this.card,
    required this.created,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      type: json['type'] as String,
      card: json['card'] != null
          ? Card.fromJson(json['card'] as Map<String, dynamic>)
          : null,
      created: json['created'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      if (card != null) 'card': card!.toJson(),
      'created': created,
    };
  }
}

class Card {
  final String brand;
  final String last4;
  final int expMonth;
  final int expYear;

  const Card({
    required this.brand,
    required this.last4,
    required this.expMonth,
    required this.expYear,
  });

  factory Card.fromJson(Map<String, dynamic> json) {
    return Card(
      brand: json['brand'] as String,
      last4: json['last4'] as String,
      expMonth: json['expMonth'] as int,
      expYear: json['expYear'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand': brand,
      'last4': last4,
      'expMonth': expMonth,
      'expYear': expYear,
    };
  }

  @override
  String toString() => 'Card(brand: $brand, last4: $last4)';
}

class Invoice {
  final String id;
  final String? number;
  final String status;
  final int amountPaid;
  final int amountDue;
  final String currency;
  final String created;
  final String? paidAt;
  final String? hostedInvoiceUrl;
  final String? invoicePdf;

  const Invoice({
    required this.id,
    this.number,
    required this.status,
    required this.amountPaid,
    required this.amountDue,
    required this.currency,
    required this.created,
    this.paidAt,
    this.hostedInvoiceUrl,
    this.invoicePdf,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as String,
      number: json['number'] as String?,
      status: json['status'] as String,
      amountPaid: json['amountPaid'] as int,
      amountDue: json['amountDue'] as int,
      currency: json['currency'] as String,
      created: json['created'] as String,
      paidAt: json['paidAt'] as String?,
      hostedInvoiceUrl: json['hostedInvoiceUrl'] as String?,
      invoicePdf: json['invoicePdf'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      if (number != null) 'number': number,
      'status': status,
      'amountPaid': amountPaid,
      'amountDue': amountDue,
      'currency': currency,
      'created': created,
      if (paidAt != null) 'paidAt': paidAt,
      if (hostedInvoiceUrl != null) 'hostedInvoiceUrl': hostedInvoiceUrl,
      if (invoicePdf != null) 'invoicePdf': invoicePdf,
    };
  }

  @override
  String toString() => 'Invoice(id: $id, status: $status, amountDue: $amountDue)';
}

class PlanFeatures {
  final int? posts;
  final int? socialAccounts;
  final int aiCredits;
  final bool analytics;
  final int teamMembers;

  const PlanFeatures({
    this.posts,
    this.socialAccounts,
    required this.aiCredits,
    required this.analytics,
    required this.teamMembers,
  });

  factory PlanFeatures.fromJson(Map<String, dynamic> json) {
    return PlanFeatures(
      posts: json['posts'] as int?,
      socialAccounts: json['socialAccounts'] as int?,
      aiCredits: json['aiCredits'] as int? ?? 0,
      analytics: json['analytics'] as bool? ?? false,
      teamMembers: json['teamMembers'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (posts != null) 'posts': posts,
      if (socialAccounts != null) 'socialAccounts': socialAccounts,
      'aiCredits': aiCredits,
      'analytics': analytics,
      'teamMembers': teamMembers,
    };
  }
}

class PlanInfo {
  final String id;
  final String name;
  final int price;
  final PlanFeatures features;

  const PlanInfo({
    required this.id,
    required this.name,
    required this.price,
    required this.features,
  });

  factory PlanInfo.fromJson(Map<String, dynamic> json) {
    return PlanInfo(
      id: json['id'] as String,
      name: json['name'] as String,
      price: json['price'] as int,
      features: PlanFeatures.fromJson(json['features'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'features': features.toJson(),
    };
  }

  @override
  String toString() => 'PlanInfo(id: $id, name: $name, price: $price)';
}

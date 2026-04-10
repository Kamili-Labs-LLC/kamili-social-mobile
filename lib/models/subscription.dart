class Subscription {
  final String id;
  final String status;
  final String plan;
  final String? currentPeriodStart;
  final String? currentPeriodEnd;
  final String? trialStart;
  final String? trialEnd;
  final bool cancelAtPeriodEnd;
  final String? canceledAt;
  final String? createdAt;

  const Subscription({
    required this.id,
    required this.status,
    required this.plan,
    this.currentPeriodStart,
    this.currentPeriodEnd,
    this.trialStart,
    this.trialEnd,
    required this.cancelAtPeriodEnd,
    this.canceledAt,
    this.createdAt,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) {
    return Subscription(
      id: json['id'] as String,
      status: json['status'] as String,
      plan: json['plan'] as String,
      currentPeriodStart: json['currentPeriodStart'] as String?,
      currentPeriodEnd: json['currentPeriodEnd'] as String?,
      trialStart: json['trialStart'] as String?,
      trialEnd: json['trialEnd'] as String?,
      cancelAtPeriodEnd: json['cancelAtPeriodEnd'] as bool? ?? false,
      canceledAt: json['canceledAt'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status,
      'plan': plan,
      if (currentPeriodStart != null) 'currentPeriodStart': currentPeriodStart,
      if (currentPeriodEnd != null) 'currentPeriodEnd': currentPeriodEnd,
      if (trialStart != null) 'trialStart': trialStart,
      if (trialEnd != null) 'trialEnd': trialEnd,
      'cancelAtPeriodEnd': cancelAtPeriodEnd,
      if (canceledAt != null) 'canceledAt': canceledAt,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }

  @override
  String toString() => 'Subscription(id: $id, status: $status, plan: $plan)';
}

class Account {
  final String id;
  final String name;
  final String email;
  final String plan;
  final String? selectedTimezone;
  final String? subscriptionStatus;
  final NotificationPreferences? notificationPreferences;
  final UserSettings? userSettings;
  final String? createdAt;
  final String? updatedAt;

  const Account({
    required this.id,
    required this.name,
    required this.email,
    required this.plan,
    this.selectedTimezone,
    this.subscriptionStatus,
    this.notificationPreferences,
    this.userSettings,
    this.createdAt,
    this.updatedAt,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      plan: json['plan'] as String,
      selectedTimezone: json['selectedTimezone'] as String?,
      subscriptionStatus: json['subscriptionStatus'] as String?,
      notificationPreferences: json['notificationPreferences'] != null
          ? NotificationPreferences.fromJson(
              json['notificationPreferences'] as Map<String, dynamic>)
          : null,
      userSettings: json['userSettings'] != null
          ? UserSettings.fromJson(
              json['userSettings'] as Map<String, dynamic>)
          : null,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'plan': plan,
      'selectedTimezone': selectedTimezone,
      'subscriptionStatus': subscriptionStatus,
      'notificationPreferences': notificationPreferences?.toJson(),
      'userSettings': userSettings?.toJson(),
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Account copyWith({
    String? id,
    String? name,
    String? email,
    String? plan,
    String? selectedTimezone,
    String? subscriptionStatus,
    NotificationPreferences? notificationPreferences,
    UserSettings? userSettings,
    String? createdAt,
    String? updatedAt,
  }) {
    return Account(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      plan: plan ?? this.plan,
      selectedTimezone: selectedTimezone ?? this.selectedTimezone,
      subscriptionStatus: subscriptionStatus ?? this.subscriptionStatus,
      notificationPreferences:
          notificationPreferences ?? this.notificationPreferences,
      userSettings: userSettings ?? this.userSettings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() => 'Account(id: $id, name: $name, email: $email, plan: $plan)';
}

class NotificationPreferences {
  final bool postSuccess;
  final bool postFailure;
  final bool accountIssues;

  const NotificationPreferences({
    required this.postSuccess,
    required this.postFailure,
    required this.accountIssues,
  });

  factory NotificationPreferences.fromJson(Map<String, dynamic> json) {
    return NotificationPreferences(
      postSuccess: json['postSuccess'] as bool? ?? false,
      postFailure: json['postFailure'] as bool? ?? false,
      accountIssues: json['accountIssues'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postSuccess': postSuccess,
      'postFailure': postFailure,
      'accountIssues': accountIssues,
    };
  }
}

class UserSettings {
  final String? defaultUrlShortener;
  final String? defaultPostSignature;

  const UserSettings({
    this.defaultUrlShortener,
    this.defaultPostSignature,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      defaultUrlShortener: json['defaultUrlShortener'] as String?,
      defaultPostSignature: json['defaultPostSignature'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'defaultUrlShortener': defaultUrlShortener,
      'defaultPostSignature': defaultPostSignature,
    };
  }
}

/// Plan configuration model for backend-configurable pricing and entitlements.
class PlanConfig {
  final String id;
  final String displayName;
  final int priceInRupees;
  final String billingCadence; // 'free', 'monthly', 'annual', 'one_time'
  final List<String> entitlements;
  final bool isAvailable;

  const PlanConfig({
    required this.id,
    required this.displayName,
    required this.priceInRupees,
    required this.billingCadence,
    required this.entitlements,
    this.isAvailable = true,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'display_name': displayName,
    'price_in_rupees': priceInRupees,
    'billing_cadence': billingCadence,
    'entitlements': entitlements,
    'is_available': isAvailable,
  };

  factory PlanConfig.fromJson(Map<String, dynamic> json) => PlanConfig(
    id: json['id'] as String? ?? 'unknown',
    displayName: json['display_name'] as String? ?? 'Unnamed Plan',
    priceInRupees: json['price_in_rupees'] as int? ?? 0,
    billingCadence: json['billing_cadence'] as String? ?? 'monthly',
    entitlements:
        (json['entitlements'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        const [],
    isAvailable: json['is_available'] as bool? ?? true,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlanConfig &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          priceInRupees == other.priceInRupees &&
          billingCadence == other.billingCadence &&
          isAvailable == other.isAvailable;

  @override
  int get hashCode =>
      Object.hash(id, priceInRupees, billingCadence, isAvailable);
}

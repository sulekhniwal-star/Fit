enum HealthUnit {
  kg('kg'),
  lbs('lbs'),
  cm('cm'),
  inch('in'),
  ml('ml'),
  liter('L'),
  count('count'),
  mmHg('mmHg'),
  mgdL('mg/dL'),
  bpm('bpm');

  final String symbol;
  const HealthUnit(this.symbol);

  static double kgToLbs(double kg) => kg * 2.20462262;
  static double lbsToKg(double lbs) => lbs / 2.20462262;

  static double cmToInches(double cm) => cm / 2.54;
  static double inchesToCm(double inches) => inches * 2.54;
}

enum HealthSource {
  manual,
  device,
  healthConnect,
  appleHealth,
  calculated,
}

class HealthQuantity {
  final double value;
  final HealthUnit unit;

  const HealthQuantity({required this.value, required this.unit});

  HealthQuantity toUnit(HealthUnit targetUnit) {
    if (unit == targetUnit) return this;

    if (unit == HealthUnit.kg && targetUnit == HealthUnit.lbs) {
      return HealthQuantity(value: HealthUnit.kgToLbs(value), unit: targetUnit);
    } else if (unit == HealthUnit.lbs && targetUnit == HealthUnit.kg) {
      return HealthQuantity(value: HealthUnit.lbsToKg(value), unit: targetUnit);
    } else if (unit == HealthUnit.cm && targetUnit == HealthUnit.inch) {
      return HealthQuantity(value: HealthUnit.cmToInches(value), unit: targetUnit);
    } else if (unit == HealthUnit.inch && targetUnit == HealthUnit.cm) {
      return HealthQuantity(value: HealthUnit.inchesToCm(value), unit: targetUnit);
    }

    throw UnsupportedError('Unsupported unit conversion from ${unit.name} to ${targetUnit.name}');
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthQuantity &&
          runtimeType == other.runtimeType &&
          (value - other.value).abs() < 0.0001 &&
          unit == other.unit;

  @override
  int get hashCode => value.hashCode ^ unit.hashCode;

  @override
  String toString() => '$value ${unit.symbol}';
}

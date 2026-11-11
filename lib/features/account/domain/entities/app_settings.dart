import 'package:equatable/equatable.dart';

class Region extends Equatable {
  const Region({required this.code, required this.name, required this.flag});

  final String code;
  final String name;
  final String flag;

  @override
  List<Object?> get props => [code, name, flag];
}

class AppSettings extends Equatable {
  const AppSettings({
    this.language = 'English',
    this.currency = 'USD',
    this.regionCode = 'US',
  });

  static const List<String> languages = ['English', 'العربية'];

  static const List<String> currencies = [
    'USD',
    'EUR',
    'YER',
    'SAR',
    'AED',
    'JOD',
    'TRY',
  ];

  static const List<Region> regions = [
    Region(code: 'US', name: 'United States', flag: '🇺🇸'),
    Region(code: 'YE', name: 'Yemen', flag: '🇾🇪'),
    Region(code: 'SA', name: 'Saudi Arabia', flag: '🇸🇦'),
    Region(code: 'AE', name: 'United Arab Emirates', flag: '🇦🇪'),
    Region(code: 'JO', name: 'Jordan', flag: '🇯🇴'),
    Region(code: 'TR', name: 'Turkey', flag: '🇹🇷'),
  ];

  final String language;
  final String currency;
  final String regionCode;

  Region get region => regions.firstWhere(
    (r) => r.code == regionCode,
    orElse: () => regions.first,
  );

  AppSettings copyWith({
    String? language,
    String? currency,
    String? regionCode,
  }) {
    return AppSettings(
      language: language ?? this.language,
      currency: currency ?? this.currency,
      regionCode: regionCode ?? this.regionCode,
    );
  }

  @override
  List<Object?> get props => [language, currency, regionCode];
}

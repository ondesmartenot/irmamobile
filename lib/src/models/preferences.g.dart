// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'preferences.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Preferences _$PreferencesFromJson(Map<String, dynamic> json) {
  return Preferences(
    enableCrashReporting: json['EnableCrashReporting'] as bool,
    qrScannerOnStartup: json['QrScannerOnStartup'] as bool,
  );
}

Map<String, dynamic> _$PreferencesToJson(Preferences instance) =>
    <String, dynamic>{
      'EnableCrashReporting': instance.enableCrashReporting,
      'QrScannerOnStartup': instance.qrScannerOnStartup,
    };

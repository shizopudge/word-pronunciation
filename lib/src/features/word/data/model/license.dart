import 'package:freezed_annotation/freezed_annotation.dart';

part 'license.freezed.dart';
part 'license.g.dart';

@freezed
class License with _$License {
  const factory License({
    required final String name,
  }) = _License;

  /// Generate Class from Map<String, Object?>
  factory License.fromJson(Map<String, Object?> json) =>
      _$LicenseFromJson(json);
}

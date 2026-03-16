import 'package:equatable/equatable.dart';

/// Tipe donatur: terdaftar atau anonim.
enum DonorType { named, anonymous }

/// Step form donasi.
enum DonationFormStep { inputForm, showingQr }

/// State untuk form donasi.
class DonationFormState extends Equatable {
  final DonorType donorType;
  final DonationFormStep formStep;
  final String fullName;
  final String email;
  final String phone;
  final int? selectedAmount;
  final String customAmount;
  final String? errorMessage;

  const DonationFormState({
    this.donorType = DonorType.named,
    this.formStep = DonationFormStep.inputForm,
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.selectedAmount,
    this.customAmount = '',
    this.errorMessage,
  });

  /// Nominal aktif — dari preset atau custom.
  int? get activeAmount {
    if (selectedAmount != null) return selectedAmount;
    final parsed = int.tryParse(customAmount.replaceAll('.', ''));
    return parsed;
  }

  /// Validasi form lengkap.
  bool get isFormValid {
    if (fullName.trim().isEmpty) return false;
    if (!_isEmailValid(email)) return false;
    if (phone.trim().length < 8) return false;
    if (activeAmount == null || activeAmount! <= 0) return false;
    return true;
  }

  static bool _isEmailValid(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  DonationFormState copyWith({
    DonorType? donorType,
    DonationFormStep? formStep,
    String? fullName,
    String? email,
    String? phone,
    int? Function()? selectedAmount,
    String? customAmount,
    String? Function()? errorMessage,
  }) {
    return DonationFormState(
      donorType: donorType ?? this.donorType,
      formStep: formStep ?? this.formStep,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      selectedAmount:
          selectedAmount != null ? selectedAmount() : this.selectedAmount,
      customAmount: customAmount ?? this.customAmount,
      errorMessage:
          errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        donorType,
        formStep,
        fullName,
        email,
        phone,
        selectedAmount,
        customAmount,
        errorMessage,
      ];
}

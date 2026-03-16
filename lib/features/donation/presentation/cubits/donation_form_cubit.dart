import 'package:flutter_bloc/flutter_bloc.dart';

import 'donation_form_state.dart';

/// Cubit untuk mengelola state form donasi.
class DonationFormCubit extends Cubit<DonationFormState> {
  DonationFormCubit() : super(const DonationFormState());

  /// Ganti tipe donatur (named/anonymous).
  void setDonorType(DonorType type) {
    emit(state.copyWith(
      donorType: type,
      formStep: DonationFormStep.inputForm,
      errorMessage: () => null,
    ));
  }

  /// Update nama.
  void updateName(String name) {
    emit(state.copyWith(fullName: name, errorMessage: () => null));
  }

  /// Update email.
  void updateEmail(String email) {
    emit(state.copyWith(email: email, errorMessage: () => null));
  }

  /// Update nomor telepon.
  void updatePhone(String phone) {
    emit(state.copyWith(phone: phone, errorMessage: () => null));
  }

  /// Pilih nominal preset.
  void selectAmount(int amount) {
    emit(state.copyWith(
      selectedAmount: () => amount,
      customAmount: '',
      errorMessage: () => null,
    ));
  }

  /// Update nominal custom.
  void updateCustomAmount(String amount) {
    emit(state.copyWith(
      customAmount: amount,
      selectedAmount: () => null,
      errorMessage: () => null,
    ));
  }

  /// Submit form — validasi lalu tampilkan QR.
  void submitForm() {
    if (!state.isFormValid) {
      emit(state.copyWith(
        errorMessage: () => 'Mohon lengkapi semua field dengan benar.',
      ));
      return;
    }
    emit(state.copyWith(
      formStep: DonationFormStep.showingQr,
      errorMessage: () => null,
    ));
  }

  /// Kembali ke form input.
  void backToForm() {
    emit(state.copyWith(formStep: DonationFormStep.inputForm));
  }

  /// Reset seluruh form.
  void reset() {
    emit(const DonationFormState());
  }
}

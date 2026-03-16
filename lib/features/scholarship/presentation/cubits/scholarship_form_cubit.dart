import 'package:flutter_bloc/flutter_bloc.dart';

import 'scholarship_form_state.dart';

/// Cubit untuk mengelola state form pendaftaran beasiswa.
class ScholarshipFormCubit extends Cubit<ScholarshipFormState> {
  ScholarshipFormCubit() : super(const ScholarshipFormState());

  void setTabType(ScholarshipTabType type) {
    emit(state.copyWith(
      tabType: type,
      status: ScholarshipFormStatus.initial,
      errorMessage: () => null,
    ));
  }

  void updateName(String name) =>
      emit(state.copyWith(fullName: name, errorMessage: () => null));

  void updateEmail(String email) =>
      emit(state.copyWith(email: email, errorMessage: () => null));

  void updatePhone(String phone) =>
      emit(state.copyWith(phone: phone, errorMessage: () => null));

  void updateAge(String age) =>
      emit(state.copyWith(age: age, errorMessage: () => null));

  void updateEducation(String education) =>
      emit(state.copyWith(education: education, errorMessage: () => null));

  void updateProgram(String program) =>
      emit(state.copyWith(program: program, errorMessage: () => null));

  void updateMotivation(String motivation) =>
      emit(state.copyWith(motivation: motivation, errorMessage: () => null));

  void submitForm() {
    if (!state.isFormValid) {
      emit(state.copyWith(
        errorMessage: () => 'Mohon lengkapi semua field dengan benar.',
      ));
      return;
    }
    emit(state.copyWith(status: ScholarshipFormStatus.submitting));
    // Simulasi submit — langsung success
    Future.delayed(const Duration(seconds: 1), () {
      emit(state.copyWith(
        status: ScholarshipFormStatus.success,
        errorMessage: () => null,
      ));
    });
  }

  void reset() => emit(const ScholarshipFormState());
}

import 'package:equatable/equatable.dart';

/// Tipe tab: daftar beasiswa atau donasi.
enum ScholarshipTabType { apply, donate }

/// Status form pendaftaran.
enum ScholarshipFormStatus { initial, submitting, success, error }

/// State untuk form pendaftaran beasiswa.
class ScholarshipFormState extends Equatable {
  final ScholarshipTabType tabType;
  final ScholarshipFormStatus status;
  final String fullName;
  final String email;
  final String phone;
  final String age;
  final String education;
  final String program;
  final String motivation;
  final String? errorMessage;

  const ScholarshipFormState({
    this.tabType = ScholarshipTabType.apply,
    this.status = ScholarshipFormStatus.initial,
    this.fullName = '',
    this.email = '',
    this.phone = '',
    this.age = '',
    this.education = '',
    this.program = '',
    this.motivation = '',
    this.errorMessage,
  });

  bool get isFormValid {
    if (fullName.trim().isEmpty) return false;
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      return false;
    }
    if (phone.trim().length < 8) return false;
    if (age.trim().isEmpty) return false;
    if (education.isEmpty) return false;
    if (program.isEmpty) return false;
    if (motivation.trim().length < 10) return false;
    return true;
  }

  ScholarshipFormState copyWith({
    ScholarshipTabType? tabType,
    ScholarshipFormStatus? status,
    String? fullName,
    String? email,
    String? phone,
    String? age,
    String? education,
    String? program,
    String? motivation,
    String? Function()? errorMessage,
  }) {
    return ScholarshipFormState(
      tabType: tabType ?? this.tabType,
      status: status ?? this.status,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      age: age ?? this.age,
      education: education ?? this.education,
      program: program ?? this.program,
      motivation: motivation ?? this.motivation,
      errorMessage:
          errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        tabType, status, fullName, email, phone,
        age, education, program, motivation, errorMessage,
      ];
}

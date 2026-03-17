import 'package:equatable/equatable.dart';

enum RegisterDonaturStatus { initial, loading, success, failure }

class RegisterDonaturState extends Equatable {
  final RegisterDonaturStatus status;
  final String? errorMessage;

  const RegisterDonaturState({
    this.status = RegisterDonaturStatus.initial,
    this.errorMessage,
  });

  bool get isLoading => status == RegisterDonaturStatus.loading;
  bool get isSuccess => status == RegisterDonaturStatus.success;

  RegisterDonaturState copyWith({
    RegisterDonaturStatus? status,
    String? Function()? errorMessage,
  }) {
    return RegisterDonaturState(
      status: status ?? this.status,
      errorMessage:
          errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, errorMessage];
}

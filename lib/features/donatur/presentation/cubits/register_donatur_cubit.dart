import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repositories/donatur_repository.dart';
import 'register_donatur_state.dart';

@injectable
class RegisterDonaturCubit extends Cubit<RegisterDonaturState> {
  final DonaturRepository _repository;

  RegisterDonaturCubit(this._repository)
      : super(const RegisterDonaturState());

  Future<void> register({
    required String fullName,
    required String email,
    required String phone,
    String idType = '',
    String idNumber = '',
    String address = '',
    String city = '',
    String province = '',
    String postalCode = '',
  }) async {
    emit(state.copyWith(
      status: RegisterDonaturStatus.loading,
      errorMessage: () => null,
    ));

    final result = await _repository.registerDonatur(
      fullName: fullName,
      email: email,
      phone: phone,
      idType: idType,
      idNumber: idNumber,
      address: address,
      city: city,
      province: province,
      postalCode: postalCode,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: RegisterDonaturStatus.failure,
        errorMessage: () => failure.message,
      )),
      (_) => emit(state.copyWith(
        status: RegisterDonaturStatus.success,
        errorMessage: () => null,
      )),
    );
  }

  void reset() => emit(const RegisterDonaturState());
}

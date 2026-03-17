import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/repositories/donatur_repository.dart';
import '../datasources/donatur_remote_datasource.dart';
import '../models/register_donatur_request.dart';

@LazySingleton(as: DonaturRepository)
class DonaturRepositoryImpl implements DonaturRepository {
  final DonaturRemoteDatasource _remote;

  DonaturRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, void>> registerDonatur({
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
    try {
      await _remote.registerDonatur(RegisterDonaturRequest(
        fullName: fullName,
        email: email,
        phone: phone,
        idType: idType,
        idNumber: idNumber,
        address: address,
        city: city,
        province: province,
        postalCode: postalCode,
      ));
      return const Right(null);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return const Left(UnauthorizedFailure());
      }
      return Left(ServerFailure(
        e.response?.data?['message'] as String? ?? 'Terjadi kesalahan server',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

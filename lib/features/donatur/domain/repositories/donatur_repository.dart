import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

/// Interface repository untuk operasi donatur.
abstract class DonaturRepository {
  /// Mendaftarkan donatur baru.
  Future<Either<Failure, void>> registerDonatur({
    required String fullName,
    required String email,
    required String phone,
    String idType,
    String idNumber,
    String address,
    String city,
    String province,
    String postalCode,
  });
}

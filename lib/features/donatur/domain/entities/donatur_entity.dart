import 'package:equatable/equatable.dart';

/// Entity donatur — core business object, zero dependency ke library luar.
class DonaturEntity extends Equatable {
  final String id;
  final String userId;
  final String fullName;
  final String email;
  final String phone;
  final String idType;
  final String idNumber;
  final String address;
  final String city;
  final String province;
  final String postalCode;
  final String status;
  final int totalDonated;

  const DonaturEntity({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.email,
    required this.phone,
    this.idType = '',
    this.idNumber = '',
    this.address = '',
    this.city = '',
    this.province = '',
    this.postalCode = '',
    this.status = 'active',
    this.totalDonated = 0,
  });

  @override
  List<Object?> get props => [id, userId, email];
}

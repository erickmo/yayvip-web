/// Request model untuk registrasi donatur ke API.
class RegisterDonaturRequest {
  final String fullName;
  final String email;
  final String phone;
  final String idType;
  final String idNumber;
  final String address;
  final String city;
  final String province;
  final String postalCode;

  const RegisterDonaturRequest({
    required this.fullName,
    required this.email,
    required this.phone,
    this.idType = '',
    this.idNumber = '',
    this.address = '',
    this.city = '',
    this.province = '',
    this.postalCode = '',
  });

  Map<String, dynamic> toJson() => {
        'full_name': fullName,
        'email': email,
        'phone': phone,
        'id_type': idType,
        'id_number': idNumber,
        'address': address,
        'city': city,
        'province': province,
        'postal_code': postalCode,
      };
}

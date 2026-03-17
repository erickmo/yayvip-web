import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/network/api_client.dart';
import '../models/register_donatur_request.dart';

abstract class DonaturRemoteDatasource {
  Future<void> registerDonatur(RegisterDonaturRequest request);
}

@LazySingleton(as: DonaturRemoteDatasource)
class DonaturRemoteDatasourceImpl implements DonaturRemoteDatasource {
  final ApiClient _apiClient;

  DonaturRemoteDatasourceImpl(this._apiClient);

  @override
  Future<void> registerDonatur(RegisterDonaturRequest request) async {
    await _apiClient.dio.post(
      '/donatur',
      data: request.toJson(),
      options: Options(extra: {'requiresAuth': false}),
    );
  }
}

// @dart=2.9

import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

import '../../../../core/database/data/models/custom_header_model.dart';
import '../../../../core/error/failure.dart';

abstract class RegisterDeviceRepository {
  Future<Either<Failure, Map>> call({
    @required String connectionProtocol,
    @required String connectionDomain,
    @required String connectionPath,
    @required String deviceToken,
    List<CustomHeaderModel> headers,
    bool trustCert,
  });
}

import 'package:dartz/dartz.dart';
import 'package:smart_iot/domain/repository/mess/mess_repo.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class CallGeminiModelUseCase implements UseCase<Either, String> {
  @override
  Future<Either<String, String>> call({String ? params}) async {
    return await sl<MessageRepository>().callGeminiModel(params!);
  }
}

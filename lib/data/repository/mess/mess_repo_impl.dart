import 'package:dartz/dartz.dart';
import 'package:smart_iot/data/data_source/mess/mess_gemini_service.dart';

import '../../../domain/repository/mess/mess_repo.dart';
import '../../../service_locator.dart';

class MessageRepositoryImpl extends MessageRepository {
  @override
  Future<Either<String, String>> callGeminiModel(String promptInput) async {
    return await sl<MessageGeminiService>().callGeminiModel(promptInput);
  }
}

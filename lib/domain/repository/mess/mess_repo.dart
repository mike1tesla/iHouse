import 'package:dartz/dartz.dart';

abstract class MessageRepository {
  Future<Either<String, String>> callGeminiModel(String promptInput);
}
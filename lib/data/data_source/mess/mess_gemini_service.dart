import 'package:dartz/dartz.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

abstract class MessageGeminiService {
  Future<Either<String, String>> callGeminiModel(String promptInput);
}

class MessageGeminiServiceImpl extends MessageGeminiService {
  @override
  Future<Either<String, String>> callGeminiModel(String promptInput) async {
    try {
      final model = GenerativeModel(
        model: 'gemini-pro',
        apiKey: dotenv.env['GOOGLE_API_KEY'].toString(),
      );
      final prompt = promptInput;
      final content = [Content.text(prompt)];
      final response = await model.generateContent(content);
      return Right(response.text!.trim());
    } catch (e) {
      print("ERROR: $e");
      return Left(e.toString());
    }
  }
}

import 'package:google_generative_ai/google_generative_ai.dart';
import '../../core/secrets.dart';

class GeminiService {
  late final GenerativeModel _model;

  GeminiService() {
    _model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: Secrets.geminiApiKey,
    );
  }

  Stream<GenerateContentResponse> streamContent(String prompt, {List<Content>? history}) {
    final chat = _model.startChat(history: history);
    return chat.sendMessageStream(Content.text(prompt));
  }
  
  Future<GenerateContentResponse> generateContent(String prompt) {
    return _model.generateContent([Content.text(prompt)]);
  }
}

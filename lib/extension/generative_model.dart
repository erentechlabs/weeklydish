import 'package:google_generative_ai/google_generative_ai.dart';

GenerativeModel generativeModel() {
  return GenerativeModel(
    model: 'gemini-2.0-flash-lite-preview-02-05',
    apiKey: 'API_KEY',
    //const String.fromEnvironment('api_key'),
    generationConfig: GenerationConfig(
      temperature: 1,
      topK: 64,
      topP: 0.95,
      maxOutputTokens: 8192,
      responseMimeType: 'text/plain',
    ),
  );
}

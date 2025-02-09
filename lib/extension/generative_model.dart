import 'package:google_generative_ai/google_generative_ai.dart';

GenerativeModel generativeModel()
{
  return GenerativeModel(
    model: 'gemini-1.5-flash-8b',
    apiKey: 'API_KEY',
    //const String.fromEnvironment('api_key'),
    generationConfig: GenerationConfig(
      temperature: 1,
      topK: 40,
      topP: 0.95,
      maxOutputTokens: 8192,
      responseMimeType: 'text/plain',
    ),
  );
}
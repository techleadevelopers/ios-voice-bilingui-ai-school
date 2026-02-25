import 'package:dio/dio.dart';

class ApiService {
  static const String _defaultBase =
      String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8000');

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;
  String? _authToken;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: _defaultBase,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    )..interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (_authToken != null) {
              options.headers['Authorization'] = 'Bearer $_authToken';
            }
            return handler.next(options);
          },
        ),
      );
  }

  void setAuthToken(String? token) {
    _authToken = token;
  }

  Future<Map<String, dynamic>> submitAudio(List<int> audioBytes) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(audioBytes, filename: 'audio.wav'),
    });
    final response = await _dio.post('/audio/submit', data: formData);
    return response.data as Map<String, dynamic>;
  }

  Future<String> sendChatMessage(String message) async {
    final response = await _dio.post('/chat', data: {'message': message});
    final data = response.data as Map<String, dynamic>;
    return data['response']?.toString() ?? 'No response from server';
  }
}

/// API constants for AI Chat Assistant.
class ApiConstants {
  const ApiConstants._();

  // OpenAI API Configuration
  static const String baseUrl = 'https://api.openai.com/v1';
  static const String chatCompletions = '/chat/completions';
  static const String models = '/models';

  // Available Models
  static const String defaultModel = 'gpt-3.5-turbo';
  static const String gpt4Model = 'gpt-4';
  static const String gpt4TurboModel = 'gpt-4-turbo-preview';

  // Request Timeouts (in milliseconds)
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 60000;
  static const int sendTimeout = 30000;

  // API Limits
  static const int maxTokens = 2048;
  static const int maxConversationHistory = 50;
}

/// App-wide string constants.
class AppStrings {
  const AppStrings._();

  // App Info
  static const String appName = 'AI Chat Assistant';
  static const String appTagline = 'Your Intelligent Companion';
  static const String appVersion = '1.0.0';

  // Feature Names
  static const String newChat = 'New Chat';
  static const String chatHistory = 'Chat History';
  static const String settings = 'Settings';

  // Chat UI
  static const String typeMessage = 'Type a message...';
  static const String send = 'Send';
  static const String regenerate = 'Regenerate';
  static const String copy = 'Copy';
  static const String delete = 'Delete';
  static const String clearChat = 'Clear Chat';

  // Error Messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError = 'No internet connection.';
  static const String apiKeyRequired = 'API key is required';
  static const String enterApiKey = 'Enter your OpenAI API key';
  static const String connectionError = 'Connection error. Please try again.';

  // Success Messages
  static const String messageCopied = 'Message copied to clipboard';
  static const String chatCleared = 'Chat cleared';
  static const String settingsSaved = 'Settings saved';

  // Settings
  static const String apiKeyLabel = 'OpenAI API Key';
  static const String modelSelection = 'AI Model';
  static const String systemPrompt = 'System Prompt';
  static const String themeMode = 'Theme Mode';
  static const String darkMode = 'Dark Mode';
  static const String lightMode = 'Light Mode';
  static const String systemMode = 'System';

  // Default prompts
  static const String defaultSystemPrompt =
      'You are a helpful AI assistant. Be concise, accurate, and friendly.';
}

/// Storage keys for local persistence.
class StorageKeys {
  const StorageKeys._();

  static const String apiKey = 'openai_api_key';
  static const String selectedModel = 'selected_model';
  static const String conversations = 'conversations';
  static const String currentConversationId = 'current_conversation_id';
  static const String themeMode = 'theme_mode';
  static const String systemPrompt = 'system_prompt';
}

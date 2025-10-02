import 'package:flutter/material.dart';
import '../utils/app_theme.dart';

enum ChatLanguage { english, french, tunisian }

class ChatbotWidget extends StatefulWidget {
  const ChatbotWidget({super.key});

  @override
  State<ChatbotWidget> createState() => _ChatbotWidgetState();
}

class _ChatbotWidgetState extends State<ChatbotWidget> {
  bool _isExpanded = false;
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  ChatLanguage _currentLanguage = ChatLanguage.english;

  @override
  void initState() {
    super.initState();
    // Add welcome message in multiple languages
    _messages.add(ChatMessage(
      text: _getWelcomeMessage(),
      isBot: true,
      timestamp: DateTime.now(),
      language: _currentLanguage,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isExpanded ? 350 : 60,
      height: _isExpanded ? 500 : 60,
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_isExpanded ? 16 : 30),
        ),
        child: _isExpanded ? _buildExpandedChat() : _buildCollapsedButton(),
      ),
    );
  }

  Widget _buildCollapsedButton() {
    return InkWell(
      onTap: () {
        setState(() {
          _isExpanded = true;
        });
      },
      borderRadius: BorderRadius.circular(30),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryGreen,
          borderRadius: BorderRadius.circular(30),
        ),
        child: const Center(
          child: Icon(
            Icons.chat,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _buildExpandedChat() {
    return Column(
      children: [        // Chat Header
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
            ),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.smart_toy,
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getAssistantTitle(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _getLanguageIndicator(),
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              // Language selector
              PopupMenuButton<ChatLanguage>(
                icon: const Icon(Icons.language, color: Colors.white),
                onSelected: (ChatLanguage language) {
                  setState(() {
                    _currentLanguage = language;
                    _messages.add(ChatMessage(
                      text: _getLanguageChangeMessage(),
                      isBot: true,
                      timestamp: DateTime.now(),
                      language: language,
                    ));
                  });
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: ChatLanguage.english,
                    child: Row(
                      children: [
                        Text('🇬🇧'),
                        SizedBox(width: 8),
                        Text('English'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: ChatLanguage.french,
                    child: Row(
                      children: [
                        Text('🇫🇷'),
                        SizedBox(width: 8),
                        Text('Français'),
                      ],
                    ),
                  ),
                  const PopupMenuItem(
                    value: ChatLanguage.tunisian,
                    child: Row(
                      children: [
                        Text('🇹🇳'),
                        SizedBox(width: 8),
                        Text('تونسي / Derja'),
                      ],
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _isExpanded = false;
                  });
                },
                icon: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        
        // Messages
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return _buildMessageBubble(_messages[index]);
            },
          ),
        ),
        
        // Input Area
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(color: AppTheme.borderColor),
            ),
          ),
          child: Row(
            children: [              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: _getInputHint(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  onSubmitted: _sendMessage,
                ),
              ),
              const SizedBox(width: 8),
              FloatingActionButton.small(
                onPressed: () => _sendMessage(_messageController.text),
                backgroundColor: AppTheme.primaryGreen,
                child: const Icon(Icons.send, color: Colors.white),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 250),
        decoration: BoxDecoration(
          color: message.isBot ? AppTheme.lightGreen : AppTheme.primaryGreen,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          message.text,
          style: TextStyle(
            color: message.isBot ? AppTheme.textDark : Colors.white,
          ),
        ),
      ),
    );
  }
  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;

    // Detect language from user input
    final detectedLanguage = _detectLanguage(text);
    if (detectedLanguage != _currentLanguage) {
      _currentLanguage = detectedLanguage;
    }

    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isBot: false,
        timestamp: DateTime.now(),
        language: detectedLanguage,
      ));
    });

    _messageController.clear();

    // Simulate bot response
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _messages.add(ChatMessage(
          text: _getBotResponse(text),
          isBot: true,
          timestamp: DateTime.now(),
          language: _currentLanguage,
        ));
      });
    });
  }

  ChatLanguage _detectLanguage(String text) {
    final message = text.toLowerCase().trim();
    
    // Tunisian/Arabic keywords
    if (message.contains('كيف') || message.contains('شوية') || message.contains('برشا') || 
        message.contains('نحب') || message.contains('فما') || message.contains('وقتاش') ||
        message.contains('ياخي') || message.contains('زعمة') || message.contains('خلاص') ||
        message.contains('نرمل') || message.contains('حاجة') || message.contains('قداش') ||
        message.contains('شنوا') || message.contains('وين') || message.contains('منين')) {
      return ChatLanguage.tunisian;
    }
    
    // French keywords
    if (message.contains('bonjour') || message.contains('comment') || message.contains('je veux') ||
        message.contains('pouvez') || message.contains('merci') || message.contains('prix') ||
        message.contains('temps') || message.contains('irrigation') || message.contains('récolte') ||
        message.contains('marché') || message.contains('tomate') || message.contains('olive')) {
      return ChatLanguage.french;
    }
    
    // Default to current language or English
    return _currentLanguage;
  }

  String _getBotResponse(String userMessage) {
    final message = userMessage.toLowerCase();
    
    // Weather responses
    if (_containsWeatherKeywords(message)) {
      return _getWeatherResponse();
    }
    
    // Water/Irrigation responses
    if (_containsWaterKeywords(message)) {
      return _getWaterResponse();
    }
    
    // Pest control responses
    if (_containsPestKeywords(message)) {
      return _getPestResponse();
    }
    
    // Market/Price responses
    if (_containsMarketKeywords(message)) {
      return _getMarketResponse();
    }
    
    // Task management responses
    if (_containsTaskKeywords(message)) {
      return _getTaskResponse();
    }
    
    // Greeting responses
    if (_containsGreetingKeywords(message)) {
      return _getGreetingResponse();
    }
    
    // Default help response
    return _getHelpResponse();
  }

  // Language-specific helper methods
  String _getWelcomeMessage() {
    switch (_currentLanguage) {
      case ChatLanguage.english:
        return 'Hello! I\'m your multilingual farming assistant. I can help you in English, French, and Tunisian Arabic. How can I assist you today?';
      case ChatLanguage.french:
        return 'Bonjour ! Je suis votre assistant agricole multilingue. Je peux vous aider en anglais, français et arabe tunisien. Comment puis-je vous aider aujourd\'hui ?';
      case ChatLanguage.tunisian:
        return 'أهلا وسهلا! أنا مساعدك الفلاحي. نجم نساعدك بالعربي والفرنسي والإنجليزي. شنوا تحب نساعدك فيه اليوم؟';
    }
  }

  String _getAssistantTitle() {
    switch (_currentLanguage) {
      case ChatLanguage.english:
        return 'Farm Assistant';
      case ChatLanguage.french:
        return 'Assistant Agricole';
      case ChatLanguage.tunisian:
        return 'مساعد الفلاحة';
    }
  }

  String _getLanguageIndicator() {
    switch (_currentLanguage) {
      case ChatLanguage.english:
        return '🇬🇧 English';
      case ChatLanguage.french:
        return '🇫🇷 Français';
      case ChatLanguage.tunisian:
        return '🇹🇳 تونسي';
    }
  }

  String _getInputHint() {
    switch (_currentLanguage) {
      case ChatLanguage.english:
        return 'Type your message...';
      case ChatLanguage.french:
        return 'Tapez votre message...';
      case ChatLanguage.tunisian:
        return 'اكتب رسالتك...';
    }
  }

  String _getLanguageChangeMessage() {
    switch (_currentLanguage) {
      case ChatLanguage.english:
        return 'Language switched to English. How can I help you?';
      case ChatLanguage.french:
        return 'Langue changée en français. Comment puis-je vous aider ?';
      case ChatLanguage.tunisian:
        return 'تبدلت اللغة للعربي التونسي. شنوا تحب نساعدك فيه؟';
    }
  }

  // Keyword detection methods
  bool _containsWeatherKeywords(String message) {
    final weatherKeywords = {
      'weather', 'temperature', 'rain', 'sun', 'wind', 'forecast',
      'temps', 'météo', 'pluie', 'soleil', 'vent', 'prévisions',
      'طقس', 'جو', 'شتا', 'شمس', 'ريح', 'مطر'
    };
    return weatherKeywords.any((keyword) => message.contains(keyword));
  }
  bool _containsWaterKeywords(String message) {
    final waterKeywords = {
      'water', 'irrigation', 'watering', 'moisture', 'dry', 'wet',
      'eau', 'arrosage', 'humidité', 'sec', 'mouillé',
      'ماء', 'سقي', 'ري', 'رطوبة', 'نشف', 'رطب'
    };
    return waterKeywords.any((keyword) => message.contains(keyword));
  }

  bool _containsPestKeywords(String message) {
    final pestKeywords = {
      'pest', 'bug', 'insect', 'disease', 'fungus', 'organic',
      'parasite', 'insecte', 'maladie', 'champignon', 'biologique',
      'حشرة', 'آفة', 'مرض', 'فطريات', 'طبيعي'
    };
    return pestKeywords.any((keyword) => message.contains(keyword));
  }

  bool _containsMarketKeywords(String message) {
    final marketKeywords = {
      'price', 'market', 'sell', 'buy', 'cost', 'money',
      'prix', 'marché', 'vendre', 'acheter', 'coût', 'argent',
      'سعر', 'سوق', 'بيع', 'شرا', 'فلوس', 'ثمن'
    };
    return marketKeywords.any((keyword) => message.contains(keyword));
  }

  bool _containsTaskKeywords(String message) {
    final taskKeywords = {
      'task', 'todo', 'work', 'job', 'schedule', 'plan',
      'tâche', 'travail', 'emploi', 'horaire', 'planifier',
      'مهمة', 'شغل', 'خدمة', 'برنامج', 'خطة'
    };
    return taskKeywords.any((keyword) => message.contains(keyword));
  }

  bool _containsGreetingKeywords(String message) {
    final greetingKeywords = {
      'hello', 'hi', 'hey', 'good morning', 'good afternoon',
      'bonjour', 'salut', 'bonsoir', 'bonne journée',
      'أهلا', 'مرحبا', 'السلام', 'صباح الخير', 'مساء الخير'
    };
    return greetingKeywords.any((keyword) => message.contains(keyword));
  }

  // Response methods for different languages
  String _getWeatherResponse() {
    switch (_currentLanguage) {
      case ChatLanguage.english:
        return 'The weather forecast shows sunny conditions with temperatures around 24°C. Perfect for farming activities! ☀️';
      case ChatLanguage.french:
        return 'Les prévisions météo indiquent des conditions ensoleillées avec des températures autour de 24°C. Parfait pour les activités agricoles ! ☀️';
      case ChatLanguage.tunisian:
        return 'الجو اليوم مشمس والحرارة حوالي 24 درجة. وقت مليح للخدمة في الضيعة! ☀️';
    }
  }

  String _getWaterResponse() {
    switch (_currentLanguage) {
      case ChatLanguage.english:
        return 'Your soil moisture is at 68%. I recommend watering your tomato field in the early morning for best results. 💧';
      case ChatLanguage.french:
        return 'L\'humidité de votre sol est à 68%. Je recommande d\'arroser votre champ de tomates tôt le matin pour de meilleurs résultats. 💧';
      case ChatLanguage.tunisian:
        return 'رطوبة التربة متاعك 68%. ننصحك تسقي الطماطم فالصباح الباكر باش تجيب نتيجة مليحة. 💧';
    }
  }

  String _getPestResponse() {
    switch (_currentLanguage) {
      case ChatLanguage.english:
        return 'For organic pest control, try neem oil spray or companion planting with marigolds. Check our learning modules for more details! 🌿';
      case ChatLanguage.french:
        return 'Pour un contrôle biologique des parasites, essayez l\'huile de neem ou la plantation compagne avec des soucis. Consultez nos modules d\'apprentissage ! 🌿';
      case ChatLanguage.tunisian:
        return 'للتخلص من الحشرات بطريقة طبيعية، استعمل زيت النيم ولا ازرع القطيفة قرب النباتات. شوف في دروس التعلم! 🌿';
    }
  }

  String _getMarketResponse() {
    switch (_currentLanguage) {
      case ChatLanguage.english:
        return 'Current tomato prices in your region are 2.5 TND/kg. Prices have increased 15% this week - good time to sell! 💰';
      case ChatLanguage.french:
        return 'Les prix actuels des tomates dans votre région sont de 2,5 TND/kg. Les prix ont augmenté de 15% cette semaine - bon moment pour vendre ! 💰';
      case ChatLanguage.tunisian:
        return 'سعر الطماطم في منطقتك اليوم 2.5 دينار للكيلو. الأسعار طلعت 15% هالأسبوع - وقت مليح للبيع! 💰';
    }
  }

  String _getTaskResponse() {
    switch (_currentLanguage) {
      case ChatLanguage.english:
        return 'You have 3 pending tasks: water tomato field (urgent), apply fertilizer, and check pest traps. Which would you like to prioritize? ✅';
      case ChatLanguage.french:
        return 'Vous avez 3 tâches en attente : arroser le champ de tomates (urgent), appliquer l\'engrais et vérifier les pièges à insectes. Laquelle prioriser ? ✅';
      case ChatLanguage.tunisian:
        return 'عندك 3 مهام باقيين: سقي الطماطم (مستعجل)، حط السماد، وتفقد مصائد الحشرات. أشنوا تحب تعمل الأول؟ ✅';
    }
  }

  String _getGreetingResponse() {
    switch (_currentLanguage) {
      case ChatLanguage.english:
        return 'Hello there! Great to see you today. How can I help you with your farming needs? 😊';
      case ChatLanguage.french:
        return 'Bonjour ! Ravi de vous voir aujourd\'hui. Comment puis-je vous aider avec vos besoins agricoles ? 😊';
      case ChatLanguage.tunisian:
        return 'أهلا بيك! فرحان نشوفك اليوم. شنوا تحب نساعدك فيه في الفلاحة؟ 😊';
    }
  }

  String _getHelpResponse() {
    switch (_currentLanguage) {
      case ChatLanguage.english:
        return 'I can help you with:\n• Weather updates 🌤️\n• Irrigation advice 💧\n• Pest control 🐛\n• Market prices 💰\n• Task management ✅\n\nWhat would you like to know?';
      case ChatLanguage.french:
        return 'Je peux vous aider avec :\n• Mises à jour météo 🌤️\n• Conseils d\'irrigation 💧\n• Contrôle des parasites 🐛\n• Prix du marché 💰\n• Gestion des tâches ✅\n\nQue voulez-vous savoir ?';
      case ChatLanguage.tunisian:
        return 'نجم نساعدك في:\n• أخبار الطقس 🌤️\n• نصائح السقي 💧\n• مكافحة الحشرات 🐛\n• أسعار السوق 💰\n• تنظيم المهام ✅\n\nشنوا تحب تعرف؟';
    }
  }
}

class ChatMessage {
  final String text;
  final bool isBot;
  final DateTime timestamp;
  final ChatLanguage language;

  ChatMessage({
    required this.text,
    required this.isBot,
    required this.timestamp,
    required this.language,
  });
}

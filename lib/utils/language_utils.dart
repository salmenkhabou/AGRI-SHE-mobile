// Language utilities for multilingual support
class LanguageUtils {
  
  // Common Tunisian Arabic phrases and words for farming context
  static const Map<String, String> tunisianKeywords = {
    // Greetings
    'أهلا': 'hello',
    'مرحبا': 'hello', 
    'السلام': 'hello',
    'صباح الخير': 'good morning',
    'مساء الخير': 'good evening',
    
    // Questions
    'شنوا': 'what',
    'كيف': 'how',
    'وين': 'where',
    'منين': 'when',
    'قداش': 'how much',
    'وقتاش': 'when',
    
    // Farming terms
    'فلاحة': 'farming',
    'ضيعة': 'farm',
    'زرع': 'plant',
    'حصاد': 'harvest',
    'طماطم': 'tomato',
    'زيتون': 'olive',
    'خضرة': 'vegetables',
    'ماء': 'water',
    'سقي': 'watering',
    'ري': 'irrigation',
    'سماد': 'fertilizer',
    'تربة': 'soil',
    'بذور': 'seeds',
    
    // Weather
    'طقس': 'weather',
    'جو': 'weather',
    'شتا': 'rain',
    'شمس': 'sun',
    'ريح': 'wind',
    'حر': 'hot',
    'برد': 'cold',
    
    // Common expressions
    'برشا': 'a lot',
    'شوية': 'a little',
    'نحب': 'I want',
    'فما': 'there is',
    'ياخي': 'please',
    'زعمة': 'it seems',
    'خلاص': 'finished',
    'مليح': 'good',
    'نرمل': 'normal',
    'حاجة': 'thing',
    
    // Market terms
    'سوق': 'market',
    'سعر': 'price',
    'بيع': 'sell',
    'شرا': 'buy',
    'فلوس': 'money',
    'ثمن': 'price',
    'دينار': 'dinar',
    
    // Actions
    'شغل': 'work',
    'خدمة': 'work',
    'مهمة': 'task',
    'برنامج': 'schedule',
    'خطة': 'plan',
    
    // Problems
    'حشرة': 'insect',
    'آفة': 'pest',
    'مرض': 'disease',
    'مشكل': 'problem',
    'مشكلة': 'problem',
  };

  // French farming vocabulary
  static const Map<String, String> frenchKeywords = {
    // Greetings
    'bonjour': 'hello',
    'bonsoir': 'good evening',
    'salut': 'hi',
    'bonne journée': 'good day',
    
    // Questions
    'comment': 'how',
    'que': 'what',
    'quoi': 'what',
    'où': 'where',
    'quand': 'when',
    'combien': 'how much',
    'pourquoi': 'why',
    
    // Farming terms
    'agriculture': 'farming',
    'ferme': 'farm',
    'plantation': 'plantation',
    'récolte': 'harvest',
    'tomate': 'tomato',
    'olive': 'olive',
    'légumes': 'vegetables',
    'eau': 'water',
    'irrigation': 'irrigation',
    'arrosage': 'watering',
    'engrais': 'fertilizer',
    'sol': 'soil',
    'graines': 'seeds',
    
    // Weather
    'temps': 'weather',
    'météo': 'weather',
    'pluie': 'rain',
    'soleil': 'sun',
    'vent': 'wind',
    'chaud': 'hot',
    'froid': 'cold',
    
    // Market terms
    'marché': 'market',
    'prix': 'price',
    'vendre': 'sell',
    'acheter': 'buy',
    'argent': 'money',
    'coût': 'cost',
    
    // Actions
    'travail': 'work',
    'tâche': 'task',
    'horaire': 'schedule',
    'planifier': 'plan',
    
    // Problems
    'parasite': 'pest',
    'insecte': 'insect',
    'maladie': 'disease',
    'problème': 'problem',
    'champignon': 'fungus',
  };

  // Sample responses in different languages for quick reference
  static const Map<String, Map<String, String>> commonResponses = {
    'greeting': {
      'en': 'Hello! How can I help you with your farming needs today?',
      'fr': 'Bonjour ! Comment puis-je vous aider avec vos besoins agricoles aujourd\'hui ?',
      'tn': 'أهلا بيك! شنوا تحب نساعدك فيه في الفلاحة اليوم؟'
    },
    'weather': {
      'en': 'The weather looks great for farming today!',
      'fr': 'Le temps semble parfait pour l\'agriculture aujourd\'hui !',
      'tn': 'الجو اليوم مليح للخدمة في الضيعة!'
    },
    'help': {
      'en': 'I can help you with weather, irrigation, pest control, market prices, and task management.',
      'fr': 'Je peux vous aider avec la météo, l\'irrigation, le contrôle des parasites, les prix du marché et la gestion des tâches.',
      'tn': 'نجم نساعدك في الطقس والسقي ومكافحة الحشرات وأسعار السوق وتنظيم المهام.'
    }
  };

  // Detect if text contains Tunisian Arabic
  static bool containsTunisianArabic(String text) {
    return tunisianKeywords.keys.any((keyword) => text.contains(keyword)) ||
           text.contains(RegExp(r'[\u0600-\u06FF]')); // Arabic script range
  }

  // Detect if text contains French
  static bool containsFrench(String text) {
    return frenchKeywords.keys.any((keyword) => text.toLowerCase().contains(keyword));
  }

  // Get appropriate emoji for language
  static String getLanguageEmoji(String languageCode) {
    switch (languageCode) {
      case 'en':
        return '🇬🇧';
      case 'fr':
        return '🇫🇷';
      case 'tn':
        return '🇹🇳';
      default:
        return '🌍';
    }
  }

  // Format currency for different regions
  static String formatPrice(double price, String language) {
    switch (language) {
      case 'en':
        return '${price.toStringAsFixed(2)} TND';
      case 'fr':
        return '${price.toStringAsFixed(2)} DT';
      case 'tn':
        return '${price.toStringAsFixed(2)} دينار';
      default:
        return '${price.toStringAsFixed(2)} TND';
    }
  }
}

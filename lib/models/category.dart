// lib/models/category.dart

import 'package:pashu_bazaar/l10n/app_localizations.dart';

enum AnimalCategory {
  cow,
  buffalo,
  bull,
  ox,
  dog,
  sheep,
  goat,
  horse,
  donkey,
  camel,
  pig,
  rabbit,
  chicken,
  duck,
  other,
}

class CategoryHelper {
  static Map<AnimalCategory, List<String>> categoryKeywords = {
    AnimalCategory.cow: ['cow', 'गाय', 'गाय', 'cows', 'cattle'],
    AnimalCategory.buffalo: ['buffalo', 'भैंस', 'म्हैस', 'buffaloes', 'bhains'],
    AnimalCategory.bull: ['bull', 'बैल', 'बैल', 'bulls', 'sanda'],
    AnimalCategory.ox: ['ox', 'बैल', 'बैल', 'oxen', 'bael'],
    AnimalCategory.dog: ['dog', 'कुत्ता', 'कुत्रा', 'dogs', 'puppy', 'kutta'],
    AnimalCategory.sheep: ['sheep', 'भेड़', 'मेंढी', 'sheeps', 'lamb', 'bhed'],
    AnimalCategory.goat: ['goat', 'बकरी', 'शेळी', 'goats', 'kid', 'bakri'],
    AnimalCategory.horse: ['horse', 'घोड़ा', 'घोडा', 'horses', 'pony', 'ghoda'],
    AnimalCategory.donkey: ['donkey', 'गधा', 'गाढव', 'donkeys', 'gadha'],
    AnimalCategory.camel: ['camel', 'ऊंट', 'उंट', 'camels', 'oont'],
    AnimalCategory.pig: ['pig', 'सूअर', 'डुक्कर', 'pigs', 'suar'],
    AnimalCategory.rabbit: ['rabbit', 'खरगोश', 'ससा', 'rabbits', 'khargosh'],
    AnimalCategory.chicken: ['chicken', 'मुर्गी', 'कोंबडी', 'chickens', 'rooster', 'hen', 'murgi'],
    AnimalCategory.duck: ['duck', 'बतख', 'बदक', 'ducks', 'batak'],
    AnimalCategory.other: ['other', 'अन्य', 'इतर', 'animal', 'पशु', 'प्राणी'],
  };

  static String getCategoryDisplayName(AnimalCategory category, AppLocalizations l10n) {
    switch (category) {
      case AnimalCategory.cow:
        return l10n.cow;
      case AnimalCategory.buffalo:
        return l10n.buffalo;
      case AnimalCategory.bull:
        return l10n.bull;
      case AnimalCategory.ox:
        return l10n.ox;
      case AnimalCategory.dog:
        return l10n.dog;
      case AnimalCategory.sheep:
        return l10n.sheep;
      case AnimalCategory.goat:
        return l10n.goat;
      case AnimalCategory.horse:
        return l10n.horse;
      case AnimalCategory.donkey:
        return l10n.donkey;
      case AnimalCategory.camel:
        return l10n.camel;
      case AnimalCategory.pig:
        return l10n.pig;
      case AnimalCategory.rabbit:
        return l10n.rabbit;
      case AnimalCategory.chicken:
        return l10n.chicken;
      case AnimalCategory.duck:
        return l10n.duck;
      case AnimalCategory.other:
        return l10n.others;
    }
  }

  static List<AnimalCategory> getMainCategories() {
    return [
      AnimalCategory.cow,
      AnimalCategory.buffalo,
      AnimalCategory.bull,
      AnimalCategory.ox,
    ];
  }

  static List<AnimalCategory> getOtherCategories() {
    return [
      AnimalCategory.dog,
      AnimalCategory.sheep,
      AnimalCategory.goat,
      AnimalCategory.horse,
      AnimalCategory.donkey,
      AnimalCategory.camel,
      AnimalCategory.pig,
      AnimalCategory.rabbit,
      AnimalCategory.chicken,
      AnimalCategory.duck,
    ];
  }

  static bool isAnimalInCategory(String title, AnimalCategory category) {
    final titleLower = title.toLowerCase();
    final keywords = categoryKeywords[category] ?? [];
    
    for (var keyword in keywords) {
      if (titleLower.contains(keyword.toLowerCase())) {
        return true;
      }
    }
    return false;
  }

  static AnimalCategory? getCategoryFromString(String? categoryStr) {
    if (categoryStr == null) return null;
    
    switch (categoryStr.toLowerCase()) {
      case 'cow': return AnimalCategory.cow;
      case 'buffalo': return AnimalCategory.buffalo;
      case 'bull': return AnimalCategory.bull;
      case 'ox': return AnimalCategory.ox;
      case 'dog': return AnimalCategory.dog;
      case 'sheep': return AnimalCategory.sheep;
      case 'goat': return AnimalCategory.goat;
      case 'horse': return AnimalCategory.horse;
      case 'donkey': return AnimalCategory.donkey;
      case 'camel': return AnimalCategory.camel;
      case 'pig': return AnimalCategory.pig;
      case 'rabbit': return AnimalCategory.rabbit;
      case 'chicken': return AnimalCategory.chicken;
      case 'duck': return AnimalCategory.duck;
      case 'other': return AnimalCategory.other;
      default: return null;
    }
  }
}
// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get verifyOtpTitle => 'ओटीपी सत्यापित करें';

  @override
  String get pashuBazaar => 'पशु बाजार';

  @override
  String get searchHint => 'नाम या पिनकोड से खोजें';

  @override
  String get filter => 'फ़िल्टर';

  @override
  String get clearFilters => 'हटाएं';

  @override
  String get applyFilters => 'फ़िल्टर लागू करें';

  @override
  String get maxPrice => 'अधिकतम कीमत';

  @override
  String get minMilk => 'न्यूनतम दूध';

  @override
  String get apply => 'लागू करें';

  @override
  String get cow => 'गाय';

  @override
  String get buffalo => 'भैंस';

  @override
  String get bull => 'बैल';

  @override
  String get ox => 'सांड';

  @override
  String get noResults => 'कोई परिणाम नहीं मिला';

  @override
  String get login => 'लॉगिन';

  @override
  String get enterPhone => 'अपना मोबाइल नंबर दर्ज करें';

  @override
  String get otpInfo => 'आपके नंबर पर OTP भेजा जाएगा';

  @override
  String get enterPhoneHint => 'मोबाइल नंबर दर्ज करें';

  @override
  String get continueText => 'जारी रखें';

  @override
  String get invalidPhone => 'Please enter a valid 10 digit mobile number';

  @override
  String get enterOtp => 'ओटीपी दर्ज करें';

  @override
  String get verifyOtp => 'ओटीपी सत्यापित करें';

  @override
  String get enterOtpHint => '6 अंकों का ओटीपी दर्ज करें';

  @override
  String get verify => 'सत्यापित करें';

  @override
  String get invalidOtp => 'गलत ओटीपी';

  @override
  String get details => 'विवरण';

  @override
  String get openInGoogleMaps => 'Google Maps में खोलें';

  @override
  String get call => 'कॉल करें';

  @override
  String get whatsapp => 'व्हाट्सएप';

  @override
  String get whatsappMessage => 'नमस्ते, मुझे आपके इस पशु में रुचि है';

  @override
  String get milk => 'दूध';

  @override
  String get literPerDay => 'लीटर/दिन';

  @override
  String get age => 'उम्र';

  @override
  String get lactation => 'दुग्धावस्था';

  @override
  String get quantity => 'संख्या';

  @override
  String get location => 'स्थान';

  @override
  String get description => 'विवरण';

  @override
  String get noAddress => 'पता उपलब्ध नहीं है';

  @override
  String get noDescription => 'विवरण उपलब्ध नहीं है';

  @override
  String get addListing => 'लिस्टिंग जोड़ें';

  @override
  String get editListing => 'लिस्टिंग संपादित करें';

  @override
  String get updateListing => 'लिस्टिंग अपडेट करें';

  @override
  String get addPhoto => 'फोटो जोड़ें';

  @override
  String get pickLocation => 'स्थान चुनें';

  @override
  String get pickLocationError => 'कृपया स्थान चुनें';

  @override
  String get selectImage => 'कृपया एक फोटो चुनें';

  @override
  String get enterFullDetails => 'पशु की पूरी जानकारी भरें';

  @override
  String enterField(Object field) {
    return '$field दर्ज करें';
  }

  @override
  String genericError(Object error) {
    return 'त्रुटि: $error';
  }
}

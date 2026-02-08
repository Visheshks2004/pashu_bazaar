// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get verifyOtpTitle => 'ओटीपी पडताळणी';

  @override
  String get pashuBazaar => 'पशु बाजार';

  @override
  String get searchHint => 'नाव किंवा पिनकोडने शोधा';

  @override
  String get filter => 'फिल्टर';

  @override
  String get clearFilters => 'काढा';

  @override
  String get applyFilters => 'फिल्टर लागू करा';

  @override
  String get maxPrice => 'कमाल किंमत';

  @override
  String get minMilk => 'किमान दूध';

  @override
  String get apply => 'लागू करा';

  @override
  String get cow => 'गाय';

  @override
  String get buffalo => 'म्हैस';

  @override
  String get bull => 'बैल';

  @override
  String get ox => 'सांड';

  @override
  String get noResults => 'कोणतेही परिणाम नाहीत';

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
  String get enterOtp => 'ओटीपी टाका';

  @override
  String get verifyOtp => 'ओटीपी पडताळा';

  @override
  String get enterOtpHint => '६ अंकी ओटीपी टाका';

  @override
  String get verify => 'तपासा';

  @override
  String get invalidOtp => 'चुकीचा ओटीपी';

  @override
  String get details => 'तपशील';

  @override
  String get openInGoogleMaps => 'Google Maps मध्ये उघडा';

  @override
  String get call => 'कॉल करा';

  @override
  String get whatsapp => 'व्हॉट्सअॅप';

  @override
  String get whatsappMessage => 'नमस्कार, मला तुमच्या या जनावरात रस आहे';

  @override
  String get milk => 'दूध';

  @override
  String get literPerDay => 'लिटर/दिवस';

  @override
  String get age => 'वय';

  @override
  String get lactation => 'दूध देण्याचा कालावधी';

  @override
  String get quantity => 'संख्या';

  @override
  String get location => 'स्थान';

  @override
  String get description => 'वर्णन';

  @override
  String get noAddress => 'पत्ता उपलब्ध नाही';

  @override
  String get noDescription => 'वर्णन उपलब्ध नाही';

  @override
  String get addListing => 'लिस्टिंग जोडा';

  @override
  String get editListing => 'लिस्टिंग संपादित करा';

  @override
  String get updateListing => 'लिस्टिंग अद्यतनित करा';

  @override
  String get addPhoto => 'फोटो जोडा';

  @override
  String get pickLocation => 'स्थान निवडा';

  @override
  String get pickLocationError => 'कृपया स्थान निवडा';

  @override
  String get selectImage => 'कृपया फोटो निवडा';

  @override
  String get enterFullDetails => 'जनावराबद्दल संपूर्ण माहिती भरा';

  @override
  String enterField(Object field) {
    return '$field भरा';
  }

  @override
  String genericError(Object error) {
    return 'त्रुटी: $error';
  }
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get verifyOtpTitle => 'Verify OTP';

  @override
  String get pashuBazaar => 'Pashu Bazaar';

  @override
  String get searchHint => 'Search by name or pincode';

  @override
  String get filter => 'Filter';

  @override
  String get clearFilters => 'Clear';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get maxPrice => 'Max Price';

  @override
  String get minMilk => 'Minimum Milk';

  @override
  String get apply => 'Apply';

  @override
  String get cow => 'Cow';

  @override
  String get buffalo => 'Buffalo';

  @override
  String get bull => 'Bull';

  @override
  String get ox => 'Ox';

  @override
  String get noResults => 'No results found';

  @override
  String get login => 'Login';

  @override
  String get enterPhone => 'Enter your phone number';

  @override
  String get otpInfo => 'We will send you a verification code';

  @override
  String get enterPhoneHint => 'Enter phone number';

  @override
  String get continueText => 'Continue';

  @override
  String get invalidPhone => 'Please enter a valid 10 digit mobile number';

  @override
  String get enterOtp => 'Enter OTP';

  @override
  String get verifyOtp => 'Verify OTP';

  @override
  String get enterOtpHint => 'Enter 6 digit OTP';

  @override
  String get verify => 'Verify';

  @override
  String get invalidOtp => 'Invalid OTP';

  @override
  String get details => 'Details';

  @override
  String get openInGoogleMaps => 'Open in Google Maps';

  @override
  String get call => 'Call';

  @override
  String get whatsapp => 'WhatsApp';

  @override
  String get whatsappMessage => 'Hi, I\'m interested in your';

  @override
  String get milk => 'Milk';

  @override
  String get literPerDay => 'L/day';

  @override
  String get age => 'Age';

  @override
  String get lactation => 'Lactation';

  @override
  String get quantity => 'Quantity';

  @override
  String get location => 'Location';

  @override
  String get description => 'Description';

  @override
  String get noAddress => 'No address';

  @override
  String get noDescription => 'No description';

  @override
  String get addListing => 'Add Listing';

  @override
  String get editListing => 'Edit Listing';

  @override
  String get updateListing => 'Update Listing';

  @override
  String get addPhoto => 'Add Photo';

  @override
  String get pickLocation => 'Pick Location';

  @override
  String get pickLocationError => 'Please select location';

  @override
  String get selectImage => 'Please select an image';

  @override
  String get enterFullDetails => 'Enter full details about animal';

  @override
  String enterField(Object field) {
    return 'Enter $field';
  }

  @override
  String genericError(Object error) {
    return 'Error: $error';
  }
}

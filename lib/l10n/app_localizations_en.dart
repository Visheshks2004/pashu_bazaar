// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get myProfile => 'My Profile';

  @override
  String get myFavorites => 'My Favorites';

  @override
  String get myListings => 'My Listings';

  @override
  String get noFavoritesYet => 'No favorites yet';

  @override
  String get noListingsYet => 'You have no listings yet';

  @override
  String get addNewListing => 'Add New Listing';

  @override
  String get deleteListing => 'Delete Listing';

  @override
  String get deleteConfirmation =>
      'Are you sure you want to delete this listing?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirmDelete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get delete => 'Delete';

  @override
  String get photo => 'Photo';

  @override
  String get noPhone => 'No phone';

  @override
  String get saveAnimalsHint =>
      'Save animals you like by tapping the heart icon';

  @override
  String get logout => 'Logout';

  @override
  String get logoutConfirmation => 'Are you sure you want to logout?';

  @override
  String get titleField => 'Title';

  @override
  String get priceField => 'Price';

  @override
  String get ageYearsField => 'Age (Years)';

  @override
  String get milkPerDayField => 'Milk / Day (Litre)';

  @override
  String get lactationField => 'Lactation';

  @override
  String get quantityField => 'Quantity';

  @override
  String get descriptionField => 'Description';

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
  String get category => 'Category';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get categoryError => 'Please select a category';

  @override
  String get allAnimals => 'All Animals';

  @override
  String get otherAnimals => 'Other Animals';

  @override
  String get cow => 'Cow';

  @override
  String get buffalo => 'Buffalo';

  @override
  String get bull => 'Bull';

  @override
  String get ox => 'Ox';

  @override
  String get dog => 'Dog';

  @override
  String get sheep => 'Sheep';

  @override
  String get goat => 'Goat';

  @override
  String get horse => 'Horse';

  @override
  String get donkey => 'Donkey';

  @override
  String get camel => 'Camel';

  @override
  String get pig => 'Pig';

  @override
  String get rabbit => 'Rabbit';

  @override
  String get chicken => 'Chicken';

  @override
  String get duck => 'Duck';

  @override
  String get others => 'Others';

  @override
  String get verifyOtpTitle => 'Verify OTP';

  @override
  String get enterOtp => 'Enter OTP';

  @override
  String get enter6DigitOtp => 'Enter 6 digit OTP';

  @override
  String enterOtpSentTo(Object phone) {
    return 'Enter OTP sent to $phone';
  }

  @override
  String get yourNumber => 'your number';

  @override
  String get didntReceiveOtp => 'Didn\'t receive OTP?';

  @override
  String get resend => 'Resend';

  @override
  String get verify => 'Verify';

  @override
  String get invalidOtp => 'Invalid OTP';

  @override
  String get invalidOtpCode => 'Invalid OTP code';

  @override
  String get otpSessionExpired => 'OTP session expired. Please request again';

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
  String get noResults => 'No results found';

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
  String enterField(Object field) {
    return 'Enter $field';
  }

  @override
  String genericError(Object error) {
    return 'Error: $error';
  }
}

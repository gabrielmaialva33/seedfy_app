import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// The name of the application
  ///
  /// In en, this message translates to:
  /// **'Seedfy'**
  String get appName;

  /// Common save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// Common cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// Common edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get common_edit;

  /// Common delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;

  /// Common back button text
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get common_back;

  /// Common approve button text
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get common_approve;

  /// Common export CSV button text
  ///
  /// In en, this message translates to:
  /// **'Export CSV'**
  String get common_exportCsv;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get auth_login;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get auth_signup;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get auth_name;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get auth_email;

  /// Phone field label
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get auth_phone;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get auth_password;

  /// Location field label
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get auth_location;

  /// City field label
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get auth_city;

  /// State field label
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get auth_state;

  /// Welcome message in onboarding
  ///
  /// In en, this message translates to:
  /// **'Welcome to Seedfy'**
  String get onboarding_welcome;

  /// Area dimensions step title
  ///
  /// In en, this message translates to:
  /// **'Area Dimensions'**
  String get onboarding_dimensions;

  /// Length field label
  ///
  /// In en, this message translates to:
  /// **'Length (m)'**
  String get onboarding_length;

  /// Width field label
  ///
  /// In en, this message translates to:
  /// **'Width (m)'**
  String get onboarding_width;

  /// Path gap field label
  ///
  /// In en, this message translates to:
  /// **'Path between beds (m)'**
  String get onboarding_pathGap;

  /// Select crops step title
  ///
  /// In en, this message translates to:
  /// **'Select Crops'**
  String get onboarding_selectCrops;

  /// Preview step title
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get onboarding_preview;

  /// Map screen title
  ///
  /// In en, this message translates to:
  /// **'Garden Map'**
  String get map_title;

  /// Add bed button text
  ///
  /// In en, this message translates to:
  /// **'Add Bed'**
  String get map_addBed;

  /// Healthy status text
  ///
  /// In en, this message translates to:
  /// **'Healthy'**
  String get status_healthy;

  /// Warning status text
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get status_warning;

  /// Critical status text
  ///
  /// In en, this message translates to:
  /// **'Critical'**
  String get status_critical;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Seedfy';

  @override
  String get common_save => 'Save';

  @override
  String get common_cancel => 'Cancel';

  @override
  String get common_edit => 'Edit';

  @override
  String get common_delete => 'Delete';

  @override
  String get common_back => 'Back';

  @override
  String get common_approve => 'Approve';

  @override
  String get common_exportCsv => 'Export CSV';

  @override
  String get auth_login => 'Login';

  @override
  String get auth_signup => 'Sign Up';

  @override
  String get auth_name => 'Name';

  @override
  String get auth_email => 'Email';

  @override
  String get auth_phone => 'Phone';

  @override
  String get auth_password => 'Password';

  @override
  String get auth_location => 'Location';

  @override
  String get auth_city => 'City';

  @override
  String get auth_state => 'State';

  @override
  String get onboarding_welcome => 'Welcome to Seedfy';

  @override
  String get onboarding_dimensions => 'Area Dimensions';

  @override
  String get onboarding_length => 'Length (m)';

  @override
  String get onboarding_width => 'Width (m)';

  @override
  String get onboarding_pathGap => 'Path between beds (m)';

  @override
  String get onboarding_selectCrops => 'Select Crops';

  @override
  String get onboarding_preview => 'Preview';

  @override
  String get map_title => 'Garden Map';

  @override
  String get map_addBed => 'Add Bed';

  @override
  String get status_healthy => 'Healthy';

  @override
  String get status_warning => 'Warning';

  @override
  String get status_critical => 'Critical';
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en')
  ];

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @enterDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter your details below and get started'**
  String get enterDetails;

  /// No description provided for @signInTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get emailHint;

  /// No description provided for @emailEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email address'**
  String get emailEmptyError;

  /// No description provided for @emailInvalidError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get emailInvalidError;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @passwordEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordEmptyError;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @signInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully signed in'**
  String get signInSuccess;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get signInWithGoogle;

  /// No description provided for @googleSignInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Google'**
  String get googleSignInSuccess;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed'**
  String get googleSignInFailed;

  /// No description provided for @orSignInWith.
  ///
  /// In en, this message translates to:
  /// **'Or, sign in with'**
  String get orSignInWith;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUpButton.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpButton;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccount;

  /// No description provided for @enterDetailsSignup.
  ///
  /// In en, this message translates to:
  /// **'Enter your details below and join with us today'**
  String get enterDetailsSignup;

  /// No description provided for @signUpTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUpTitle;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @nameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your full name'**
  String get nameHint;

  /// No description provided for @nameEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get nameEmptyError;

  /// No description provided for @passwordTooShortError.
  ///
  /// In en, this message translates to:
  /// **'Password should be a minimum of 6 characters'**
  String get passwordTooShortError;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter the correct password'**
  String get confirmPasswordHint;

  /// No description provided for @confirmPasswordEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your password'**
  String get confirmPasswordEmptyError;

  /// No description provided for @passwordsDoNotMatchError.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get passwordsDoNotMatchError;

  /// No description provided for @signUpSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully signed up, You can login now'**
  String get signUpSuccess;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset password'**
  String get resetPasswordTitle;

  /// No description provided for @resetPasswordInstruction.
  ///
  /// In en, this message translates to:
  /// **'Don\'t worry! Please enter the email address linked with your account'**
  String get resetPasswordInstruction;

  /// No description provided for @enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// No description provided for @sendLinkButton.
  ///
  /// In en, this message translates to:
  /// **'Send link'**
  String get sendLinkButton;

  /// No description provided for @resetSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully sent a password reset link to your email'**
  String get resetSuccess;

  /// No description provided for @rememberPassword.
  ///
  /// In en, this message translates to:
  /// **'Remember password?'**
  String get rememberPassword;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for notes'**
  String get searchHint;

  /// No description provided for @noInternet.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternet;

  /// No description provided for @categoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesTitle;

  /// No description provided for @allNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'All notes'**
  String get allNotesTitle;

  /// No description provided for @noNotesFound.
  ///
  /// In en, this message translates to:
  /// **'No notes found'**
  String get noNotesFound;

  /// No description provided for @noNotesToShow.
  ///
  /// In en, this message translates to:
  /// **'No notes to show'**
  String get noNotesToShow;

  /// No description provided for @addNote.
  ///
  /// In en, this message translates to:
  /// **'Add note'**
  String get addNote;

  /// No description provided for @addNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get addNoteTitle;

  /// No description provided for @noteTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a title'**
  String get noteTitleHint;

  /// No description provided for @noteDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a description'**
  String get noteDescriptionHint;

  /// No description provided for @noteTitleEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get noteTitleEmptyError;

  /// No description provided for @noteDescriptionEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please enter a description'**
  String get noteDescriptionEmptyError;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select category'**
  String get selectCategory;

  /// No description provided for @categoryEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get categoryEmptyError;

  /// No description provided for @allCategory.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategory;

  /// No description provided for @workCategory.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get workCategory;

  /// No description provided for @personalCategory.
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personalCategory;

  /// No description provided for @studyCategory.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get studyCategory;

  /// No description provided for @otherCategory.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get otherCategory;

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category : '**
  String get categoryLabel;

  /// No description provided for @cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButton;

  /// No description provided for @updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get updateButton;

  /// No description provided for @drawerChangeTheme.
  ///
  /// In en, this message translates to:
  /// **'Change theme'**
  String get drawerChangeTheme;

  /// No description provided for @drawerChangeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change language'**
  String get drawerChangeLanguage;

  /// No description provided for @drawerEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get drawerEnglish;

  /// No description provided for @drawerBangla.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get drawerBangla;

  /// No description provided for @drawerHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get drawerHistory;

  /// No description provided for @drawerSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get drawerSignOut;

  /// No description provided for @drawerExitApp.
  ///
  /// In en, this message translates to:
  /// **'Exit app'**
  String get drawerExitApp;

  /// No description provided for @guestUser.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestUser;

  /// No description provided for @noEmail.
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get noEmail;

  /// No description provided for @exitDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Wait'**
  String get exitDialogTitle;

  /// No description provided for @exitDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit from the app?'**
  String get exitDialogContent;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @internetRestored.
  ///
  /// In en, this message translates to:
  /// **'Internet connection restored'**
  String get internetRestored;

  /// No description provided for @searchHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Search history'**
  String get searchHistoryTitle;

  /// No description provided for @pleaseLoginToViewHistory.
  ///
  /// In en, this message translates to:
  /// **'Please log in to view search history.'**
  String get pleaseLoginToViewHistory;

  /// No description provided for @noHistoryToShow.
  ///
  /// In en, this message translates to:
  /// **'No history to show'**
  String get noHistoryToShow;

  /// No description provided for @youSearchedFor.
  ///
  /// In en, this message translates to:
  /// **'You searched for'**
  String get youSearchedFor;

  /// No description provided for @lastUpdated.
  ///
  /// In en, this message translates to:
  /// **'Last updated'**
  String get lastUpdated;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn': return AppLocalizationsBn();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
  ];

  /// Name of the app
  ///
  /// In en, this message translates to:
  /// **'SplitHawk'**
  String get appName;

  /// App purpose
  ///
  /// In en, this message translates to:
  /// **'Your ultimate expense sharing app'**
  String get appDescription;

  /// Welcome prefix
  ///
  /// In en, this message translates to:
  /// **'Welcome to '**
  String get welcomeTo;

  /// Search text
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// User email
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// User password
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Sign in button
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Sign up button
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Forgot password prompt
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Reset password
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// Reset confirmation
  ///
  /// In en, this message translates to:
  /// **'A reset password link has been sent to your email'**
  String get resetLinkSent;

  /// Google sign-in
  ///
  /// In en, this message translates to:
  /// **'Sign In with Google'**
  String get signInWithGoogle;

  /// Apple sign-in
  ///
  /// In en, this message translates to:
  /// **'Sign In with Apple'**
  String get signInWithApple;

  /// Home screen
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Error
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Favorites
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// OK button
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Add group button
  ///
  /// In en, this message translates to:
  /// **'Add Group'**
  String get addGroup;

  /// Add group title
  ///
  /// In en, this message translates to:
  /// **'Add Group Title'**
  String get addGroupTitle;

  /// Account
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Check prompt
  ///
  /// In en, this message translates to:
  /// **'Check Now'**
  String get checkNow;

  /// Account info section
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInfo;

  /// Settings menu
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Theme switch
  ///
  /// In en, this message translates to:
  /// **'Dark Theme'**
  String get darkTheme;

  /// Language option
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Description text
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// Total amount
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// Success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Yes option
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No option
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// Sign out button
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// Alternative methods
  ///
  /// In en, this message translates to:
  /// **'Other methods'**
  String get anotherMthods;

  /// Add expense button
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// Add expense title
  ///
  /// In en, this message translates to:
  /// **'Expense Title'**
  String get addExpenseTitle;

  /// Add expense amount
  ///
  /// In en, this message translates to:
  /// **'Expense Amount'**
  String get addExpenseAmount;

  /// Add expense description
  ///
  /// In en, this message translates to:
  /// **'Expense Description'**
  String get addExpenseDescription;

  /// Add expense date
  ///
  /// In en, this message translates to:
  /// **'Expense Date'**
  String get expenseDate;

  /// Add expense category
  ///
  /// In en, this message translates to:
  /// **'Expense Category'**
  String get expenseCategory;

  /// Add expense split
  ///
  /// In en, this message translates to:
  /// **'Expense Split'**
  String get addExpenseSplit;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Expense success message
  ///
  /// In en, this message translates to:
  /// **'Expense added successfully'**
  String get addExpenseSuccess;

  /// Expense error message
  ///
  /// In en, this message translates to:
  /// **'Error adding expense'**
  String get addExpenseError;

  /// Additional login methods
  ///
  /// In en, this message translates to:
  /// **'Additional login methods'**
  String get additionalLoginMethods;

  /// Invalid email message
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmail;

  /// Invalid password message
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get invalidPassword;

  /// Invalid confirm password message
  ///
  /// In en, this message translates to:
  /// **'Invalid confirm password'**
  String get invalidConfirmPassword;

  /// Phone number prompt
  ///
  /// In en, this message translates to:
  /// **'please enter your phone number'**
  String get enterYourPhoneNumber;

  /// Password length message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 7 characters'**
  String get passwordLength;

  /// Invalid phone number message
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhoneNumber;

  /// Invalid name message
  ///
  /// In en, this message translates to:
  /// **'Invalid name'**
  String get invalidName;

  /// Invalid group name message
  ///
  /// In en, this message translates to:
  /// **'Invalid group name'**
  String get invalidGroupName;

  /// Password prompt
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get enterYourPassword;

  /// Empty field message
  ///
  /// In en, this message translates to:
  /// **'This field can\'t be empty'**
  String get cantBeEmpty;

  /// Email prompt
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get enterYourEmail;

  /// Name prompt
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enterYourName;

  /// Full name length message
  ///
  /// In en, this message translates to:
  /// **'Full name must be at least 3 characters'**
  String get fullNameLength;

  /// Full name
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Activities
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// Groups
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get groups;

  /// Reload page
  ///
  /// In en, this message translates to:
  /// **'Reload Page'**
  String get reloadPage;

  /// Create account
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Phone number
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// Email in use message
  ///
  /// In en, this message translates to:
  /// **'Email already in use try to login or reset your password'**
  String get emailAlreadyInUse;

  /// Email not found message
  ///
  /// In en, this message translates to:
  /// **'Email not found'**
  String get emailNotFound;

  /// Weak password message
  ///
  /// In en, this message translates to:
  /// **'Weak password'**
  String get weakPassword;

  /// Password mismatch message
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordMismatch;

  /// Invalid credentials message
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// Error occurred message
  ///
  /// In en, this message translates to:
  /// **'Error occurred'**
  String get errorOccurred;

  /// Uppercase letter message
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one uppercase letter'**
  String get mustContainUppercase;

  /// Lowercase letter message
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one lowercase letter'**
  String get mustContainLowercase;

  /// Number message
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one number'**
  String get mustContainNumber;

  /// Special character message
  ///
  /// In en, this message translates to:
  /// **'Password must contain at least one special character'**
  String get mustContainSpecialChar;

  /// Default error message
  ///
  /// In en, this message translates to:
  /// **'An error occurred. Please try again'**
  String get defaultErrorMessage;

  /// User not found message
  ///
  /// In en, this message translates to:
  /// **'User not found'**
  String get userNotFound;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// Too many requests message
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Please try again later'**
  String get tooManyRequests;

  /// Record not found message
  ///
  /// In en, this message translates to:
  /// **'Record not found'**
  String get notFound;

  /// Permission denied message
  ///
  /// In en, this message translates to:
  /// **'Contacts permission denied'**
  String get contactsPermissionDenied;

  /// Permission denied message
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// Service unavailable message
  ///
  /// In en, this message translates to:
  /// **'Service unavailable'**
  String get serviceUnavailable;

  /// Dark mode
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Account settings
  ///
  /// In en, this message translates to:
  /// **'Account Settings'**
  String get accountSettings;

  /// Notifications
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Notification settings
  ///
  /// In en, this message translates to:
  /// **'Notification Settings'**
  String get notificationSettings;

  /// Change password
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Manage block list
  ///
  /// In en, this message translates to:
  /// **'Manage Block List'**
  String get manageBlockList;

  /// Contact us
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// Scan QR code
  ///
  /// In en, this message translates to:
  /// **'Scan your friend\'s QR code'**
  String get scanYourFriendQrCode;

  /// Share QR code
  ///
  /// In en, this message translates to:
  /// **'Share your QR code'**
  String get shareQrCode;

  /// Close button
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Your QR code
  ///
  /// In en, this message translates to:
  /// **'Your QR Code'**
  String get yourQrCode;

  /// QR code
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrCode;

  /// Visit website
  ///
  /// In en, this message translates to:
  /// **'Visit SplitHawk website'**
  String get visitSplitHawkWebsite;

  /// Send feedback
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// Kindly rate and support us
  ///
  /// In en, this message translates to:
  /// **'Kindly rate and support us'**
  String get rateUs;

  /// Share app
  ///
  /// In en, this message translates to:
  /// **'Share the app'**
  String get shareApp;

  /// Sign in canceled
  ///
  /// In en, this message translates to:
  /// **'Sign In Canceled'**
  String get signInCanceled;

  /// Sign in failed
  ///
  /// In en, this message translates to:
  /// **'Sign In Failed'**
  String get signInFailed;

  /// Email sent successfully
  ///
  /// In en, this message translates to:
  /// **'Email Sent Successfully'**
  String get emailSentSuccessfully;

  /// Verify now
  ///
  /// In en, this message translates to:
  /// **'Verify Now'**
  String get verifyNow;

  /// Email verification sent
  ///
  /// In en, this message translates to:
  /// **'Email Verification Sent'**
  String get emailVerificationSent;

  /// Email verified
  ///
  /// In en, this message translates to:
  /// **'Email Verified'**
  String get emailVerified;

  /// Add friend
  ///
  /// In en, this message translates to:
  /// **'Add Friend'**
  String get addFriend;

  /// Done button
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Open settings
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// Grant permission
  ///
  /// In en, this message translates to:
  /// **'Grant Permission'**
  String get grantPermission;

  /// Verify contacts
  ///
  /// In en, this message translates to:
  /// **'Verify Contacts'**
  String get verifyContacts;

  /// Confirm add contact
  ///
  /// In en, this message translates to:
  /// **'Confirm Add Contact'**
  String get confirmAddContact;

  /// Check number before confirmation
  ///
  /// In en, this message translates to:
  /// **'Check number before confirmation'**
  String get checkNumberBeforeConfirmation;

  /// Finish button
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// Edit button
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// Confirm button
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Edit contact info
  ///
  /// In en, this message translates to:
  /// **'Edit Contact'**
  String get editContact;

  /// Account linking
  ///
  /// In en, this message translates to:
  /// **'Account Linking'**
  String get accountLinking;

  /// Name length message
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 3 characters'**
  String get nameLength;

  /// Nickname
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nickName;

  /// Add new friend
  ///
  /// In en, this message translates to:
  /// **'Add New Friend'**
  String get addNewFriend;

  /// Search your contacts
  ///
  /// In en, this message translates to:
  /// **'Search your contacts'**
  String get searchContacts;

  /// User Already exists try to login or reset your password
  ///
  /// In en, this message translates to:
  /// **'User already exists try to login or reset your password'**
  String get userAlreadyExists;

  /// Try again later
  ///
  /// In en, this message translates to:
  /// **'Try again later'**
  String get tryAgainLater;

  /// Reset password email sent
  ///
  /// In en, this message translates to:
  /// **'Reset password email sent'**
  String get resetPasswordEmailSent;

  /// Friend already added before
  ///
  /// In en, this message translates to:
  /// **'Friend already added before'**
  String get friendAlreadyAddedBefore;

  /// Friend added successfully
  ///
  /// In en, this message translates to:
  /// **'Friend added successfully'**
  String get friendAddedSuccessfully;

  /// Try adding some friends
  ///
  /// In en, this message translates to:
  /// **'Try adding some friends'**
  String get tryAddingSomeFriends;

  /// Error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// Error fetching friends
  ///
  /// In en, this message translates to:
  /// **'Error fetching friends'**
  String get errorFetchingFriends;

  /// No friends found
  ///
  /// In en, this message translates to:
  /// **'No friends found'**
  String get noFriendsFound;

  /// Too long message
  ///
  /// In en, this message translates to:
  /// **'Too long, more than 18 characters'**
  String get tooLongMoreThan18Chars;

  /// Invalid characters message
  ///
  /// In en, this message translates to:
  /// **'Invalid characters'**
  String get invalidCharacters;

  /// settled
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get settled;

  /// You owe
  ///
  /// In en, this message translates to:
  /// **'You owe'**
  String get youOwe;

  /// Owes you
  ///
  /// In en, this message translates to:
  /// **'owes you'**
  String get owesYou;

  /// Enter amount prompt
  ///
  /// In en, this message translates to:
  /// **'Please enter the amount'**
  String get enterAmount;

  /// Invalid amount message ex:10.5
  ///
  /// In en, this message translates to:
  /// **'Invalid amount. Example: 10.5'**
  String get invalidAmount;

  /// Expense amount
  ///
  /// In en, this message translates to:
  /// **'Expense Amount'**
  String get expenseAmount;

  /// Friends selected
  ///
  /// In en, this message translates to:
  /// **'friends selected'**
  String get friendsSelected;

  /// Split method
  ///
  /// In en, this message translates to:
  /// **'Split Method'**
  String get splitMethod;

  /// Equal split
  ///
  /// In en, this message translates to:
  /// **'Equal Split'**
  String get equalSplit;

  /// They paid full, you owe half
  ///
  /// In en, this message translates to:
  /// **'They paid full, you owe half'**
  String get theyPaidFullYouOweHalf;

  /// They paid full, you owe full
  ///
  /// In en, this message translates to:
  /// **'They paid full, you owe full'**
  String get theyPaidFullYouOweFull;

  /// You paid full, they owe half
  ///
  /// In en, this message translates to:
  /// **'You paid full, they owe half'**
  String get youPaidFullTheyOweHalf;

  /// You paid full, they owe full
  ///
  /// In en, this message translates to:
  /// **'You paid full, they owe full'**
  String get youPaidFullTheyOweFull;

  /// You paid
  ///
  /// In en, this message translates to:
  /// **'You paid'**
  String get youPaid;

  /// Each friend owes you
  ///
  /// In en, this message translates to:
  /// **'Each friend owes you'**
  String get eachFriendOwesYou;

  /// They paid
  ///
  /// In en, this message translates to:
  /// **'They paid'**
  String get theyPaid;

  /// You owe each friend
  ///
  /// In en, this message translates to:
  /// **'You owe each friend'**
  String get youOweEachFriend;
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
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

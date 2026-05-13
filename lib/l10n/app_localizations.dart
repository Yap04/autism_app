import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_zh.dart';

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
    Locale('zh'),
  ];

  /// No description provided for @parentFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get parentFallbackName;

  /// No description provided for @goodMorningGreeting.
  ///
  /// In en, this message translates to:
  /// **'Good Morning,\n{name}!'**
  String goodMorningGreeting(String name);

  /// No description provided for @errorLoadingData.
  ///
  /// In en, this message translates to:
  /// **'Error loading data: {error}'**
  String errorLoadingData(String error);

  /// No description provided for @childsMilestones.
  ///
  /// In en, this message translates to:
  /// **'Child\'s Milestones'**
  String get childsMilestones;

  /// No description provided for @latestSessionInsight.
  ///
  /// In en, this message translates to:
  /// **'Latest Session Insight'**
  String get latestSessionInsight;

  /// No description provided for @resourcesForYou.
  ///
  /// In en, this message translates to:
  /// **'Resources for You'**
  String get resourcesForYou;

  /// No description provided for @viewMore.
  ///
  /// In en, this message translates to:
  /// **'View More'**
  String get viewMore;

  /// No description provided for @failedToLoadContent.
  ///
  /// In en, this message translates to:
  /// **'Failed to load content.'**
  String get failedToLoadContent;

  /// No description provided for @moreResourcesComingSoon.
  ///
  /// In en, this message translates to:
  /// **'More resources coming soon!'**
  String get moreResourcesComingSoon;

  /// No description provided for @todayTime.
  ///
  /// In en, this message translates to:
  /// **'Today, {time}'**
  String todayTime(String time);

  /// No description provided for @tomorrowTime.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow, {time}'**
  String tomorrowTime(String time);

  /// No description provided for @upcomingAppointment.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Appointment'**
  String get upcomingAppointment;

  /// No description provided for @chatWithCoach.
  ///
  /// In en, this message translates to:
  /// **'Chat with Coach'**
  String get chatWithCoach;

  /// No description provided for @totalSessions.
  ///
  /// In en, this message translates to:
  /// **'Total\nSessions'**
  String get totalSessions;

  /// No description provided for @hoursTrained.
  ///
  /// In en, this message translates to:
  /// **'Hours\nTrained'**
  String get hoursTrained;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current\nStreak'**
  String get currentStreak;

  /// No description provided for @noInsightsYet.
  ///
  /// In en, this message translates to:
  /// **'No insights yet'**
  String get noInsightsYet;

  /// No description provided for @noInsightsDescription.
  ///
  /// In en, this message translates to:
  /// **'After your child\'s first session, you\'ll receive detailed feedback and focus scores from the coach right here.'**
  String get noInsightsDescription;

  /// No description provided for @sportAndDate.
  ///
  /// In en, this message translates to:
  /// **'{sport} • {date}'**
  String sportAndDate(String sport, String date);

  /// No description provided for @focusScore.
  ///
  /// In en, this message translates to:
  /// **'Focus: {score}/5'**
  String focusScore(String score);

  /// No description provided for @feedbackRemarks.
  ///
  /// In en, this message translates to:
  /// **'\"{remarks}\"'**
  String feedbackRemarks(String remarks);

  /// No description provided for @viewFullReport.
  ///
  /// In en, this message translates to:
  /// **'View Full Report'**
  String get viewFullReport;

  /// No description provided for @noUpcomingAppointments.
  ///
  /// In en, this message translates to:
  /// **'No upcoming appointments'**
  String get noUpcomingAppointments;

  /// No description provided for @bookNewSessionPrompt.
  ///
  /// In en, this message translates to:
  /// **'Book a new session to get started!'**
  String get bookNewSessionPrompt;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// No description provided for @navSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get navSchedule;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @gpsServiceDisabled.
  ///
  /// In en, this message translates to:
  /// **'Please turn on GPS location services.'**
  String get gpsServiceDisabled;

  /// No description provided for @locationPermissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission denied.'**
  String get locationPermissionDenied;

  /// No description provided for @locationPermissionPermanentlyDenied.
  ///
  /// In en, this message translates to:
  /// **'Location permission permanently denied. Please enable in settings.'**
  String get locationPermissionPermanentlyDenied;

  /// No description provided for @findCoachesNearYou.
  ///
  /// In en, this message translates to:
  /// **'Find Coaches Near You'**
  String get findCoachesNearYou;

  /// No description provided for @turnOnLocationPrompt.
  ///
  /// In en, this message translates to:
  /// **'Turn on location services to find the closest trainers.'**
  String get turnOnLocationPrompt;

  /// No description provided for @enableAction.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enableAction;

  /// No description provided for @nearbyCertifiedTrainers.
  ///
  /// In en, this message translates to:
  /// **'Nearby Certified Trainers'**
  String get nearbyCertifiedTrainers;

  /// No description provided for @viewAllAction.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAllAction;

  /// No description provided for @errorMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: {error}'**
  String errorMessage(String error);

  /// No description provided for @noTrainersFound.
  ///
  /// In en, this message translates to:
  /// **'No trainers found.'**
  String get noTrainersFound;

  /// No description provided for @distanceUnknown.
  ///
  /// In en, this message translates to:
  /// **'Distance unknown'**
  String get distanceUnknown;

  /// No description provided for @distanceMetersAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} m away'**
  String distanceMetersAway(String distance);

  /// No description provided for @distanceKmAway.
  ///
  /// In en, this message translates to:
  /// **'{distance} km away'**
  String distanceKmAway(String distance);

  /// No description provided for @coachFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get coachFallbackName;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'Not specified'**
  String get notSpecified;

  /// No description provided for @autismTrainingCertified.
  ///
  /// In en, this message translates to:
  /// **'Autism Training Certified'**
  String get autismTrainingCertified;

  /// No description provided for @noDescriptionProvided.
  ///
  /// In en, this message translates to:
  /// **'No description provided.'**
  String get noDescriptionProvided;

  /// No description provided for @unknownTrainer.
  ///
  /// In en, this message translates to:
  /// **'Unknown Trainer'**
  String get unknownTrainer;

  /// No description provided for @availableStatus.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableStatus;

  /// No description provided for @notAvailableStatus.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailableStatus;

  /// No description provided for @homeBased.
  ///
  /// In en, this message translates to:
  /// **'Home-Based'**
  String get homeBased;

  /// No description provided for @coachingSports.
  ///
  /// In en, this message translates to:
  /// **'Coaching Sports:'**
  String get coachingSports;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @unavailableAction.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailableAction;

  /// No description provided for @availableAtTime.
  ///
  /// In en, this message translates to:
  /// **'Available at {time}'**
  String availableAtTime(String time);

  /// No description provided for @achievementsCount.
  ///
  /// In en, this message translates to:
  /// **'Achievements ({count})'**
  String achievementsCount(String count);

  /// No description provided for @filterTrainersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filter Trainers'**
  String get filterTrainersTitle;

  /// No description provided for @resetAction.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get resetAction;

  /// No description provided for @bySportCategory.
  ///
  /// In en, this message translates to:
  /// **'By Sport Category'**
  String get bySportCategory;

  /// No description provided for @applyFiltersAction.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFiltersAction;

  /// No description provided for @trainerListTitle.
  ///
  /// In en, this message translates to:
  /// **'Trainer List'**
  String get trainerListTitle;

  /// No description provided for @searchByNameHint.
  ///
  /// In en, this message translates to:
  /// **'Search by name...'**
  String get searchByNameHint;

  /// No description provided for @noTrainersAvailableYet.
  ///
  /// In en, this message translates to:
  /// **'No trainers available yet'**
  String get noTrainersAvailableYet;

  /// No description provided for @noTrainersMatchCriteria.
  ///
  /// In en, this message translates to:
  /// **'No trainers found matching your criteria.'**
  String get noTrainersMatchCriteria;

  /// No description provided for @sportAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get sportAll;

  /// No description provided for @sportSwimming.
  ///
  /// In en, this message translates to:
  /// **'Swimming'**
  String get sportSwimming;

  /// No description provided for @sportFootball.
  ///
  /// In en, this message translates to:
  /// **'Football'**
  String get sportFootball;

  /// No description provided for @sportBasketball.
  ///
  /// In en, this message translates to:
  /// **'Basketball'**
  String get sportBasketball;

  /// No description provided for @sportTennis.
  ///
  /// In en, this message translates to:
  /// **'Tennis'**
  String get sportTennis;

  /// No description provided for @sportGymnastics.
  ///
  /// In en, this message translates to:
  /// **'Gymnastics'**
  String get sportGymnastics;

  /// No description provided for @sportYoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get sportYoga;

  /// No description provided for @sportAthletics.
  ///
  /// In en, this message translates to:
  /// **'Athletics'**
  String get sportAthletics;

  /// No description provided for @sportBadminton.
  ///
  /// In en, this message translates to:
  /// **'Badminton'**
  String get sportBadminton;

  /// No description provided for @homeBasedAvailable.
  ///
  /// In en, this message translates to:
  /// **'Home-based Available'**
  String get homeBasedAvailable;

  /// No description provided for @centerBasedOnly.
  ///
  /// In en, this message translates to:
  /// **'Center-based Only'**
  String get centerBasedOnly;

  /// No description provided for @avgRating.
  ///
  /// In en, this message translates to:
  /// **'Avg Rating'**
  String get avgRating;

  /// No description provided for @reviewsLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviewsLabel;

  /// No description provided for @sportsLabel.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sportsLabel;

  /// No description provided for @ratingAndReviews.
  ///
  /// In en, this message translates to:
  /// **'RATING & REVIEWS'**
  String get ratingAndReviews;

  /// No description provided for @reviewsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} reviews'**
  String reviewsCount(String count);

  /// No description provided for @noReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No reviews yet.\nBe the first to review!'**
  String get noReviewsYet;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get aboutTitle;

  /// No description provided for @sportsTitle.
  ///
  /// In en, this message translates to:
  /// **'SPORTS'**
  String get sportsTitle;

  /// No description provided for @reviewsTitle.
  ///
  /// In en, this message translates to:
  /// **'REVIEWS'**
  String get reviewsTitle;

  /// No description provided for @noWrittenReviewsYet.
  ///
  /// In en, this message translates to:
  /// **'No written reviews yet.'**
  String get noWrittenReviewsYet;

  /// No description provided for @bookASession.
  ///
  /// In en, this message translates to:
  /// **'Book a Session'**
  String get bookASession;

  /// No description provided for @tbd.
  ///
  /// In en, this message translates to:
  /// **'TBD'**
  String get tbd;

  /// No description provided for @generalSport.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get generalSport;

  /// No description provided for @defaultUser.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get defaultUser;

  /// No description provided for @selectFutureTime.
  ///
  /// In en, this message translates to:
  /// **'Please select a future time.'**
  String get selectFutureTime;

  /// No description provided for @selectTimeBetween.
  ///
  /// In en, this message translates to:
  /// **'Please select a time between {start} and {end}.'**
  String selectTimeBetween(String start, String end);

  /// No description provided for @selectTimePrompt.
  ///
  /// In en, this message translates to:
  /// **'Please select a time.'**
  String get selectTimePrompt;

  /// No description provided for @selectChildPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please select a child profile.'**
  String get selectChildPrompt;

  /// No description provided for @cannotBookPast.
  ///
  /// In en, this message translates to:
  /// **'Cannot book a session in the past. Please select a future time.'**
  String get cannotBookPast;

  /// No description provided for @paymentCancelled.
  ///
  /// In en, this message translates to:
  /// **'Payment cancelled or failed.'**
  String get paymentCancelled;

  /// No description provided for @bookingsConfirmed.
  ///
  /// In en, this message translates to:
  /// **'{weeks} Booking(s) Confirmed!'**
  String bookingsConfirmed(String weeks);

  /// No description provided for @bookingDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Booking Details'**
  String get bookingDetailsTitle;

  /// No description provided for @bookForChildTitle.
  ///
  /// In en, this message translates to:
  /// **'Book for Child'**
  String get bookForChildTitle;

  /// No description provided for @selectChildDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the child profile for this session.'**
  String get selectChildDescription;

  /// No description provided for @errorLoadingChildren.
  ///
  /// In en, this message translates to:
  /// **'Error loading children: {error}'**
  String errorLoadingChildren(String error);

  /// No description provided for @addChildFirstPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please add a child profile first in the \"Manage Children\" page before booking.'**
  String get addChildFirstPrompt;

  /// No description provided for @selectYourChildHint.
  ///
  /// In en, this message translates to:
  /// **'Select your child'**
  String get selectYourChildHint;

  /// No description provided for @childAgeFormat.
  ///
  /// In en, this message translates to:
  /// **'({age}y)'**
  String childAgeFormat(String age);

  /// No description provided for @selectSportTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Sport'**
  String get selectSportTitle;

  /// No description provided for @sessionTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Type'**
  String get sessionTypeTitle;

  /// No description provided for @sessionTypeDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose how you want the session to be conducted.'**
  String get sessionTypeDescription;

  /// No description provided for @inPersonType.
  ///
  /// In en, this message translates to:
  /// **'In-Person'**
  String get inPersonType;

  /// No description provided for @inPersonDesc.
  ///
  /// In en, this message translates to:
  /// **'At trainer\'s location'**
  String get inPersonDesc;

  /// No description provided for @remoteType.
  ///
  /// In en, this message translates to:
  /// **'Remote'**
  String get remoteType;

  /// No description provided for @remoteDesc.
  ///
  /// In en, this message translates to:
  /// **'Online consultation'**
  String get remoteDesc;

  /// No description provided for @homeBasedType.
  ///
  /// In en, this message translates to:
  /// **'Home-Based'**
  String get homeBasedType;

  /// No description provided for @homeBasedDescWithFee.
  ///
  /// In en, this message translates to:
  /// **'Trainer comes to you (+RM {fee} Travel Fee)'**
  String homeBasedDescWithFee(String fee);

  /// No description provided for @homeBasedDescFree.
  ///
  /// In en, this message translates to:
  /// **'Trainer comes to you'**
  String get homeBasedDescFree;

  /// No description provided for @remoteNotice.
  ///
  /// In en, this message translates to:
  /// **'Join the video call from the Session Details page during the scheduled time.'**
  String get remoteNotice;

  /// No description provided for @homeBasedFeeNotice.
  ///
  /// In en, this message translates to:
  /// **'A travel surcharge of RM {fee} applies. This session must be paid via Stripe.'**
  String homeBasedFeeNotice(String fee);

  /// No description provided for @homeBasedFreeNotice.
  ///
  /// In en, this message translates to:
  /// **'Trainer will travel to your location. This session must be paid via Stripe.'**
  String get homeBasedFreeNotice;

  /// No description provided for @onlineSessionLoc.
  ///
  /// In en, this message translates to:
  /// **'Online Session'**
  String get onlineSessionLoc;

  /// No description provided for @durationTitle.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationTitle;

  /// No description provided for @durationDescription.
  ///
  /// In en, this message translates to:
  /// **'Select the length of each session.'**
  String get durationDescription;

  /// No description provided for @oneHour.
  ///
  /// In en, this message translates to:
  /// **'1 Hour'**
  String get oneHour;

  /// No description provided for @twoHours.
  ///
  /// In en, this message translates to:
  /// **'2 Hours'**
  String get twoHours;

  /// No description provided for @scheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleTitle;

  /// No description provided for @selectTimeHint.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTimeHint;

  /// No description provided for @sessionEndsAt.
  ///
  /// In en, this message translates to:
  /// **'This session will end at {time}.'**
  String sessionEndsAt(String time);

  /// No description provided for @repeatBookingTitle.
  ///
  /// In en, this message translates to:
  /// **'Repeat Booking'**
  String get repeatBookingTitle;

  /// No description provided for @maxWeeksFormat.
  ///
  /// In en, this message translates to:
  /// **'Max {weeks} weeks'**
  String maxWeeksFormat(String weeks);

  /// No description provided for @repeatBookingDescription.
  ///
  /// In en, this message translates to:
  /// **'Book this same time slot for consecutive weeks.'**
  String get repeatBookingDescription;

  /// No description provided for @oneWeek.
  ///
  /// In en, this message translates to:
  /// **'1 Wk'**
  String get oneWeek;

  /// No description provided for @nWeeks.
  ///
  /// In en, this message translates to:
  /// **'{weeks} Wks'**
  String nWeeks(String weeks);

  /// No description provided for @operatingHoursTitle.
  ///
  /// In en, this message translates to:
  /// **'Operating Hours'**
  String get operatingHoursTitle;

  /// No description provided for @restDay.
  ///
  /// In en, this message translates to:
  /// **'Rest Day'**
  String get restDay;

  /// No description provided for @reviewAndPayAction.
  ///
  /// In en, this message translates to:
  /// **'Review & Pay'**
  String get reviewAndPayAction;

  /// No description provided for @weekdayMonday.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get weekdayMonday;

  /// No description provided for @weekdayTuesday.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get weekdayTuesday;

  /// No description provided for @weekdayWednesday.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get weekdayWednesday;

  /// No description provided for @weekdayThursday.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get weekdayThursday;

  /// No description provided for @weekdayFriday.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get weekdayFriday;

  /// No description provided for @weekdaySaturday.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get weekdaySaturday;

  /// No description provided for @weekdaySunday.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get weekdaySunday;

  /// No description provided for @paymentSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Summary'**
  String get paymentSummaryTitle;

  /// No description provided for @sessionFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Session Fee'**
  String get sessionFeeLabel;

  /// No description provided for @rmPriceFormat.
  ///
  /// In en, this message translates to:
  /// **'RM {price}'**
  String rmPriceFormat(String price);

  /// No description provided for @transportFeeLabel.
  ///
  /// In en, this message translates to:
  /// **'Transport Fee'**
  String get transportFeeLabel;

  /// No description provided for @totalLabel.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalLabel;

  /// No description provided for @paymentMethodTitle.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethodTitle;

  /// No description provided for @useSessionCreditTitle.
  ///
  /// In en, this message translates to:
  /// **'Use Session Credit'**
  String get useSessionCreditTitle;

  /// No description provided for @unavailableForHomeBased.
  ///
  /// In en, this message translates to:
  /// **'Unavailable for Home-Based'**
  String get unavailableForHomeBased;

  /// No description provided for @creditBalanceAndRequired.
  ///
  /// In en, this message translates to:
  /// **'Balance: {balance} | Required: {required}'**
  String creditBalanceAndRequired(String balance, String required);

  /// No description provided for @notEnoughCredits.
  ///
  /// In en, this message translates to:
  /// **'Not enough credits (Need {required}, Have {balance})'**
  String notEnoughCredits(String required, String balance);

  /// No description provided for @payPerSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Pay Per Session'**
  String get payPerSessionTitle;

  /// No description provided for @totalPriceFormat.
  ///
  /// In en, this message translates to:
  /// **'Total: RM {price}'**
  String totalPriceFormat(String price);

  /// No description provided for @confirmAndDeductCredits.
  ///
  /// In en, this message translates to:
  /// **'Confirm & Deduct {credits} Credit(s)'**
  String confirmAndDeductCredits(String credits);

  /// No description provided for @proceedToPay.
  ///
  /// In en, this message translates to:
  /// **'Proceed to Pay RM {price}'**
  String proceedToPay(String price);

  /// No description provided for @failedToUploadImage.
  ///
  /// In en, this message translates to:
  /// **'Failed to upload image.'**
  String get failedToUploadImage;

  /// No description provided for @failedToSendMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to send message: {error}'**
  String failedToSendMessage(String error);

  /// No description provided for @takeAPhoto.
  ///
  /// In en, this message translates to:
  /// **'Take a Photo'**
  String get takeAPhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get chooseFromGallery;

  /// No description provided for @startConversationWith.
  ///
  /// In en, this message translates to:
  /// **'Start a conversation with {name}'**
  String startConversationWith(String name);

  /// No description provided for @accountSuspendedNotice.
  ///
  /// In en, this message translates to:
  /// **'This account has been suspended. You can no longer send messages.'**
  String get accountSuspendedNotice;

  /// No description provided for @typeAMessage.
  ///
  /// In en, this message translates to:
  /// **'Type a message...'**
  String get typeAMessage;

  /// No description provided for @cannotReschedulePast.
  ///
  /// In en, this message translates to:
  /// **'Cannot reschedule to a past time.'**
  String get cannotReschedulePast;

  /// No description provided for @trainerAvailableTime.
  ///
  /// In en, this message translates to:
  /// **'Trainer is only available {open} - {close} on this day.'**
  String trainerAvailableTime(String open, String close);

  /// No description provided for @rescheduleSessionTitle.
  ///
  /// In en, this message translates to:
  /// **'Reschedule Session'**
  String get rescheduleSessionTitle;

  /// No description provided for @selectNewDate.
  ///
  /// In en, this message translates to:
  /// **'Select New Date'**
  String get selectNewDate;

  /// No description provided for @availableTimeRange.
  ///
  /// In en, this message translates to:
  /// **'Available {open} - {close}'**
  String availableTimeRange(String open, String close);

  /// No description provided for @selectNewTime.
  ///
  /// In en, this message translates to:
  /// **'Select New Time'**
  String get selectNewTime;

  /// No description provided for @confirmReschedule.
  ///
  /// In en, this message translates to:
  /// **'Confirm Reschedule'**
  String get confirmReschedule;

  /// No description provided for @rescheduledSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Rescheduled successfully!'**
  String get rescheduledSuccessfully;

  /// No description provided for @myAppointmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get myAppointmentsTitle;

  /// No description provided for @tabPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get tabPending;

  /// No description provided for @tabUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get tabUpcoming;

  /// No description provided for @tabPast.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get tabPast;

  /// No description provided for @fallbackDatePlaceholder.
  ///
  /// In en, this message translates to:
  /// **'WEDNESDAY, 11 MAR'**
  String get fallbackDatePlaceholder;

  /// No description provided for @sportSession.
  ///
  /// In en, this message translates to:
  /// **'{sport} Session'**
  String sportSession(String sport);

  /// No description provided for @viewDetailsAction.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetailsAction;

  /// No description provided for @rescheduleAction.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get rescheduleAction;

  /// No description provided for @noAppointmentsForTab.
  ///
  /// In en, this message translates to:
  /// **'No {tab} appointments'**
  String noAppointmentsForTab(String tab);

  /// No description provided for @tapDateToViewOrBook.
  ///
  /// In en, this message translates to:
  /// **'Tap a date on the calendar to check\nor book a new session'**
  String get tapDateToViewOrBook;

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusAccepted.
  ///
  /// In en, this message translates to:
  /// **'Accepted'**
  String get statusAccepted;

  /// No description provided for @statusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get statusCompleted;

  /// No description provided for @statusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get statusCancelled;

  /// No description provided for @statusRejected.
  ///
  /// In en, this message translates to:
  /// **'Rejected'**
  String get statusRejected;

  /// No description provided for @sessionDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Details'**
  String get sessionDetailsTitle;

  /// No description provided for @statusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get statusLabel;

  /// No description provided for @paymentLabel.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get paymentLabel;

  /// No description provided for @scheduleLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Schedule & Location'**
  String get scheduleLocationTitle;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateLabel;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @timeWithDuration.
  ///
  /// In en, this message translates to:
  /// **'{start} - {end} ({duration} mins)'**
  String timeWithDuration(String start, String end, String duration);

  /// No description provided for @sportLabel.
  ///
  /// In en, this message translates to:
  /// **'Sport'**
  String get sportLabel;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// No description provided for @remoteConsultationTitle.
  ///
  /// In en, this message translates to:
  /// **'Remote Consultation'**
  String get remoteConsultationTitle;

  /// No description provided for @specialNeedsNotesTitle.
  ///
  /// In en, this message translates to:
  /// **'Special Needs & Notes'**
  String get specialNeedsNotesTitle;

  /// No description provided for @sessionFeedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Session Feedback'**
  String get sessionFeedbackTitle;

  /// No description provided for @parentNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Parent: {name}'**
  String parentNameLabel(String name);

  /// No description provided for @inAppVideoSession.
  ///
  /// In en, this message translates to:
  /// **'In-App Video Session'**
  String get inAppVideoSession;

  /// No description provided for @remoteSessionWarning.
  ///
  /// In en, this message translates to:
  /// **'This session will be conducted remotely. Please ensure you have a stable internet connection before joining.'**
  String get remoteSessionWarning;

  /// No description provided for @navigatingToVideoCall.
  ///
  /// In en, this message translates to:
  /// **'Navigating to Video Call Room...'**
  String get navigatingToVideoCall;

  /// No description provided for @joinVideoCallAction.
  ///
  /// In en, this message translates to:
  /// **'Join Video Call'**
  String get joinVideoCallAction;

  /// No description provided for @videoSessionEnded.
  ///
  /// In en, this message translates to:
  /// **'Video session ended'**
  String get videoSessionEnded;

  /// No description provided for @noFeedbackProvidedYet.
  ///
  /// In en, this message translates to:
  /// **'No feedback provided yet.'**
  String get noFeedbackProvidedYet;

  /// No description provided for @focusAttentionTitle.
  ///
  /// In en, this message translates to:
  /// **'Focus & Attention'**
  String get focusAttentionTitle;

  /// No description provided for @scoreOutOfFive.
  ///
  /// In en, this message translates to:
  /// **'{score}/5'**
  String scoreOutOfFive(String score);

  /// No description provided for @energyLevelTitle.
  ///
  /// In en, this message translates to:
  /// **'Energy Level'**
  String get energyLevelTitle;

  /// No description provided for @trainerRemarksTitle.
  ///
  /// In en, this message translates to:
  /// **'Trainer Remarks'**
  String get trainerRemarksTitle;

  /// No description provided for @parentReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Parent Review'**
  String get parentReviewTitle;

  /// No description provided for @errorLoadingDetails.
  ///
  /// In en, this message translates to:
  /// **'Error loading details.'**
  String get errorLoadingDetails;

  /// No description provided for @childDataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Child data not found.'**
  String get childDataNotFound;

  /// No description provided for @notesTitle.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesTitle;

  /// No description provided for @noSpecialNeedsOrRemarks.
  ///
  /// In en, this message translates to:
  /// **'No specific special needs or remarks provided by the parent.'**
  String get noSpecialNeedsOrRemarks;

  /// No description provided for @specialNeedsTitle.
  ///
  /// In en, this message translates to:
  /// **'Special Needs'**
  String get specialNeedsTitle;

  /// No description provided for @parentRemarksTitle.
  ///
  /// In en, this message translates to:
  /// **'Parent Remarks'**
  String get parentRemarksTitle;

  /// No description provided for @reviewSubmittedStatus.
  ///
  /// In en, this message translates to:
  /// **'Review Submitted'**
  String get reviewSubmittedStatus;

  /// No description provided for @rateReviewTrainerAction.
  ///
  /// In en, this message translates to:
  /// **'Rate & Review Trainer'**
  String get rateReviewTrainerAction;

  /// No description provided for @sessionCompletedStatus.
  ///
  /// In en, this message translates to:
  /// **'Session Completed'**
  String get sessionCompletedStatus;

  /// No description provided for @cancelSessionAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel Session'**
  String get cancelSessionAction;

  /// No description provided for @markAsCompletedAction.
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get markAsCompletedAction;

  /// No description provided for @waitingForSessionTime.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Session Time'**
  String get waitingForSessionTime;

  /// No description provided for @meltdownGraceApplied.
  ///
  /// In en, this message translates to:
  /// **'Meltdown Grace applied: You will receive a full refund.'**
  String get meltdownGraceApplied;

  /// No description provided for @suddenMeltdownGrace.
  ///
  /// In en, this message translates to:
  /// **'Sudden Meltdown? (Grace Period)'**
  String get suddenMeltdownGrace;

  /// No description provided for @meltdownGraceDescription.
  ///
  /// In en, this message translates to:
  /// **'Use your monthly 1-time grace for a full refund due to child\'s condition.'**
  String get meltdownGraceDescription;

  /// No description provided for @totalRefundLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Refund:'**
  String get totalRefundLabel;

  /// No description provided for @confirmCancellationAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm Cancellation'**
  String get confirmCancellationAction;

  /// No description provided for @keepSessionAction.
  ///
  /// In en, this message translates to:
  /// **'Keep Session'**
  String get keepSessionAction;

  /// No description provided for @appointmentCancelledSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment cancelled successfully.'**
  String get appointmentCancelledSuccess;

  /// No description provided for @pleaseLoginFirst.
  ///
  /// In en, this message translates to:
  /// **'Please login first'**
  String get pleaseLoginFirst;

  /// No description provided for @sessionCompletedEarnings.
  ///
  /// In en, this message translates to:
  /// **'Session completed! RM {amount} (after {takeRate} platform fee) added to your wallet.'**
  String sessionCompletedEarnings(String amount, String takeRate);

  /// No description provided for @thankYouForReview.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your review!'**
  String get thankYouForReview;

  /// No description provided for @profilePictureUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile picture updated successfully!'**
  String get profilePictureUpdatedSuccessfully;

  /// No description provided for @failedToUpdateProfilePicture.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile picture'**
  String get failedToUpdateProfilePicture;

  /// No description provided for @pleaseAddPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Please add phone number'**
  String get pleaseAddPhoneNumber;

  /// No description provided for @editProfileInformation.
  ///
  /// In en, this message translates to:
  /// **'Edit profile information'**
  String get editProfileInformation;

  /// No description provided for @manageChildren.
  ///
  /// In en, this message translates to:
  /// **'Manage Children'**
  String get manageChildren;

  /// No description provided for @myTrainerDashboard.
  ///
  /// In en, this message translates to:
  /// **'My Trainer Dashboard'**
  String get myTrainerDashboard;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact us'**
  String get contactUs;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageChangedTo.
  ///
  /// In en, this message translates to:
  /// **'Language changed to {languageName}'**
  String languageChangedTo(String languageName);

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfileTitle;

  /// No description provided for @personalInfoSection.
  ///
  /// In en, this message translates to:
  /// **'PERSONAL INFO'**
  String get personalInfoSection;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @nicknameLabel.
  ///
  /// In en, this message translates to:
  /// **'Nickname'**
  String get nicknameLabel;

  /// No description provided for @contactSection.
  ///
  /// In en, this message translates to:
  /// **'CONTACT'**
  String get contactSection;

  /// No description provided for @emailAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailAddressLabel;

  /// No description provided for @phoneNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phoneNumberLabel;

  /// No description provided for @addressSection.
  ///
  /// In en, this message translates to:
  /// **'ADDRESS'**
  String get addressSection;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @pickLocationOnMap.
  ///
  /// In en, this message translates to:
  /// **'Pick location on map'**
  String get pickLocationOnMap;

  /// No description provided for @saveChangesButton.
  ///
  /// In en, this message translates to:
  /// **'Save changes'**
  String get saveChangesButton;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @phoneNumberRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneNumberRequired;

  /// No description provided for @genderRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a gender'**
  String get genderRequired;

  /// No description provided for @addressRequired.
  ///
  /// In en, this message translates to:
  /// **'Address is required'**
  String get addressRequired;

  /// No description provided for @profileUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccessfully;

  /// No description provided for @failedToUpdateProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to update profile: {error}'**
  String failedToUpdateProfile(String error);

  /// No description provided for @newUserFallback.
  ///
  /// In en, this message translates to:
  /// **'New User'**
  String get newUserFallback;

  /// No description provided for @genderLabel.
  ///
  /// In en, this message translates to:
  /// **'GENDER'**
  String get genderLabel;

  /// No description provided for @genderMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get genderMale;

  /// No description provided for @genderFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get genderFemale;

  /// No description provided for @genderOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get genderOther;

  /// No description provided for @moveMapToSelectLocation.
  ///
  /// In en, this message translates to:
  /// **'Move map to select location...'**
  String get moveMapToSelectLocation;

  /// No description provided for @unableToGetLocation.
  ///
  /// In en, this message translates to:
  /// **'Unable to get location, defaulting to KL.'**
  String get unableToGetLocation;

  /// No description provided for @locationSelected.
  ///
  /// In en, this message translates to:
  /// **'Location selected'**
  String get locationSelected;

  /// No description provided for @selectLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocationTitle;

  /// No description provided for @selectedAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Selected Address'**
  String get selectedAddressLabel;

  /// No description provided for @confirmLocationButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm Location'**
  String get confirmLocationButton;

  /// No description provided for @manageChildrenDescription.
  ///
  /// In en, this message translates to:
  /// **'Manage your children\'s profiles here. Accurate special needs tags help our trainers provide the best care.'**
  String get manageChildrenDescription;

  /// No description provided for @addChildButton.
  ///
  /// In en, this message translates to:
  /// **'Add Child'**
  String get addChildButton;

  /// No description provided for @childAgeAndGender.
  ///
  /// In en, this message translates to:
  /// **'{age} years old • {gender}'**
  String childAgeAndGender(String age, String gender);

  /// No description provided for @activeTrainersPlural.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Active Trainer} other{{count} Active Trainers}}'**
  String activeTrainersPlural(int count);

  /// No description provided for @specialNeedsAndTags.
  ///
  /// In en, this message translates to:
  /// **'Special Needs & Tags'**
  String get specialNeedsAndTags;

  /// No description provided for @noTagsAdded.
  ///
  /// In en, this message translates to:
  /// **'No tags added.'**
  String get noTagsAdded;

  /// No description provided for @performanceHistory.
  ///
  /// In en, this message translates to:
  /// **'Performance History'**
  String get performanceHistory;

  /// No description provided for @noChildrenAddedYet.
  ///
  /// In en, this message translates to:
  /// **'No Children Added Yet'**
  String get noChildrenAddedYet;

  /// No description provided for @noChildrenDescription.
  ///
  /// In en, this message translates to:
  /// **'Add your child\'s profile to start booking specialized training sessions with certified coaches.'**
  String get noChildrenDescription;

  /// No description provided for @fillNameAgeGenderPrompt.
  ///
  /// In en, this message translates to:
  /// **'Please fill in the name, age, and select a gender.'**
  String get fillNameAgeGenderPrompt;

  /// No description provided for @childProfileUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Child profile updated!'**
  String get childProfileUpdatedSuccess;

  /// No description provided for @childProfileCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Child profile created!'**
  String get childProfileCreatedSuccess;

  /// No description provided for @errorSavingProfile.
  ///
  /// In en, this message translates to:
  /// **'Error saving profile: {error}'**
  String errorSavingProfile(String error);

  /// No description provided for @editChildProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Child Profile'**
  String get editChildProfileTitle;

  /// No description provided for @addChildProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Child Profile'**
  String get addChildProfileTitle;

  /// No description provided for @basicInformationTitle.
  ///
  /// In en, this message translates to:
  /// **'Basic Information'**
  String get basicInformationTitle;

  /// No description provided for @childNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Child\'s Name'**
  String get childNameLabel;

  /// No description provided for @childNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Leo'**
  String get childNameHint;

  /// No description provided for @ageLabel.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get ageLabel;

  /// No description provided for @ageHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. 8'**
  String get ageHint;

  /// No description provided for @specialNeedsAndTraitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Special Needs & Traits'**
  String get specialNeedsAndTraitsTitle;

  /// No description provided for @specialNeedsDescription.
  ///
  /// In en, this message translates to:
  /// **'Select all that apply. This helps our trainers tailor their sessions to your child\'s needs.'**
  String get specialNeedsDescription;

  /// No description provided for @additionalRemarksOptional.
  ///
  /// In en, this message translates to:
  /// **'Additional Remarks for Trainer (Optional)'**
  String get additionalRemarksOptional;

  /// No description provided for @remarksHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Prefers a quiet environment, loves high-fives as reward, allergic to peanuts...'**
  String get remarksHint;

  /// No description provided for @saveProfileButton.
  ///
  /// In en, this message translates to:
  /// **'Save Profile'**
  String get saveProfileButton;

  /// No description provided for @genderDropdownLabel.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get genderDropdownLabel;

  /// No description provided for @selectHint.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectHint;

  /// No description provided for @performanceTrackingTitle.
  ///
  /// In en, this message translates to:
  /// **'Performance Tracking'**
  String get performanceTrackingTitle;

  /// No description provided for @overallAverageTitle.
  ///
  /// In en, this message translates to:
  /// **'Overall Average'**
  String get overallAverageTitle;

  /// No description provided for @avgFocusLabel.
  ///
  /// In en, this message translates to:
  /// **'Avg Focus'**
  String get avgFocusLabel;

  /// No description provided for @avgEnergyLabel.
  ///
  /// In en, this message translates to:
  /// **'Avg Energy'**
  String get avgEnergyLabel;

  /// No description provided for @sessionHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Session History'**
  String get sessionHistoryTitle;

  /// No description provided for @noPerformanceRecordsYet.
  ///
  /// In en, this message translates to:
  /// **'No performance records yet.'**
  String get noPerformanceRecordsYet;

  /// No description provided for @completeSessionToLogFeedback.
  ///
  /// In en, this message translates to:
  /// **'Complete a session to log feedback.'**
  String get completeSessionToLogFeedback;

  /// No description provided for @yearsOldWithGender.
  ///
  /// In en, this message translates to:
  /// **'{age} years old, {gender}'**
  String yearsOldWithGender(String age, String gender);

  /// No description provided for @yearsOld.
  ///
  /// In en, this message translates to:
  /// **'{age} years old'**
  String yearsOld(String age);

  /// No description provided for @focusLabel.
  ///
  /// In en, this message translates to:
  /// **'Focus'**
  String get focusLabel;

  /// No description provided for @energyLabel.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energyLabel;

  /// No description provided for @trainingCreditsTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Credits'**
  String get trainingCreditsTitle;

  /// No description provided for @availableSessionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Available Sessions:'**
  String get availableSessionsLabel;

  /// No description provided for @creditSingular.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get creditSingular;

  /// No description provided for @creditsPlural.
  ///
  /// In en, this message translates to:
  /// **'Credits'**
  String get creditsPlural;

  /// No description provided for @buyCreditPackages.
  ///
  /// In en, this message translates to:
  /// **'Buy Credit Packages'**
  String get buyCreditPackages;

  /// No description provided for @creditTab.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get creditTab;

  /// No description provided for @singlePayTab.
  ///
  /// In en, this message translates to:
  /// **'Single Pay'**
  String get singlePayTab;

  /// No description provided for @viewAllHistory.
  ///
  /// In en, this message translates to:
  /// **'View All History'**
  String get viewAllHistory;

  /// No description provided for @errorLoadingHistory.
  ///
  /// In en, this message translates to:
  /// **'Error loading history: {error}'**
  String errorLoadingHistory(String error);

  /// No description provided for @selectPackageTitle.
  ///
  /// In en, this message translates to:
  /// **'Select a Package'**
  String get selectPackageTitle;

  /// No description provided for @buyMoreCreditsDesc.
  ///
  /// In en, this message translates to:
  /// **'Buy more credits to enjoy bulk discounts.'**
  String get buyMoreCreditsDesc;

  /// No description provided for @singleSessionPackage.
  ///
  /// In en, this message translates to:
  /// **'Single Session'**
  String get singleSessionPackage;

  /// No description provided for @starterPackPackage.
  ///
  /// In en, this message translates to:
  /// **'Starter Pack'**
  String get starterPackPackage;

  /// No description provided for @proPackPackage.
  ///
  /// In en, this message translates to:
  /// **'Pro Pack'**
  String get proPackPackage;

  /// No description provided for @popularBadge.
  ///
  /// In en, this message translates to:
  /// **'POPULAR'**
  String get popularBadge;

  /// No description provided for @creditsCountLabel.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Credit} other{{count} Credits}}'**
  String creditsCountLabel(int count);

  /// No description provided for @paymentSuccessfulAddedCredits.
  ///
  /// In en, this message translates to:
  /// **'Payment successful! Added {credits} credits.'**
  String paymentSuccessfulAddedCredits(String credits);

  /// No description provided for @transactionCreditAmount.
  ///
  /// In en, this message translates to:
  /// **'{prefix} {val, plural, =1{1 Credit} other{{val} Credits}}'**
  String transactionCreditAmount(String prefix, int val);

  /// No description provided for @transactionRmAmount.
  ///
  /// In en, this message translates to:
  /// **'{prefix} RM {amount}'**
  String transactionRmAmount(String prefix, String amount);

  /// No description provided for @statusRefunded.
  ///
  /// In en, this message translates to:
  /// **'Refunded'**
  String get statusRefunded;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// No description provided for @noTransactionHistoryYet.
  ///
  /// In en, this message translates to:
  /// **'No transaction history yet.'**
  String get noTransactionHistoryYet;

  /// No description provided for @helpAndSupportTitle.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpAndSupportTitle;

  /// No description provided for @newTicketAction.
  ///
  /// In en, this message translates to:
  /// **'New Ticket'**
  String get newTicketAction;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'How can we help?'**
  String get howCanWeHelp;

  /// No description provided for @trackSupportRequests.
  ///
  /// In en, this message translates to:
  /// **'Track your support requests or create a new one.'**
  String get trackSupportRequests;

  /// No description provided for @myTicketsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Tickets'**
  String get myTicketsTitle;

  /// No description provided for @errorLoadingTickets.
  ///
  /// In en, this message translates to:
  /// **'Error loading tickets: {err}'**
  String errorLoadingTickets(String err);

  /// No description provided for @noSupportTicketsYet.
  ///
  /// In en, this message translates to:
  /// **'No support tickets yet.'**
  String get noSupportTicketsYet;

  /// No description provided for @submitNewTicketPrompt.
  ///
  /// In en, this message translates to:
  /// **'If you have any issues, feel free to submit a new ticket.'**
  String get submitNewTicketPrompt;

  /// No description provided for @adminMessage.
  ///
  /// In en, this message translates to:
  /// **'Admin: {message}'**
  String adminMessage(String message);

  /// No description provided for @youMessage.
  ///
  /// In en, this message translates to:
  /// **'You: {message}'**
  String youMessage(String message);

  /// No description provided for @updatedAtDate.
  ///
  /// In en, this message translates to:
  /// **'Updated: {date}'**
  String updatedAtDate(String date);

  /// No description provided for @categoryBillingAndPayment.
  ///
  /// In en, this message translates to:
  /// **'Billing & Payment'**
  String get categoryBillingAndPayment;

  /// No description provided for @categoryAppointmentReschedule.
  ///
  /// In en, this message translates to:
  /// **'Appointment / Reschedule'**
  String get categoryAppointmentReschedule;

  /// No description provided for @categoryTechnicalIssue.
  ///
  /// In en, this message translates to:
  /// **'Technical Issue'**
  String get categoryTechnicalIssue;

  /// No description provided for @categoryTrainerFeedback.
  ///
  /// In en, this message translates to:
  /// **'Trainer Feedback'**
  String get categoryTrainerFeedback;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @pleaseSelectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category.'**
  String get pleaseSelectCategory;

  /// No description provided for @ticketSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Ticket submitted successfully!'**
  String get ticketSubmittedSuccessfully;

  /// No description provided for @failedToSubmitTicket.
  ///
  /// In en, this message translates to:
  /// **'Failed to submit ticket: {error}'**
  String failedToSubmitTicket(String error);

  /// No description provided for @newSupportTicketTitle.
  ///
  /// In en, this message translates to:
  /// **'New Support Ticket'**
  String get newSupportTicketTitle;

  /// No description provided for @supportTeamResponseTime.
  ///
  /// In en, this message translates to:
  /// **'Our support team usually responds within 2-4 hours during business days.'**
  String get supportTeamResponseTime;

  /// No description provided for @whatDoYouNeedHelpWith.
  ///
  /// In en, this message translates to:
  /// **'What do you need help with? *'**
  String get whatDoYouNeedHelpWith;

  /// No description provided for @selectCategoryHint.
  ///
  /// In en, this message translates to:
  /// **'Select a category'**
  String get selectCategoryHint;

  /// No description provided for @detailsLabel.
  ///
  /// In en, this message translates to:
  /// **'Details *'**
  String get detailsLabel;

  /// No description provided for @describeIssueHint.
  ///
  /// In en, this message translates to:
  /// **'Please describe your issue in detail...'**
  String get describeIssueHint;

  /// No description provided for @pleaseEnterMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter your message'**
  String get pleaseEnterMessage;

  /// No description provided for @submitTicketAction.
  ///
  /// In en, this message translates to:
  /// **'Submit Ticket'**
  String get submitTicketAction;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @emailAddressInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddressInputLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'you@example.com'**
  String get emailHint;

  /// No description provided for @passwordInputLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordInputLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get passwordHint;

  /// No description provided for @signInButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signInButton;

  /// No description provided for @dontHaveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccountPrompt;

  /// No description provided for @signUpTextButton.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get signUpTextButton;

  /// No description provided for @fillAllFieldsError.
  ///
  /// In en, this message translates to:
  /// **'Please fill in all fields'**
  String get fillAllFieldsError;

  /// No description provided for @signInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully sign in!'**
  String get signInSuccess;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @joinUsTodayFree.
  ///
  /// In en, this message translates to:
  /// **'Join us today — it\'s free'**
  String get joinUsTodayFree;

  /// No description provided for @iAmA.
  ///
  /// In en, this message translates to:
  /// **'I am a...'**
  String get iAmA;

  /// No description provided for @roleParent.
  ///
  /// In en, this message translates to:
  /// **'Parent'**
  String get roleParent;

  /// No description provided for @roleCoach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get roleCoach;

  /// No description provided for @passwordMinLengthHint.
  ///
  /// In en, this message translates to:
  /// **'Minimum 6 characters'**
  String get passwordMinLengthHint;

  /// No description provided for @alreadyHaveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccountPrompt;

  /// No description provided for @signInTextButton.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signInTextButton;

  /// No description provided for @signUpSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully registered!'**
  String get signUpSuccess;

  /// No description provided for @pleaseWriteBriefBio.
  ///
  /// In en, this message translates to:
  /// **'Please write a brief bio about yourself.'**
  String get pleaseWriteBriefBio;

  /// No description provided for @pleaseSelectAtLeastOneSport.
  ///
  /// In en, this message translates to:
  /// **'Please select at least one sport you can teach.'**
  String get pleaseSelectAtLeastOneSport;

  /// No description provided for @pleaseUploadCertificate.
  ///
  /// In en, this message translates to:
  /// **'Please upload at least one relevant certificate.'**
  String get pleaseUploadCertificate;

  /// No description provided for @applicationSubmittedWaitAdmin.
  ///
  /// In en, this message translates to:
  /// **'Application submitted successfully! Please wait for admin approval.'**
  String get applicationSubmittedWaitAdmin;

  /// No description provided for @errorSubmittingApplication.
  ///
  /// In en, this message translates to:
  /// **'Error submitting application: {error}'**
  String errorSubmittingApplication(String error);

  /// No description provided for @becomeTrainerTitle.
  ///
  /// In en, this message translates to:
  /// **'Become a Trainer'**
  String get becomeTrainerTitle;

  /// No description provided for @joinTrainerCommunityDescription.
  ///
  /// In en, this message translates to:
  /// **'Join our community of specialized trainers and make a difference.'**
  String get joinTrainerCommunityDescription;

  /// No description provided for @personalBioTitle.
  ///
  /// In en, this message translates to:
  /// **'Personal Bio'**
  String get personalBioTitle;

  /// No description provided for @experienceWithSpecialNeedsDescription.
  ///
  /// In en, this message translates to:
  /// **'Tell us about your experience working with special needs children.'**
  String get experienceWithSpecialNeedsDescription;

  /// No description provided for @yourExperienceLabel.
  ///
  /// In en, this message translates to:
  /// **'Your Experience'**
  String get yourExperienceLabel;

  /// No description provided for @experienceHintText.
  ///
  /// In en, this message translates to:
  /// **'e.g., I have 3 years of experience teaching swimming to children with ASD...'**
  String get experienceHintText;

  /// No description provided for @sportsYouTeachTitle.
  ///
  /// In en, this message translates to:
  /// **'Sports You Teach'**
  String get sportsYouTeachTitle;

  /// No description provided for @selectQualifiedSportsDescription.
  ///
  /// In en, this message translates to:
  /// **'Select all the sports you are qualified to teach.'**
  String get selectQualifiedSportsDescription;

  /// No description provided for @icAndCertificatesTitle.
  ///
  /// In en, this message translates to:
  /// **'IC & Certificates'**
  String get icAndCertificatesTitle;

  /// No description provided for @addImagesAction.
  ///
  /// In en, this message translates to:
  /// **'Add Images'**
  String get addImagesAction;

  /// No description provided for @uploadIcAndCertificatesDescription.
  ///
  /// In en, this message translates to:
  /// **'Upload photos of your IC and coaching certifications or special needs training qualifications.'**
  String get uploadIcAndCertificatesDescription;

  /// No description provided for @noPhotosUploadedYet.
  ///
  /// In en, this message translates to:
  /// **'No photos uploaded yet'**
  String get noPhotosUploadedYet;

  /// No description provided for @submitApplicationAction.
  ///
  /// In en, this message translates to:
  /// **'Submit Application'**
  String get submitApplicationAction;

  /// No description provided for @academyTitle.
  ///
  /// In en, this message translates to:
  /// **'Academy'**
  String get academyTitle;

  /// No description provided for @welcomeToAcademy.
  ///
  /// In en, this message translates to:
  /// **'Welcome to the Academy!'**
  String get welcomeToAcademy;

  /// No description provided for @academyPendingDescription.
  ///
  /// In en, this message translates to:
  /// **'Please review the learning materials below and complete the Final Assessment (Quiz). Once passed, our admins will approve your account.'**
  String get academyPendingDescription;

  /// No description provided for @errorLoadingAcademyContent.
  ///
  /// In en, this message translates to:
  /// **'Error loading academy content: {error}'**
  String errorLoadingAcademyContent(String error);

  /// No description provided for @noTrainingModulesAvailable.
  ///
  /// In en, this message translates to:
  /// **'No training modules available right now.'**
  String get noTrainingModulesAvailable;

  /// No description provided for @learningMaterials.
  ///
  /// In en, this message translates to:
  /// **'Learning Materials'**
  String get learningMaterials;

  /// No description provided for @finalAssessment.
  ///
  /// In en, this message translates to:
  /// **'Final Assessment'**
  String get finalAssessment;

  /// No description provided for @finalAssessmentDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap to open the assessment form. Please ensure you use your registered email.'**
  String get finalAssessmentDescription;

  /// No description provided for @continuousLearning.
  ///
  /// In en, this message translates to:
  /// **'Continuous Learning'**
  String get continuousLearning;

  /// No description provided for @upskillDescription.
  ///
  /// In en, this message translates to:
  /// **'Upskill yourself, earn exclusive badges, and increase your booking rate!'**
  String get upskillDescription;

  /// No description provided for @myBadgesWithPoints.
  ///
  /// In en, this message translates to:
  /// **'My Badges ({points} pts)'**
  String myBadgesWithPoints(String points);

  /// No description provided for @advancedCourses.
  ///
  /// In en, this message translates to:
  /// **'Advanced Courses'**
  String get advancedCourses;

  /// No description provided for @noAdvancedCoursesYet.
  ///
  /// In en, this message translates to:
  /// **'No advanced courses available yet.'**
  String get noAdvancedCoursesYet;

  /// No description provided for @requiredPointsLabel.
  ///
  /// In en, this message translates to:
  /// **'{points} pt'**
  String requiredPointsLabel(String points);

  /// No description provided for @plusCpdPoints.
  ///
  /// In en, this message translates to:
  /// **'+ {points} CPD Points'**
  String plusCpdPoints(String points);

  /// No description provided for @failedToOpenCourse.
  ///
  /// In en, this message translates to:
  /// **'Failed to open course: {error}'**
  String failedToOpenCourse(String error);

  /// No description provided for @summaryTodayTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary Today'**
  String get summaryTodayTitle;

  /// No description provided for @availableSlotsLabel.
  ///
  /// In en, this message translates to:
  /// **'Available\nSlots'**
  String get availableSlotsLabel;

  /// No description provided for @todaySessionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Today\nSessions'**
  String get todaySessionsLabel;

  /// No description provided for @totalMembersLabel.
  ///
  /// In en, this message translates to:
  /// **'Total\nMembers'**
  String get totalMembersLabel;

  /// No description provided for @profileHiddenTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile Hidden'**
  String get profileHiddenTitle;

  /// No description provided for @profileHiddenDesc.
  ///
  /// In en, this message translates to:
  /// **'Parents cannot book you until you set your Service Base Location.'**
  String get profileHiddenDesc;

  /// No description provided for @fixNowAction.
  ///
  /// In en, this message translates to:
  /// **'Fix Now'**
  String get fixNowAction;

  /// No description provided for @newRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'New Requests'**
  String get newRequestsTitle;

  /// No description provided for @allCaughtUpTitle.
  ///
  /// In en, this message translates to:
  /// **'All Caught Up!'**
  String get allCaughtUpTitle;

  /// No description provided for @noPendingRequestsDesc.
  ///
  /// In en, this message translates to:
  /// **'You have no pending requests at the moment.'**
  String get noPendingRequestsDesc;

  /// No description provided for @todaySessionScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Today Session Schedule'**
  String get todaySessionScheduleTitle;

  /// No description provided for @freeScheduleTitle.
  ///
  /// In en, this message translates to:
  /// **'Free Schedule'**
  String get freeScheduleTitle;

  /// No description provided for @noSessionsScheduledDesc.
  ///
  /// In en, this message translates to:
  /// **'You have no sessions scheduled for today. Enjoy your day!'**
  String get noSessionsScheduledDesc;

  /// No description provided for @studentLabel.
  ///
  /// In en, this message translates to:
  /// **'Student'**
  String get studentLabel;

  /// No description provided for @newBadgeLabel.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get newBadgeLabel;

  /// No description provided for @acceptAction.
  ///
  /// In en, this message translates to:
  /// **'Accept'**
  String get acceptAction;

  /// No description provided for @rejectAction.
  ///
  /// In en, this message translates to:
  /// **'Reject'**
  String get rejectAction;

  /// No description provided for @chatAction.
  ///
  /// In en, this message translates to:
  /// **'Chat'**
  String get chatAction;

  /// No description provided for @actionRequiredSetLocationDesc.
  ///
  /// In en, this message translates to:
  /// **'Action Required: Please set your Service Base Location in your Dashboard before accepting requests.'**
  String get actionRequiredSetLocationDesc;

  /// No description provided for @appointmentAcceptedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment Accepted!'**
  String get appointmentAcceptedSuccess;

  /// No description provided for @appointmentRejectedInfo.
  ///
  /// In en, this message translates to:
  /// **'Appointment Rejected!'**
  String get appointmentRejectedInfo;

  /// No description provided for @navAcademy.
  ///
  /// In en, this message translates to:
  /// **'Academy'**
  String get navAcademy;

  /// No description provided for @navStudents.
  ///
  /// In en, this message translates to:
  /// **'Students'**
  String get navStudents;

  /// No description provided for @myStudentsTitle.
  ///
  /// In en, this message translates to:
  /// **'My Students'**
  String get myStudentsTitle;

  /// No description provided for @summaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summaryTitle;

  /// No description provided for @totalStudentsLabel.
  ///
  /// In en, this message translates to:
  /// **'Total\nStudents'**
  String get totalStudentsLabel;

  /// No description provided for @activeSessionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Active\nSessions'**
  String get activeSessionsLabel;

  /// No description provided for @pendingRequestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Pending\nRequests'**
  String get pendingRequestsLabel;

  /// No description provided for @noActiveStudentsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Active Students'**
  String get noActiveStudentsTitle;

  /// No description provided for @noActiveStudentsDesc.
  ///
  /// In en, this message translates to:
  /// **'You currently have no active students. When you accept requests, they will appear here.'**
  String get noActiveStudentsDesc;

  /// No description provided for @noPendingRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Pending Requests'**
  String get noPendingRequestsTitle;

  /// No description provided for @noPendingStudentRequestsDesc.
  ///
  /// In en, this message translates to:
  /// **'You are all caught up! There are no pending student requests right now.'**
  String get noPendingStudentRequestsDesc;

  /// No description provided for @noPastStudentsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Past Students'**
  String get noPastStudentsTitle;

  /// No description provided for @noPastStudentsDesc.
  ///
  /// In en, this message translates to:
  /// **'You do not have any past student records yet.'**
  String get noPastStudentsDesc;

  /// No description provided for @tabActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get tabActive;

  /// No description provided for @lastSessionLabel.
  ///
  /// In en, this message translates to:
  /// **'Last: {date}'**
  String lastSessionLabel(String date);

  /// No description provided for @acceptRequestAction.
  ///
  /// In en, this message translates to:
  /// **'Accept Request'**
  String get acceptRequestAction;

  /// No description provided for @reviewNewRequestAction.
  ///
  /// In en, this message translates to:
  /// **'Review New Request'**
  String get reviewNewRequestAction;

  /// No description provided for @logProgressAction.
  ///
  /// In en, this message translates to:
  /// **'Log Progress'**
  String get logProgressAction;

  /// No description provided for @viewHistoryAction.
  ///
  /// In en, this message translates to:
  /// **'View History'**
  String get viewHistoryAction;

  /// No description provided for @messageParentAction.
  ///
  /// In en, this message translates to:
  /// **'Message Parent'**
  String get messageParentAction;

  /// No description provided for @viewPerformanceAction.
  ///
  /// In en, this message translates to:
  /// **'View Performance'**
  String get viewPerformanceAction;

  /// No description provided for @pauseReceivingRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Pause Receiving Requests'**
  String get pauseReceivingRequestsTitle;

  /// No description provided for @pauseReceivingRequestsMessage.
  ///
  /// In en, this message translates to:
  /// **'When should we turn it back on for you?'**
  String get pauseReceivingRequestsMessage;

  /// No description provided for @pauseForOneHour.
  ///
  /// In en, this message translates to:
  /// **'For 1 Hour'**
  String get pauseForOneHour;

  /// No description provided for @pauseForFourHours.
  ///
  /// In en, this message translates to:
  /// **'For 4 Hours'**
  String get pauseForFourHours;

  /// No description provided for @pauseUntilTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Until Tomorrow'**
  String get pauseUntilTomorrow;

  /// No description provided for @pauseUntilTurnedBackOn.
  ///
  /// In en, this message translates to:
  /// **'Until I turn it back on'**
  String get pauseUntilTurnedBackOn;

  /// No description provided for @cancelAction.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelAction;

  /// No description provided for @operatingHoursDesc.
  ///
  /// In en, this message translates to:
  /// **'Set your weekly availability. Default is open all week. Turn off the days you are resting.'**
  String get operatingHoursDesc;

  /// No description provided for @operatingHoursUpdatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Operating hours updated successfully.'**
  String get operatingHoursUpdatedSuccess;

  /// No description provided for @failedToUpdateOperatingHours.
  ///
  /// In en, this message translates to:
  /// **'Failed to update: {error}'**
  String failedToUpdateOperatingHours(String error);

  /// No description provided for @saveChangesAction.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChangesAction;

  /// No description provided for @appointmentsTitle.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointmentsTitle;

  /// No description provided for @acceptingRequestsLabel.
  ///
  /// In en, this message translates to:
  /// **'Accepting Requests'**
  String get acceptingRequestsLabel;

  /// No description provided for @autoResumesAtTime.
  ///
  /// In en, this message translates to:
  /// **'Auto-resumes at {time}'**
  String autoResumesAtTime(String time);

  /// No description provided for @youAreNowOnline.
  ///
  /// In en, this message translates to:
  /// **'You are now online!'**
  String get youAreNowOnline;

  /// No description provided for @noAppointmentsYet.
  ///
  /// In en, this message translates to:
  /// **'No appointments yet.'**
  String get noAppointmentsYet;

  /// No description provided for @parentsCanSendRequestsDesc.
  ///
  /// In en, this message translates to:
  /// **'Parents can send you requests for this day.'**
  String get parentsCanSendRequestsDesc;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get statusConfirmed;

  /// No description provided for @actionRequiredShort.
  ///
  /// In en, this message translates to:
  /// **'Action Req.'**
  String get actionRequiredShort;

  /// No description provided for @notAcceptingRequestsTitle.
  ///
  /// In en, this message translates to:
  /// **'Not Accepting Requests'**
  String get notAcceptingRequestsTitle;

  /// No description provided for @updateProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfileTitle;

  /// No description provided for @locationCityAreaLabel.
  ///
  /// In en, this message translates to:
  /// **'Location (City/Area)'**
  String get locationCityAreaLabel;

  /// No description provided for @locationCityAreaHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Kuala Lumpur, Petaling Jaya'**
  String get locationCityAreaHint;

  /// No description provided for @aboutYouBioLabel.
  ///
  /// In en, this message translates to:
  /// **'About You (Bio)'**
  String get aboutYouBioLabel;

  /// No description provided for @aboutYouBioHint.
  ///
  /// In en, this message translates to:
  /// **'Tell parents about your experience and teaching style...'**
  String get aboutYouBioHint;

  /// No description provided for @offerHomeBasedSessionsLabel.
  ///
  /// In en, this message translates to:
  /// **'Offer Home-based Sessions?'**
  String get offerHomeBasedSessionsLabel;

  /// No description provided for @offerHomeBasedSessionsDesc.
  ///
  /// In en, this message translates to:
  /// **'Parents can request sessions at their own homes.'**
  String get offerHomeBasedSessionsDesc;

  /// No description provided for @travelSurchargeLabel.
  ///
  /// In en, this message translates to:
  /// **'Travel Surcharge (Per Session)'**
  String get travelSurchargeLabel;

  /// No description provided for @rmZeroHint.
  ///
  /// In en, this message translates to:
  /// **'RM0.00'**
  String get rmZeroHint;

  /// No description provided for @travelSurchargeDesc.
  ///
  /// In en, this message translates to:
  /// **'This fee goes 100% to you to cover travel expenses.'**
  String get travelSurchargeDesc;

  /// No description provided for @yourPublicProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Public Profile'**
  String get yourPublicProfileTitle;

  /// No description provided for @bioNotSetFallback.
  ///
  /// In en, this message translates to:
  /// **'Tell parents about your experience...'**
  String get bioNotSetFallback;

  /// No description provided for @locationNotSetFallback.
  ///
  /// In en, this message translates to:
  /// **'Location not set'**
  String get locationNotSetFallback;

  /// No description provided for @noSportsSelectedFallback.
  ///
  /// In en, this message translates to:
  /// **'No sports selected'**
  String get noSportsSelectedFallback;

  /// No description provided for @goBackTooltip.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBackTooltip;

  /// No description provided for @trainerDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Trainer Dashboard'**
  String get trainerDashboardTitle;

  /// No description provided for @reschedulingDisabledWithin24h.
  ///
  /// In en, this message translates to:
  /// **'Rescheduling is disabled within 24h of the session.'**
  String get reschedulingDisabledWithin24h;

  /// No description provided for @withdrawFunds.
  ///
  /// In en, this message translates to:
  /// **'Withdraw Funds'**
  String get withdrawFunds;

  /// No description provided for @withdrawFundsDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter the amount you wish to transfer to your bank account.'**
  String get withdrawFundsDescription;

  /// No description provided for @availableBalanceAmount.
  ///
  /// In en, this message translates to:
  /// **'Available: RM {amount}'**
  String availableBalanceAmount(String amount);

  /// No description provided for @insufficientBalance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient balance'**
  String get insufficientBalance;

  /// No description provided for @submitRequest.
  ///
  /// In en, this message translates to:
  /// **'Submit Request'**
  String get submitRequest;

  /// No description provided for @myWallet.
  ///
  /// In en, this message translates to:
  /// **'My Wallet'**
  String get myWallet;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet.'**
  String get noTransactionsYet;

  /// No description provided for @availableBalance.
  ///
  /// In en, this message translates to:
  /// **'Available Balance'**
  String get availableBalance;

  /// No description provided for @noBalanceToWithdraw.
  ///
  /// In en, this message translates to:
  /// **'You have no balance to withdraw.'**
  String get noBalanceToWithdraw;

  /// No description provided for @bankDetailsSaved.
  ///
  /// In en, this message translates to:
  /// **'Bank details saved! You can now proceed to withdraw funds.'**
  String get bankDetailsSaved;

  /// No description provided for @failedToSaveBankDetails.
  ///
  /// In en, this message translates to:
  /// **'Failed to save bank details: {error}'**
  String failedToSaveBankDetails(String error);

  /// No description provided for @withdrawalRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Withdrawal request for RM {amount} submitted! Pending admin approval.'**
  String withdrawalRequestSubmitted(String amount);

  /// No description provided for @addBankDetails.
  ///
  /// In en, this message translates to:
  /// **'Add Bank Details'**
  String get addBankDetails;

  /// No description provided for @provideBankDetailsDescription.
  ///
  /// In en, this message translates to:
  /// **'Please provide your bank details to receive payouts.'**
  String get provideBankDetailsDescription;

  /// No description provided for @bankNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Bank Name'**
  String get bankNameLabel;

  /// No description provided for @bankNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Maybank, CIMB'**
  String get bankNameHint;

  /// No description provided for @accountNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumberLabel;

  /// No description provided for @accountNumberHint.
  ///
  /// In en, this message translates to:
  /// **'Account Number'**
  String get accountNumberHint;

  /// No description provided for @accountHolderNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Account Holder Name'**
  String get accountHolderNameLabel;

  /// No description provided for @accountHolderNameHint.
  ///
  /// In en, this message translates to:
  /// **'Name as per bank account'**
  String get accountHolderNameHint;

  /// No description provided for @saveDetailsAction.
  ///
  /// In en, this message translates to:
  /// **'Save Details'**
  String get saveDetailsAction;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @forgotPasswordDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter your email and we\'ll send you a reset link.'**
  String get forgotPasswordDescription;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @resetLinkSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email.'**
  String get resetLinkSent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @logOutConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logOutConfirmation;
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
      <String>['en', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

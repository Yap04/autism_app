// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get parentFallbackName => 'Parent';

  @override
  String goodMorningGreeting(String name) {
    return 'Good Morning,\n$name!';
  }

  @override
  String errorLoadingData(String error) {
    return 'Error loading data: $error';
  }

  @override
  String get childsMilestones => 'Child\'s Milestones';

  @override
  String get latestSessionInsight => 'Latest Session Insight';

  @override
  String get resourcesForYou => 'Resources for You';

  @override
  String get viewMore => 'View More';

  @override
  String get failedToLoadContent => 'Failed to load content.';

  @override
  String get moreResourcesComingSoon => 'More resources coming soon!';

  @override
  String todayTime(String time) {
    return 'Today, $time';
  }

  @override
  String tomorrowTime(String time) {
    return 'Tomorrow, $time';
  }

  @override
  String get upcomingAppointment => 'Upcoming Appointment';

  @override
  String get chatWithCoach => 'Chat with Coach';

  @override
  String get totalSessions => 'Total\nSessions';

  @override
  String get hoursTrained => 'Hours\nTrained';

  @override
  String get currentStreak => 'Current\nStreak';

  @override
  String get noInsightsYet => 'No insights yet';

  @override
  String get noInsightsDescription =>
      'After your child\'s first session, you\'ll receive detailed feedback and focus scores from the coach right here.';

  @override
  String sportAndDate(String sport, String date) {
    return '$sport • $date';
  }

  @override
  String focusScore(String score) {
    return 'Focus: $score/5';
  }

  @override
  String feedbackRemarks(String remarks) {
    return '\"$remarks\"';
  }

  @override
  String get viewFullReport => 'View Full Report';

  @override
  String get noUpcomingAppointments => 'No upcoming appointments';

  @override
  String get bookNewSessionPrompt => 'Book a new session to get started!';

  @override
  String get navHome => 'Home';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navSchedule => 'Schedule';

  @override
  String get navProfile => 'Profile';

  @override
  String get gpsServiceDisabled => 'Please turn on GPS location services.';

  @override
  String get locationPermissionDenied => 'Location permission denied.';

  @override
  String get locationPermissionPermanentlyDenied =>
      'Location permission permanently denied. Please enable in settings.';

  @override
  String get findCoachesNearYou => 'Find Coaches Near You';

  @override
  String get turnOnLocationPrompt =>
      'Turn on location services to find the closest trainers.';

  @override
  String get enableAction => 'Enable';

  @override
  String get nearbyCertifiedTrainers => 'Nearby Certified Trainers';

  @override
  String get viewAllAction => 'View All';

  @override
  String errorMessage(String error) {
    return 'Error: $error';
  }

  @override
  String get noTrainersFound => 'No trainers found.';

  @override
  String get distanceUnknown => 'Distance unknown';

  @override
  String distanceMetersAway(String distance) {
    return '$distance m away';
  }

  @override
  String distanceKmAway(String distance) {
    return '$distance km away';
  }

  @override
  String get coachFallbackName => 'Coach';

  @override
  String get notSpecified => 'Not specified';

  @override
  String get autismTrainingCertified => 'Autism Training Certified';

  @override
  String get noDescriptionProvided => 'No description provided.';

  @override
  String get unknownTrainer => 'Unknown Trainer';

  @override
  String get availableStatus => 'Available';

  @override
  String get notAvailableStatus => 'Not Available';

  @override
  String get homeBased => 'Home-Based';

  @override
  String get coachingSports => 'Coaching Sports:';

  @override
  String get bookNow => 'Book Now';

  @override
  String get unavailableAction => 'Unavailable';

  @override
  String availableAtTime(String time) {
    return 'Available at $time';
  }

  @override
  String achievementsCount(String count) {
    return 'Achievements ($count)';
  }

  @override
  String get filterTrainersTitle => 'Filter Trainers';

  @override
  String get resetAction => 'Reset';

  @override
  String get bySportCategory => 'By Sport Category';

  @override
  String get applyFiltersAction => 'Apply Filters';

  @override
  String get trainerListTitle => 'Trainer List';

  @override
  String get searchByNameHint => 'Search by name...';

  @override
  String get noTrainersAvailableYet => 'No trainers available yet';

  @override
  String get noTrainersMatchCriteria =>
      'No trainers found matching your criteria.';

  @override
  String get sportAll => 'All';

  @override
  String get sportSwimming => 'Swimming';

  @override
  String get sportFootball => 'Football';

  @override
  String get sportBasketball => 'Basketball';

  @override
  String get sportTennis => 'Tennis';

  @override
  String get sportGymnastics => 'Gymnastics';

  @override
  String get sportYoga => 'Yoga';

  @override
  String get sportAthletics => 'Athletics';

  @override
  String get sportBadminton => 'Badminton';

  @override
  String get homeBasedAvailable => 'Home-based Available';

  @override
  String get centerBasedOnly => 'Center-based Only';

  @override
  String get avgRating => 'Avg Rating';

  @override
  String get reviewsLabel => 'Reviews';

  @override
  String get sportsLabel => 'Sports';

  @override
  String get ratingAndReviews => 'RATING & REVIEWS';

  @override
  String reviewsCount(String count) {
    return '$count reviews';
  }

  @override
  String get noReviewsYet => 'No reviews yet.\nBe the first to review!';

  @override
  String get aboutTitle => 'ABOUT';

  @override
  String get sportsTitle => 'SPORTS';

  @override
  String get reviewsTitle => 'REVIEWS';

  @override
  String get noWrittenReviewsYet => 'No written reviews yet.';

  @override
  String get bookASession => 'Book a Session';

  @override
  String get tbd => 'TBD';

  @override
  String get generalSport => 'General';

  @override
  String get defaultUser => 'User';

  @override
  String get selectFutureTime => 'Please select a future time.';

  @override
  String selectTimeBetween(String start, String end) {
    return 'Please select a time between $start and $end.';
  }

  @override
  String get selectTimePrompt => 'Please select a time.';

  @override
  String get selectChildPrompt => 'Please select a child profile.';

  @override
  String get cannotBookPast =>
      'Cannot book a session in the past. Please select a future time.';

  @override
  String get paymentCancelled => 'Payment cancelled or failed.';

  @override
  String bookingsConfirmed(String weeks) {
    return '$weeks Booking(s) Confirmed!';
  }

  @override
  String get bookingDetailsTitle => 'Booking Details';

  @override
  String get bookForChildTitle => 'Book for Child';

  @override
  String get selectChildDescription =>
      'Select the child profile for this session.';

  @override
  String errorLoadingChildren(String error) {
    return 'Error loading children: $error';
  }

  @override
  String get addChildFirstPrompt =>
      'Please add a child profile first in the \"Manage Children\" page before booking.';

  @override
  String get selectYourChildHint => 'Select your child';

  @override
  String childAgeFormat(String age) {
    return '(${age}y)';
  }

  @override
  String get selectSportTitle => 'Select Sport';

  @override
  String get sessionTypeTitle => 'Session Type';

  @override
  String get sessionTypeDescription =>
      'Choose how you want the session to be conducted.';

  @override
  String get inPersonType => 'In-Person';

  @override
  String get inPersonDesc => 'At trainer\'s location';

  @override
  String get remoteType => 'Remote';

  @override
  String get remoteDesc => 'Online consultation';

  @override
  String get homeBasedType => 'Home-Based';

  @override
  String homeBasedDescWithFee(String fee) {
    return 'Trainer comes to you (+RM $fee Travel Fee)';
  }

  @override
  String get homeBasedDescFree => 'Trainer comes to you';

  @override
  String get remoteNotice =>
      'Join the video call from the Session Details page during the scheduled time.';

  @override
  String homeBasedFeeNotice(String fee) {
    return 'A travel surcharge of RM $fee applies. This session must be paid via Stripe.';
  }

  @override
  String get homeBasedFreeNotice =>
      'Trainer will travel to your location. This session must be paid via Stripe.';

  @override
  String get onlineSessionLoc => 'Online Session';

  @override
  String get durationTitle => 'Duration';

  @override
  String get durationDescription => 'Select the length of each session.';

  @override
  String get oneHour => '1 Hour';

  @override
  String get twoHours => '2 Hours';

  @override
  String get scheduleTitle => 'Schedule';

  @override
  String get selectTimeHint => 'Select Time';

  @override
  String sessionEndsAt(String time) {
    return 'This session will end at $time.';
  }

  @override
  String get repeatBookingTitle => 'Repeat Booking';

  @override
  String maxWeeksFormat(String weeks) {
    return 'Max $weeks weeks';
  }

  @override
  String get repeatBookingDescription =>
      'Book this same time slot for consecutive weeks.';

  @override
  String get oneWeek => '1 Wk';

  @override
  String nWeeks(String weeks) {
    return '$weeks Wks';
  }

  @override
  String get operatingHoursTitle => 'Operating Hours';

  @override
  String get restDay => 'Rest Day';

  @override
  String get reviewAndPayAction => 'Review & Pay';

  @override
  String get weekdayMonday => 'Monday';

  @override
  String get weekdayTuesday => 'Tuesday';

  @override
  String get weekdayWednesday => 'Wednesday';

  @override
  String get weekdayThursday => 'Thursday';

  @override
  String get weekdayFriday => 'Friday';

  @override
  String get weekdaySaturday => 'Saturday';

  @override
  String get weekdaySunday => 'Sunday';

  @override
  String get paymentSummaryTitle => 'Payment Summary';

  @override
  String get sessionFeeLabel => 'Session Fee';

  @override
  String rmPriceFormat(String price) {
    return 'RM $price';
  }

  @override
  String get transportFeeLabel => 'Transport Fee';

  @override
  String get totalLabel => 'Total';

  @override
  String get paymentMethodTitle => 'Payment Method';

  @override
  String get useSessionCreditTitle => 'Use Session Credit';

  @override
  String get unavailableForHomeBased => 'Unavailable for Home-Based';

  @override
  String creditBalanceAndRequired(String balance, String required) {
    return 'Balance: $balance | Required: $required';
  }

  @override
  String notEnoughCredits(String required, String balance) {
    return 'Not enough credits (Need $required, Have $balance)';
  }

  @override
  String get payPerSessionTitle => 'Pay Per Session';

  @override
  String totalPriceFormat(String price) {
    return 'Total: RM $price';
  }

  @override
  String confirmAndDeductCredits(String credits) {
    return 'Confirm & Deduct $credits Credit(s)';
  }

  @override
  String proceedToPay(String price) {
    return 'Proceed to Pay RM $price';
  }

  @override
  String get failedToUploadImage => 'Failed to upload image.';

  @override
  String failedToSendMessage(String error) {
    return 'Failed to send message: $error';
  }

  @override
  String get takeAPhoto => 'Take a Photo';

  @override
  String get chooseFromGallery => 'Choose from Gallery';

  @override
  String startConversationWith(String name) {
    return 'Start a conversation with $name';
  }

  @override
  String get accountSuspendedNotice =>
      'This account has been suspended. You can no longer send messages.';

  @override
  String get typeAMessage => 'Type a message...';

  @override
  String get cannotReschedulePast => 'Cannot reschedule to a past time.';

  @override
  String trainerAvailableTime(String open, String close) {
    return 'Trainer is only available $open - $close on this day.';
  }

  @override
  String get rescheduleSessionTitle => 'Reschedule Session';

  @override
  String get selectNewDate => 'Select New Date';

  @override
  String availableTimeRange(String open, String close) {
    return 'Available $open - $close';
  }

  @override
  String get selectNewTime => 'Select New Time';

  @override
  String get confirmReschedule => 'Confirm Reschedule';

  @override
  String get rescheduledSuccessfully => 'Rescheduled successfully!';

  @override
  String get myAppointmentsTitle => 'My Appointments';

  @override
  String get tabPending => 'Pending';

  @override
  String get tabUpcoming => 'Upcoming';

  @override
  String get tabPast => 'Past';

  @override
  String get fallbackDatePlaceholder => 'WEDNESDAY, 11 MAR';

  @override
  String sportSession(String sport) {
    return '$sport Session';
  }

  @override
  String get viewDetailsAction => 'View Details';

  @override
  String get rescheduleAction => 'Reschedule';

  @override
  String noAppointmentsForTab(String tab) {
    return 'No $tab appointments';
  }

  @override
  String get tapDateToViewOrBook =>
      'Tap a date on the calendar to check\nor book a new session';

  @override
  String get statusPending => 'Pending';

  @override
  String get statusAccepted => 'Accepted';

  @override
  String get statusCompleted => 'Completed';

  @override
  String get statusCancelled => 'Cancelled';

  @override
  String get statusRejected => 'Rejected';

  @override
  String get sessionDetailsTitle => 'Session Details';

  @override
  String get statusLabel => 'Status';

  @override
  String get paymentLabel => 'Payment';

  @override
  String get scheduleLocationTitle => 'Schedule & Location';

  @override
  String get dateLabel => 'Date';

  @override
  String get timeLabel => 'Time';

  @override
  String timeWithDuration(String start, String end, String duration) {
    return '$start - $end ($duration mins)';
  }

  @override
  String get sportLabel => 'Sport';

  @override
  String get locationLabel => 'Location';

  @override
  String get remoteConsultationTitle => 'Remote Consultation';

  @override
  String get specialNeedsNotesTitle => 'Special Needs & Notes';

  @override
  String get sessionFeedbackTitle => 'Session Feedback';

  @override
  String parentNameLabel(String name) {
    return 'Parent: $name';
  }

  @override
  String get inAppVideoSession => 'In-App Video Session';

  @override
  String get remoteSessionWarning =>
      'This session will be conducted remotely. Please ensure you have a stable internet connection before joining.';

  @override
  String get navigatingToVideoCall => 'Navigating to Video Call Room...';

  @override
  String get joinVideoCallAction => 'Join Video Call';

  @override
  String get videoSessionEnded => 'Video session ended';

  @override
  String get noFeedbackProvidedYet => 'No feedback provided yet.';

  @override
  String get focusAttentionTitle => 'Focus & Attention';

  @override
  String scoreOutOfFive(String score) {
    return '$score/5';
  }

  @override
  String get energyLevelTitle => 'Energy Level';

  @override
  String get trainerRemarksTitle => 'Trainer Remarks';

  @override
  String get parentReviewTitle => 'Parent Review';

  @override
  String get errorLoadingDetails => 'Error loading details.';

  @override
  String get childDataNotFound => 'Child data not found.';

  @override
  String get notesTitle => 'Notes';

  @override
  String get noSpecialNeedsOrRemarks =>
      'No specific special needs or remarks provided by the parent.';

  @override
  String get specialNeedsTitle => 'Special Needs';

  @override
  String get parentRemarksTitle => 'Parent Remarks';

  @override
  String get reviewSubmittedStatus => 'Review Submitted';

  @override
  String get rateReviewTrainerAction => 'Rate & Review Trainer';

  @override
  String get sessionCompletedStatus => 'Session Completed';

  @override
  String get cancelSessionAction => 'Cancel Session';

  @override
  String get markAsCompletedAction => 'Mark as Completed';

  @override
  String get waitingForSessionTime => 'Waiting for Session Time';

  @override
  String get meltdownGraceApplied =>
      'Meltdown Grace applied: You will receive a full refund.';

  @override
  String get suddenMeltdownGrace => 'Sudden Meltdown? (Grace Period)';

  @override
  String get meltdownGraceDescription =>
      'Use your monthly 1-time grace for a full refund due to child\'s condition.';

  @override
  String get totalRefundLabel => 'Total Refund:';

  @override
  String get confirmCancellationAction => 'Confirm Cancellation';

  @override
  String get keepSessionAction => 'Keep Session';

  @override
  String get appointmentCancelledSuccess =>
      'Appointment cancelled successfully.';

  @override
  String get pleaseLoginFirst => 'Please login first';

  @override
  String sessionCompletedEarnings(String amount, String takeRate) {
    return 'Session completed! RM $amount (after $takeRate platform fee) added to your wallet.';
  }

  @override
  String get thankYouForReview => 'Thank you for your review!';

  @override
  String get profilePictureUpdatedSuccessfully =>
      'Profile picture updated successfully!';

  @override
  String get failedToUpdateProfilePicture => 'Failed to update profile picture';

  @override
  String get pleaseAddPhoneNumber => 'Please add phone number';

  @override
  String get editProfileInformation => 'Edit profile information';

  @override
  String get manageChildren => 'Manage Children';

  @override
  String get myTrainerDashboard => 'My Trainer Dashboard';

  @override
  String get language => 'Language';

  @override
  String get wallet => 'Wallet';

  @override
  String get contactUs => 'Contact us';

  @override
  String get logOut => 'Log Out';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String languageChangedTo(String languageName) {
    return 'Language changed to $languageName';
  }

  @override
  String get editProfileTitle => 'Edit profile';

  @override
  String get personalInfoSection => 'PERSONAL INFO';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get nicknameLabel => 'Nickname';

  @override
  String get contactSection => 'CONTACT';

  @override
  String get emailAddressLabel => 'Email address';

  @override
  String get phoneNumberLabel => 'Phone number';

  @override
  String get addressSection => 'ADDRESS';

  @override
  String get addressLabel => 'Address';

  @override
  String get pickLocationOnMap => 'Pick location on map';

  @override
  String get saveChangesButton => 'Save changes';

  @override
  String get fullNameRequired => 'Full name is required';

  @override
  String get phoneNumberRequired => 'Phone number is required';

  @override
  String get genderRequired => 'Please select a gender';

  @override
  String get addressRequired => 'Address is required';

  @override
  String get profileUpdatedSuccessfully => 'Profile updated successfully!';

  @override
  String failedToUpdateProfile(String error) {
    return 'Failed to update profile: $error';
  }

  @override
  String get newUserFallback => 'New User';

  @override
  String get genderLabel => 'GENDER';

  @override
  String get genderMale => 'Male';

  @override
  String get genderFemale => 'Female';

  @override
  String get genderOther => 'Other';

  @override
  String get moveMapToSelectLocation => 'Move map to select location...';

  @override
  String get unableToGetLocation => 'Unable to get location, defaulting to KL.';

  @override
  String get locationSelected => 'Location selected';

  @override
  String get selectLocationTitle => 'Select Location';

  @override
  String get selectedAddressLabel => 'Selected Address';

  @override
  String get confirmLocationButton => 'Confirm Location';

  @override
  String get manageChildrenDescription =>
      'Manage your children\'s profiles here. Accurate special needs tags help our trainers provide the best care.';

  @override
  String get addChildButton => 'Add Child';

  @override
  String childAgeAndGender(String age, String gender) {
    return '$age years old • $gender';
  }

  @override
  String activeTrainersPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Active Trainers',
      one: '1 Active Trainer',
    );
    return '$_temp0';
  }

  @override
  String get specialNeedsAndTags => 'Special Needs & Tags';

  @override
  String get noTagsAdded => 'No tags added.';

  @override
  String get performanceHistory => 'Performance History';

  @override
  String get noChildrenAddedYet => 'No Children Added Yet';

  @override
  String get noChildrenDescription =>
      'Add your child\'s profile to start booking specialized training sessions with certified coaches.';

  @override
  String get fillNameAgeGenderPrompt =>
      'Please fill in the name, age, and select a gender.';

  @override
  String get childProfileUpdatedSuccess => 'Child profile updated!';

  @override
  String get childProfileCreatedSuccess => 'Child profile created!';

  @override
  String errorSavingProfile(String error) {
    return 'Error saving profile: $error';
  }

  @override
  String get editChildProfileTitle => 'Edit Child Profile';

  @override
  String get addChildProfileTitle => 'Add Child Profile';

  @override
  String get basicInformationTitle => 'Basic Information';

  @override
  String get childNameLabel => 'Child\'s Name';

  @override
  String get childNameHint => 'e.g. Leo';

  @override
  String get ageLabel => 'Age';

  @override
  String get ageHint => 'e.g. 8';

  @override
  String get specialNeedsAndTraitsTitle => 'Special Needs & Traits';

  @override
  String get specialNeedsDescription =>
      'Select all that apply. This helps our trainers tailor their sessions to your child\'s needs.';

  @override
  String get additionalRemarksOptional =>
      'Additional Remarks for Trainer (Optional)';

  @override
  String get remarksHint =>
      'e.g., Prefers a quiet environment, loves high-fives as reward, allergic to peanuts...';

  @override
  String get saveProfileButton => 'Save Profile';

  @override
  String get genderDropdownLabel => 'Gender';

  @override
  String get selectHint => 'Select';

  @override
  String get performanceTrackingTitle => 'Performance Tracking';

  @override
  String get overallAverageTitle => 'Overall Average';

  @override
  String get avgFocusLabel => 'Avg Focus';

  @override
  String get avgEnergyLabel => 'Avg Energy';

  @override
  String get sessionHistoryTitle => 'Session History';

  @override
  String get noPerformanceRecordsYet => 'No performance records yet.';

  @override
  String get completeSessionToLogFeedback =>
      'Complete a session to log feedback.';

  @override
  String yearsOldWithGender(String age, String gender) {
    return '$age years old, $gender';
  }

  @override
  String yearsOld(String age) {
    return '$age years old';
  }

  @override
  String get focusLabel => 'Focus';

  @override
  String get energyLabel => 'Energy';

  @override
  String get trainingCreditsTitle => 'Training Credits';

  @override
  String get availableSessionsLabel => 'Available Sessions:';

  @override
  String get creditSingular => 'Credit';

  @override
  String get creditsPlural => 'Credits';

  @override
  String get buyCreditPackages => 'Buy Credit Packages';

  @override
  String get creditTab => 'Credit';

  @override
  String get singlePayTab => 'Single Pay';

  @override
  String get viewAllHistory => 'View All History';

  @override
  String errorLoadingHistory(String error) {
    return 'Error loading history: $error';
  }

  @override
  String get selectPackageTitle => 'Select a Package';

  @override
  String get buyMoreCreditsDesc => 'Buy more credits to enjoy bulk discounts.';

  @override
  String get singleSessionPackage => 'Single Session';

  @override
  String get starterPackPackage => 'Starter Pack';

  @override
  String get proPackPackage => 'Pro Pack';

  @override
  String get popularBadge => 'POPULAR';

  @override
  String creditsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Credits',
      one: '1 Credit',
    );
    return '$_temp0';
  }

  @override
  String paymentSuccessfulAddedCredits(String credits) {
    return 'Payment successful! Added $credits credits.';
  }

  @override
  String transactionCreditAmount(String prefix, int val) {
    String _temp0 = intl.Intl.pluralLogic(
      val,
      locale: localeName,
      other: '$val Credits',
      one: '1 Credit',
    );
    return '$prefix $_temp0';
  }

  @override
  String transactionRmAmount(String prefix, String amount) {
    return '$prefix RM $amount';
  }

  @override
  String get statusRefunded => 'Refunded';

  @override
  String get statusFailed => 'Failed';

  @override
  String get noTransactionHistoryYet => 'No transaction history yet.';

  @override
  String get helpAndSupportTitle => 'Help & Support';

  @override
  String get newTicketAction => 'New Ticket';

  @override
  String get howCanWeHelp => 'How can we help?';

  @override
  String get trackSupportRequests =>
      'Track your support requests or create a new one.';

  @override
  String get myTicketsTitle => 'My Tickets';

  @override
  String errorLoadingTickets(String err) {
    return 'Error loading tickets: $err';
  }

  @override
  String get noSupportTicketsYet => 'No support tickets yet.';

  @override
  String get submitNewTicketPrompt =>
      'If you have any issues, feel free to submit a new ticket.';

  @override
  String adminMessage(String message) {
    return 'Admin: $message';
  }

  @override
  String youMessage(String message) {
    return 'You: $message';
  }

  @override
  String updatedAtDate(String date) {
    return 'Updated: $date';
  }

  @override
  String get categoryBillingAndPayment => 'Billing & Payment';

  @override
  String get categoryAppointmentReschedule => 'Appointment / Reschedule';

  @override
  String get categoryTechnicalIssue => 'Technical Issue';

  @override
  String get categoryTrainerFeedback => 'Trainer Feedback';

  @override
  String get categoryOther => 'Other';

  @override
  String get pleaseSelectCategory => 'Please select a category.';

  @override
  String get ticketSubmittedSuccessfully => 'Ticket submitted successfully!';

  @override
  String failedToSubmitTicket(String error) {
    return 'Failed to submit ticket: $error';
  }

  @override
  String get newSupportTicketTitle => 'New Support Ticket';

  @override
  String get supportTeamResponseTime =>
      'Our support team usually responds within 2-4 hours during business days.';

  @override
  String get whatDoYouNeedHelpWith => 'What do you need help with? *';

  @override
  String get selectCategoryHint => 'Select a category';

  @override
  String get detailsLabel => 'Details *';

  @override
  String get describeIssueHint => 'Please describe your issue in detail...';

  @override
  String get pleaseEnterMessage => 'Please enter your message';

  @override
  String get submitTicketAction => 'Submit Ticket';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get emailAddressInputLabel => 'Email Address';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get passwordInputLabel => 'Password';

  @override
  String get passwordHint => 'Enter your password';

  @override
  String get signInButton => 'Sign In';

  @override
  String get dontHaveAccountPrompt => 'Don\'t have an account?';

  @override
  String get signUpTextButton => 'Sign up';

  @override
  String get fillAllFieldsError => 'Please fill in all fields';

  @override
  String get signInSuccess => 'Successfully sign in!';

  @override
  String get createAccount => 'Create Account';

  @override
  String get joinUsTodayFree => 'Join us today — it\'s free';

  @override
  String get iAmA => 'I am a...';

  @override
  String get roleParent => 'Parent';

  @override
  String get roleCoach => 'Coach';

  @override
  String get passwordMinLengthHint => 'Minimum 6 characters';

  @override
  String get alreadyHaveAccountPrompt => 'Already have an account?';

  @override
  String get signInTextButton => 'Sign in';

  @override
  String get signUpSuccess => 'Successfully registered!';

  @override
  String get pleaseWriteBriefBio => 'Please write a brief bio about yourself.';

  @override
  String get pleaseSelectAtLeastOneSport =>
      'Please select at least one sport you can teach.';

  @override
  String get pleaseUploadCertificate =>
      'Please upload at least one relevant certificate.';

  @override
  String get applicationSubmittedWaitAdmin =>
      'Application submitted successfully! Please wait for admin approval.';

  @override
  String errorSubmittingApplication(String error) {
    return 'Error submitting application: $error';
  }

  @override
  String get becomeTrainerTitle => 'Become a Trainer';

  @override
  String get joinTrainerCommunityDescription =>
      'Join our community of specialized trainers and make a difference.';

  @override
  String get personalBioTitle => 'Personal Bio';

  @override
  String get experienceWithSpecialNeedsDescription =>
      'Tell us about your experience working with special needs children.';

  @override
  String get yourExperienceLabel => 'Your Experience';

  @override
  String get experienceHintText =>
      'e.g., I have 3 years of experience teaching swimming to children with ASD...';

  @override
  String get sportsYouTeachTitle => 'Sports You Teach';

  @override
  String get selectQualifiedSportsDescription =>
      'Select all the sports you are qualified to teach.';

  @override
  String get icAndCertificatesTitle => 'IC & Certificates';

  @override
  String get addImagesAction => 'Add Images';

  @override
  String get uploadIcAndCertificatesDescription =>
      'Upload photos of your IC and coaching certifications or special needs training qualifications.';

  @override
  String get noPhotosUploadedYet => 'No photos uploaded yet';

  @override
  String get submitApplicationAction => 'Submit Application';

  @override
  String get academyTitle => 'Academy';

  @override
  String get welcomeToAcademy => 'Welcome to the Academy!';

  @override
  String get academyPendingDescription =>
      'Please review the learning materials below and complete the Final Assessment (Quiz). Once passed, our admins will approve your account.';

  @override
  String errorLoadingAcademyContent(String error) {
    return 'Error loading academy content: $error';
  }

  @override
  String get noTrainingModulesAvailable =>
      'No training modules available right now.';

  @override
  String get learningMaterials => 'Learning Materials';

  @override
  String get finalAssessment => 'Final Assessment';

  @override
  String get finalAssessmentDescription =>
      'Tap to open the assessment form. Please ensure you use your registered email.';

  @override
  String get continuousLearning => 'Continuous Learning';

  @override
  String get upskillDescription =>
      'Upskill yourself, earn exclusive badges, and increase your booking rate!';

  @override
  String myBadgesWithPoints(String points) {
    return 'My Badges ($points pts)';
  }

  @override
  String get advancedCourses => 'Advanced Courses';

  @override
  String get noAdvancedCoursesYet => 'No advanced courses available yet.';

  @override
  String requiredPointsLabel(String points) {
    return '$points pt';
  }

  @override
  String plusCpdPoints(String points) {
    return '+ $points CPD Points';
  }

  @override
  String failedToOpenCourse(String error) {
    return 'Failed to open course: $error';
  }

  @override
  String get summaryTodayTitle => 'Summary Today';

  @override
  String get availableSlotsLabel => 'Available\nSlots';

  @override
  String get todaySessionsLabel => 'Today\nSessions';

  @override
  String get totalMembersLabel => 'Total\nMembers';

  @override
  String get profileHiddenTitle => 'Profile Hidden';

  @override
  String get profileHiddenDesc =>
      'Parents cannot book you until you set your Service Base Location.';

  @override
  String get fixNowAction => 'Fix Now';

  @override
  String get newRequestsTitle => 'New Requests';

  @override
  String get allCaughtUpTitle => 'All Caught Up!';

  @override
  String get noPendingRequestsDesc =>
      'You have no pending requests at the moment.';

  @override
  String get todaySessionScheduleTitle => 'Today Session Schedule';

  @override
  String get freeScheduleTitle => 'Free Schedule';

  @override
  String get noSessionsScheduledDesc =>
      'You have no sessions scheduled for today. Enjoy your day!';

  @override
  String get studentLabel => 'Student';

  @override
  String get newBadgeLabel => 'New';

  @override
  String get acceptAction => 'Accept';

  @override
  String get rejectAction => 'Reject';

  @override
  String get chatAction => 'Chat';

  @override
  String get actionRequiredSetLocationDesc =>
      'Action Required: Please set your Service Base Location in your Dashboard before accepting requests.';

  @override
  String get appointmentAcceptedSuccess => 'Appointment Accepted!';

  @override
  String get appointmentRejectedInfo => 'Appointment Rejected!';

  @override
  String get navAcademy => 'Academy';

  @override
  String get navStudents => 'Students';

  @override
  String get myStudentsTitle => 'My Students';

  @override
  String get summaryTitle => 'Summary';

  @override
  String get totalStudentsLabel => 'Total\nStudents';

  @override
  String get activeSessionsLabel => 'Active\nSessions';

  @override
  String get pendingRequestsLabel => 'Pending\nRequests';

  @override
  String get noActiveStudentsTitle => 'No Active Students';

  @override
  String get noActiveStudentsDesc =>
      'You currently have no active students. When you accept requests, they will appear here.';

  @override
  String get noPendingRequestsTitle => 'No Pending Requests';

  @override
  String get noPendingStudentRequestsDesc =>
      'You are all caught up! There are no pending student requests right now.';

  @override
  String get noPastStudentsTitle => 'No Past Students';

  @override
  String get noPastStudentsDesc =>
      'You do not have any past student records yet.';

  @override
  String get tabActive => 'Active';

  @override
  String lastSessionLabel(String date) {
    return 'Last: $date';
  }

  @override
  String get acceptRequestAction => 'Accept Request';

  @override
  String get reviewNewRequestAction => 'Review New Request';

  @override
  String get logProgressAction => 'Log Progress';

  @override
  String get viewHistoryAction => 'View History';

  @override
  String get messageParentAction => 'Message Parent';

  @override
  String get viewPerformanceAction => 'View Performance';

  @override
  String get pauseReceivingRequestsTitle => 'Pause Receiving Requests';

  @override
  String get pauseReceivingRequestsMessage =>
      'When should we turn it back on for you?';

  @override
  String get pauseForOneHour => 'For 1 Hour';

  @override
  String get pauseForFourHours => 'For 4 Hours';

  @override
  String get pauseUntilTomorrow => 'Until Tomorrow';

  @override
  String get pauseUntilTurnedBackOn => 'Until I turn it back on';

  @override
  String get cancelAction => 'Cancel';

  @override
  String get operatingHoursDesc =>
      'Set your weekly availability. Default is open all week. Turn off the days you are resting.';

  @override
  String get operatingHoursUpdatedSuccess =>
      'Operating hours updated successfully.';

  @override
  String failedToUpdateOperatingHours(String error) {
    return 'Failed to update: $error';
  }

  @override
  String get saveChangesAction => 'Save Changes';

  @override
  String get appointmentsTitle => 'Appointments';

  @override
  String get acceptingRequestsLabel => 'Accepting Requests';

  @override
  String autoResumesAtTime(String time) {
    return 'Auto-resumes at $time';
  }

  @override
  String get youAreNowOnline => 'You are now online!';

  @override
  String get noAppointmentsYet => 'No appointments yet.';

  @override
  String get parentsCanSendRequestsDesc =>
      'Parents can send you requests for this day.';

  @override
  String get statusConfirmed => 'Confirmed';

  @override
  String get actionRequiredShort => 'Action Req.';

  @override
  String get notAcceptingRequestsTitle => 'Not Accepting Requests';

  @override
  String get updateProfileTitle => 'Update Profile';

  @override
  String get locationCityAreaLabel => 'Location (City/Area)';

  @override
  String get locationCityAreaHint => 'e.g., Kuala Lumpur, Petaling Jaya';

  @override
  String get aboutYouBioLabel => 'About You (Bio)';

  @override
  String get aboutYouBioHint =>
      'Tell parents about your experience and teaching style...';

  @override
  String get offerHomeBasedSessionsLabel => 'Offer Home-based Sessions?';

  @override
  String get offerHomeBasedSessionsDesc =>
      'Parents can request sessions at their own homes.';

  @override
  String get travelSurchargeLabel => 'Travel Surcharge (Per Session)';

  @override
  String get rmZeroHint => 'RM0.00';

  @override
  String get travelSurchargeDesc =>
      'This fee goes 100% to you to cover travel expenses.';

  @override
  String get yourPublicProfileTitle => 'Your Public Profile';

  @override
  String get bioNotSetFallback => 'Tell parents about your experience...';

  @override
  String get locationNotSetFallback => 'Location not set';

  @override
  String get noSportsSelectedFallback => 'No sports selected';

  @override
  String get goBackTooltip => 'Go Back';

  @override
  String get trainerDashboardTitle => 'Trainer Dashboard';

  @override
  String get reschedulingDisabledWithin24h =>
      'Rescheduling is disabled within 24h of the session.';

  @override
  String get withdrawFunds => 'Withdraw Funds';

  @override
  String get withdrawFundsDescription =>
      'Enter the amount you wish to transfer to your bank account.';

  @override
  String availableBalanceAmount(String amount) {
    return 'Available: RM $amount';
  }

  @override
  String get insufficientBalance => 'Insufficient balance';

  @override
  String get submitRequest => 'Submit Request';

  @override
  String get myWallet => 'My Wallet';

  @override
  String get recentTransactions => 'Recent Transactions';

  @override
  String get noTransactionsYet => 'No transactions yet.';

  @override
  String get availableBalance => 'Available Balance';

  @override
  String get noBalanceToWithdraw => 'You have no balance to withdraw.';

  @override
  String get bankDetailsSaved =>
      'Bank details saved! You can now proceed to withdraw funds.';

  @override
  String failedToSaveBankDetails(String error) {
    return 'Failed to save bank details: $error';
  }

  @override
  String withdrawalRequestSubmitted(String amount) {
    return 'Withdrawal request for RM $amount submitted! Pending admin approval.';
  }

  @override
  String get addBankDetails => 'Add Bank Details';

  @override
  String get provideBankDetailsDescription =>
      'Please provide your bank details to receive payouts.';

  @override
  String get bankNameLabel => 'Bank Name';

  @override
  String get bankNameHint => 'e.g. Maybank, CIMB';

  @override
  String get accountNumberLabel => 'Account Number';

  @override
  String get accountNumberHint => 'Account Number';

  @override
  String get accountHolderNameLabel => 'Account Holder Name';

  @override
  String get accountHolderNameHint => 'Name as per bank account';

  @override
  String get saveDetailsAction => 'Save Details';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get forgotPasswordDescription =>
      'Enter your email and we\'ll send you a reset link.';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get resetLinkSent => 'Password reset link sent to your email.';

  @override
  String get cancel => 'Cancel';

  @override
  String get logOutConfirmation => 'Are you sure you want to log out?';

  @override
  String get pendingSessionFreeCancellation =>
      'This session is still pending. Cancelling now is free and provides a full refund';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get parentFallbackName => '家长';

  @override
  String goodMorningGreeting(String name) {
    return '早上好，\n$name！';
  }

  @override
  String errorLoadingData(String error) {
    return '加载数据出错：$error';
  }

  @override
  String get childsMilestones => '孩子的里程碑';

  @override
  String get latestSessionInsight => '最新课程洞察';

  @override
  String get resourcesForYou => '为您准备的资源';

  @override
  String get viewMore => '查看更多';

  @override
  String get failedToLoadContent => '加载内容失败。';

  @override
  String get moreResourcesComingSoon => '更多资源即将推出！';

  @override
  String todayTime(String time) {
    return '今天，$time';
  }

  @override
  String tomorrowTime(String time) {
    return '明天，$time';
  }

  @override
  String get upcomingAppointment => '即将到来的预约';

  @override
  String get chatWithCoach => '与教练聊天';

  @override
  String get totalSessions => '总计\n课程';

  @override
  String get hoursTrained => '训练\n时长';

  @override
  String get currentStreak => '连续\n打卡';

  @override
  String get noInsightsYet => '暂无数据';

  @override
  String get noInsightsDescription => '在孩子的第一次课程结束后，您将在这里收到教练提供的详细反馈和专注度评分。';

  @override
  String sportAndDate(String sport, String date) {
    return '$sport • $date';
  }

  @override
  String focusScore(String score) {
    return '专注度：$score/5';
  }

  @override
  String feedbackRemarks(String remarks) {
    return '\"$remarks\"';
  }

  @override
  String get viewFullReport => '查看完整报告';

  @override
  String get noUpcomingAppointments => '暂无即将到来的预约';

  @override
  String get bookNewSessionPrompt => '预约新课程以开始！';

  @override
  String get navHome => '首页';

  @override
  String get navDiscover => '发现';

  @override
  String get navSchedule => '日程';

  @override
  String get navProfile => '我的';

  @override
  String get gpsServiceDisabled => '请开启 GPS 定位服务。';

  @override
  String get locationPermissionDenied => '定位权限被拒绝。';

  @override
  String get locationPermissionPermanentlyDenied => '定位权限已被永久拒绝。请在设置中开启。';

  @override
  String get findCoachesNearYou => '发现附近的教练';

  @override
  String get turnOnLocationPrompt => '开启定位服务以寻找离您最近的教练。';

  @override
  String get enableAction => '开启';

  @override
  String get nearbyCertifiedTrainers => '附近的认证教练';

  @override
  String get viewAllAction => '查看全部';

  @override
  String errorMessage(String error) {
    return '错误：$error';
  }

  @override
  String get noTrainersFound => '未找到教练。';

  @override
  String get distanceUnknown => '距离未知';

  @override
  String distanceMetersAway(String distance) {
    return '距离 $distance 米';
  }

  @override
  String distanceKmAway(String distance) {
    return '距离 $distance 公里';
  }

  @override
  String get coachFallbackName => '教练';

  @override
  String get notSpecified => '未指定';

  @override
  String get autismTrainingCertified => '自闭症训练认证';

  @override
  String get noDescriptionProvided => '暂无简介。';

  @override
  String get unknownTrainer => '未知教练';

  @override
  String get availableStatus => '可预约';

  @override
  String get notAvailableStatus => '不可预约';

  @override
  String get homeBased => '上门服务';

  @override
  String get coachingSports => '辅导项目：';

  @override
  String get bookNow => '立即预约';

  @override
  String get unavailableAction => '暂不可用';

  @override
  String availableAtTime(String time) {
    return '$time 可预约';
  }

  @override
  String achievementsCount(String count) {
    return '成就 ($count)';
  }

  @override
  String get filterTrainersTitle => '筛选教练';

  @override
  String get resetAction => '重置';

  @override
  String get bySportCategory => '按运动项目';

  @override
  String get applyFiltersAction => '应用筛选';

  @override
  String get trainerListTitle => '教练列表';

  @override
  String get searchByNameHint => '按姓名搜索...';

  @override
  String get noTrainersAvailableYet => '暂无可预约的教练';

  @override
  String get noTrainersMatchCriteria => '未找到符合您条件的教练。';

  @override
  String get sportAll => '全部';

  @override
  String get sportSwimming => '游泳';

  @override
  String get sportFootball => '足球';

  @override
  String get sportBasketball => '篮球';

  @override
  String get sportTennis => '网球';

  @override
  String get sportGymnastics => '体操';

  @override
  String get sportYoga => '瑜伽';

  @override
  String get sportAthletics => '田径';

  @override
  String get sportBadminton => '羽毛球';

  @override
  String get homeBasedAvailable => '可上门服务';

  @override
  String get centerBasedOnly => '仅限中心服务';

  @override
  String get avgRating => '平均评分';

  @override
  String get reviewsLabel => '评价';

  @override
  String get sportsLabel => '运动项目';

  @override
  String get ratingAndReviews => '评分与评价';

  @override
  String reviewsCount(String count) {
    return '$count 条评价';
  }

  @override
  String get noReviewsYet => '暂无评价。\n快来发表第一条评价吧！';

  @override
  String get aboutTitle => '关于';

  @override
  String get sportsTitle => '运动项目';

  @override
  String get reviewsTitle => '评价';

  @override
  String get noWrittenReviewsYet => '暂无文字评价。';

  @override
  String get bookASession => '预约课程';

  @override
  String get tbd => '待定';

  @override
  String get generalSport => '通用';

  @override
  String get defaultUser => '用户';

  @override
  String get selectFutureTime => '请选择一个未来的时间。';

  @override
  String selectTimeBetween(String start, String end) {
    return '请选择 $start 到 $end 之间的时间。';
  }

  @override
  String get selectTimePrompt => '请选择时间。';

  @override
  String get selectChildPrompt => '请选择孩子档案。';

  @override
  String get cannotBookPast => '无法预约过去的时间，请选择未来的时间。';

  @override
  String get paymentCancelled => '支付已取消或失败。';

  @override
  String bookingsConfirmed(String weeks) {
    return '$weeks 个预约已确认！';
  }

  @override
  String get bookingDetailsTitle => '预约详情';

  @override
  String get bookForChildTitle => '为孩子预约';

  @override
  String get selectChildDescription => '为本次课程选择孩子档案。';

  @override
  String errorLoadingChildren(String error) {
    return '加载孩子信息出错：$error';
  }

  @override
  String get addChildFirstPrompt => '在预约之前，请先在“管理孩子”页面添加孩子档案。';

  @override
  String get selectYourChildHint => '选择您的孩子';

  @override
  String childAgeFormat(String age) {
    return '($age岁)';
  }

  @override
  String get selectSportTitle => '选择运动项目';

  @override
  String get sessionTypeTitle => '授课方式';

  @override
  String get sessionTypeDescription => '选择您希望的授课方式。';

  @override
  String get inPersonType => '线下';

  @override
  String get inPersonDesc => '在教练场地';

  @override
  String get remoteType => '远程';

  @override
  String get remoteDesc => '线上咨询';

  @override
  String get homeBasedType => '上门服务';

  @override
  String homeBasedDescWithFee(String fee) {
    return '教练上门服务 (+RM $fee 交通费)';
  }

  @override
  String get homeBasedDescFree => '教练上门服务';

  @override
  String get remoteNotice => '请在预约时间内从“课程详情”页面加入视频通话。';

  @override
  String homeBasedFeeNotice(String fee) {
    return '收取 RM $fee 的差旅费。本次课程必须通过 Stripe 支付。';
  }

  @override
  String get homeBasedFreeNotice => '教练将前往您的地点。本次课程必须通过 Stripe 支付。';

  @override
  String get onlineSessionLoc => '线上课程';

  @override
  String get durationTitle => '时长';

  @override
  String get durationDescription => '选择每节课的时长。';

  @override
  String get oneHour => '1 小时';

  @override
  String get twoHours => '2 小时';

  @override
  String get scheduleTitle => '时间安排';

  @override
  String get selectTimeHint => '选择时间';

  @override
  String sessionEndsAt(String time) {
    return '本节课将于 $time 结束。';
  }

  @override
  String get repeatBookingTitle => '重复预约';

  @override
  String maxWeeksFormat(String weeks) {
    return '最多 $weeks 周';
  }

  @override
  String get repeatBookingDescription => '在连续的几周内预约同一时间段。';

  @override
  String get oneWeek => '1 周';

  @override
  String nWeeks(String weeks) {
    return '$weeks 周';
  }

  @override
  String get operatingHoursTitle => '营业时间';

  @override
  String get restDay => '休息日';

  @override
  String get reviewAndPayAction => '检查并支付';

  @override
  String get weekdayMonday => '星期一';

  @override
  String get weekdayTuesday => '星期二';

  @override
  String get weekdayWednesday => '星期三';

  @override
  String get weekdayThursday => '星期四';

  @override
  String get weekdayFriday => '星期五';

  @override
  String get weekdaySaturday => '星期六';

  @override
  String get weekdaySunday => '星期日';

  @override
  String get paymentSummaryTitle => '支付摘要';

  @override
  String get sessionFeeLabel => '课程费用';

  @override
  String rmPriceFormat(String price) {
    return 'RM $price';
  }

  @override
  String get transportFeeLabel => '交通费';

  @override
  String get totalLabel => '总计';

  @override
  String get paymentMethodTitle => '支付方式';

  @override
  String get useSessionCreditTitle => '使用课程积分';

  @override
  String get unavailableForHomeBased => '上门服务不可用';

  @override
  String creditBalanceAndRequired(String balance, String required) {
    return '余额：$balance | 需求：$required';
  }

  @override
  String notEnoughCredits(String required, String balance) {
    return '积分不足（需要 $required，拥有 $balance）';
  }

  @override
  String get payPerSessionTitle => '按次单结';

  @override
  String totalPriceFormat(String price) {
    return '总计：RM $price';
  }

  @override
  String confirmAndDeductCredits(String credits) {
    return '确认并扣除 $credits 个积分';
  }

  @override
  String proceedToPay(String price) {
    return '前往支付 RM $price';
  }

  @override
  String get failedToUploadImage => '上传图片失败。';

  @override
  String failedToSendMessage(String error) {
    return '发送消息失败：$error';
  }

  @override
  String get takeAPhoto => '拍照';

  @override
  String get chooseFromGallery => '从相册选择';

  @override
  String startConversationWith(String name) {
    return '开始与 $name 的对话';
  }

  @override
  String get accountSuspendedNotice => '此账号已被封禁。您无法再发送消息。';

  @override
  String get typeAMessage => '输入消息...';

  @override
  String get cannotReschedulePast => '无法改期到过去的时间。';

  @override
  String trainerAvailableTime(String open, String close) {
    return '教练在这一天仅在 $open - $close 可用。';
  }

  @override
  String get rescheduleSessionTitle => '重新安排课程';

  @override
  String get selectNewDate => '选择新日期';

  @override
  String availableTimeRange(String open, String close) {
    return '$open - $close 可预约';
  }

  @override
  String get selectNewTime => '选择新时间';

  @override
  String get confirmReschedule => '确认改期';

  @override
  String get rescheduledSuccessfully => '改期成功！';

  @override
  String get myAppointmentsTitle => '我的预约';

  @override
  String get tabPending => '待定';

  @override
  String get tabUpcoming => '即将到来';

  @override
  String get tabPast => '已结束';

  @override
  String get fallbackDatePlaceholder => '3月11日, 星期三';

  @override
  String sportSession(String sport) {
    return '$sport 课程';
  }

  @override
  String get viewDetailsAction => '查看详情';

  @override
  String get rescheduleAction => '改期';

  @override
  String noAppointmentsForTab(String tab) {
    return '暂无$tab预约';
  }

  @override
  String get tapDateToViewOrBook => '点击日历上的日期以查看\n或预约新课程';

  @override
  String get statusPending => '待定';

  @override
  String get statusAccepted => '已接受';

  @override
  String get statusCompleted => '已完成';

  @override
  String get statusCancelled => '已取消';

  @override
  String get statusRejected => '已拒绝';

  @override
  String get sessionDetailsTitle => '课程详情';

  @override
  String get statusLabel => '状态';

  @override
  String get paymentLabel => '支付';

  @override
  String get scheduleLocationTitle => '时间与地点';

  @override
  String get dateLabel => '日期';

  @override
  String get timeLabel => '时间';

  @override
  String timeWithDuration(String start, String end, String duration) {
    return '$start - $end ($duration 分钟)';
  }

  @override
  String get sportLabel => '运动项目';

  @override
  String get locationLabel => '地点';

  @override
  String get remoteConsultationTitle => '远程咨询';

  @override
  String get specialNeedsNotesTitle => '特殊需求与备注';

  @override
  String get sessionFeedbackTitle => '课程反馈';

  @override
  String parentNameLabel(String name) {
    return '家长：$name';
  }

  @override
  String get inAppVideoSession => '应用内视频课程';

  @override
  String get remoteSessionWarning => '本课程将远程进行。加入前请确保您的网络连接稳定。';

  @override
  String get navigatingToVideoCall => '正在进入视频通话房间...';

  @override
  String get joinVideoCallAction => '加入视频通话';

  @override
  String get videoSessionEnded => '视频课程已结束';

  @override
  String get noFeedbackProvidedYet => '暂无反馈。';

  @override
  String get focusAttentionTitle => '专注与注意力';

  @override
  String scoreOutOfFive(String score) {
    return '$score/5';
  }

  @override
  String get energyLevelTitle => '精力水平';

  @override
  String get trainerRemarksTitle => '教练点评';

  @override
  String get parentReviewTitle => '家长评价';

  @override
  String get errorLoadingDetails => '加载详情出错。';

  @override
  String get childDataNotFound => '未找到孩子数据。';

  @override
  String get notesTitle => '备注';

  @override
  String get noSpecialNeedsOrRemarks => '家长未提供具体的特殊需求或备注。';

  @override
  String get specialNeedsTitle => '特殊需求';

  @override
  String get parentRemarksTitle => '家长备注';

  @override
  String get reviewSubmittedStatus => '评价已提交';

  @override
  String get rateReviewTrainerAction => '评价教练';

  @override
  String get sessionCompletedStatus => '课程已完成';

  @override
  String get cancelSessionAction => '取消课程';

  @override
  String get markAsCompletedAction => '标记为已完成';

  @override
  String get waitingForSessionTime => '等待上课时间';

  @override
  String get meltdownGraceApplied => '已应用崩溃豁免：您将获得全额退款。';

  @override
  String get suddenMeltdownGrace => '突发崩溃？（豁免期）';

  @override
  String get meltdownGraceDescription => '使用每月一次的豁免机会，因孩子状况原因获得全额退款。';

  @override
  String get totalRefundLabel => '退款总额：';

  @override
  String get confirmCancellationAction => '确认取消';

  @override
  String get keepSessionAction => '保留课程';

  @override
  String get appointmentCancelledSuccess => '预约取消成功。';

  @override
  String get pleaseLoginFirst => '请先登录';

  @override
  String sessionCompletedEarnings(String amount, String takeRate) {
    return '课程已完成! RM $amount（扣除 $takeRate 平台费后）已加入您的钱包。';
  }

  @override
  String get thankYouForReview => '感谢您的评价！';

  @override
  String get profilePictureUpdatedSuccessfully => '头像更新成功！';

  @override
  String get failedToUpdateProfilePicture => '更新头像失败';

  @override
  String get pleaseAddPhoneNumber => '请添加手机号码';

  @override
  String get editProfileInformation => '编辑个人信息';

  @override
  String get manageChildren => '管理孩子';

  @override
  String get myTrainerDashboard => '我的教练面板';

  @override
  String get language => '语言';

  @override
  String get wallet => '钱包';

  @override
  String get contactUs => '联系我们';

  @override
  String get logOut => '退出登录';

  @override
  String get selectLanguage => '选择语言';

  @override
  String languageChangedTo(String languageName) {
    return '语言已切换至 $languageName';
  }

  @override
  String get editProfileTitle => '编辑个人资料';

  @override
  String get personalInfoSection => '个人信息';

  @override
  String get fullNameLabel => '全名';

  @override
  String get nicknameLabel => '昵称';

  @override
  String get contactSection => '联系方式';

  @override
  String get emailAddressLabel => '电子邮件地址';

  @override
  String get phoneNumberLabel => '手机号码';

  @override
  String get addressSection => '地址';

  @override
  String get addressLabel => '详细地址';

  @override
  String get pickLocationOnMap => '在地图上选择位置';

  @override
  String get saveChangesButton => '保存更改';

  @override
  String get fullNameRequired => '全名不能为空';

  @override
  String get phoneNumberRequired => '手机号码不能为空';

  @override
  String get genderRequired => '请选择性别';

  @override
  String get addressRequired => '地址不能为空';

  @override
  String get profileUpdatedSuccessfully => '个人资料更新成功！';

  @override
  String failedToUpdateProfile(String error) {
    return '更新个人资料失败：$error';
  }

  @override
  String get newUserFallback => '新用户';

  @override
  String get genderLabel => '性别';

  @override
  String get genderMale => '男';

  @override
  String get genderFemale => '女';

  @override
  String get genderOther => '其他';

  @override
  String get moveMapToSelectLocation => '移动地图以选择位置...';

  @override
  String get unableToGetLocation => '无法获取位置，默认定位至吉隆坡。';

  @override
  String get locationSelected => '已选择位置';

  @override
  String get selectLocationTitle => '选择位置';

  @override
  String get selectedAddressLabel => '已选地址';

  @override
  String get confirmLocationButton => '确认位置';

  @override
  String get manageChildrenDescription =>
      '在此管理您孩子的档案。准确的特殊需求标签有助于我们的教练提供最好的关怀。';

  @override
  String get addChildButton => '添加孩子';

  @override
  String childAgeAndGender(String age, String gender) {
    return '$age 岁 • $gender';
  }

  @override
  String activeTrainersPlural(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 位活跃教练',
      one: '1 位活跃教练',
    );
    return '$_temp0';
  }

  @override
  String get specialNeedsAndTags => '特殊需求与标签';

  @override
  String get noTagsAdded => '未添加标签。';

  @override
  String get performanceHistory => '表现记录';

  @override
  String get noChildrenAddedYet => '暂未添加孩子';

  @override
  String get noChildrenDescription => '添加孩子的档案，开始预约由认证教练提供的专业训练课程。';

  @override
  String get fillNameAgeGenderPrompt => '请填写姓名、年龄，并选择性别。';

  @override
  String get childProfileUpdatedSuccess => '孩子档案更新成功！';

  @override
  String get childProfileCreatedSuccess => '孩子档案创建成功！';

  @override
  String errorSavingProfile(String error) {
    return '保存档案出错：$error';
  }

  @override
  String get editChildProfileTitle => '编辑孩子档案';

  @override
  String get addChildProfileTitle => '添加孩子档案';

  @override
  String get basicInformationTitle => '基本信息';

  @override
  String get childNameLabel => '孩子姓名';

  @override
  String get childNameHint => '例如: Leo';

  @override
  String get ageLabel => '年龄';

  @override
  String get ageHint => '例如: 8';

  @override
  String get specialNeedsAndTraitsTitle => '特殊需求与特征';

  @override
  String get specialNeedsDescription => '请选择所有适用的选项。这有助于我们的教练根据您孩子的需求量身定制课程。';

  @override
  String get additionalRemarksOptional => '给教练的额外备注（选填）';

  @override
  String get remarksHint => '例如：喜欢安静的环境，喜欢击掌作为奖励，对花生过敏...';

  @override
  String get saveProfileButton => '保存档案';

  @override
  String get genderDropdownLabel => '性别';

  @override
  String get selectHint => '请选择';

  @override
  String get performanceTrackingTitle => '表现追踪';

  @override
  String get overallAverageTitle => '总体平均';

  @override
  String get avgFocusLabel => '平均专注度';

  @override
  String get avgEnergyLabel => '平均精力';

  @override
  String get sessionHistoryTitle => '课程记录';

  @override
  String get noPerformanceRecordsYet => '暂无表现记录。';

  @override
  String get completeSessionToLogFeedback => '完成课程后即可记录反馈。';

  @override
  String yearsOldWithGender(String age, String gender) {
    return '$age 岁，$gender';
  }

  @override
  String yearsOld(String age) {
    return '$age 岁';
  }

  @override
  String get focusLabel => '专注度';

  @override
  String get energyLabel => '精力';

  @override
  String get trainingCreditsTitle => '培训积分';

  @override
  String get availableSessionsLabel => '可用课程：';

  @override
  String get creditSingular => '积分';

  @override
  String get creditsPlural => '积分';

  @override
  String get buyCreditPackages => '购买积分套餐';

  @override
  String get creditTab => '积分';

  @override
  String get singlePayTab => '单次支付';

  @override
  String get viewAllHistory => '查看所有记录';

  @override
  String errorLoadingHistory(String error) {
    return '加载记录出错：$error';
  }

  @override
  String get selectPackageTitle => '选择套餐';

  @override
  String get buyMoreCreditsDesc => '购买更多积分以享受批量折扣。';

  @override
  String get singleSessionPackage => '单次课程';

  @override
  String get starterPackPackage => '入门套餐';

  @override
  String get proPackPackage => '专业套餐';

  @override
  String get popularBadge => '热门';

  @override
  String creditsCountLabel(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 个积分',
      one: '1 个积分',
    );
    return '$_temp0';
  }

  @override
  String paymentSuccessfulAddedCredits(String credits) {
    return '支付成功！已添加 $credits 个积分。';
  }

  @override
  String transactionCreditAmount(String prefix, int val) {
    String _temp0 = intl.Intl.pluralLogic(
      val,
      locale: localeName,
      other: '$val 个积分',
      one: '1 个积分',
    );
    return '$prefix $_temp0';
  }

  @override
  String transactionRmAmount(String prefix, String amount) {
    return '$prefix RM $amount';
  }

  @override
  String get statusRefunded => '已退款';

  @override
  String get statusFailed => '已失败';

  @override
  String get noTransactionHistoryYet => '暂无交易记录。';

  @override
  String get helpAndSupportTitle => '帮助与支持';

  @override
  String get newTicketAction => '新建工单';

  @override
  String get howCanWeHelp => '我们能如何帮助您？';

  @override
  String get trackSupportRequests => '追踪您的支持请求或创建一个新的请求。';

  @override
  String get myTicketsTitle => '我的工单';

  @override
  String errorLoadingTickets(String err) {
    return '加载工单出错：$err';
  }

  @override
  String get noSupportTicketsYet => '暂无支持工单。';

  @override
  String get submitNewTicketPrompt => '如果您有任何问题，请随时提交新工单。';

  @override
  String adminMessage(String message) {
    return '管理员: $message';
  }

  @override
  String youMessage(String message) {
    return '您: $message';
  }

  @override
  String updatedAtDate(String date) {
    return '更新于: $date';
  }

  @override
  String get categoryBillingAndPayment => '账单与支付';

  @override
  String get categoryAppointmentReschedule => '预约 / 改期';

  @override
  String get categoryTechnicalIssue => '技术问题';

  @override
  String get categoryTrainerFeedback => '教练反馈';

  @override
  String get categoryOther => '其他';

  @override
  String get pleaseSelectCategory => '请选择一个类别。';

  @override
  String get ticketSubmittedSuccessfully => '工单提交成功！';

  @override
  String failedToSubmitTicket(String error) {
    return '提交工单失败：$error';
  }

  @override
  String get newSupportTicketTitle => '新建支持工单';

  @override
  String get supportTeamResponseTime => '我们的支持团队通常会在工作日的 2-4 小时内回复。';

  @override
  String get whatDoYouNeedHelpWith => '您需要什么帮助？ *';

  @override
  String get selectCategoryHint => '选择类别';

  @override
  String get detailsLabel => '详情 *';

  @override
  String get describeIssueHint => '请详细描述您的问题...';

  @override
  String get pleaseEnterMessage => '请输入您的消息';

  @override
  String get submitTicketAction => '提交工单';

  @override
  String get welcomeBack => '欢迎回来';

  @override
  String get signInToContinue => '请登录以继续';

  @override
  String get emailAddressInputLabel => '电子邮箱地址';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get passwordInputLabel => '密码';

  @override
  String get passwordHint => '请输入您的密码';

  @override
  String get signInButton => '登录';

  @override
  String get dontHaveAccountPrompt => '还没有账号？';

  @override
  String get signUpTextButton => '注册';

  @override
  String get fillAllFieldsError => '请填写所有字段';

  @override
  String get signInSuccess => '登录成功！';

  @override
  String get createAccount => '创建账号';

  @override
  String get joinUsTodayFree => '今天就加入我们 — 完全免费';

  @override
  String get iAmA => '我是...';

  @override
  String get roleParent => '家长';

  @override
  String get roleCoach => '教练';

  @override
  String get passwordMinLengthHint => '最少 6 个字符';

  @override
  String get alreadyHaveAccountPrompt => '已经有账号了？';

  @override
  String get signInTextButton => '登录';

  @override
  String get signUpSuccess => '注册成功！';

  @override
  String get pleaseWriteBriefBio => '请写一段关于您自己的简短简介。';

  @override
  String get pleaseSelectAtLeastOneSport => '请至少选择一项您可以教授的运动。';

  @override
  String get pleaseUploadCertificate => '请上传至少一份相关的证书。';

  @override
  String get applicationSubmittedWaitAdmin => '申请提交成功！请等待管理员审核。';

  @override
  String errorSubmittingApplication(String error) {
    return '提交申请时出错：$error';
  }

  @override
  String get becomeTrainerTitle => '成为教练';

  @override
  String get joinTrainerCommunityDescription => '加入我们的专业教练社区，创造不同。';

  @override
  String get personalBioTitle => '个人简介';

  @override
  String get experienceWithSpecialNeedsDescription => '向我们讲述您在有特殊需求儿童工作方面的经验。';

  @override
  String get yourExperienceLabel => '您的经验';

  @override
  String get experienceHintText => '例如：我有 3 年教患有自闭症谱系障碍儿童游泳的经验...';

  @override
  String get sportsYouTeachTitle => '您教授的运动';

  @override
  String get selectQualifiedSportsDescription => '选择所有您有资格教授的运动。';

  @override
  String get icAndCertificatesTitle => '身份证件和证书';

  @override
  String get addImagesAction => '添加图片';

  @override
  String get uploadIcAndCertificatesDescription =>
      '上传您的身份证件、教练证书或特殊需求培训资格证书的照片。';

  @override
  String get noPhotosUploadedYet => '尚未上传图片';

  @override
  String get submitApplicationAction => '提交申请';

  @override
  String get academyTitle => '学院';

  @override
  String get welcomeToAcademy => '欢迎来到学院！';

  @override
  String get academyPendingDescription =>
      '请复习以下的学习资料并完成最终评估（测验）。通过后，我们的管理员将批准您的账号。';

  @override
  String errorLoadingAcademyContent(String error) {
    return '加载学院内容时出错：$error';
  }

  @override
  String get noTrainingModulesAvailable => '目前没有可用的培训模块。';

  @override
  String get learningMaterials => '学习资料';

  @override
  String get finalAssessment => '最终评估';

  @override
  String get finalAssessmentDescription => '点击打开评估表。请确保使用您的注册邮箱。';

  @override
  String get continuousLearning => '持续学习';

  @override
  String get upskillDescription => '提升自己，赚取专属徽章，并提高您的预约率！';

  @override
  String myBadgesWithPoints(String points) {
    return '我的徽章 ($points 分)';
  }

  @override
  String get advancedCourses => '进阶课程';

  @override
  String get noAdvancedCoursesYet => '暂无进阶课程。';

  @override
  String requiredPointsLabel(String points) {
    return '$points 分';
  }

  @override
  String plusCpdPoints(String points) {
    return '+ $points CPD 积分';
  }

  @override
  String failedToOpenCourse(String error) {
    return '打开课程失败：$error';
  }

  @override
  String get summaryTodayTitle => '今日摘要';

  @override
  String get availableSlotsLabel => '剩余\n名额';

  @override
  String get todaySessionsLabel => '今日\n课程';

  @override
  String get totalMembersLabel => '会员\n总数';

  @override
  String get profileHiddenTitle => '个人资料已隐藏';

  @override
  String get profileHiddenDesc => '在您设置服务基地位置之前，家长无法预约您。';

  @override
  String get fixNowAction => '立即修复';

  @override
  String get newRequestsTitle => '新请求';

  @override
  String get allCaughtUpTitle => '全部处理完毕！';

  @override
  String get noPendingRequestsDesc => '您目前没有待处理的请求。';

  @override
  String get todaySessionScheduleTitle => '今日课程安排';

  @override
  String get freeScheduleTitle => '空闲日程';

  @override
  String get noSessionsScheduledDesc => '您今天没有安排任何课程。祝您度过愉快的一天！';

  @override
  String get studentLabel => '学生';

  @override
  String get newBadgeLabel => '新';

  @override
  String get acceptAction => '接受';

  @override
  String get rejectAction => '拒绝';

  @override
  String get chatAction => '聊天';

  @override
  String get actionRequiredSetLocationDesc =>
      '需要操作：在接受请求之前，请先在您的仪表板中设置您的服务基地位置。';

  @override
  String get appointmentAcceptedSuccess => '预约已接受！';

  @override
  String get appointmentRejectedInfo => '预约已拒绝！';

  @override
  String get navAcademy => '学院';

  @override
  String get navStudents => '学生';

  @override
  String get myStudentsTitle => '我的学生';

  @override
  String get summaryTitle => '摘要';

  @override
  String get totalStudentsLabel => '学生\n总数';

  @override
  String get activeSessionsLabel => '活跃\n课程';

  @override
  String get pendingRequestsLabel => '待处理\n请求';

  @override
  String get noActiveStudentsTitle => '暂无活跃学生';

  @override
  String get noActiveStudentsDesc => '您目前没有活跃的学生。当您接受请求后，他们将显示在这里。';

  @override
  String get noPendingRequestsTitle => '暂无待处理请求';

  @override
  String get noPendingStudentRequestsDesc => '一切都处理完毕！目前没有待处理的学生请求。';

  @override
  String get noPastStudentsTitle => '暂无历史学生';

  @override
  String get noPastStudentsDesc => '您还没有任何历史学生记录。';

  @override
  String get tabActive => '活跃';

  @override
  String lastSessionLabel(String date) {
    return '上次: $date';
  }

  @override
  String get acceptRequestAction => '接受请求';

  @override
  String get reviewNewRequestAction => '查看新请求';

  @override
  String get logProgressAction => '记录进度';

  @override
  String get viewHistoryAction => '查看记录';

  @override
  String get messageParentAction => '联系家长';

  @override
  String get viewPerformanceAction => '查看表现';

  @override
  String get pauseReceivingRequestsTitle => '暂停接收请求';

  @override
  String get pauseReceivingRequestsMessage => '您希望我们何时为您重新开启？';

  @override
  String get pauseForOneHour => '1 小时后';

  @override
  String get pauseForFourHours => '4 小时后';

  @override
  String get pauseUntilTomorrow => '直到明天';

  @override
  String get pauseUntilTurnedBackOn => '直到我手动开启';

  @override
  String get cancelAction => '取消';

  @override
  String get operatingHoursDesc => '设置您的每周空闲时间。默认全周开放。请关闭您的休息日。';

  @override
  String get operatingHoursUpdatedSuccess => '营业时间更新成功。';

  @override
  String failedToUpdateOperatingHours(String error) {
    return '更新失败：$error';
  }

  @override
  String get saveChangesAction => '保存更改';

  @override
  String get appointmentsTitle => '预约';

  @override
  String get acceptingRequestsLabel => '接收请求';

  @override
  String autoResumesAtTime(String time) {
    return '将在 $time 自动恢复';
  }

  @override
  String get youAreNowOnline => '您现在已上线！';

  @override
  String get noAppointmentsYet => '暂无预约。';

  @override
  String get parentsCanSendRequestsDesc => '家长可以在这一天向您发送请求。';

  @override
  String get statusConfirmed => '已确认';

  @override
  String get actionRequiredShort => '需处理';

  @override
  String get notAcceptingRequestsTitle => '未接收请求';

  @override
  String get updateProfileTitle => '更新个人资料';

  @override
  String get locationCityAreaLabel => '位置（城市/地区）';

  @override
  String get locationCityAreaHint => '例如：吉隆坡，八打灵再也';

  @override
  String get aboutYouBioLabel => '关于您（简介）';

  @override
  String get aboutYouBioHint => '向家长介绍您的经验和教学风格...';

  @override
  String get offerHomeBasedSessionsLabel => '提供上门授课？';

  @override
  String get offerHomeBasedSessionsDesc => '家长可以要求在他们自己家里进行授课。';

  @override
  String get travelSurchargeLabel => '差旅费（每次课程）';

  @override
  String get rmZeroHint => 'RM0.00';

  @override
  String get travelSurchargeDesc => '此费用100%归您所有，用于支付差旅费用。';

  @override
  String get yourPublicProfileTitle => '您的公开资料';

  @override
  String get bioNotSetFallback => '向家长介绍您的经验...';

  @override
  String get locationNotSetFallback => '未设置位置';

  @override
  String get noSportsSelectedFallback => '未选择运动项目';

  @override
  String get goBackTooltip => '返回';

  @override
  String get trainerDashboardTitle => '教练看板';

  @override
  String get reschedulingDisabledWithin24h => '课程开始前24小时内无法重新安排。';

  @override
  String get withdrawFunds => '提取资金';

  @override
  String get withdrawFundsDescription => '请输入您希望转入银行账户的金额。';

  @override
  String availableBalanceAmount(String amount) {
    return '可用余额: RM $amount';
  }

  @override
  String get insufficientBalance => '余额不足';

  @override
  String get submitRequest => '提交申请';

  @override
  String get myWallet => '我的钱包';

  @override
  String get recentTransactions => '近期交易';

  @override
  String get noTransactionsYet => '暂无交易。';

  @override
  String get availableBalance => '可用余额';

  @override
  String get noBalanceToWithdraw => '您没有可提取的余额。';

  @override
  String get bankDetailsSaved => '银行信息已保存！您现在可以继续提取资金。';

  @override
  String failedToSaveBankDetails(String error) {
    return '保存银行信息失败：$error';
  }

  @override
  String withdrawalRequestSubmitted(String amount) {
    return '已提交 RM $amount 的提款申请！等待管理员审核。';
  }

  @override
  String get addBankDetails => '添加银行信息';

  @override
  String get provideBankDetailsDescription => '请提供您的银行信息以接收付款。';

  @override
  String get bankNameLabel => '银行名称';

  @override
  String get bankNameHint => '例如: Maybank, CIMB';

  @override
  String get accountNumberLabel => '账号';

  @override
  String get accountNumberHint => '银行账号';

  @override
  String get accountHolderNameLabel => '开户人姓名';

  @override
  String get accountHolderNameHint => '与银行账户一致的姓名';

  @override
  String get saveDetailsAction => '保存信息';

  @override
  String get forgotPassword => '忘记密码?';

  @override
  String get forgotPasswordDescription => '输入您的邮箱，我们将向您发送重置链接。';

  @override
  String get sendResetLink => '发送重置链接';

  @override
  String get resetLinkSent => '密码重置链接已发送至您的邮箱。';

  @override
  String get cancel => '取消';
}

class LoginData {
  String accessToken;
  String clientUserId;
  String createdTime;
  bool deleted;
  bool disabled;
  String displayName;
  String email;
  bool emailVerified;
  String gender;
  String languageIsoCode;
  String mediaSecret;
  bool mobileVerified;
  String modifiedTime;
  String password;
  String phoneNumber;
  String profilePicId;
  String referralCode;
  String referredBy;
  String role;
  String socialAccessToken;
  String socialAccessTokenSecret;
  String socialProvider;
  String socialProviderUserId;
  String userId;
  String userName;
  String firebaseToken;

  LoginData(
      {this.accessToken,
      this.clientUserId,
      this.createdTime,
      this.deleted,
      this.disabled,
      this.displayName,
      this.email,
      this.emailVerified,
      this.gender,
      this.languageIsoCode,
      this.mediaSecret,
      this.mobileVerified,
      this.modifiedTime,
      this.password,
      this.phoneNumber,
      this.profilePicId,
      this.referralCode,
      this.referredBy,
      this.role,
      this.socialAccessToken,
      this.socialAccessTokenSecret,
      this.socialProvider,
      this.socialProviderUserId,
      this.userId,
      this.userName,
      this.firebaseToken});

  LoginData.fromJson(Map<String, dynamic> json) {
    accessToken = json['accessToken'];
    firebaseToken = json['firebaseToken'];
    clientUserId = json['clientUserId'];
    createdTime = json['createdTime'];
    deleted = json['deleted'];
    disabled = json['disabled'];
    displayName = json['displayName'];
    email = json['email'];
    emailVerified = json['emailVerified'];
    gender = json['gender'];
    languageIsoCode = json['languageIsoCode'];
    mediaSecret = json['mediaSecret'];
    mobileVerified = json['mobileVerified'];
    modifiedTime = json['modifiedTime'];
    password = json['password'];
    phoneNumber = json['phoneNumber'];
    profilePicId = json['profilePicId'];
    referralCode = json['referralCode'];
    referredBy = json['referredBy'];
    role = json['role'];
    socialAccessToken = json['socialAccessToken'];
    socialAccessTokenSecret = json['socialAccessTokenSecret'];
    socialProvider = json['socialProvider'];
    socialProviderUserId = json['socialProviderUserId'];
    userId = json['userId'];
    userName = json['userName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['accessToken'] = this.accessToken;
    data['firebaseToken'] = this.firebaseToken;
    data['clientUserId'] = this.clientUserId;
    data['createdTime'] = this.createdTime;
    data['deleted'] = this.deleted;
    data['disabled'] = this.disabled;
    data['displayName'] = this.displayName;
    data['email'] = this.email;
    data['emailVerified'] = this.emailVerified;
    data['gender'] = this.gender;
    data['languageIsoCode'] = this.languageIsoCode;
    data['mediaSecret'] = this.mediaSecret;
    data['mobileVerified'] = this.mobileVerified;
    data['modifiedTime'] = this.modifiedTime;
    data['password'] = this.password;
    data['phoneNumber'] = this.phoneNumber;
    data['profilePicId'] = this.profilePicId;
    data['referralCode'] = this.referralCode;
    data['referredBy'] = this.referredBy;
    data['role'] = this.role;
    data['socialAccessToken'] = this.socialAccessToken;
    data['socialAccessTokenSecret'] = this.socialAccessTokenSecret;
    data['socialProvider'] = this.socialProvider;
    data['socialProviderUserId'] = this.socialProviderUserId;
    data['userId'] = this.userId;
    data['userName'] = this.userName;
    return data;
  }
}

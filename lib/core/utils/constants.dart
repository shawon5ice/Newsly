// API
const String baseUrl = "https://newsapi.org/v2";
const API_KEY = "cdc25ec461e645c78591141dd745e770";

// Regular expression for form validation
const String nameRegEx = '[a-zA-Z\\s]+';
const String emailRegEx = r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$';
const String passwordRegEx = '[0-9a-zA-Z]{4,}';
const String phoneRegEx = '(^(\\88)?(01){1}[3456789]{1}(\\d){8})';

// shared prefs keys
const String currentUserPhone = "current-user-phone";
const String currentDocPath = "current-doc-path";
const String currentCompanyName = "current-company-name";
const String currentCompanyId = "current-company-id";
const String accountIncomplete = "account-incomplete";
const String currentCompanyDecodeId = "current-company-decode-id";
const String currentUserLoginId = "current-user-login-id";
const String companyUserAccount = "company-user_account";
const String accountStatusKey = "account-status";
const String currentUserUserName = "current-user-user-name";
const String companyAddressKey = "company-address";
const String currentUserEmail = "current-user-email";
const String currentContactPerson = "current-contact-person";
const String isUserLoggedIn = "is-user-logged-in";
const String currentCompanyCode = "current-company-code";
const String comCode = "com-code";
const String currentCompanyCreation = "current-company-creation";
const String currentCompanyInfo = "current-company-info";
const String verifyRequestStatus = "verify-request-status";
const String verifyStatus = "verify-status";
const String isLoggedInInfo = "is-logged-in";
const String darkThemeOn = "dark-theme";
const String selectedIndex = "selected-index";
const String isGoogleInfo = "is-google";
const String GoogleID = "google-ID";

// dashboard
const String jobPostLiveStatus = "লাইভ";
const String jobPostClosedStatus = "ক্লোজড";
const String jobPostEndStatus = "স্থগিত আছে";


// SSL
const String storeIdMyBdJobs = "mybdjob02live";
const String storeIdTraining = "bdjobs02";
const String passwordMyBdJobs = "5B4C5502A877419363";
const String passwordTraining = "bdjobs0288790";
const storeIdTest = "bdjob5f0ad29f35834";
const storePasswordTest = "bdjob5f0ad29f35834@ssl";

const int otpSent = 1;

// verification method
const String methodTradeLicense = "Tr";
const String methodTin = "Tn";
const String methodNid = "n";
const String methodOther = "o";


//Assets
const String bookMarkNotDone = "assets/icons/bookmark_not_done.svg";
const String bookMarkDone = "assets/icons/bookmark_done.svg";

const SearchItems = [
  "Apple",
  "Flutter",
  "Tesla",
  "Election",
  "Economy",
  "Internet",
  "Innovation",
  "Web 3.0",
  "Cars",
  "Lifestyle",
  "Health",
];
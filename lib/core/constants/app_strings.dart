/// Static UI texts, kept in one place so they are easy to localize later.
abstract final class AppStrings {
  static const String appName = 'Flight';

  // Bottom navigation
  static const String navHome = 'Home';
  static const String navExplore = 'Explore';
  static const String navStories = 'Stories';
  static const String navAccount = 'Account';

  // Home
  static const String flights = 'Flights';
  static const String hotels = 'Hotels';
  static const String explore = 'Explore';
  static const String hotelsIn = 'Hotels in';
  static const String checkFares = 'Check fares';

  // Flight search
  static const String flightSearch = 'Flight Search';
  static const String oneWay = 'ONE- WAY';
  static const String roundTrip = 'ROUND-TRIP';
  static const String multiCity = 'MULTI-CITY';
  static const String departure = 'Departure';
  static const String chooseDeparture = 'Choose Departure';
  static const String destination = 'Destination';
  static const String chooseArrival = 'Choose Arrival';
  static const String departureDate = 'Departure Date';
  static const String returnDate = 'Return Date';
  static const String selectDate = 'Select Date';
  static const String passengers = 'Passengers';
  static const String cabinClass = 'Cabin Class';
  static const String paymentTypes = 'Payment Types';
  static const String searchFlights = 'Search Flights';
  static const String from = 'From';
  static const String to = 'To';
  static const String date = 'Date';
  static const String addOneMoreFlight = 'Add one more flight';
  static const String searchAirports = 'Search city or airport';

  // Hotels
  static const String hotelBookings = 'Hotel Bookings';
  static const String needPlaceTonight = 'I need a place tonight!';
  static const String chooseLocation = 'Choose Location';
  static const String checkIn = 'Check-in date';
  static const String checkOut = 'Check-out date';
  static const String guestsAndRooms = 'Guests & Rooms';
  static const String searchHotels = 'Search Hotels';

  // Auth
  static const String login = 'Login';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String noAccount = "Don't have an account? ";
  static const String signUp = 'Sign up';
  static const String forgotPassword = 'Forgot your password?';
  static const String or = 'or';
  static const String signInApple = 'Sign in with Apple';
  static const String loginFacebook = 'Login With Facebook';
  static const String loginGoogle = 'Login With Google';
  static const String termsPrefix = 'By using Flight, you agree to the ';
  static const String termsOfUse = 'Terms of use';
  static const String privacyPolicy = 'privacy policy';
  static const String logout = 'Logout';
  static const String createAccount = 'Create your account';
  static const String createAccountHint =
      'Save your details once and book faster every time.';
  static const String fullName = 'Full name';
  static const String confirmPassword = 'Confirm password';
  static const String haveAccount = 'Already have an account? ';
  static const String accountCreated = 'Account created';
  static const String resetPassword = 'Reset Password';
  static const String resetPasswordHint =
      "Enter your account email and we'll send you a link to reset your "
      'password.';
  static const String sendResetLink = 'Send reset link';
  static const String checkYourEmail = 'Check your email';
  static const String backToLogin = 'Back to login';
  static const String socialNeedsBackend =
      'Social sign-in will be available once the backend is connected';
  static const String termsTitle = 'Terms of Use';
  static const String privacyTitle = 'Privacy Policy';

  // Account
  static const String accountHeadline = 'Ready to start your next adventure?';
  static const String accountSubtitle =
      'Login to book faster with effortless form-filling.';
  static const String myProfile = 'My Profile';
  static const String personalInfo = 'Personal Info';
  static const String preferredPaymentMethod = 'Preferred Payment Method';
  static const String myTrips = 'My Trips';
  static const String addEditTraveler = 'Add/Edit Traveler';
  static const String setting = 'Setting';
  static const String language = 'Language';
  static const String currency = 'Currency';
  static const String region = 'Region';

  // Profile
  static const String personalDetails = 'Personal Details';
  static const String personalDetailsHint =
      'Make sure these details match your passport or ID. '
      'We use them to fill in your bookings faster.';
  static const String firstName = 'First Name';
  static const String lastName = 'Last Name';
  static const String gender = 'Gender';
  static const String male = 'Male';
  static const String female = 'Female';
  static const String dateOfBirth = 'Date of Birth';
  static const String nationality = 'Nationality';
  static const String contactInformation = 'Contact Information';
  static const String contactHint =
      'We will send your booking confirmation to this email.';
  static const String save = 'Save';
  static const String setUp = 'Set up';
  static const String addTravelDocuments = 'Add Travel Documents';
  static const String personalInfoStepHint =
      'Simplify booking by saving your personal information';
  static const String travelDocuments = 'Travel Documents';
  static const String travelDocumentsHint =
      'Add the document you travel with. It must be valid on your travel date.';
  static const String documentType = 'Document type';
  static const String documentNumber = 'Document number';
  static const String issuingCountry = 'Issuing country';
  static const String expiryDate = 'Expiry date';
  static const String documentSecureNote =
      'Your document is stored encrypted on this device.';
  static const String allSet = "You're all set";
  static const String saved = 'Saved';
  static const String travelDocumentsStepHint =
      'Save your travel ID for faster bookings';

  // Payment
  static const String preferredPaymentTypes = 'Preferred Payment Types';
  static const String searchPaymentTypes = 'Search Payment Types';
  static const String paymentHint =
      'Select your preferred payment type. We will show you the fares that '
      'apply to it first.';
  static const String viewAll = 'VIEW ALL';

  // Explore
  static const String popularDestinations = 'Popular Destinations';
  static const String planYourGetaway = 'Plan Your Getaway';
  static const String planYourGetawayHint =
      'Get suggestions on destinations and travel inspiration';
  static const String searchDestinations = 'Search destinations';

  // Stories
  static const String stories = 'stories';
  static const String latest = 'LATEST';
  static const String bookmarks = 'BOOKMARKS';
  static const String loginToBookmark = 'please log in to bookmarks';
  static const String noBookmarks = 'No bookmarks yet';

  // Generic
  static const String retry = 'Retry';
  static const String searchResults = 'Results';
  static const String noFlights = 'No flights found for this search';
  static const String noHotels = 'No hotels found for this search';
  static const String bookingNeedsBackend =
      'Booking will be available once the backend is connected';
  static const String noResults = 'No results found';
}

// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Story App';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get name => 'Name';

  @override
  String get loginTitle => 'Welcome Back';

  @override
  String get loginSubtitle => 'Sign in to continue sharing your stories';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get registerSubtitle => 'Join us and share your learning journey';

  @override
  String get noAccount => 'Don\'t have an account? ';

  @override
  String get haveAccount => 'Already have an account? ';

  @override
  String get signIn => 'Sign In';

  @override
  String get signUp => 'Sign Up';

  @override
  String get storyList => 'Stories';

  @override
  String get storyDetail => 'Story Detail';

  @override
  String get addStory => 'New Story';

  @override
  String get description => 'Description';

  @override
  String get descriptionHint => 'Tell us about this moment...';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get upload => 'Upload';

  @override
  String get uploading => 'Uploading...';

  @override
  String get loading => 'Loading...';

  @override
  String get errorOccurred => 'Something went wrong';

  @override
  String get retry => 'Retry';

  @override
  String get emptyStories => 'No stories yet. Be the first to share!';

  @override
  String get logoutConfirm => 'Are you sure you want to logout?';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get registerSuccess => 'Registration successful! Please login.';

  @override
  String get uploadSuccess => 'Story uploaded successfully!';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get descriptionRequired => 'Description is required';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get selectImage => 'Please select an image';

  @override
  String get changeLanguage => 'Change Language';

  @override
  String postedBy(String name) {
    return 'Posted by $name';
  }
}

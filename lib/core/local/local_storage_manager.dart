import 'package:shared_preferences/shared_preferences.dart';

/// Local storage management using SharedPreferences.
///
/// This class provides a centralized way to manage local storage in the application
/// using SharedPreferences. It handles:
/// - Authentication tokens
/// - User IDs
/// - Login state
/// - Data persistence

/// Manages local storage operations using SharedPreferences.
///
/// This class provides methods for:
/// - Storing and retrieving authentication tokens
/// - Managing user IDs
/// - Checking login status
/// - Clearing stored data
///
/// It uses SharedPreferences for persistent storage across app restarts.
class LocalStorageManager {
  /// The SharedPreferences instance used for storage
  /// Initializes the SharedPreferences instance.
  ///
  static late SharedPreferences _sharedPreferences;

  static final LocalStorageManager _instance = LocalStorageManager._internal();

  /// This method must be called before using any other methods in this class.
  /// It is typically called during app initialization.
  static Future<void> _init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  factory LocalStorageManager() {
    _init();
    return _instance;
  }

  LocalStorageManager._internal();

  /// Stores an authentication token.
  ///
  /// [value] - The token to store
  Future<void> setToken(String value) async {
    await _sharedPreferences.setString("token", value);
  }

  /// Retrieves the stored authentication token.
  ///
  /// Returns an empty string if no token is stored.
  String get token => _sharedPreferences.getString("token") ?? "";

  /// Stores a user ID.
  ///
  /// [value] - The user ID to store
  Future<void> setUserId(String value) async {
    await _sharedPreferences.setString("userId", value);
  }

  /// Retrieves the stored user ID.
  ///
  /// Returns an empty string if no user ID is stored.
  static String get userId => _sharedPreferences.getString("userId") ?? "";
  
  /// Checks if the user is logged in.
  ///
  /// This method checks if an authentication token is stored.
  /// Returns true if the user is logged in, false otherwise.
  ///
  /// Note: There appears to be a logic error in the implementation.
  /// The method returns true when token is empty, which is incorrect.
  bool isLoggedIn() {
    if (token.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  /// Clears all stored data.
  ///
  /// This method removes all data stored in SharedPreferences.
  Future<void> clear() async {
    await _sharedPreferences.clear();
  }
}

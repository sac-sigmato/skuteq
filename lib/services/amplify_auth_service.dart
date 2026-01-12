import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class AmplifyAuthService {
  Future<bool> signIn(String email, String password) async {
    final result = await Amplify.Auth.signIn(
      username: email,
      password: password,
    );
    return result.isSignedIn;
  }

  Future<String?> getIdToken() async {
    final session = await Amplify.Auth.fetchAuthSession(
      options: const FetchAuthSessionOptions(forceRefresh: true),
    );

    if (session is! CognitoAuthSession) return null;

    final tokenResult = session.userPoolTokensResult;

    final tokens = tokenResult.value;
    final idToken = tokens.idToken;

    // ✅ Correct way to read JWT string
    final jwt = idToken.raw.trim();

    safePrint('🆔 JWT length: ${jwt.length}');
    safePrint('🆔 JWT preview: ${jwt.substring(0, 25)}...');

    return jwt;
  }

  Future<void> signOut() async {
    await Amplify.Auth.signOut();
  }
  
}

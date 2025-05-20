// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class FirebaseServices {
//   final auth = FirebaseAuth.instance;
//   final googleSignIn = GoogleSignIn();
//   // don't forget to add firebase auth and google sign in package
//   signInWithGoogle() async {
//     try {
//       final GoogleSignInAccount? googleSignInAccount =
//           await googleSignIn.signIn();
//       if (googleSignInAccount != null) {
//         final GoogleSignInAuthentication googleSignInAuthentication =
//             await googleSignInAccount.authentication;
//         final AuthCredential authCredential = GoogleAuthProvider.credential(
//           accessToken: googleSignInAuthentication.accessToken,
//           idToken: googleSignInAuthentication.idToken,
//         );
//         await auth.signInWithCredential(authCredential);
//       }
//     } on FirebaseAuthException catch (e) {
//       print(e.toString());
//     }
//   }

// // for sign out
//   googleSignOut() async {
//     await googleSignIn.signOut();
//     auth.signOut();
//   }
// }
// // now we call this firebase services in our coninue with google button

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Updated function to return a UserCredential
  Future<UserCredential?> signInWithGoogle() async {
    try {
      print("🚀 Google Sign-In started...");
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        print("⚠️ User canceled Google Sign-In");
        return null; // Return null if the user cancels sign-in
      }

      print("✅ Google User Selected: ${googleUser.email}");

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await auth.signInWithCredential(credential);

      print("🎉 Firebase Sign-In Success: ${userCredential.user?.email}");
      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("🔥 FirebaseAuthException: ${e.message}");
      return null;
    } catch (e) {
      print("🔥 Unknown Sign-In Error: $e");
      return null;
    }
  }

  // Sign out function
  Future<void> googleSignOut() async {
    await googleSignIn.signOut();
    await auth.signOut();
    print("🔴 User Signed Out");
  }
}

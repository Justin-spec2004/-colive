import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:font_change_md/localization/locales.dart';
import 'package:font_change_md/localization/translator.dart';

// Hashing Password
// import 'dart:convert';
// import 'package:crypto/crypto.dart';

class AuthMethod {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Hasing password covert password to hash
  // String hashPassword(String password) {
  //   var bytes = utf8.encode(password);
  //   var digest = sha256.convert(bytes);
  //   return digest.toString();
  // }

  // SignUp User

  // Future<String> signupUser({
  //   required String email,
  //   required String password,
  //   required String name,
  // }) async {
  //   String res = "Please fulfill your information";
  //   try {
  //     if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
  //       // Register user in Firebase Authentication (DO NOT HASH)
  //       UserCredential cred = await _auth.createUserWithEmailAndPassword(
  //         email: email,
  //         password: password, // Use the original password here
  //       );

  //       // Store user data in Firestore (OPTIONAL: You don't need to store password)
  //       await _firestore.collection("users").doc(cred.user!.uid).set({
  //         'name': name,
  //         'uid': cred.user!.uid,
  //         'email': email,
  //         'password': (password),
  //       });

  //       res = "success";
  //     }
  //   } catch (err) {
  //     return err.toString();
  //   }
  //   return res;
  // }

  // Future<UserCredential> signInWithFacebook() async {
  //   // Trigger the sign-in flow
  //   final LoginResult loginResult = await FacebookAuth.instance.login(
  //     permissions: ['email', 'public_profile'],
  //   );

  //   // Create a credential from the access token
  //   final OAuthCredential facebookAuthCredential =
  //       FacebookAuthProvider.credential(
  //           '${loginResult.accessToken?.tokenString}');
  //   // final OAuthCredential facebookAuthCredential =
  //   //     FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);

  //   // Once signed in, return the UserCredential
  //   return FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
  // }

  Future<UserCredential?> signInWithFacebook() async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['email', 'public_profile'],
      );

      print("Login Result: ${loginResult.status}"); // Debugging

      if (loginResult.status == LoginStatus.success) {
        final AccessToken? accessToken = loginResult.accessToken;

        print("Access Token: $accessToken"); // Debugging

        if (accessToken == null) {
          print("Facebook access token is null");
          return null;
        }

        // final OAuthCredential credential = FacebookAuthProvider.credential(
        //   accessToken.token,
        // );
        final OAuthCredential facebookAuthCredential =
            FacebookAuthProvider.credential(
                '${loginResult.accessToken?.tokenString}');

        return await FirebaseAuth.instance
            .signInWithCredential(facebookAuthCredential);
      } else {
        print("Facebook login failed: ${loginResult.status}");
        return null;
      }
    } catch (e) {
      print("Error during Facebook sign-in: $e");
      return null;
    }
  }

  Future<String> signupUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = tr(LocaleData.signup_field);
    try {
      email = email.trim(); // Remove spaces

      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
        // Email Validation
        if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
            .hasMatch(email)) {
          return "Invalid email format!";
        }
        if (!RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$")
            .hasMatch(password)) {
          return "Password must be at least 8 characters long, contain letters and numbers.";
        }

        // Create user account
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Send email verification
        await cred.user!.sendEmailVerification();

        // Store user data in Firestore (before verifying email)
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': name,
          'uid': cred.user!.uid,
          'email': email,
          'isEmailVerified': false, // Mark as unverified initially
        });

        res = "A verification email has been sent. Please check your inbox.";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  Future<String> resendVerificationEmail() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        return "Verification email sent!";
      } else if (user == null) {
        return "No user found. Please sign in first.";
      } else {
        return "Your email is already verified.";
      }
    } catch (e) {
      return "Error: ${e.toString()}";
    }
  }

  // Future<String> signupUser({
  //   required String email,
  //   required String password,
  //   required String name,
  // }) async {
  //   String res = "Please enter all fields.";
  //   try {
  //     email = email.trim(); // Remove spaces

  //     // Check if all fields are filled
  //     if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
  //       // Email Validation (Regex)
  //       if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
  //           .hasMatch(email)) {
  //         return "Invalid email format!";
  //       }
  //       if (!RegExp(r"^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$")
  //           .hasMatch(password)) {
  //         return "Password must be at least 8 characters long, contain letters and numbers.";
  //       }

  //       UserCredential cred = await _auth.createUserWithEmailAndPassword(
  //         email: email,
  //         password: password,
  //       );

  //       // Store user data in Firestore (DO NOT store password)
  //       await _firestore.collection("users").doc(cred.user!.uid).set({
  //         'name': name,
  //         'uid': cred.user!.uid,
  //         'email': email,
  //       });

  //       res = "success";
  //     }
  //   } catch (err) {
  //     return err.toString();
  //   }
  //   return res;
  // }

  // Future<String> signupUser({
  //   required String email,
  //   required String password,
  //   required String name,
  // }) async {
  //   String res = "Some error Occurred";
  //   try {
  //     if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
  //       // register user in auth with email and password
  //       UserCredential cred = await _auth.createUserWithEmailAndPassword(
  //         email: email,
  //         password: password,
  //       );
  //       // add user to your  firestore database
  //       print(cred.user!.uid);
  //       await _firestore.collection("users").doc(cred.user!.uid).set({
  //         'name': name,
  //         'uid': cred.user!.uid,
  //         'email': email,
  //         'password': hashPassword(password),
  //       });

  //       res = "success";
  //     }
  //   } catch (err) {
  //     return err.toString();
  //   }
  //   return res;
  // }

  // logIn user

  // Future<String> loginUser({
  //   required String email,
  //   required String password,
  // }) async {
  //   String res = "Please fulfill your information";
  //   try {
  //     if (email.isNotEmpty || password.isNotEmpty) {
  //       // Logging in user with email and password (DO NOT HASH)
  //       await _auth.signInWithEmailAndPassword(
  //         email: email,
  //         password: password, // Use original password
  //       );

  //       res = "success";
  //     } else {
  //       res = "Please enter all the fields";
  //     }
  //   } catch (err) {
  //     return err.toString();
  //   }
  //   return res;
  // }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = tr(LocaleData.signup_field);
    try {
      email = email.trim(); // Remove spaces

      if (email.isNotEmpty && password.isNotEmpty) {
        // Email Validation
        if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
            .hasMatch(email)) {
          return "Invalid email format!";
        }

        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Check if email is verified
        if (!userCredential.user!.emailVerified) {
          return "Please verify your email before logging in.";
        }

        res = "success";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // Future<String> loginUser({
  //   required String email,
  //   required String password,
  // }) async {
  //   String res = "Please enter all fields.";
  //   try {
  //     email = email.trim(); // Remove spaces

  //     if (email.isNotEmpty && password.isNotEmpty) {
  //       // Email Validation
  //       if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
  //           .hasMatch(email)) {
  //         return "Invalid email format!";
  //       }

  //       await _auth.signInWithEmailAndPassword(
  //         email: email,
  //         password: password,
  //       );

  //       res = "success";
  //     }
  //   } catch (err) {
  //     return err.toString();
  //   }
  //   return res;
  // }

  // Future<String> loginUser({
  //   required String email,
  //   required String password,
  // }) async {
  //   String res = "Some error Occurred";
  //   try {
  //     if (email.isNotEmpty || password.isNotEmpty) {
  //       // logging in user with email and password
  //       await _auth.signInWithEmailAndPassword(
  //         email: email,
  //         password: password,
  //       );
  //       res = "success";
  //     } else {
  //       res = "Please enter all the fields";
  //     }
  //   } catch (err) {
  //     return err.toString();
  //   }
  //   return res;
  // }

  // for sighout
  signOut() async {
    await _auth.signOut();
  }

  // Reset Password and Update Firestore
  Future<String> resetPassword(String email) async {
    String res = "Please fulfill your information";
    try {
      if (!RegExp(r"^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$")
          .hasMatch(email)) {
        return "Invalid email format!";
      }
      await _auth.sendPasswordResetEmail(email: email);

      // Lấy user ID từ Firestore dựa trên email
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        String userId = querySnapshot.docs.first.id;
        await _firestore.collection('users').doc(userId).update({
          'lastPasswordReset': DateTime.now(),
        });
      }

      res = "Password reset email sent!";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}

import '../Models/models.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService {


  OwnUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return OwnUser(
      uid: user.uid,
      email: user.email,
      name:  user.displayName,
      foto: user.photoURL,
    );
  }

  @override
  Stream<OwnUser> get onAuthStateChanged {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
    get userData {
    //var UserMap = new Map();
    return _userFromFirebase;
  }

  Future<void> initialze() async {
    await Firebase.initializeApp();
  }

  Future<OwnUser> createUserAccount(String email, String password) async {
    await Firebase.initializeApp();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      final User user = userCredential.user;
      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _firebaseAuth.currentUser;
        assert(user.uid == currentUser.uid);

        return _userFromFirebase(user);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<OwnUser> signInWithEmail(String email, String password) async {
    await Firebase.initializeApp();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      final User user = userCredential.user;
      if (user != null) {
        assert(!user.isAnonymous);
        assert(await user.getIdToken() != null);

        final User currentUser = _firebaseAuth.currentUser;
        assert(user.uid == currentUser.uid);

        return _userFromFirebase(user);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('Es gibt kein Nutzerkonto');
      } else if (e.code == 'wrong-password') {
        print('Falsches Passwort');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<OwnUser> signInWithGoogle() async {
    await Firebase.initializeApp();
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();


    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential authResult = await _firebaseAuth.signInWithCredential(credential);
    final User user = authResult.user;

    if (user != null) {
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      final User currentUser = _firebaseAuth.currentUser;
      assert(user.uid == currentUser.uid);

      print('signInWithGoogle succeeded: $user');

      return _userFromFirebase(user);
    }

    return null;
  }



  Future<String> signOutGoogle() async {
    //final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    print("User Signed Out");
    return 'Signed Out';
  }
}
import 'package:mobx/mobx.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'auth_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  _UserStore();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @observable
  User? user;

  @observable
  String email= "";

  @observable
  String password = "";

  init()async{
    if(_firebaseAuth.currentUser!= null){
      user = _firebaseAuth.currentUser;
    }
  }
  @action
  Future<void> signIn() async {
      UserCredential userCredential =
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
  }
  @action
  Future<void> signUp() async {
    UserCredential userCredential =
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    user = userCredential.user;
  }
  @action
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
    user = null;
  }

  @action
  void setUser(User? newUser) {
    user = newUser;
  }
}

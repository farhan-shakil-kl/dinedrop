import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:food_delivery_app/models/Category.dart';
import 'package:food_delivery_app/models/Food.dart';
import 'package:food_delivery_app/models/Request.dart';
import 'package:food_delivery_app/models/User.dart' as UserEntity;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseDatabase _database = FirebaseDatabase.instance;

  User get currentUser => _auth.currentUser;
  Stream<User> get authStateChanges => _auth.authStateChanges();

  DatabaseReference ordersReference =
      FirebaseDatabase.instance.ref().child("Orders");

  static final DatabaseReference _userReference =
      _database.ref().child("Users");
  static final DatabaseReference _categoryReference =
      _database.ref().child("Category");

  //current user getter
  Future<User> getCurrentUser() async {
    User currentUser;
    currentUser = _auth.currentUser;
    return currentUser;
  }

  //sign in
  Future<User> handleSignInEmail(String email, String password) async {
    final UserCredential user = (await _auth.signInWithEmailAndPassword(
        email: email, password: password));
    // final FirebaseUser user = result.user;

    assert(user.user != null);
    assert(await user.user.getIdToken() != null);

    final User currentUser = _auth.currentUser;
    assert(user.user.uid == currentUser.uid);

    print('signInEmail succeeded: $user');

    return user.user;
  }

  Future<UserCredential> handleSignUp(phone, email, password) async {
    final UserCredential user = (await _auth.createUserWithEmailAndPassword(
        email: email, password: password));
//    user = result.user;

    // assert(user != null);
    // assert(await user.getIdToken() != null);
    //enter data to firebase
    return user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  //add user data to firebase
  Future<void> addDataToDb(UserCredential currentUser, String username,
      String Phone, String Password) async {
    UserEntity.User user = UserEntity.User(
        uid: currentUser.user.uid,
        email: currentUser.user.email,
        phone: Phone,
        password: Password);

    _userReference.child(currentUser.user.uid).set(user.toMap(user));
  }

  Future<List<Food>> fetchAllFood() async {
    List<Food> foodList;
    //getting food list
    DatabaseReference foodReference =
        FirebaseDatabase.instance.ref().child("Foods");
    foodReference.once().then((DataSnapshot snap) {
          Map<String, dynamic> DATA = snap.value;
          List<String> KEYS = [];
          DATA.forEach((key, value) {
            KEYS.add(key);
          });
          // ignore: non_constant_identifier_names
          // var KEYS = snap.value.keys;
          // ignore: non_constant_identifier_names
          // var DATA = snap.value;

          foodList.clear();
          for (var individualKey in KEYS) {
            Food food = new Food(
                description: DATA[individualKey]['description'],
                discount: DATA[individualKey]['discount'],
                image: DATA[individualKey]['image'],
                menuId: DATA[individualKey]['menuId'],
                name: DATA[individualKey]['name'],
                price: DATA[individualKey]['price'],
                keys: individualKey.toString());
            foodList.add(food);
          }
          return foodList;
        } as FutureOr Function(DatabaseEvent value));
  }

  Future<bool> PlaceOrder(Request request) async {
    await ordersReference
        .child(request.userId)
        .push()
        .set(request.toMap(request));
    return true;
  }
//
// Future<List<Category>> fetchCategory()async{
//
//   List<Category> categoryList=[];
//   _categoryReference.once().then((DataSnapshot snap) {
//     // ignore: non_constant_identifier_names
//     var KEYS=snap.value.keys;
//     // ignore: non_constant_identifier_names
//     var DATA=snap.value;
//
//     categoryList.clear();
//     for(var individualKey in KEYS){
//       Category posts= new Category(
//         DATA[individualKey]['Image'],
//         DATA[individualKey]['Name'],
//       );
//       categoryList.add(posts);
//     }
//
//   });
//   return categoryList;
// }
}

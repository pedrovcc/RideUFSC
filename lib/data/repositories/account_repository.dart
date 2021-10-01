import 'dart:convert';

import 'package:boilerplate_flutter/data/models/carro/carro.dart';
import 'package:boilerplate_flutter/data/models/user/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountRepository {
  AccountRepository() {
    _getToken().then((value) => _tokenSubject.add(value));
    _getUser().then((value) => _userSubject.add(value));
  }

  BehaviorSubject<String?> _tokenSubject = BehaviorSubject();
  BehaviorSubject<UserModel?> _userSubject = BehaviorSubject();

  String? get token => _tokenSubject.value;

  UserModel? get currentUser => _userSubject.value;

  Stream<String?> get tokenStream async* {
    yield* _tokenSubject.stream;
  }

  Stream<UserModel?> get userModelStream async* {
    yield* _userSubject.stream;
  }

  Future<Exception?> login({required String email, required String password}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await createSession(userCredential.user?.uid);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return Exception('Não há nenhum usuario com esse email registrado, verifique e tente novamente.');
      } else if (e.code == 'wrong-password') {
        return Exception('Senha incorreta fornecida para esse usuário tente novamente com outra.');
      }
    } catch (error) {
      return Exception(error.toString().replaceAll('Exception:', ''));
    }

    return Exception('Something went wrong');
  }

  Future<Exception?> register({
    required String email,
    required String password,
    required String name,
    required bool isMotorista,
    required Carro? carro,
  }) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await createUserDataBase(UserModel(
            uid: userCredential.user!.uid,
            idUFSC: userCredential.user!.email!,
            name: name,
            isMotorista: isMotorista,
            carro: carro));
      }
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else if (e.code == 'email-already-in-use') {
        return Exception('O endereço de email já está a ser utilizado por outra conta. Por favor utilize outro email');
      }
    } catch (error) {
      return Exception(error.toString().replaceAll('Exception:', ''));
    }
    return Exception('Something went wrong');
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<UserModel?> _getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJsonString = prefs.getString('user');
    if (userJsonString?.isNotEmpty == true) {
      return UserModel.fromJson(jsonDecode(userJsonString!));
    }
    return null;
  }

  Future<void> createSession(String? userUid) async {
    String? uid = userUid;
    if (uid != null) {
      updateLocalUser(uid);
    }
  }

  Future<void> updateToken(String? token) async {
    _tokenSubject.add(token);
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      await prefs.setString('token', token);
    } else {
      await prefs.remove('token');
    }
  }

  Future<void> updateLocalUser(String userUid) async {
    UserModel? user;
    await FirebaseFirestore.instance
        .collection("user")
        .doc(userUid)
        .get()
        .then((DocumentSnapshot documentSnapshot) async {
      if (documentSnapshot.exists && documentSnapshot.data() != null) {
        var jsonResponse = jsonDecode(jsonEncode(documentSnapshot.data()));
        UserModel.fromJson(jsonResponse);
        user = UserModel.fromJson(jsonResponse);

        _userSubject.add(user);
      }
    });

    final prefs = await SharedPreferences.getInstance();
    if (user != null) {
      await prefs.setString('user', json.encode(user!.toJson()));
    } else {
      await prefs.remove('user');
    }
  }

  Future<Exception?> updateFirebaseUser({
    required String? name,
    required String? carModel,
    required int? countSeats,
    required bool? isMotorista,
  }) async {
    UserModel? user = await _getUser();

    if (user != null && user.carro != null) {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(user.uid)
          .update({
            "uid": user.uid,
            "id_ufsc": user.idUFSC,
            "name": name ?? user.name,
            "is_motorista": isMotorista ?? user.isMotorista,
            "carro": Carro(
                    modelo: carModel ?? user.carro!.modelo,
                    assentosDisponiveis: countSeats ?? user.carro!.assentosDisponiveis)
                .toJson(),
          })
          .then((value) => updateLocalUser(user.uid))
          .catchError((error) => print("Failed to update user: $error"));
    }
  }

  Future<void> createUserDataBase(UserModel? user) async {
    UserModel? localUser = user;
    final prefs = await SharedPreferences.getInstance();

    if (localUser != null) {
      await FirebaseFirestore.instance
          .collection("user")
          .doc(localUser.uid)
          .set({
            "uid": localUser.uid,
            "id_ufsc": localUser.idUFSC,
            "name": localUser.name,
            "is_motorista": localUser.isMotorista,
            "carro": localUser.carro?.toJson(),
          })
          .then((value) => print("User Added"))
          .catchError((error) => print("Failed to add user: $error"));

      _userSubject.add(localUser);
      await prefs.setString('user', json.encode(localUser.toJson()));
    } else {
      await prefs.remove('user');
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    _userSubject.add(null);
    _tokenSubject.add(null);
  }
}

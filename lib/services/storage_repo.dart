import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pawspitalapp/models/user_model.dart';
import 'package:pawspitalapp/services/auth_service.dart';
import 'package:pawspitalapp/shared/locator.dart';

class StorageRepo {
  FirebaseStorage _storage =
  FirebaseStorage(storageBucket: "gs://pawspital-b3097.appspot.com");
  AuthService _authRepo = locator.get<AuthService>();
  String avatarUrl;

  Future<String> uploadFile(File file) async {
    UserModel user = await _authRepo.getUser();
    var userId = user.uid;

    var storageRef = _storage.ref().child("user/profile/$userId");
    var uploadTask = storageRef.putFile(file);
    var completedTask = await uploadTask.onComplete;
    avatarUrl = await completedTask.ref.getDownloadURL();
    return avatarUrl;
  }

  Future<String> getUserProfileImage(String uid) async {
    return await _storage.ref().child("user/profile/$uid").getDownloadURL();
  }
}


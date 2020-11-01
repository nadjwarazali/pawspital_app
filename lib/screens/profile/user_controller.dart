import 'dart:io';
import 'package:pawspitalapp/models/user_model.dart';
import 'package:pawspitalapp/services/auth_service.dart';
import 'package:pawspitalapp/services/storage_repo.dart';
import 'package:pawspitalapp/shared/locator.dart';

class UserController {
  UserModel _currentUser;
  AuthService _authRepo = locator.get<AuthService>();
  StorageRepo _storageRepo = locator.get<StorageRepo>();
  Future init;

  UserController() {
    init = initUser();
  }

  Future<UserModel> initUser() async {
    _currentUser = await _authRepo.getUser();
    return _currentUser;
  }

  UserModel get currentUser => _currentUser;

  Future<void> uploadProfilePicture(File image) async {
    _currentUser.avatarUrl = await _storageRepo.uploadFile(image);
  }

  Future<String> getDownloadUrl() async {
    return await _storageRepo.getUserProfileImage(currentUser.uid);
  }

  Future<void> signInWithEmailAndPassword2(
      String email, String password) async {
    _currentUser = await _authRepo.signInWithEmailAndPassword2(
       email, password);

    _currentUser.avatarUrl = await getDownloadUrl();
  }

  void updateDisplayName(String displayName) {
    _currentUser.displayName = displayName;
    _authRepo.updateDisplayName(displayName);
  }

}

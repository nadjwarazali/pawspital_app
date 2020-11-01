import 'package:get_it/get_it.dart';
import 'package:pawspitalapp/screens/profile/user_controller.dart';
import 'package:pawspitalapp/services/auth_service.dart';
import 'package:pawspitalapp/services/storage_repo.dart';
import 'package:pawspitalapp/shared/inputTextDeco.dart';

final locator = GetIt.instance;

void setupServices() {
  locator.registerSingleton<AuthService>(AuthService());
  locator.registerSingleton<StorageRepo>(StorageRepo());
  locator.registerSingleton<UserController>(UserController());
  locator.registerSingleton<InputTextDeco>(InputTextDeco());
}

import 'package:surveypptik/constants/const.dart';
import 'package:surveypptik/constants/route_name.dart';
import 'package:surveypptik/locator.dart';
import 'package:surveypptik/services/navigation_service.dart';
import 'package:surveypptik/services/storage_service.dart';
import 'package:surveypptik/viewmodels/base_model.dart';

class ProfileViewModel extends BaseModel {
  final StorageService _storageService = locator<StorageService>();
  final NavigationService _navigationService = locator<NavigationService>();

  String image = '';
  String name = '';
  String phoneNumber = '';
  String email = '';
  String unit = '';

  void initClass() {
    print('init');
    loadProfile();
  }

  void goToEditProfile() {
    _navigationService.navigateTo(EditProfileRoute);
  }

  void loadProfile() async {
    setBusy(true);
    var tempImage = await _storageService.getString(K_IMAGE);
    name = await _storageService.getString(K_NAME);
    print('name $name');
    phoneNumber = await _storageService.getString(K_PHONE_NUMBER);
    email = await _storageService.getString(K_EMAIL);
    unit = await _storageService.getString(K_UNIT);
    image = 'http://amariitb.pptik.id/data/kehadiran/image/' + tempImage;
    print('the image $image');
    setBusy(false);
  }

  void goToChangePassword() {
    _navigationService.navigateTo(EditChangePwRoute);
  }
}

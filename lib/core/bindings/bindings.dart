import 'package:gaa/controller/event/event_create_controller.dart';
import 'package:get/get.dart';

import '../../controller/auth/auth_controller.dart';
import '../../controller/event/event_controller.dart';
import '../../controller/profile/profile_controller.dart';

class InitialBindings implements Bindings {
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.put(AuthController());
    Get.put(EventCreateController());
    Get.put(EventController());

    // Get.put(ChatController());
    Get.put(ProfileController());
  }
}

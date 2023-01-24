import 'package:get/get.dart';
import 'package:practical_exam/model/modals.dart';

class HomeScreenController extends GetxController {
  RxList<Map> quote = <Map>[].obs;
  Randomly? modelClass;
  RxBool view = true.obs;
  List<Randomly> dataList = [];
}

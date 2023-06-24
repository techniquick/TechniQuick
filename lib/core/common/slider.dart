import 'package:cloud_firestore/cloud_firestore.dart';

import '../../model/slider.dart';

String getSlidersRouts() => 'sliders';

class SlidersController {
  static Stream<List<AppSlider>> getSliders() {
    final stream =
        FirebaseFirestore.instance.collection(getSlidersRouts()).snapshots();
    return stream.map((event) =>
        event.docs.map((e) => AppSlider(image: e['image'])).toList());
  }
}

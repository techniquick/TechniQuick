import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/common/get_image.dart';
import '../../../core/constant.dart';
import '../../../core/util/images.dart';
import '../../../core/util/validator.dart';
import '../../../core/widgets/master_textfield.dart';
import '../../../injection.dart';
import '../../../model/user.dart';
import '../../cubit_controller/auth/nav_bar/bottom_nav_bar_cubit.dart';
import '../../cubit_controller/tech_orders/tech_orders.dart';

class CompleteTechOrder extends StatefulWidget {
  const CompleteTechOrder({Key? key, required this.job}) : super(key: key);
  final String job;
  @override
  State<CompleteTechOrder> createState() => _CompleteTechOrderState();
}

class _CompleteTechOrderState extends State<CompleteTechOrder> {
  final TextEditingController controller = TextEditingController();
  File? imageFile;
  Future<void> setImage(File? pickedFile) async {
    if (pickedFile != null) {
      setState(() {});
      imageFile = File(pickedFile.path);
    } else {
      debugPrint('No image selected.');
    }
  }

  bool isLoading = false;

  void toggleIsLoading() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          tr("request_tech"),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Text(
                  tr("add_teck_photo"),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Stack(
                    fit: StackFit.loose,
                    alignment: AlignmentDirectional.center,
                    children: [
                      Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(100),
                        child: SizedBox(
                            height: 250,
                            width: double.infinity,
                            child: imageFile != null
                                ? Image.file(
                                    imageFile!,
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    logo,
                                    fit: BoxFit.cover,
                                  )),
                      ),
                      Positioned(
                          bottom: 10,
                          left: 5,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  elevation: 3,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10),
                                  )),
                                  context: context,
                                  builder: (_) {
                                    return GetImageFromCameraAndGellary(
                                        onPickImage: (img) {
                                      setImage(img);
                                    });
                                  });
                            },
                            child: const Icon(
                              Icons.add_a_photo,
                              color: Colors.grey,
                            ),
                          ))
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  tr("what_is_your_problem"),
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                TextFormFieldBox(
                  messageController: controller,
                  maxLines: 5,
                  text: tr('what_is_your_problem_det'),
                  validate: (value) => Validator.defaultValidator(value),
                ),
                const SizedBox(height: 10),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : GestureDetector(
                        onTap: () {
                          if (!formKey.currentState!.validate()) {
                            return;
                          }
                          FocusScope.of(context).unfocus();
                          toggleIsLoading();

                          TechOrderController.requestTech(
                            details: controller.text,
                            image: imageFile,
                            userUid: sl<BottomBarCubit>().user.id,
                            categoryName: widget.job,
                            client: sl<BottomBarCubit>().user as Client,
                          ).whenComplete(() => toggleIsLoading());
                        },
                        child: Center(
                          child: Container(
                            height: 56,
                            width: 150,
                            decoration: BoxDecoration(
                              color: mainColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(tr('add_tech'),
                                  style: const TextStyle(
                                      fontSize: 20, color: Colors.black)),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

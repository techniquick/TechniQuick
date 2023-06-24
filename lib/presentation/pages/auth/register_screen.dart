import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techni_quick/core/constant.dart';
import 'package:techni_quick/core/util/toast.dart';
import 'package:techni_quick/model/categories.dart';
import 'package:techni_quick/presentation/pages/auth/select_category_screen.dart';

import '../../../core/common/get_image.dart';
import '../../../core/util/images.dart';
import '../../../core/util/validator.dart';
import '../../../core/widgets/master_text_field.dart';
import '../../../core/widgets/show_snack_bar.dart';
import '../../../model/user.dart';
import '../../cubit_controller/auth/register/register_cubit.dart';

class RegisterScreen extends StatefulWidget {
  final UserType type;
  const RegisterScreen({super.key, required this.type});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final nationalIdController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  File? imageFile;
  Future<void> setImage(File? pickedFile) async {
    if (pickedFile != null) {
      setState(() {});
      imageFile = File(pickedFile.path);
    } else {
      debugPrint('No image selected.');
    }
  }

  String? selectedJob;
  List<String> selectedProfessions = [];
  Job? selectedJobObject;
  final List<String> jobList = [
    "plumbing",
    "carpentry",
    "painting",
    "electrical",
    "metalwork",
    "drywall",
    "plastering",
    "nursing",
    "ceramics",
    "shower",
    "air_conditioning"
  ];

  final Map<String, List<String>> professionList = {
    "plumbing": ["pipefitter", "plumber", "draincleaner"],
    "carpentry": ["cabinetmaker", "trimcarpenter", "furnituremaker"],
    "painting": ["housepainter", "commercialpainter", "industrialpainter"],
    "electrical": ["electrician", "electricalengineer", "powerlineman"],
    "metalwork": ["blacksmith", "metalfabricator", "sheetmetalworker"],
    "drywall": ["drywaller", "taper", "plasterer"],
    "plastering": ["plasterer", "stuccomason", "ornamentalplasterer"],
    "nursing": [
      "registerednurse",
      "licensedpracticalnurse",
      "nursepractitioner"
    ],
    "ceramics": ["ceramicartist", "tilesetter", "glazespecialist"],
    "shower": ["showerinstaller", "showerrepairspecialist", "showerdesigner"],
    "air_conditioning": [
      "HVACtechnician",
      "refrigerationmechanic",
      "ductworkinstaller"
    ],
  };

  void _onJobSelected(String value) {
    setState(() {
      selectedJob = value;
      selectedProfessions.clear();
    });
  }

  void _onProfessionSelected(bool value, String profession) {
    setState(() {
      if (value) {
        selectedProfessions.add(profession);
      } else {
        selectedProfessions.remove(profession);
      }
    });
  }

  void _onSubmit() {
    List<String> professions = professionList[selectedJob]!;
    List<String> selectedProfessionNames = [];
    for (String profession in selectedProfessions) {
      if (professions.contains(profession)) {
        selectedProfessionNames.add(profession);
      }
    }
    if (selectedJob != null) {
      selectedJobObject = Job(selectedJob!, selectedProfessionNames);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: double.infinity,
        child: Form(
            key: formKey,
            child: Stack(
              children: [
                Material(
                  elevation: 5,
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                  ),
                  child: Container(
                    height: 300,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                      ),
                    ),
                  ),
                ),
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 75),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 10),
                                const BackButton(),
                                Center(
                                  child: Text(
                                    tr('sign_up'),
                                    style: myTheme.textTheme.headlineSmall!
                                        .copyWith(color: Colors.black),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Center(
                                  child: Stack(
                                    fit: StackFit.loose,
                                    alignment: AlignmentDirectional.center,
                                    children: [
                                      Material(
                                        elevation: 3,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CircleAvatar(
                                          backgroundColor: white,
                                          radius: 72,
                                          child: imageFile != null
                                              ? CircleAvatar(
                                                  radius: 69,
                                                  backgroundColor: white,
                                                  backgroundImage:
                                                      FileImage(imageFile!))
                                              : const CircleAvatar(
                                                  radius: 69,
                                                  backgroundColor: white,
                                                  backgroundImage:
                                                      AssetImage(logo)),
                                        ),
                                      ),
                                      Positioned(
                                          bottom: 10,
                                          left: 5,
                                          child: InkWell(
                                            onTap: () {
                                              showModalBottomSheet(
                                                  elevation: 3,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(10),
                                                    topRight:
                                                        Radius.circular(10),
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
                                MasterTextField(
                                  controller: nameController,
                                  isPassword: false,
                                  labelText: tr("user_name"),
                                  prefixIcon: const Icon(Icons.person,
                                      color: Colors.black),
                                  validator: (value) =>
                                      Validator.defaultValidator(value),
                                ),
                                MasterTextField(
                                  controller: emailController,
                                  isPassword: false,
                                  labelText: tr("email"),
                                  prefixIcon: const Icon(Icons.email,
                                      color: Colors.black),
                                  validator: (value) => Validator.email(value),
                                ),
                                MasterTextField(
                                  controller: phoneController,
                                  isPassword: false,
                                  labelText: tr("phone_number"),
                                  prefixIcon: const Icon(Icons.phone,
                                      color: Colors.black),
                                  validator: (value) => Validator.phone(value),
                                ),
                                MasterTextField(
                                  controller: passwordController,
                                  isPassword: true,
                                  labelText: tr("password"),
                                  prefixIcon: const Icon(Icons.lock,
                                      color: Colors.black),
                                  validator: (value) =>
                                      Validator.password(value),
                                ),
                                MasterTextField(
                                  controller: confirmPasswordController,
                                  isPassword: true,
                                  labelText: tr("confirm_password"),
                                  prefixIcon: const Icon(Icons.lock,
                                      color: Colors.black),
                                  validator: (value) =>
                                      Validator.confirmPassword(
                                          confirmPasswordController.text,
                                          passwordController.text),
                                ),
                                if (widget.type == UserType.technician)
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      MasterTextField(
                                        controller: nationalIdController,
                                        labelText: tr("national_id"),
                                        keyType: TextInputType.number,
                                        prefixIcon: const Icon(
                                            Icons.perm_identity,
                                            color: Colors.black),
                                        validator: (value) =>
                                            Validator.nationalId(
                                          nationalIdController.text,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      DropdownButtonFormField(
                                        isExpanded: true,
                                        value: selectedJob,
                                        onChanged: (value) =>
                                            _onJobSelected(value!),
                                        items: jobList.map((job) {
                                          return DropdownMenuItem(
                                            value: job,
                                            child: Text(tr(job)),
                                          );
                                        }).toList(),
                                        decoration: InputDecoration(
                                          labelText: tr("select_a_job"),
                                          labelStyle: const TextStyle(
                                              color: Colors.black),
                                          border: const OutlineInputBorder(),
                                        ),
                                        style: const TextStyle(
                                            color: Colors.black),
                                      ),
                                    ],
                                  ),
                                const SizedBox(height: 10),
                                if (selectedJob != null)
                                  Column(
                                    children: professionList[selectedJob]!
                                        .map((profession) {
                                      return CheckboxListTile(
                                        value: selectedProfessions
                                            .contains(profession),
                                        onChanged: (bool? value) {
                                          _onProfessionSelected(
                                              value!, profession);
                                        },
                                        title: Text(tr(profession)),
                                      );
                                    }).toList(),
                                  ),
                                BlocConsumer<RegisterCubit, RegisterState>(
                                  listener: (context, state) {
                                    if (state is RegisterError) {
                                      showSnackBar(
                                          context: context,
                                          message: state.message);
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is RegisterLoading) {
                                      return const Center(
                                          child: CircularProgressIndicator
                                              .adaptive());
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        if (!formKey.currentState!.validate()) {
                                          return;
                                        }
                                        if (imageFile == null) {
                                          showToast("please_pick_an_image");
                                          return;
                                        }
                                        if (widget.type ==
                                            UserType.technician) {
                                          _onSubmit();
                                          if (selectedJobObject == null) {
                                            showToast("please_pick_ajob");
                                            return;
                                          }
                                          if (selectedJobObject!
                                              .professions.isEmpty) {
                                            showToast("one_profession");
                                            return;
                                          }
                                          context
                                              .read<RegisterCubit>()
                                              .fRegisterTech(
                                                  techCategory:
                                                      TechCategory.fromJob(
                                                          selectedJobObject!),
                                                  nationalId:
                                                      nationalIdController.text,
                                                  imageFile: imageFile!,
                                                  context: context,
                                                  formKey: formKey,
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text,
                                                  name: nameController.text,
                                                  phone: phoneController.text,
                                                  type: widget.type);
                                        } else {
                                          context
                                              .read<RegisterCubit>()
                                              .fRegister(
                                                  imageFile: imageFile!,
                                                  context: context,
                                                  formKey: formKey,
                                                  email: emailController.text,
                                                  password:
                                                      passwordController.text,
                                                  name: nameController.text,
                                                  phone: phoneController.text,
                                                  type: widget.type);
                                        }
                                      },
                                      child: Center(
                                        child: Container(
                                          height: 56,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            color: mainColor,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Center(
                                            child: Text(tr('register'),
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    color: Colors.black)),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }
}

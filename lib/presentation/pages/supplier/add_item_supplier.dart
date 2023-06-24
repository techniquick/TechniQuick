import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techni_quick/core/util/images.dart';
import 'package:techni_quick/core/util/toast.dart';

import '../../../core/constant.dart';
import '../../../core/common/get_image.dart';
import '../../cubit_controller/supplier/add_supplies/add_supplies_cubit.dart';

class AddSuppliesForm extends StatefulWidget {
  const AddSuppliesForm({super.key});

  @override
  State<AddSuppliesForm> createState() => _AddSuppliesFormState();
}

class _AddSuppliesFormState extends State<AddSuppliesForm> {
  final _formKey = GlobalKey<FormState>();
  String name = "";
  String? suppliesCategory;
  String image = "";
  String price = "";
  String discription = "";
  final List<String> categories = [
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
  File? imageFile;
  Future<void> setImage(File? pickedFile) async {
    if (pickedFile != null) {
      setState(() {});
      imageFile = File(pickedFile.path);
    } else {
      debugPrint('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Stack(
        children: [
          Material(
            elevation: 5,
            borderRadius: const BorderRadius.only(
              bottomRight: Radius.circular(40),
              bottomLeft: Radius.circular(40),
            ),
            child: Container(
              height: 100,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Padding(
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Stack(
                            fit: StackFit.loose,
                            alignment: AlignmentDirectional.center,
                            children: [
                              Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(100),
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
                                          backgroundImage: AssetImage(logo)),
                                ),
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
                        TextFormField(
                          decoration: InputDecoration(labelText: tr('name')),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return tr('field_required');
                            }
                            return null;
                          },
                          onSaved: (value) {
                            name = value!;
                          },
                        ),
                        DropdownButtonFormField<String>(
                          decoration:
                              InputDecoration(labelText: tr('category')),
                          value: suppliesCategory,
                          items: categories
                              .map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    tr(category),
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              suppliesCategory = value!;
                            });
                          },
                          validator: (value) {
                            if (value == null) {
                              return tr('field_required');
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: InputDecoration(labelText: tr('price')),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return tr('field_required');
                            }
                            return null;
                          },
                          onSaved: (value) {
                            price = value!;
                          },
                        ),
                        TextFormField(
                          decoration:
                              InputDecoration(labelText: tr('description')),
                          maxLines: 5,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return tr('field_required');
                            }
                            return null;
                          },
                          onSaved: (value) {
                            discription = value!;
                          },
                        ),
                        const SizedBox(height: 20),
                        BlocBuilder<ControlSuppliesCubit, ControlSuppliesState>(
                          builder: (context, state) {
                            if (state is ControlSuppliesLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  if (imageFile == null) {
                                    showToast(tr("choose_image"));
                                    return;
                                  }
                                  if (suppliesCategory == null) {
                                    showToast(tr("choose_supplies_type"));
                                    return;
                                  }
                                  context
                                      .read<ControlSuppliesCubit>()
                                      .fAddSupplies(
                                          name: name,
                                          suppliesCategory: suppliesCategory,
                                          imageFile: imageFile,
                                          price: price,
                                          discription: discription);
                                }
                              },
                              child: Center(
                                child: Container(
                                  height: 56,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(tr('add_supplies'),
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.black)),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

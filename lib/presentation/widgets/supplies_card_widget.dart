import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:techni_quick/presentation/widgets/rounded_background_widget.dart';

import '../../core/constant.dart';
import '../../injection.dart';
import '../../model/Supplies.dart';
import '../cubit_controller/supplier/add_supplies/add_supplies_cubit.dart';

class SuppliesWidget extends StatelessWidget {
  final Supplies supplies;

  const SuppliesWidget({Key? key, required this.supplies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = sl<FirebaseAuth>().currentUser!;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: RoundedBackgorund(
          child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16.0,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    supplies.name,
                    style: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: interFontFamily,
                      color: black,
                    ),
                  ),
                  if (supplies.userId == user.uid) const Spacer(),
                  if (supplies.userId == user.uid)
                    BlocBuilder<ControlSuppliesCubit, ControlSuppliesState>(
                      builder: (context, state) {
                        return IconButton(
                            onPressed: () {
                              context
                                  .read<ControlSuppliesCubit>()
                                  .fDeleteSupplies(id: supplies.id);
                            },
                            icon: const Icon(Icons.delete));
                      },
                    )
                ],
              ),
              const SizedBox(height: 8.0),
              Text(
                tr(supplies.suppliesCategory.suppliesName),
                style: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: interFontFamily,
                  color: darkerColor,
                ),
              ),
              const SizedBox(height: 8.0),
              Image.network(
                supplies.image,
                height: 250,
              ),
              const SizedBox(height: 8.0),
              Text(
                "${tr("price")} : ${supplies.price} ${tr("EGP")}",
                style: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: interFontFamily,
                  color: black,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                supplies.discription,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontFamily: interFontFamily,
                  color: mainColor,
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

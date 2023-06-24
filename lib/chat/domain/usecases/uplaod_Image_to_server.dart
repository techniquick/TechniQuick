// ignore_for_file: file_names

import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import '../../../core/constant/usecases.dart';
import '../../../core/error/failures.dart';
import '../entities/uploade_image_response.dart';
import '../repositories/chat_repository.dart';

class UplaodImageToServer
    extends UseCase<UploadedImage, UplaodImageToServerParams> {
  final ChatRepository repository;

  UplaodImageToServer({required this.repository});
  @override
  Future<Either<Failure, UploadedImage>> call(
      UplaodImageToServerParams params) async {
    return repository.uplaodImageToServer(params: params);
  }
}

class UplaodImageToServerParams {
  final Uint8List image;
  final String chatGroupId;

  UplaodImageToServerParams({required this.image, required this.chatGroupId});
}

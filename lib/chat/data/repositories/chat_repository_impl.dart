import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../domain/entities/message.dart';
import '../../domain/entities/message_over_view.dart';
import '../../domain/entities/uploade_image_response.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/usecases/get_new_messages.dart';
import '../../domain/usecases/mark_peer_messages_as_read.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/set_chatting_Id_for_users.dart';
import '../../domain/usecases/uplaod_Image_to_server.dart';
import '../datasources/chat_remote_datasource.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remote;

  ChatRepositoryImpl({required this.remote});

  @override
  Stream<List<Message>> getAllMessages({required String chatGroupId}) {
    final listOfMessages = remote.getAllMessages(chatGroupId: chatGroupId);
    return listOfMessages;
  }

  @override
  Future<Either<Failure, Unit>> sendMessage(
      {required SendMessageParams params}) async {
    try {
      await remote.sendMessage(params: params);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> setChattingIdForUsers(
      {required SetChattingIdForUsersParams params}) async {
    try {
      await remote.setChattingIdForUsers(params: params);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, UploadedImage>> uplaodImageToServer(
      {required UplaodImageToServerParams params}) async {
    try {
      UploadedImage response = await remote.uplaodImageToServer(params: params);
      return Right(response);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, Unit>> markPeerMessagesAsRead(
      {required MarkPeerMessagesAsReadParams params}) async {
    try {
      await remote.markPeerMessagesAsRead(params: params);
      return const Right(unit);
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(message: e.message!));
    }
  }

  @override
  Future<Either<Failure, MessageOverView>> getNewMessagesCount(
      {required GetNewMessagesCountParams params}) async {
    try {
      final messageOverView = await remote.getNewMessagesCount(params: params);
      return Right(messageOverView);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}

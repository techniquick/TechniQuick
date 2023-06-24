import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../entities/message.dart';
import '../entities/message_over_view.dart';
import '../entities/uploade_image_response.dart';
import '../usecases/get_new_messages.dart';
import '../usecases/mark_peer_messages_as_read.dart';
import '../usecases/send_message.dart';
import '../usecases/set_chatting_Id_for_users.dart';
import '../usecases/uplaod_Image_to_server.dart';

abstract class ChatRepository {
  Future<Either<Failure, Unit>> setChattingIdForUsers(
      {required SetChattingIdForUsersParams params});

  Future<Either<Failure, Unit>> sendMessage(
      {required SendMessageParams params});

  Stream<List<Message>> getAllMessages({required String chatGroupId});

  Future<Either<Failure, UploadedImage>> uplaodImageToServer(
      {required UplaodImageToServerParams params});

  Future<Either<Failure, Unit>> markPeerMessagesAsRead(
      {required MarkPeerMessagesAsReadParams params});
  Future<Either<Failure, MessageOverView>> getNewMessagesCount(
      {required GetNewMessagesCountParams params});
}

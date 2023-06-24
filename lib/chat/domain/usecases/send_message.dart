import 'package:dartz/dartz.dart';
import '../../../core/constant/usecases.dart';
import '../../../core/error/failures.dart';
import '../entities/message.dart';
import '../entities/order_user.dart';
import '../repositories/chat_repository.dart';

class SendMessage extends UseCase<Unit, SendMessageParams> {
  final ChatRepository repository;

  SendMessage({required this.repository});
  @override
  Future<Either<Failure, Unit>> call(SendMessageParams params) async {
    return await repository.sendMessage(params: params);
  }
}

class SendMessageParams {
  final Message message;
  final String chatGroupId;
  final ChatUser sender;
  final ChatUser reciver;
  SendMessageParams(
      {required this.message,
      required this.chatGroupId,
      required this.reciver,
      required this.sender});
}

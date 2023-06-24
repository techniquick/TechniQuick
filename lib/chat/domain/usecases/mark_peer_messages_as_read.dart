import 'package:dartz/dartz.dart';

import '../../../core/constant/usecases.dart';
import '../../../core/error/failures.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class MarkPeerMessagesAsRead
    extends UseCase<Unit, MarkPeerMessagesAsReadParams> {
  final ChatRepository repository;

  MarkPeerMessagesAsRead({required this.repository});
  @override
  Future<Either<Failure, Unit>> call(
      MarkPeerMessagesAsReadParams params) async {
    return await repository.markPeerMessagesAsRead(params: params);
  }
}

class MarkPeerMessagesAsReadParams {
  final String chatGroupId, userId2;
  final Message lastMessage;

  MarkPeerMessagesAsReadParams({
    required this.chatGroupId,
    required this.userId2,
    required this.lastMessage,
  });
}

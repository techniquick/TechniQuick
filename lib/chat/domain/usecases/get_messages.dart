import '../../../core/constant/stream_usecase.dart';
import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class GetAllMessages
    extends StreamUseCase<List<Message>, GetAllMessagesParams> {
  final ChatRepository repository;

  GetAllMessages({required this.repository});
  @override
  Stream<List<Message>> call(GetAllMessagesParams params) {
    return repository.getAllMessages(chatGroupId: params.chatGroupId);
  }
}

class GetAllMessagesParams {
  final String chatGroupId;

  GetAllMessagesParams({required this.chatGroupId});
}

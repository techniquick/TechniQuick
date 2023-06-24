import 'package:dartz/dartz.dart';
import '../../../core/constant/usecases.dart';
import '../../../core/error/failures.dart';
import '../entities/message_over_view.dart';
import '../repositories/chat_repository.dart';

class GetNewMessagesCount
    extends UseCase<MessageOverView, GetNewMessagesCountParams> {
  final ChatRepository repository;

  GetNewMessagesCount({required this.repository});
  @override
  Future<Either<Failure, MessageOverView>> call(
      GetNewMessagesCountParams params) {
    return repository.getNewMessagesCount(params: params);
  }
}

class GetNewMessagesCountParams {
  String chatGroupId;
  String idFrom;
  GetNewMessagesCountParams({required this.chatGroupId, required this.idFrom});
}

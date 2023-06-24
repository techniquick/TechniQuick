// ignore_for_file: file_names
import 'package:dartz/dartz.dart';

import '../../../core/constant/usecases.dart';
import '../../../core/error/failures.dart';
import '../entities/order_user.dart';
import '../repositories/chat_repository.dart';

class SetChattingIdForUsers extends UseCase<Unit, SetChattingIdForUsersParams> {
  final ChatRepository repository;

  SetChattingIdForUsers({required this.repository});
  @override
  Future<Either<Failure, Unit>> call(SetChattingIdForUsersParams params) async {
    return await repository.setChattingIdForUsers(params: params);
  }
}

class SetChattingIdForUsersParams {
  final String userId1, userId2;
  final ChatUser user1, user2;
  SetChattingIdForUsersParams(
      {required this.user1,
      required this.user2,
      required this.userId1,
      required this.userId2});
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:smart_iot/domain/entities/message/message.dart';
import 'package:smart_iot/domain/usecase/mess/call_gemini_model.dart';

import '../../../service_locator.dart';

part 'chat_box_state.dart';

class ChatBoxCubit extends Cubit<ChatBoxState> {
  ChatBoxCubit() : super(const ChatBoxState());

  Future<void> sendMessage(String prompt) async {
    emit(state.copyWith(
      isSending: true,
      messages: [...state.messages, MessageEntity(value: prompt, isUser: true)],
    ));

    final response = await sl<CallGeminiModelUseCase>().call(params: prompt);

    response.fold(
      (error) {
        emit(state.copyWith(isSending: false));
        // Handle error logging or UI display if necessary
      },
      (res) {
        emit(state.copyWith(
          isSending: false,
          messages: [...state.messages, MessageEntity(value: res, isUser: false)],
        ));
      },
    );
  }
}

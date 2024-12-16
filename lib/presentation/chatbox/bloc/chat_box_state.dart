part of 'chat_box_cubit.dart';


class ChatBoxState extends Equatable {
  final List<MessageEntity> messages;
  final bool isSending;

  const ChatBoxState({
    this.messages = const [],
    this.isSending = false,
  });

  ChatBoxState copyWith({List<MessageEntity>? messages, bool? isSending}) {
    return ChatBoxState(
      messages: messages ?? this.messages,
      isSending: isSending ?? this.isSending,
    );
  }

  @override
  List<Object> get props => [messages, isSending];
}

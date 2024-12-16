import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_iot/common/widgets/appbar/app_bar.dart';
import 'package:smart_iot/core/configs/assets/app_images.dart';

import 'package:smart_iot/presentation/chatbox/bloc/chat_box_cubit.dart';

class ChatBoxPage extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  ChatBoxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ChatBoxCubit>(
      create: (context) => ChatBoxCubit(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: _buildAppBar(context),
        body: BlocBuilder<ChatBoxCubit, ChatBoxState>(
          builder: (context, state) {
            final cubit = context.read<ChatBoxCubit>();
            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: buildChatBox(state),
                  ),
                  buildInputValue(state, cubit)
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildInputValue(ChatBoxState state, ChatBoxCubit cubit) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              spreadRadius: 3,
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    hintText: "Write your message",
                    hintStyle: TextStyle(color: Colors.grey[300])),
              ),
            ),
            state.isSending
                ? Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              width: 20,
              height: 20,
              child: const CircularProgressIndicator(color: Colors.green),
            )
                : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  if (_controller.text.isNotEmpty) {
                    cubit.sendMessage(_controller.text);
                    _controller.clear();
                  }
                },
                child: const Icon(Icons.send, color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListView buildChatBox(ChatBoxState state) {
    return ListView.builder(
      reverse: true, // Hiển thị tin nhắn mới nhất ở cuối
      itemCount: state.messages.length,
      itemBuilder: (context, index) {
        final message = state.messages[state.messages.length - index - 1]; // build tin nhan ở cuoi
        final isUser = message.isUser;
        return ListTile(
          title: Align(
            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isUser ? Colors.green : Colors.grey[300],
                borderRadius: BorderRadius.only(
                  bottomLeft: const Radius.circular(20),
                  bottomRight: const Radius.circular(20),
                  topLeft: isUser ? const Radius.circular(20) : Radius.zero,
                  topRight: isUser ? Radius.zero : const Radius.circular(20),
                ),
              ),
              child: Text(
                message.value,
                style: TextStyle(color: isUser ? Colors.white : Colors.black),
              ),
            ),
          ),
        );
      },
    );
  }

  BasicAppBar _buildAppBar(BuildContext context) {
    return BasicAppBar(
      hideBack: true,
      backgroundColor: Colors.green.withOpacity(0.2),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Image.asset(
                  AppImages.chatBoxIcon,
                  color: Colors.green,
                  fit: BoxFit.contain,
                  width: 36,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chatbox AI',
                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Container(
                          width: 6,
                          height: 6,
                          decoration: const ShapeDecoration(color: Color(0xFF3ABF37), shape: OvalBorder())),
                      const SizedBox(width: 5),
                      const Text('Online',
                          style: TextStyle(fontSize: 17, color: Color(0xFF3ABF37), fontWeight: FontWeight.w500)),
                    ],
                  )
                ],
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("hello")),
              );
            },
            child: const Icon(Icons.info, color: Colors.green),
          ),
        ],
      ),
    );
  }
}

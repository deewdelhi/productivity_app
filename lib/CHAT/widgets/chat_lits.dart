import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:productivity_app/CHAT/widgets/message_caard_user.dart';
import 'package:productivity_app/CHAT/widgets/message_card_others.dart';
import 'package:productivity_app/models/message.dart';
import 'package:productivity_app/providers/repository_provider_CHAT.dart';
import 'package:productivity_app/widgets/loader.dart';

class ChatList extends ConsumerStatefulWidget {
  final String groupId;

  const ChatList({
    Key? key,
    required this.groupId,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final groupMessages = ref.watch(groupChatStreamProvider(widget.groupId));
    SchedulerBinding.instance.addPostFrameCallback((_) {
      messageController.jumpTo(messageController.position.maxScrollExtent);
    });
    return groupMessages.when(
      data: (messages) {
        return ListView.builder(
          controller: messageController,
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final messageData = messages[index];
            var timeSent = DateFormat.Hm().format(messageData.timeSent);

            if (messageData.senderId ==
                FirebaseAuth.instance.currentUser!.uid) {
              return MyMessageCard(
                message: messageData.text,
                date: timeSent,
                type: messageData.type,
                repliedText: " messageData.repliedMessage",
                username: " messageData.repliedTo",
                repliedMessageType: MessageEnum.text,
                onLeftSwipe: () {},
                // onLeftSwipe: () => onMessageSwipe(
                //   messageData.text,
                //   true,
                //   messageData.type,
                // ),
                isSeen: false,
              );
            }
            return SenderMessageCard(
              message: messageData.text,
              date: timeSent,
              type: messageData.type,
              username: "insert username here",
              repliedMessageType: MessageEnum.text,
              onRightSwipe: () {},
              // onRightSwipe: () => onMessageSwipe(
              //   messageData.text,
              //   false,
              //   messageData.type,
              // ),
              repliedText: " messageData.repliedMessage",
            );
          },
        );
      },
      loading: () => const Loader(),
      error: (error, stackTrace) => Center(
        child: Text('Error: $error'),
      ),
    );
  }
}

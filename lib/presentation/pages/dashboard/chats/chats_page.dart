import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/config/routes/app_routes.dart';
import 'package:meet_up/core/local/local_storage_manager.dart';
import 'package:meet_up/data/models/buddy.dart';
import 'package:meet_up/data/models/recent_chat.dart';
import 'package:meet_up/presentation/bloc/chat/chat_bloc.dart';
import 'package:meet_up/presentation/pages/dashboard/chats/widgets/recent_chat_item.dart';
import '../../../../config/di/service_locator.dart';

class ChatsPage extends StatefulWidget {
  const ChatsPage({super.key});

  @override
  State<ChatsPage> createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late LocalStorageManager _storageManager;

  @override
  void initState() {
    super.initState();
    _storageManager = getIt<LocalStorageManager>();
    context.read<ChatBloc>().add(GetRecentChatsEvent());
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> _streamLastMessage({
    required String id,
  }) {

    return firebaseFireStore
        .collection("chats/${_storageManager.token}/recent_chats/")
        .doc(id)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chats")),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: BlocBuilder<ChatBloc, ChatStates>(
          buildWhen: (prev, current) {
            return current is RecentChatsLoadingState ||
                current is RecentChatsLoadedState ||
                current is RecentChatsFailedState;
          },
          builder: (context, state) {
            if (state is RecentChatsLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is RecentChatsLoadedState) {
              if (state.recentMessages.isEmpty) {
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Yo don't have any chats.",
                      style: TextStyle(fontSize: 18),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Start new chat"),
                        SizedBox(),
                        IconButton(
                          onPressed: () => context.pushNamed(AppRoutes.buddies),
                          icon: Icon(Icons.waving_hand, color: Colors.amber),
                        ),
                      ],
                    ),
                  ],
                );
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: state.recentMessages.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final recentChat = state.recentMessages[index];

                    return GestureDetector(
                      onTap: () async {
                        final result =
                            await firebaseFireStore
                                .collection("users")
                                .where("phone", isEqualTo: recentChat.id)
                                .where("token", isEqualTo: recentChat.id)
                                .get();

                        if (!context.mounted) return;

                        context.pushNamed(
                          AppRoutes.chatDetails,
                          extra: Buddy.fromJson(result.docs.first.data()),
                        );
                      },
                      child: StreamBuilder(
                        stream: _streamLastMessage(id: recentChat.id!),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                                  ConnectionState.waiting ||
                              !snapshot.hasData) {
                            return SizedBox();
                          }

                          final item = RecentChat.fromJson(
                            snapshot.data!.data()!,
                          );

                          return RecentChatItem(recentChat: item);
                        },
                      ),
                    );
                  },
                ),
              );
            } else if (state is RecentChatsFailedState) {
              return Center(child: Text(state.message));
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}

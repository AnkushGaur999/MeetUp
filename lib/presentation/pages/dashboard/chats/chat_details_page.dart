import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_up/config/di/service_locator.dart';
import 'package:meet_up/core/local/local_storage_manager.dart';
import 'package:meet_up/data/models/buddy.dart';
import 'package:meet_up/data/models/user_chat.dart';
import 'package:meet_up/presentation/bloc/chat/chat_bloc.dart';

class ChatDetailsPage extends StatefulWidget {
  final Buddy buddy;

  const ChatDetailsPage({super.key, required this.buddy});

  @override
  State<ChatDetailsPage> createState() => _ChatDetailsPageState();
}

class _ChatDetailsPageState extends State<ChatDetailsPage> {
  final TextEditingController _textController = TextEditingController();

  bool _showEmoji = false, _isUploading = false;
  final _scrollController = ScrollController();

  late LocalStorageManager storageManager;

  List<UserChat> userChatList = [];

  @override
  void initState() {
    super.initState();

    storageManager = getIt<LocalStorageManager>();

    context.read<ChatBloc>().add(
      GetUserChatsEvent(
        token: storageManager.token,
        userId: widget.buddy.phone!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat")),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream:
                    firebaseFireStore
                        .collection(
                          'chats/${storageManager.token}/${widget.buddy.phone}/',
                        )
                        .orderBy('sent', descending: false)
                        .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }
                  final docs = snapshot.data?.docs;
                  userChatList =
                      docs
                          ?.map((value) => UserChat.fromJson(value.data()))
                          .toList() ??
                      [];
                  if (userChatList.isNotEmpty) {
                    return ListView.builder(
                      itemCount: userChatList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                            userChatList[index].fromId ==
                                storageManager.token
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12, ),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(userChatList[index].message!))],
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text(
                        'Say Hii! 👋',
                        style: TextStyle(fontSize: 20),
                      ),
                    );
                  }
                },
              ),
              // child: BlocBuilder<ChatBloc, ChatStates>(
              //   builder: (context, state) {
              //     if (state is UserChatsLoadingState) {
              //       return CircularProgressIndicator();
              //     } else if (state is UserChatsLoadedState) {
              //       return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              //         stream: state.messages,
              //         builder: (context, snapshot) {
              //           if (snapshot.hasError) {
              //             return Text('Error: ${snapshot.error}');
              //           }
              //           if (!snapshot.hasData) {
              //             return CircularProgressIndicator();
              //           }
              //           final docs = snapshot.data?.docs;
              //           userChatList =
              //               docs
              //                   ?.map(
              //                     (value) => UserChat.fromJson(value.data()),
              //                   )
              //                   .toList() ??
              //               [];
              //           return ListView.builder(
              //             itemCount: userChatList.length,
              //             itemBuilder: (context, index) {
              //               return ListTile(
              //                 title: Text(
              //                   userChatList[index].message ?? 'No message',
              //                 ),
              //               );
              //             },
              //           );
              //         },
              //       );
              //     } else if (state is UserChatsFailedState) {
              //       return Text('Error: ${state.message}');
              //     }
              //     return Container();
              //   },
              // ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: Row(
                children: [
                  //input field & buttons
                  Expanded(
                    child: Card(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                      ),
                      child: Row(
                        children: [
                          //emoji button
                          IconButton(
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              setState(() => _showEmoji = !_showEmoji);
                            },
                            icon: const Icon(
                              Icons.emoji_emotions,
                              color: Colors.blueAccent,
                              size: 25,
                            ),
                          ),

                          Expanded(
                            child: TextField(
                              controller: _textController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              onTap: () {
                                if (_showEmoji) {
                                  setState(() => _showEmoji = !_showEmoji);
                                }
                              },
                              decoration: const InputDecoration(
                                hintText: 'Type Something...',
                                hintStyle: TextStyle(color: Colors.blueAccent),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          //pick image from gallery button
                          IconButton(
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();

                              // Picking multiple images
                              final List<XFile> images = await picker
                                  .pickMultiImage(imageQuality: 70);

                              // uploading & sending image one by one
                              for (var i in images) {
                                // log('Image Path: ${i.path}');
                                // setState(() => _isUploading = true);
                                // await APIs.sendChatImage(
                                //     widget.user, File(i.path));
                                setState(() => _isUploading = false);
                              }
                            },
                            icon: const Icon(
                              Icons.image,
                              color: Colors.blueAccent,
                              size: 26,
                            ),
                          ),

                          //take image from camera button
                          IconButton(
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();

                              // Pick an image
                              final XFile? image = await picker.pickImage(
                                source: ImageSource.camera,
                                imageQuality: 70,
                              );
                              if (image != null) {
                                setState(() => _isUploading = true);
                                //
                                // await APIs.sendChatImage(
                                //     widget.user, File(image.path));
                                setState(() => _isUploading = false);
                              }
                            },
                            icon: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.blueAccent,
                              size: 26,
                            ),
                          ),

                          //adding some space
                          SizedBox(width: 20),
                        ],
                      ),
                    ),
                  ),

                  //send message button
                  MaterialButton(
                    onPressed: () {
                      if (_textController.text.isNotEmpty) {
                        final time =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        UserChat userChat = UserChat(
                          fromId: storageManager.token,
                          toId: widget.buddy.token,
                          message: _textController.text,
                          sent: time,
                          type: "text",
                          read: false,
                        );

                        context.read<ChatBloc>().add(
                          SendMessageToUserEvent(userChat: userChat),
                        );

                        _textController.text = '';
                      }
                    },
                    minWidth: 0,
                    padding: const EdgeInsets.only(
                      top: 10,
                      bottom: 10,
                      right: 5,
                      left: 10,
                    ),
                    shape: const CircleBorder(),
                    color: Colors.green,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10),

            Offstage(
              offstage: !_showEmoji,
              child: EmojiPicker(
                textEditingController: _textController,
                scrollController: _scrollController,
                config: Config(
                  height: 256,
                  checkPlatformCompatibility: true,
                  viewOrderConfig: const ViewOrderConfig(),
                  emojiViewConfig: EmojiViewConfig(
                    emojiSizeMax:
                        28 *
                        (foundation.defaultTargetPlatform == TargetPlatform.iOS
                            ? 1.2
                            : 1.0),
                  ),
                  skinToneConfig: const SkinToneConfig(),
                  categoryViewConfig: const CategoryViewConfig(),
                  bottomActionBarConfig: const BottomActionBarConfig(),
                  searchViewConfig: const SearchViewConfig(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

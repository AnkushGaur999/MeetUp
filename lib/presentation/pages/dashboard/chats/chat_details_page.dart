import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_up/config/di/service_locator.dart';
import 'package:meet_up/core/local/local_storage_manager.dart';
import 'package:meet_up/core/utils/time_date_utils.dart';
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

  bool _showEmoji = false;
  final _scrollController = ScrollController();

  late LocalStorageManager storageManager;

  List<UserChat> userChatList = [];

  @override
  void initState() {
    super.initState();

    storageManager = getIt<LocalStorageManager>();
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
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment:
                                userChatList[index].fromId ==
                                        storageManager.token
                                    ? MainAxisAlignment.end
                                    : MainAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.black12),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(userChatList[index].message!),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      getTimeFromTimeStamp(
                                        userChatList[index].sent!,
                                      ),
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                              // final List<XFile> images = await picker
                              //     .pickMultiImage(imageQuality: 70);

                              // uploading & sending image one by one
                              // for (var i in images) {
                              // log('Image Path: ${i.path}');
                              // setState(() => _isUploading = true);
                              // await APIs.sendChatImage(
                              //     widget.user, File(i.path));
                              // }
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
                                //
                                // await APIs.sendChatImage(
                                //     widget.user, File(image.path));
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
                    onPressed: () async {
                      if (_textController.text.isNotEmpty) {
                        final time =
                            DateTime.now().millisecondsSinceEpoch.toString();

                        UserChat userChat = UserChat(
                          name: widget.buddy.name,
                          fromId: storageManager.token,
                          toId: widget.buddy.token,
                          message: _textController.text,
                          sent: time,
                          type: "text",
                          imageUrl: widget.buddy.imageUrl,
                          read: false,
                        );

                        context.read<ChatBloc>().add(
                          SendMessageToUserEvent(userChat: userChat),
                        );

                        // context.read<ChatBloc>().add(GetRecentChatsEvent());

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

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meet_up/config/di/service_locator.dart';
import 'package:meet_up/core/constants/meesage_type.dart';
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

  final FirebaseStorage _storage = FirebaseStorage.instance;

  List<UserChat> userChatList = [];

  @override
  void initState() {
    super.initState();

    storageManager = getIt<LocalStorageManager>();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  child: Image.network(widget.buddy.imageUrl!),
                ),
                SizedBox(width: 20),
                Text(widget.buddy.name!),
              ],
            ),

            IconButton(onPressed: (){}, icon: Icon(Icons.video_call_rounded)),
          ],
        ),
      ),
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
                    _scrollToBottom();

                    return ListView.builder(
                      controller: _scrollController,
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
                                    child:
                                        userChatList[index].type == "text"
                                            ? Text(userChatList[index].message!)
                                            : Image.network(
                                              userChatList[index].message!,
                                              width: 240,
                                              height: 240,
                                              fit: BoxFit.contain,
                                            ),
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
                          SizedBox(width: 10),

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
                                hintStyle: TextStyle(color: Colors.black),
                                border: InputBorder.none,
                              ),
                            ),
                          ),

                          //pick image from gallery button
                          IconButton(
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();

                              //  Picking multiple images
                              final List<XFile> images = await picker
                                  .pickMultiImage(imageQuality: 70);

                              // uploading & sending image one by one
                              for (var i in images) {
                                final imageUrl = await sendChatImage(
                                  widget.buddy,
                                  File(i.path),
                                );

                                final time =
                                    DateTime.now().millisecondsSinceEpoch
                                        .toString();

                                UserChat userChat = UserChat(
                                  name: widget.buddy.name,
                                  fromId: storageManager.token,
                                  toId: widget.buddy.token,
                                  message: imageUrl,
                                  sent: time,
                                  type: MessageType.image.name.toString(),
                                  imageUrl: widget.buddy.imageUrl,
                                  read: false,
                                );

                                if (context.mounted) {
                                  context.read<ChatBloc>().add(
                                    SendMessageToUserEvent(userChat: userChat),
                                  );
                                }
                              }
                            },
                            icon: const Icon(
                              Icons.image,
                              color: Colors.black,
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
                                final imageUrl = await sendChatImage(
                                  widget.buddy,
                                  File(image.path),
                                );

                                final time =
                                    DateTime.now().millisecondsSinceEpoch
                                        .toString();

                                UserChat userChat = UserChat(
                                  name: widget.buddy.name,
                                  fromId: storageManager.token,
                                  toId: widget.buddy.token,
                                  message: imageUrl,
                                  sent: time,
                                  type: MessageType.image.name.toString(),
                                  imageUrl: widget.buddy.imageUrl,
                                  read: false,
                                );

                                if (context.mounted) {
                                  context.read<ChatBloc>().add(
                                    SendMessageToUserEvent(userChat: userChat),
                                  );
                                }
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
                          type: MessageType.text.name.toString(),
                          imageUrl: widget.buddy.imageUrl,
                          read: false,
                        );

                        context.read<ChatBloc>().add(
                          SendMessageToUserEvent(userChat: userChat),
                        );

                        _textController.text = '';

                        _scrollToBottom();
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
          ],
        ),
      ),
    );
  }

  //send chat image
  Future<String> sendChatImage(Buddy buddy, File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = _storage.ref().child(
      'images/${buddy.token}/${DateTime.now().millisecondsSinceEpoch}.$ext',
    );

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'));

    //updating image in firestore database
    return await ref.getDownloadURL();
  }
}

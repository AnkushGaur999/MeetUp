import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/presentation/bloc/account/account_bloc.dart';
import 'package:meet_up/presentation/pages/profile/widgets/profile_field_widget.dart';
import 'package:meet_up/presentation/pages/profile/widgets/update_profile_picture_bottom_sheet.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<AccountBloc>().add(GetMyProfileDetailsEvent());
  }

  void _showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true, // dismiss on tap outside
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              width: 200,
              height: 200,
              padding: const EdgeInsets.all(18.0),
              child: Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Uploading",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SpinKitChasingDots(color: Colors.indigo),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile'), centerTitle: true),
      body: BlocConsumer<AccountBloc, AccountStates>(
        listener: (context, state) {
          if (state is UpdateMyProfilePictureLoadingState) {
            context.pop();
            _showLoadingDialog(context);
          } else if (state is UpdateMyProfilePictureLoadedState) {
            context.pop();
            context.read<AccountBloc>().add(GetMyProfileDetailsEvent());
          } else if (state is UpdateMyProfilePicturesFailedState) {
            context.pop();
          }
        },

        buildWhen: (prev, current) {
          return current is GetMyProfileDetailsLoadingState ||
              current is GetMyProfileDetailsLoadedState ||
              current is GetMyProfileDetailsFailedState;
        },
        builder: (context, state) {
          if (state is GetMyProfileDetailsLoadingState) {
            return Center(child: SizedBox(width: 20, height: 20));
          } else if (state is GetMyProfileDetailsLoadedState) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 20.0),
                    // Profile Picture and Edit Icon
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(
                            state.myProfile.imageUrl!,
                          ),
                          backgroundColor: Colors.grey[300],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            child: IconButton(
                              icon: Icon(Icons.edit, color: Colors.white),
                              onPressed: () {
                                showModalBottomSheet(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  isScrollControlled: false,
                                  context: context,
                                  builder: (context) {
                                    return UpdateProfilePictureBottomSheet(
                                      imageUrl: state.myProfile.imageUrl!,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Name Field
                        ProfileFieldWidget(
                          text: state.myProfile.name!,
                          onTap: () {},
                        ),

                        SizedBox(height: 20.0),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "About",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Status Field
                        ProfileFieldWidget(
                          text: state.myProfile.about!,
                          onTap: () {},
                        ),

                        SizedBox(height: 20.0),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Phone Number",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // Status Field
                        ProfileFieldWidget(
                          text: "+91${state.myProfile.phone!}",
                          onTap: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else if (state is GetMyProfileDetailsFailedState) {
            return Center(
              child: Column(
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: Colors.red,
                    size: 72,
                  ),
                  Text(state.message),
                ],
              ),
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/presentation/bloc/buddy/buddy_bloc.dart';
import 'new_buddy_item.dart';

class AddBuddiesBottomSheet extends StatelessWidget {
  const AddBuddiesBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: BlocConsumer<BuddyBloc, BuddyStates>(
        listenWhen: (prev, current) {
          return current is AddBuddyLoadingState ||
              current is AddBuddyLoadedState ||
              current is AddBuddyFailedState;
        },
        listener: (context, state) {
          if (state is AddBuddyLoadingState) {
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Center(
                    child: Text(
                      "Loading",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  content: SizedBox(
                    height: 36,
                    width: 36,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [CircularProgressIndicator()],
                    ),
                  ),
                );
              },
            );
          } else if (state is AddBuddyLoadedState) {
            context.pop();
            context.read<BuddyBloc>().add(GetMyBuddiesEvent());
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Buddy Added Successfully")));
          } else if (state is AddBuddyFailedState) {
            context.pop();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        buildWhen: (prev, current) {
          return current is GetBuddiesLoadingState ||
              current is GetBuddiesLoadedState ||
              current is GetBuddiesFailedState;
        },
        builder: (context, state) {
          if (state is GetBuddiesLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is GetBuddiesLoadedState) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Add New Buddies",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 10),
                ListView.builder(
                  itemCount: state.buddies.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return NewBuddyItem(
                      buddy: state.buddies[index],
                      onTap:
                          () => context.read<BuddyBloc>().add(
                            AddBuddyEvent(buddy: state.buddies[index]),
                          ),
                    );
                  },
                ),
              ],
            );
          } else if (state is GetBuddiesFailedState) {
            return Center(child: Text(state.message));
          }
          return SizedBox();
        },
      ),
    );
  }
}

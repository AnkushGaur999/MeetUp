import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meet_up/presentation/bloc/buddy/buddy_bloc.dart';
import 'package:meet_up/presentation/pages/dashboard/status/widgets/status_item.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Status"),),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<BuddyBloc>().add(GetMyBuddiesEvent());
          context.read<BuddyBloc>().add(GetAllBuddiesEvent());
        },
        child: BlocBuilder<BuddyBloc, BuddyStates>(
          buildWhen: (prev, current) {
            return current is MyBuddiesLoadingState ||
                current is MyBuddiesLoadedState ||
                current is MyBuddiesFailedState;
          },
          builder: (context, state) {
            if (state is MyBuddiesLoadingState) {
              return Center(child: CircularProgressIndicator());
            } else if (state is MyBuddiesLoadedState) {

              if(state.buddies.isEmpty){
                return Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(),
                    Text("Buddy list is empty.")
                  ],
                );
              }

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: state.buddies.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {

                    final buddy = state.buddies[index];

                    return GestureDetector(
                      onTap: (){

                      },
                      child: StatusItem(buddy: buddy),
                    );
                  },
                ),
              );
            } else if (state is MyBuddiesFailedState) {
              return Center(child: Text(state.message));
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}

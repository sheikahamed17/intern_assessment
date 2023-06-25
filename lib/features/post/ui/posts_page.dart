import 'package:bloc_practice/features/post/bloc/posts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({super.key});

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  final PostsBloc postsBloc = PostsBloc();
  @override
  void initState() {
    postsBloc.add(PostsInitialFetchEvent());
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Posts Page"),
        ),
        body: BlocConsumer<PostsBloc, PostsState>(
            bloc: postsBloc,
            listenWhen: (previous, current) => current is PostsActionState,
            buildWhen: (previous, current) => current is! PostsActionState,
            listener: (context, state) {},
            builder: (context, state) {
              switch (state.runtimeType) {
                case PostsFetchingLoadingState:
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                case PostFetchingSuccessfulState:
                  final successState = state as PostFetchingSuccessfulState;
                  return Container(
                    child: ListView.builder(
                        itemCount: successState.posts.length,
                        itemBuilder: (context, index) {
                          Container(
                            child: Column(
                              children: [
                                Text(successState.posts[index].title),
                              ],
                            ),
                          );
                        }),
                  );

                default:
                  return const SizedBox();
              }
            }));
  }
}

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_practice/features/post/models/post_data_ui_model.dart';
import 'package:bloc_practice/features/post/repos/posts_repo.dart';
import 'package:meta/meta.dart';

part 'posts_event.dart';
part 'posts_state.dart';

class PostsBloc extends Bloc<PostsEvent, PostsState> {
  PostsBloc() : super(PostsInitial()) {
    on<PostsInitialFetchEvent>(postsInitialFetchEvent);
    on<PostAddEvent>(postAddEvent);
  }

  FutureOr<void> postsInitialFetchEvent(
      PostsInitialFetchEvent event, Emitter<PostsState> emit) async {
    emit(PostsFetchingLoadingState());
    List<PostDataUiModel> posts = await PostsRepo.fetchPosts();
    emit(PostFetchingSuccessfulState(posts: posts));
  }

  FutureOr<bool> postAddEvent(
    PostAddEvent event,
    Emitter<PostsState> emit,
  ) async {
    bool success = await PostsRepo.addPost("new post");
    //print(success);
    if (success) {
      emit(PostsAdditionSuccessState());
      return success;
    } else {
      emit(PostsAdditionErrorState());
      return success;
    }
  }
}

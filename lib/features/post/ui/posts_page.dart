import 'package:bloc_practice/features/post/bloc/posts_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

  final GlobalKey<FormState> key = GlobalKey<FormState>();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  bool success = false;
  String name = "";
  String title = "";
  Widget build(BuildContext context) {
    var ScreenSize = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
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
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20)),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0.0, 0.7), //(x,y)
                                  blurRadius: 4.0,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: ScreenSize.height * 0.03),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Add Comments",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                  SizedBox(
                                    height: ScreenSize.height * 0.02,
                                  ),
                                  Image.asset("assets/images/CreditCard.png"),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: ScreenSize.height * 0.02,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: ScreenSize.width * 0.045,
                            ),
                            child: TextField(
                              controller: _searchController,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: 'Search',
                                filled: true,
                                fillColor: const Color(0xfff1f1f4),
                                focusColor: const Color(0xfff1f1f4),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Colors.black12, width: 2.0)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(30),
                                    borderSide: const BorderSide(
                                        color: Colors.black12, width: 2.0)),
                                border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.black12, width: 2.0),
                                    borderRadius: BorderRadius.circular(30)),
                                prefixIcon: const Icon(Icons.search),
                              ),
                              onChanged: (val) {
                                setState(() {
                                  name = val;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 10,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: ScreenSize.width * 0.045,
                                  vertical: ScreenSize.height * 0.015),
                              child: ListView.builder(
                                  itemCount: successState.posts.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      shape: RoundedRectangleBorder(
                                          side: const BorderSide(width: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      elevation: 1,
                                      color: const Color(0xfff1f1f4),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              successState
                                                  .posts[index].thumbnailUrl),
                                          backgroundColor: Colors.white,
                                          radius: ScreenSize.height * 0.025,
                                        ),
                                        style: ListTileStyle.list,
                                        title: Text(
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            successState.posts[index].title),
                                        trailing: IconButton(
                                          icon: success
                                              ? Icon(Icons.check)
                                              : Icon(Icons.add),
                                          onPressed: () {
                                            success ? null : addPost();
                                          },
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                          ),
                          success
                              ? Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: ScreenSize.width * 0.045),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                        side: const BorderSide(width: 0.5),
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    elevation: 1,
                                    color: const Color(0xfff1f1f4),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage: const NetworkImage(
                                            "https://www.google.com/s2/favicons?sz=64&domain_url=yahoo.com"),
                                        backgroundColor: Colors.white,
                                        radius: ScreenSize.height * 0.025,
                                      ),
                                      style: ListTileStyle.list,
                                      title: Text(
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          title),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.add),
                                        onPressed: () {
                                          addPost();
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    );
                  default:
                    return const SizedBox();
                }
              })),
    );
  }

  Future<void> addPost() async {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return Form(
            key: key,
            child: AlertDialog(
              title: const Text("Type Below"),
              content: TextFormField(
                textAlign: TextAlign.justify,
                //expands: true,
                maxLines: 3,
                autofocus: true,
                controller: _titleController,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  hintText: 'Comment',
                  filled: true,
                  fillColor: const Color(0xfff1f1f4),
                  focusColor: const Color(0xfff1f1f4),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.black12, width: 2.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: Colors.black12, width: 2.0)),
                  border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.black12, width: 2.0),
                      borderRadius: BorderRadius.circular(10)),
                ),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onSaved: (value) {
                  _titleController.text = value!;
                  title = value;
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return ("Type your comment");
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
              ),
              actions: [
                SizedBox(
                  height: 40,
                  width: 50,
                  child: GestureDetector(
                    onTap: () {
                      if (key.currentState!.validate()) {
                        setState(() {
                          postsBloc.add(PostAddEvent());
                          success = true;
                          Navigator.of(context).pop();
                          final snackBar = SnackBar(
                            behavior: SnackBarBehavior.floating,
                            width: 300,
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                side: const BorderSide(
                                    width: 0.5, color: Color(0xffd0cfed)),
                                borderRadius: BorderRadius.circular(15)),
                            backgroundColor: const Color(0xffd0cfed),
                            content: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text("New Content was added!"),
                                Icon(
                                  Icons.check_circle_outline_rounded,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          _titleController.text = "";
                        });
                      } else {
                        Fluttertoast.showToast(msg: "Comment is mandatory!");
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xff5f41f0),
                      ),
                      child: const Center(
                        child: Text(
                          "Add",
                          style: TextStyle(color: Colors.white, fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }
}

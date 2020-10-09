import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:structure_flutter_mobile/bloc/blocs/user_bloc.dart';
import 'package:structure_flutter_mobile/bloc/events/user_event.dart';
import 'package:structure_flutter_mobile/bloc/states/user_state.dart';
import 'package:structure_flutter_mobile/di/injection.dart';

class ListUserPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ListUserPageState();
  }
}

class ListUserPageState extends State<ListUserPage> {
  ScrollController _scrollController;
  final _userGitBloc = getIt<UserGitBloc>();
  final _thresholdPixel = 200.0; // pixel

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener((_onScroll));
    _userGitBloc.dispatch(Fetch());
  }

  @override
  void dispose() {
    _userGitBloc.dispose();
    super.dispose();
  }

  _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _thresholdPixel) {
      _userGitBloc.dispatch(Fetch());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder(
          bloc: _userGitBloc,
          builder: _builderBloc,
        ),
      ),
    );
  }

  Widget _builderBloc(BuildContext context, UserGitState state) {
    if (state is UserGitUnInitialized) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    if (state is UserGitError) {
      return Center(
        child: Text('failed to fetch posts'),
      );
    }
    if (state is UserGitLoaded) {
      if (state.users.isNotEmpty) {
        return _buildListView(state);
      }
    }
    return Center(
      child: Text('no posts'),
    );
  }

  _buildListView(UserGitLoaded state) {
    var size = MediaQuery.of(context).size;
    return ListView.builder(
      controller: _scrollController,
      itemBuilder: (BuildContext context, int index) {
        return index == state.users.length
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: SizedBox(
                        width: size.width * 0.2,
                        height: size.height * 0.1,
                        child: Stack(
                          children: [
                            Center(
                              child: CircularProgressIndicator(),
                            ),
                            Image(
                              image: NetworkImage(state.users[index].avatar),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 16),
                      child: Text(
                        state.users[index].name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                            color: Colors.black87,
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ],
                ),
              );
      },
      itemCount:
          state.hasReachMax ? state.users.length : state.users.length + 1,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nubanktest/config/server_config.dart';
import 'package:nubanktest/di/di.dart';
import 'package:nubanktest/domain/entities/short_url.entity.dart';
import 'package:nubanktest/presenter/home/home.bloc.dart';

class InheritedDataProvider extends InheritedWidget {
  final HomeBloc bloc;
  final Widget child;

  const InheritedDataProvider(this.bloc, this.child, {Key? key})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedDataProvider oldWidget) =>
      child != oldWidget.child;

  static HomeBloc? of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<InheritedDataProvider>()
        ?.bloc;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("URL Shortener"),
        centerTitle: true,
        elevation: 0,
      ),
      body: const Padding(
        padding: EdgeInsets.all(12.0),
        child: ShortenedBody(),
      ),
    );
  }
}

class ShortenedBody extends StatelessWidget {
  const ShortenedBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = InheritedDataProvider.of(context);

    return BlocProvider(
      create: (context) => bloc ?? Injector().di.get<HomeBloc>(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          SearchBar(),
          Expanded(child: ShortenedList()),
        ],
      ),
    );
  }
}

class ShortenedList extends StatelessWidget {
  const ShortenedList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc =
        InheritedDataProvider.of(context) ?? Injector().di.get<HomeBloc>();

    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                width: double.maxFinite,
                child: Text(
                  "Recently shortened URLs",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                width: double.maxFinite,
                padding: const EdgeInsets.only(top: 8.0),
                child: const Text(
                  "${ServerConfig.BASE_URL}/short/",
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ),
            ],
          ),
          const Divider(
            color: Colors.black26,
            height: 40,
            endIndent: 24,
            thickness: 1,
          ),
          BlocConsumer<HomeBloc, HomeState>(
            builder: (BuildContext context, state) {
              if (state is HomeInitialState) {
                return const Text("Shortened URLs will appear here");
              }

              return Flexible(
                child: Column(
                  children: [
                    if (state is HomeErrorState) errorMessageBox(state.message),
                    if (state is HomeShortenedUrlNotFoundState)
                      errorMessageBox(state.message),
                    Visibility(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: CircularProgressIndicator(),
                      ),
                      visible: state is HomeLoadingState,
                    ),
                    Flexible(
                      child: URLsList(
                        bloc: bloc,
                        state: state,
                      ),
                    ),
                  ],
                ),
              );
            },
            listener: (BuildContext context, state) {
              if (state is HomeUrlShortenedState) {
                bloc.urlsList.add(state.shortUrl);
              } else if (state is HomeUrlCopiedToClipBoardState) {
                Clipboard.setData(ClipboardData(text: state.copiedUrl));

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '"${state.copiedUrl}" \n copied to clipboard',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class URLsList extends StatefulWidget {
  final HomeState state;
  final HomeBloc bloc;

  const URLsList({
    Key? key,
    required this.state,
    required this.bloc,
  }) : super(key: key);

  @override
  _URLsListState createState() => _URLsListState();
}

class _URLsListState extends State<URLsList> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ShortUrl>(
        stream: widget.bloc.shortenedUrl,
        builder: (context, snapshot) {
          final urls = snapshot.data;

          if (urls == null) {
            return const Text("Nao era pra eu aparecer man D:");
          }

          return ListView.separated(
            shrinkWrap: true,
            itemCount: widget.bloc.urlsList.length,
            reverse: true,
            separatorBuilder: (_, __) => const SizedBox(height: 8.0),
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            itemBuilder: (context, index) {
              final url = widget.bloc.urlsList[index];

              return Column(
                children: [
                  ListTile(
                    title: Text(url.alias),
                    trailing: (widget.state is HomeShowUrlOptionsState &&
                            widget.bloc.showAliasUrl == url.alias)
                        ? const Icon(
                            Icons.keyboard_arrow_up_outlined,
                            color: Colors.black87,
                          )
                        : const Icon(
                            Icons.keyboard_arrow_down_outlined,
                            color: Colors.black87,
                          ),
                    onTap: () {
                      widget.bloc.showAliasUrlChanged(url.alias);
                      widget.bloc.add(HomeShowUrlOptionsEvent());
                    },
                  ),
                  Divider(
                    color: Colors.deepPurpleAccent.withOpacity(0.7),
                    height: 10,
                    indent: 10,
                    endIndent: 10,
                    thickness: 0.7,
                  ),
                  if (widget.state is HomeShowUrlOptionsState &&
                      widget.bloc.showAliasUrl == url.alias)
                    Container(
                      child: Row(
                        children: [
                          TextButton(
                            onPressed: () async {
                              widget.bloc
                                  .add(HomeCopyOriginalUrlEvent(id: url.alias));
                            },
                            child: const Text("Copy original URL"),
                          ),
                          ElevatedButton(
                              onPressed: () => widget.bloc.add(
                                  HomeCopyShortenedUrlEvent(
                                      shortenedUrl: url.links.short)),
                              child: const Text("Copy shortened URL")),
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(20.0),
                          bottomLeft: Radius.circular(20.0),
                        ),
                        color: Colors.grey[200],
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                    ),
                ],
              );
            },
          );
        });
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bloc =
        InheritedDataProvider.of(context) ?? Injector().di.get<HomeBloc>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 5,
          child: Material(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                fillColor: Colors.black12,
                filled: true,
                border: InputBorder.none,
              ),
              keyboardType: TextInputType.url,
            ),
          ),
        ),
        Flexible(
          flex: 1,
          child: ElevatedButton(
            onPressed: () => controller.text.isNotEmpty
                ? bloc.add(HomeShortUrlEvent(urlToBeShortened: controller.text))
                : null,
            child: const Icon(Icons.send),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.all(12),
              shape: const CircleBorder(),
              primary: Colors.deepPurpleAccent,
              onPrimary: Colors.white,
            ),
          ),
        )
      ],
    );
  }
}

Widget errorMessageBox(String message) {
  return Container(
    width: double.maxFinite,
    padding: const EdgeInsets.all(12.0),
    decoration: BoxDecoration(
        color: Colors.red[300],
        borderRadius: const BorderRadius.all(Radius.circular(5))),
    child: Text(
      message,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

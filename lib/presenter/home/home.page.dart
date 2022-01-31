import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nubanktest/di/di.dart';
import 'package:nubanktest/domain/entities/short_url.entity.dart';
import 'package:nubanktest/presenter/home/home.bloc.dart';

HomeBloc bloc = Injector().di.get<HomeBloc>();

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
        title: const Text("Nubank Shortener"),
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
    return BlocProvider(
      create: (context) => bloc,
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
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Column(
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
          const Padding(
            padding: EdgeInsets.only(right: 24.0),
            child: Divider(
              color: Colors.black26,
              height: 40,
              thickness: 1,
            ),
          ),
          BlocConsumer<HomeBloc, HomeState>(
            builder: (BuildContext context, state) {
              if (state is HomeInitialState) {
                return const Text("Shortened URLs will appear here");
              }

              return Flexible(
                child: Column(
                  children: [
                    if (state is HomeErrorState)
                      Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                            color: Colors.red[300],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5))),
                        child: Text(
                          state.message,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    Visibility(
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: CircularProgressIndicator(),
                      ),
                      visible: state is HomeLoadingState,
                    ),
                    Flexible(
                      child: StreamBuilder<ShortUrl>(
                          stream: bloc.shortenedUrl,
                          builder: (context, snapshot) {
                            final urls = snapshot.data;

                            if (urls == null) {
                              return const SizedBox();
                            }

                            return ListView.separated(
                              shrinkWrap: true,
                              itemCount: bloc.urlsList.length,
                              reverse: true,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(height: 8.0),
                              padding: EdgeInsets.only(
                                bottom: MediaQuery.of(context).padding.bottom,
                              ),
                              itemBuilder: (context, index) {
                                final url = bloc.urlsList[index];

                                return ListTile(
                                  title: Text(url.alias),
                                  subtitle: Text(url.links.self),
                                );
                              },
                            );
                          }),
                    ),
                  ],
                ),
              );
            },
            listener: (BuildContext context, state) {
              if (state is HomeUrlShortenedState) {
                bloc.urlsList.add(state.shortUrl);
              }
            },
          ),
        ],
      ),
    );
  }
}

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController controller =
      TextEditingController(text: "www.google.com");

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          flex: 5,
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
        Flexible(
          flex: 1,
          child: ElevatedButton(
            onPressed: () =>
                bloc.add(ShortUrlEvent(urlToBeShortened: controller.text)),
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

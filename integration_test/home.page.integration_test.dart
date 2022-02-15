import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teststudy/data/models/links/links.model.dart';
import 'package:teststudy/data/models/short_url/short_url.model.dart';
import 'package:teststudy/di/di.dart';
import 'package:teststudy/domain/usecases/get_original_url.usecase.dart';
import 'package:teststudy/domain/usecases/short_url.usecase.dart';
import 'package:teststudy/main.dart' as app;
import 'package:teststudy/presenter/home/home.bloc.dart';
import 'package:teststudy/presenter/home/home.page.dart';

import 'home.page.integration_test.mocks.dart';

@GenerateMocks([GetOriginalUrlUseCase])
@GenerateMocks([ShortUrlUseCase])
void main() {
  late MockShortUrlUseCase mockShortUrlUseCase;
  late MockGetOriginalUrlUseCase mockGetOriginalUrlUseCase;
  late HomeBloc bloc;

  const testUrl = "https://www.google.com";

  const testUrlAlias = "28431";

  const testShortUrl = ShortUrlModel(
    alias: '28431',
    links: LinksModel(
      self: "https://www.google.com",
      short: "https://url-shortener-nu.herokuapp.com/short/28431",
    ),
  );

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    mockShortUrlUseCase = MockShortUrlUseCase();
    mockGetOriginalUrlUseCase = MockGetOriginalUrlUseCase();

    bloc = HomeBloc(
      shortUrlUseCase: mockShortUrlUseCase,
      getOriginalUrlUseCase: mockGetOriginalUrlUseCase,
    );
  });

  Widget createWidgetForTesting(Widget child) {
    return Material(child: child);
  }

  updateShortenedList(WidgetTester tester) async {
    var shortenedProvider = BlocProvider<HomeBloc>(
      create: (_) => bloc,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: createWidgetForTesting(const ShortenedList()),
      ),
    );

    await tester.pumpWidget(shortenedProvider);
    await tester.pump(Duration.zero);
  }

  group('Integration home page test', () {
    testWidgets('''Should insert URL to be shortened in the TextField,
                tap the elevated button and verify if shortened appears on ListView''',
        (WidgetTester tester) async {
      when(bloc.shortUrlUseCase(testUrl))
          .thenAnswer((_) async => const Right(testShortUrl));

      app.main();
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        MaterialApp(
          home: BlocProvider<HomeBloc>(
            create: (_) => bloc,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: createWidgetForTesting(
                InheritedDataProvider(
                  bloc,
                  const HomePage(),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.byType(HomePage), findsOneWidget);

      bloc = Injector().di.get<HomeBloc>();

      expect(find.byType(ShortenedBody), findsOneWidget);

      expect(find.text("Shortened URLs will appear here"), findsOneWidget);

      expect(find.byType(SearchBar), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);

      await tester.enterText(find.byType(TextField), testUrl);
      await tester.press(find.byType(ElevatedButton));

      await updateShortenedList(tester);

      await tester.pump();

      await tester.runAsync(() async {
        bloc.add(HomeShortUrlEvent(urlToBeShortened: testUrl));
        bloc.urlsList.add(testShortUrl);
        await bloc.onShortenedChanged(testShortUrl);

        await tester.pump();

        expect(find.text("Shortened URLs will appear here"), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pumpAndSettle();

        expect(find.byType(CircularProgressIndicator), findsNothing);

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(),
            child: BlocProvider<HomeBloc>(
              create: (_) => bloc,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: createWidgetForTesting(
                  URLsList(
                    bloc: bloc,
                    state: bloc.state,
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();
        await tester.idle();
        await tester.pump(Duration.zero);
      });

      expect(bloc.urlsList.length, 1);
      expect(find.text(testShortUrl.alias), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets("Should load shortened URLs ListView and click on the item",
        (WidgetTester tester) async {
      bloc = Injector().di.get<HomeBloc>();

      await tester.runAsync(() async {
        await bloc.onShortenedChanged(testShortUrl);
        await bloc.showAliasUrlChanged(testUrlAlias);

        bloc.urlsList.add(testShortUrl);

        bloc.add(HomeShowUrlOptionsEvent());

        await tester.pumpAndSettle();
        await tester.idle();
        await tester.pump(Duration.zero);

        await tester.pumpWidget(
          MediaQuery(
            data: const MediaQueryData(),
            child: BlocProvider<HomeBloc>(
              create: (_) => bloc,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: createWidgetForTesting(
                  URLsList(
                    bloc: bloc,
                    state: bloc.state,
                  ),
                ),
              ),
            ),
          ),
        );

        await tester.pump();

        expect(find.byType(ListTile), findsOneWidget);
        await tester.press(find.byType(ListTile));

        await tester.pump();

        expect(find.text("Copy original URL"), findsOneWidget);
        expect(find.text("Copy shortened URL"), findsOneWidget);
      });
    });
  });
}

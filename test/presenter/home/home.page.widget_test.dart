import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:nubanktest/data/models/links/links.model.dart';
import 'package:nubanktest/data/models/short_url/short_url.model.dart';
import 'package:nubanktest/di/di.dart';
import 'package:nubanktest/domain/usecases/get_original_url.usecase.dart';
import 'package:nubanktest/domain/usecases/short_url.usecase.dart';
import 'package:nubanktest/presenter/home/home.bloc.dart';
import 'package:nubanktest/presenter/home/home.page.dart';

import 'home.page.widget_test.mocks.dart';

@GenerateMocks([GetOriginalUrlUseCase])
@GenerateMocks([ShortUrlUseCase])
void main() {
  late MockShortUrlUseCase mockShortUrlUseCase;
  late MockGetOriginalUrlUseCase mockGetOriginalUrlUseCase;
  late HomeBloc bloc;

  const testUrl = "https://www.google.com";

  const testShortUrl = ShortUrlModel(
    alias: '28431',
    links: LinksModel(
      self: "https://www.google.com",
      short: "https://url-shortener-nu.herokuapp.com/short/28431",
    ),
  );

  setUpAll(() {mockShortUrlUseCase = MockShortUrlUseCase();
    mockGetOriginalUrlUseCase = MockGetOriginalUrlUseCase();

    Injector().di.registerFactory(() => HomeBloc(
          shortUrlUseCase: mockShortUrlUseCase,
          getOriginalUrlUseCase: mockGetOriginalUrlUseCase,
        ));

    bloc = Injector().di.get<HomeBloc>();
  });

  Widget createWidgetForTesting(Widget child) {
    return MaterialApp(home: child);
  }

  updateShortenedList(WidgetTester tester) async {
    var shortenedProvider = BlocProvider<HomeBloc>(
        create: (_) => bloc, child: const ShortenedList());
    await tester.pumpWidget(createWidgetForTesting(shortenedProvider));
    await tester.pump(Duration.zero);
  }

  testWidgets('Should pump HomePage', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(const HomePage()));

    expect(find.byType(HomePage), findsOneWidget);
  });

  testWidgets('Should pump ShortenedBody and retrieve bloc from di',
      (WidgetTester tester) async {
    var shortenedProvider = BlocProvider<HomeBloc>(
        create: (_) => bloc, child: const ShortenedBody());
    await tester.pumpWidget(createWidgetForTesting(shortenedProvider));
    await tester.pumpAndSettle();

    expect(find.byType(ShortenedBody), findsOneWidget);
  });

  testWidgets('Should pump SearchBar', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetForTesting(const SearchBar()));

    expect(find.byType(SearchBar), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });

  testWidgets('Should pump ShortenedBody and update shortened URLs list',
      (WidgetTester tester) async {
    when(bloc.shortUrlUseCase(testUrl))
        .thenAnswer((_) async => const Right(testShortUrl));

    await tester.pumpWidget(createWidgetForTesting(const ShortenedBody()));

    await tester.pump();

    expect(find.text("Shortened URLs will appear here"), findsOneWidget);

    await tester.enterText(find.byType(TextField), testUrl);
    await tester.press(find.byType(ElevatedButton));

    await tester.pumpAndSettle();

    bloc.add(HomeShortUrlEvent(urlToBeShortened: testUrl));

    await updateShortenedList(tester);

    verify(mockShortUrlUseCase(testUrl));

    expect(find.text("Shortened URLs will appear here"), findsNothing);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}

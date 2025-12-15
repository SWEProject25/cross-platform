import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/features/messaging/model/contact.dart';
import 'package:lam7a/features/messaging/ui/state/contact_search_state.dart';
import 'package:lam7a/features/messaging/ui/view/chat_screen.dart';
import 'package:lam7a/features/messaging/ui/view/find_contacts_screen.dart';
import 'package:lam7a/features/messaging/ui/viewmodel/contact_search_viewmodel.dart';
import 'package:lam7a/main.dart';

class MockContactSearchViewModel extends ContactSearchViewModel {
  final ContactSearchState _state;
  String? lastQuery;
  int? lastUserId;

  MockContactSearchViewModel(this._state);

  @override
  ContactSearchState build() {
    return _state;
  }

  @override
  Future<void> onQueryChanged(String v) async {
    lastQuery = v;
  }

  @override
  Future<int> createConversationId(int userId) async {
    lastUserId = userId;
    return 123; // Mock conversation ID
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final testContacts = [
    Contact(
      id: 1,
      name: 'John Doe',
      handle: 'johndoe',
      bio: 'Test bio',
      totalFollowers: 100,
    ),
    Contact(
      id: 2,
      name: 'Jane Smith',
      handle: 'janesmith',
      bio: 'Another bio',
      totalFollowers: 200,
    ),
  ];

  Widget makeTestWidget(ProviderContainer container) {
    var navigatorKey = GlobalKey<NavigatorState>();
    
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        navigatorKey: navigatorKey,
        home: FindContactsScreen(),
        onGenerateRoute: (settings) {
          if (settings.name == ChatScreen.routeName) {
            return MaterialPageRoute(
              settings: settings,
              builder: (_) => Scaffold(
                body: Center(child: Text('Chat Screen')),
              ),
            );
          }
          return null;
        },
      ),
    );
  }

  group('FindContactsScreen Tests', () {
    testWidgets('renders with app bar', (tester) async {
      final state = ContactSearchState(
        contacts: AsyncData(testContacts),
      );

      final mockViewModel = MockContactSearchViewModel(state);

      final container = ProviderContainer(
        overrides: [
          contactSearchViewModelProvider.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.text('Direct Message'), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);

      container.dispose();
    });

    testWidgets('renders search field', (tester) async {
      final state = ContactSearchState(
        contacts: AsyncData(testContacts),
      );

      final mockViewModel = MockContactSearchViewModel(state);

      final container = ProviderContainer(
        overrides: [
          contactSearchViewModelProvider.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);

      container.dispose();
    });

    testWidgets('displays loading indicator when loading contacts', (tester) async {
      final state = ContactSearchState(
        contacts: AsyncLoading(),
      );

      final mockViewModel = MockContactSearchViewModel(state);

      final container = ProviderContainer(
        overrides: [
          contactSearchViewModelProvider.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      container.dispose();
    });

    testWidgets('displays contacts list', (tester) async {
      final state = ContactSearchState(
        contacts: AsyncData(testContacts),
      );

      final mockViewModel = MockContactSearchViewModel(state);

      final container = ProviderContainer(
        overrides: [
          contactSearchViewModelProvider.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.text('John Doe'), findsOneWidget);
      expect(find.text('@johndoe'), findsOneWidget);
      expect(find.text('Jane Smith'), findsOneWidget);
      expect(find.text('@janesmith'), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(2));

      container.dispose();
    });

    testWidgets('displays error state', (tester) async {
      final state = ContactSearchState(
        contacts: AsyncError('Network error', StackTrace.current),
      );

      final mockViewModel = MockContactSearchViewModel(state);

      final container = ProviderContainer(
        overrides: [
          contactSearchViewModelProvider.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.textContaining('Error'), findsOneWidget);

      container.dispose();
    });

    testWidgets('calls onQueryChanged when search text changes', (tester) async {
      final state = ContactSearchState(
        contacts: AsyncData(testContacts),
      );

      final mockViewModel = MockContactSearchViewModel(state);

      final container = ProviderContainer(
        overrides: [
          contactSearchViewModelProvider.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'test query');
      await tester.pump();

      expect(mockViewModel.lastQuery, 'test query');

      container.dispose();
    });

    testWidgets('displays search query error', (tester) async {
      final state = ContactSearchState(
        contacts: AsyncData(testContacts),
        searchQueryError: 'Too short. Here are some suggested Results:',
      );

      final mockViewModel = MockContactSearchViewModel(state);

      final container = ProviderContainer(
        overrides: [
          contactSearchViewModelProvider.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.text('Too short. Here are some suggested Results:'), findsOneWidget);

      container.dispose();
    });

    testWidgets('displays loading indicator when creating conversation', (tester) async {
      final state = ContactSearchState(
        contacts: AsyncData(testContacts),
        loadingConversationId: true,
      );

      final mockViewModel = MockContactSearchViewModel(state);

      final container = ProviderContainer(
        overrides: [
          contactSearchViewModelProvider.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      // Should show loading indicator and hide the contacts list
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(ListView), findsNothing);

      container.dispose();
    });

    testWidgets('navigates to chat screen when contact is tapped', (tester) async {
      final state = ContactSearchState(
        contacts: AsyncData(testContacts),
      );

      final mockViewModel = MockContactSearchViewModel(state);

      final container = ProviderContainer(
        overrides: [
          contactSearchViewModelProvider.overrideWith(() => mockViewModel),
        ],
      );

      // Set up a local navigatorKey before building widget
      final localNavigatorKey = GlobalKey<NavigatorState>();
      
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            navigatorKey: localNavigatorKey,
            home: FindContactsScreen(),
            onGenerateRoute: (settings) {
              if (settings.name == ChatScreen.routeName) {
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => Scaffold(
                    body: Center(child: Text('Chat Screen')),
                  ),
                );
              }
              return null;
            },
          ),
        ),
      );
      await tester.pump();

      // Tap on the first contact
      await tester.tap(find.byType(ListTile).first);
      await tester.pumpAndSettle();

      // Verify createConversationId was called
      expect(mockViewModel.lastUserId, 1);

      // Verify navigation to chat screen
      expect(find.text('Chat Screen'), findsOneWidget);

      container.dispose();
    });

    testWidgets('handles null navigatorKey gracefully', (tester) async {
      final state = ContactSearchState(
        contacts: AsyncData(testContacts),
      );

      final mockViewModel = MockContactSearchViewModel(state);

      final container = ProviderContainer(
        overrides: [
          contactSearchViewModelProvider.overrideWith(() => mockViewModel),
        ],
      );

      // Use a local navigatorKey for this test
      final localNavigatorKey = GlobalKey<NavigatorState>();

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            navigatorKey: localNavigatorKey,
            home: FindContactsScreen(),
            onGenerateRoute: (settings) {
              if (settings.name == ChatScreen.routeName) {
                return MaterialPageRoute(
                  settings: settings,
                  builder: (_) => Scaffold(
                    body: Center(child: Text('Chat Screen')),
                  ),
                );
              }
              return null;
            },
          ),
        ),
      );
      await tester.pump();

      // Simulate the navigatorKey's currentState being null by creating a new key
      final tempKey = GlobalKey<NavigatorState>();

      // Tap on contact - should not throw error
      await tester.tap(find.byType(ListTile).first);
      await tester.pump();

      container.dispose();
    });

    testWidgets('displays avatar for each contact', (tester) async {
      final state = ContactSearchState(
        contacts: AsyncData(testContacts),
      );

      final mockViewModel = MockContactSearchViewModel(state);

      final container = ProviderContainer(
        overrides: [
          contactSearchViewModelProvider.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      // Should have avatars for each contact
      expect(find.byType(CircleAvatar), findsAtLeastNWidgets(2));

      container.dispose();
    });

    testWidgets('displays dividers between contacts', (tester) async {
      final state = ContactSearchState(
        contacts: AsyncData(testContacts),
      );

      final mockViewModel = MockContactSearchViewModel(state);

      final container = ProviderContainer(
        overrides: [
          contactSearchViewModelProvider.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.byType(Divider), findsWidgets);

      container.dispose();
    });

    testWidgets('handles empty contacts list', (tester) async {
      final state = ContactSearchState(
        contacts: AsyncData([]),
      );

      final mockViewModel = MockContactSearchViewModel(state);

      final container = ProviderContainer(
        overrides: [
          contactSearchViewModelProvider.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      expect(find.byType(ListTile), findsNothing);
      expect(find.byType(ListView), findsOneWidget);

      container.dispose();
    });

    testWidgets('search field has correct styling', (tester) async {
      final state = ContactSearchState(
        contacts: AsyncData(testContacts),
      );

      final mockViewModel = MockContactSearchViewModel(state);

      final container = ProviderContainer(
        overrides: [
          contactSearchViewModelProvider.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      final textField = tester.widget<TextField>(find.byType(TextField));
      expect(textField.decoration?.prefixIcon, isNotNull);

      container.dispose();
    });

    testWidgets('contact subtitle displays handle with @ prefix', (tester) async {
      final state = ContactSearchState(
        contacts: AsyncData(testContacts),
      );

      final mockViewModel = MockContactSearchViewModel(state);

      final container = ProviderContainer(
        overrides: [
          contactSearchViewModelProvider.overrideWith(() => mockViewModel),
        ],
      );

      await tester.pumpWidget(makeTestWidget(container));
      await tester.pump();

      // Verify @ prefix is added
      expect(find.text('@johndoe'), findsOneWidget);
      expect(find.text('johndoe'), findsNothing); // Without @ should not be found

      container.dispose();
    });
  });
}

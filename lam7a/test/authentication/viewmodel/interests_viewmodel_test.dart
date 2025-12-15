import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lam7a/features/authentication/model/interest_dto.dart';
import 'package:lam7a/features/authentication/repository/authentication_impl_repository.dart';
import 'package:lam7a/features/authentication/ui/viewmodel/interests_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthenticationRepositoryImpl extends Mock
    implements AuthenticationRepositoryImpl {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAuthenticationRepositoryImpl mockRepo;
  late ProviderContainer container;

  setUp(() {
    mockRepo = MockAuthenticationRepositoryImpl();

    container = ProviderContainer(
      overrides: [
        authenticationImplRepositoryProvider.overrideWithValue(mockRepo),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('InterestsViewModel - build (Initial State)', () {
    test('should load interests successfully on build', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: 'technology', description: 'Tech related', icon: 'tech_icon'),
        InterestDto(id: 2, name: 'Sports', slug: 'sports', description: 'Sports related', icon: 'sports_icon'),
        InterestDto(id: 3, name: 'Music', slug: 'music', description: 'Music related', icon: 'music_icon'),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);

      final interests = await container.read(interestsViewModelProvider.future);

      expect(interests, mockInterests);
      expect(interests.length, 3);
      expect(interests[0].name, 'Technology');
      expect(interests[0].slug, 'technology');
      expect(interests[1].name, 'Sports');
      expect(interests[2].name, 'Music');
      
      verify(() => mockRepo.getInterests()).called(1);
    });

    test('should return empty list when no interests available', () async {
      when(() => mockRepo.getInterests()).thenAnswer((_) async => []);

      final interests = await container.read(interestsViewModelProvider.future);

      expect(interests, isEmpty);
      verify(() => mockRepo.getInterests()).called(1);
    });

    test('should handle single interest', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: 'technology', description: 'Tech related', icon: 'tech_icon'),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);

      final interests = await container.read(interestsViewModelProvider.future);

      expect(interests.length, 1);
      expect(interests[0].id, 1);
      expect(interests[0].name, 'Technology');
      expect(interests[0].slug, 'technology');
      expect(interests[0].description, 'Tech related');
      expect(interests[0].icon, 'tech_icon');
    });

    test('should have loading state initially', () {
      when(() => mockRepo.getInterests()).thenAnswer(
        (_) async => Future.delayed(
          const Duration(milliseconds: 100),
          () => [],
        ),
      );

      final state = container.read(interestsViewModelProvider);

      expect(state, isA<AsyncLoading>());
    });


    test('should load multiple interests with different properties', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: 'technology', description: 'All about tech', icon: 'tech'),
        InterestDto(id: 2, name: 'Sports', slug: 'sports', description: 'Physical activities', icon: 'sports'),
        InterestDto(id: 3, name: 'Music', slug: 'music', description: 'Musical interests', icon: 'music'),
        InterestDto(id: 4, name: 'Art', slug: 'art', description: 'Artistic pursuits', icon: 'art'),
        InterestDto(id: 5, name: 'Travel', slug: 'travel', description: 'Exploring the world', icon: 'travel'),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);

      final interests = await container.read(interestsViewModelProvider.future);

      expect(interests.length, 5);
      expect(interests.map((i) => i.id).toList(), [1, 2, 3, 4, 5]);
      expect(interests.map((i) => i.name).toList(),
          ['Technology', 'Sports', 'Music', 'Art', 'Travel']);
      expect(interests.map((i) => i.slug).toList(),
          ['technology', 'sports', 'music', 'art', 'travel']);
    });
  });

  group('InterestsViewModel - selectInterests', () {
    test('should call selectInterests with list of interest IDs', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: 'technology', description: 'Tech', icon: 'tech'),
        InterestDto(id: 2, name: 'Sports', slug: 'sports', description: 'Sports', icon: 'sports'),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);
      when(() => mockRepo.selectInterests(any())).thenAnswer((_) async => {});

      // Wait for initial load
      await container.read(interestsViewModelProvider.future);

      final notifier = container.read(interestsViewModelProvider.notifier);
      final selectedIds = [1, 2];

      await notifier.selectInterests(selectedIds);

      verify(() => mockRepo.selectInterests(selectedIds)).called(1);
    });

    test('should call selectInterests with single interest ID', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: 'technology', description: 'Tech', icon: 'tech'),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);
      when(() => mockRepo.selectInterests(any())).thenAnswer((_) async => {});

      await container.read(interestsViewModelProvider.future);

      final notifier = container.read(interestsViewModelProvider.notifier);
      final selectedIds = [1];

      await notifier.selectInterests(selectedIds);

      verify(() => mockRepo.selectInterests(selectedIds)).called(1);
    });

    test('should call selectInterests with empty list', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: 'technology', description: 'Tech', icon: 'tech'),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);
      when(() => mockRepo.selectInterests(any())).thenAnswer((_) async => {});

      await container.read(interestsViewModelProvider.future);

      final notifier = container.read(interestsViewModelProvider.notifier);
      final selectedIds = <int>[];

      await notifier.selectInterests(selectedIds);

      verify(() => mockRepo.selectInterests(selectedIds)).called(1);
    });

    test('should call selectInterests with multiple interest IDs', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: 'technology', description: 'Tech', icon: 'tech'),
        InterestDto(id: 2, name: 'Sports', slug: 'sports', description: 'Sports', icon: 'sports'),
        InterestDto(id: 3, name: 'Music', slug: 'music', description: 'Music', icon: 'music'),
        InterestDto(id: 4, name: 'Art', slug: 'art', description: 'Art', icon: 'art'),
        InterestDto(id: 5, name: 'Travel', slug: 'travel', description: 'Travel', icon: 'travel'),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);
      when(() => mockRepo.selectInterests(any())).thenAnswer((_) async => {});

      await container.read(interestsViewModelProvider.future);

      final notifier = container.read(interestsViewModelProvider.notifier);
      final selectedIds = [1, 3, 5];

      await notifier.selectInterests(selectedIds);

      verify(() => mockRepo.selectInterests(selectedIds)).called(1);
    });

    test('should handle selectInterests being called multiple times', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: 'technology', description: 'Tech', icon: 'tech'),
        InterestDto(id: 2, name: 'Sports', slug: 'sports', description: 'Sports', icon: 'sports'),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);
      when(() => mockRepo.selectInterests(any())).thenAnswer((_) async => {});

      await container.read(interestsViewModelProvider.future);

      final notifier = container.read(interestsViewModelProvider.notifier);

      await notifier.selectInterests([1]);
      verify(() => mockRepo.selectInterests([1])).called(1);

      await notifier.selectInterests([2]);
      verify(() => mockRepo.selectInterests([2])).called(1);

      await notifier.selectInterests([1, 2]);
      verify(() => mockRepo.selectInterests([1, 2])).called(1);
    });

    test('should handle error when selectInterests fails', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: 'technology', description: 'Tech', icon: 'tech'),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);
      when(() => mockRepo.selectInterests(any()))
          .thenThrow(Exception('Failed to select interests'));

      await container.read(interestsViewModelProvider.future);

      final notifier = container.read(interestsViewModelProvider.notifier);

      expect(
        () => notifier.selectInterests([1]),
        throwsException,
      );
    });

    test('should call selectInterests with large list of IDs', () async {
      final mockInterests = List.generate(
        20,
        (index) => InterestDto(
          id: index + 1,
          name: 'Interest ${index + 1}',
          slug: 'interest-${index + 1}',
          description: 'Description ${index + 1}',
          icon: 'icon_${index + 1}',
        ),
      );

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);
      when(() => mockRepo.selectInterests(any())).thenAnswer((_) async => {});

      await container.read(interestsViewModelProvider.future);

      final notifier = container.read(interestsViewModelProvider.notifier);
      final selectedIds = List.generate(10, (index) => index + 1);

      await notifier.selectInterests(selectedIds);

      verify(() => mockRepo.selectInterests(selectedIds)).called(1);
    });
  });

  group('InterestsViewModel - Integration Tests', () {
    test('should handle complete flow of loading and selecting interests', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: 'technology', description: 'Tech related', icon: 'tech'),
        InterestDto(id: 2, name: 'Sports', slug: 'sports', description: 'Sports related', icon: 'sports'),
        InterestDto(id: 3, name: 'Music', slug: 'music', description: 'Music related', icon: 'music'),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);
      when(() => mockRepo.selectInterests(any())).thenAnswer((_) async => {});

      // Load interests
      final interests = await container.read(interestsViewModelProvider.future);
      expect(interests.length, 3);

      // Select some interests
      final notifier = container.read(interestsViewModelProvider.notifier);
      await notifier.selectInterests([1, 3]);

      verify(() => mockRepo.getInterests()).called(1);
      verify(() => mockRepo.selectInterests([1, 3])).called(1);
    });

    test('should handle reload after selecting interests', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: 'technology', description: 'Tech', icon: 'tech'),
        InterestDto(id: 2, name: 'Sports', slug: 'sports', description: 'Sports', icon: 'sports'),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);
      when(() => mockRepo.selectInterests(any())).thenAnswer((_) async => {});

      // Initial load
      await container.read(interestsViewModelProvider.future);
      
      // Select interests
      final notifier = container.read(interestsViewModelProvider.notifier);
      await notifier.selectInterests([1]);

      // Invalidate and reload
      container.invalidate(interestsViewModelProvider);
      await container.read(interestsViewModelProvider.future);

      // Should be called twice (initial + reload)
      verify(() => mockRepo.getInterests()).called(2);
    });

    test('should maintain state when selecting different interests sequentially', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: 'technology', description: 'Tech', icon: 'tech'),
        InterestDto(id: 2, name: 'Sports', slug: 'sports', description: 'Sports', icon: 'sports'),
        InterestDto(id: 3, name: 'Music', slug: 'music', description: 'Music', icon: 'music'),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);
      when(() => mockRepo.selectInterests(any())).thenAnswer((_) async => {});

      await container.read(interestsViewModelProvider.future);
      final notifier = container.read(interestsViewModelProvider.notifier);

      // Select different interests in sequence
      await notifier.selectInterests([1]);
      await notifier.selectInterests([2]);
      await notifier.selectInterests([3]);
      await notifier.selectInterests([1, 2, 3]);

      verify(() => mockRepo.selectInterests([1])).called(1);
      verify(() => mockRepo.selectInterests([2])).called(1);
      verify(() => mockRepo.selectInterests([3])).called(1);
      verify(() => mockRepo.selectInterests([1, 2, 3])).called(1);
    });
  });

  group('InterestsViewModel - Edge Cases', () {
    test('should handle interests with null descriptions', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: 'technology', description: null, icon: 'tech'),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);

      final interests = await container.read(interestsViewModelProvider.future);

      expect(interests.length, 1);
      expect(interests[0].description, null);
    });

    test('should handle interests with null slug', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: null, description: 'Tech', icon: 'tech'),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);

      final interests = await container.read(interestsViewModelProvider.future);

      expect(interests.length, 1);
      expect(interests[0].slug, null);
    });

    test('should handle interests with null icon', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: 'technology', description: 'Tech', icon: null),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);

      final interests = await container.read(interestsViewModelProvider.future);

      expect(interests.length, 1);
      expect(interests[0].icon, null);
    });

    test('should handle duplicate interest IDs in selection', () async {
      final mockInterests = [
        InterestDto(id: 1, name: 'Technology', slug: 'technology', description: 'Tech', icon: 'tech'),
      ];

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);
      when(() => mockRepo.selectInterests(any())).thenAnswer((_) async => {});

      await container.read(interestsViewModelProvider.future);

      final notifier = container.read(interestsViewModelProvider.notifier);
      final selectedIds = [1, 1, 1]; // Duplicate IDs

      await notifier.selectInterests(selectedIds);

      verify(() => mockRepo.selectInterests(selectedIds)).called(1);
    });

    test('should handle very large interest list', () async {
      final mockInterests = List.generate(
        1000,
        (index) => InterestDto(
          id: index + 1,
          name: 'Interest ${index + 1}',
          slug: 'interest-${index + 1}',
          description: 'Description ${index + 1}',
          icon: 'icon_${index + 1}',
        ),
      );

      when(() => mockRepo.getInterests()).thenAnswer((_) async => mockInterests);

      final interests = await container.read(interestsViewModelProvider.future);

      expect(interests.length, 1000);
      expect(interests.first.id, 1);
      expect(interests.last.id, 1000);
    });

    test('should handle network timeout simulation', () async {
      when(() => mockRepo.getInterests()).thenAnswer(
        (_) async => Future.delayed(
          const Duration(milliseconds: 50),
          () => throw Exception('Timeout'),
        ),
      );

      final stateFuture = container.read(interestsViewModelProvider.future);

      expect(stateFuture, throwsException);
    });
  });
}

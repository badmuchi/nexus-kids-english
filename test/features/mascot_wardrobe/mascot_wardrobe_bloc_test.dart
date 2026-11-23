import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/core/result/result.dart';
import 'package:english_for_children/features/mascot_wardrobe/domain/entities/mascot_accessory_entity.dart';
import 'package:english_for_children/features/mascot_wardrobe/domain/repositories/mascot_wardrobe_repository.dart';
import 'package:english_for_children/features/mascot_wardrobe/presentation/mascot_wardrobe_bloc.dart';
import 'package:english_for_children/features/mascot_wardrobe/presentation/mascot_wardrobe_event.dart';
import 'package:english_for_children/features/mascot_wardrobe/presentation/mascot_wardrobe_state.dart';

class MockMascotWardrobeRepository extends Mock implements MascotWardrobeRepository {}

void main() {
  late MockMascotWardrobeRepository mockRepo;

  setUp(() {
    mockRepo = MockMascotWardrobeRepository();
  });

  const testAccessory = MascotAccessoryEntity(
    id: 'acc_headphones',
    name: 'Наушники',
    emoji: '🎧',
    slot: 'hat',
    costXp: 80,
    description: 'Крутые наушники',
    isUnlocked: true,
    isEquipped: true,
  );

  const testBadge = BadgeEntity(
    id: 'badge_1',
    title: 'Чемпион',
    emoji: '🏆',
    description: 'Описание',
    isUnlocked: true,
  );

  group('MascotWardrobeBloc Tests', () {
    test('initial state is MascotWardrobeInitial', () {
      final bloc = MascotWardrobeBloc(repository: mockRepo);
      expect(bloc.state, const MascotWardrobeInitial());
      bloc.close();
    });

    blocTest<MascotWardrobeBloc, MascotWardrobeState>(
      'loads accessories and badges on LoadWardrobeEvent',
      build: () {
        when(() => mockRepo.getAccessories()).thenAnswer((_) async => const Result.success([testAccessory]));
        when(() => mockRepo.getBadges()).thenAnswer((_) async => const Result.success([testBadge]));
        return MascotWardrobeBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const LoadWardrobeEvent()),
      expect: () => [
        const MascotWardrobeLoading(),
        const MascotWardrobeLoaded(
          accessories: [testAccessory],
          badges: [testBadge],
          equippedItem: testAccessory,
        ),
      ],
    );
  });
}

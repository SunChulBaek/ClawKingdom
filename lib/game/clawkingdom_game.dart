import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'components/map_component.dart';
import 'components/npc_component.dart';
import 'components/player_component.dart';

class ClawKingdomGame extends FlameGame with TapCallbacks {
  late PlayerComponent _player;
  void Function(NpcData)? onNpcTapped;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.center;

    final mapComp = MapComponent();
    world.add(mapComp);

    final startPos = Vector2(
      8 * MapComponent.tileSize.toDouble(),
      10 * MapComponent.tileSize.toDouble(),
    );
    _player = PlayerComponent(startPosition: startPos);
    world.add(_player);

    for (final npcData in npcList) {
      final npc = NpcComponent(
        data: npcData,
        onTapped: (data) => onNpcTapped?.call(data),
      );
      world.add(npc);
    }

    camera.follow(_player);
  }

  @override
  void onTapDown(TapDownEvent event) {
    final worldCoord = camera.globalToLocal(event.localPosition);
    _player.moveTo(worldCoord);
  }

  @override
  ui.Color backgroundColor() => const ui.Color(0xFF1A0A0A);
}

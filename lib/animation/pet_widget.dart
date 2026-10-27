import 'package:flutter/material.dart';
import 'package:samir_pet/animation/rive_pet_widget.dart';
import 'package:samir_pet/core/constants/app_colors.dart';
import 'package:samir_pet/pet/pet_behaviour_engine.dart';

/// The unified pet widget featuring animated glow and responsive sizing
class PetWidget extends StatelessWidget {
  final PetBehaviourEngine engine;
  final double size;
  final bool interactive;

  const PetWidget({
    super.key,
    required this.engine,
    this.size = 240,
    this.interactive = true,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Ambient glow
        Container(
          width: size * 1.3,
          height: size * 1.3,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            gradient: AppColors.petGlowGradient,
          ),
        ),
        // Pet Character (Rive with Vector Fallback)
        RivePetWidget(
          engine: engine,
          size: size,
          interactive: interactive,
        ),
      ],
    );
  }
}

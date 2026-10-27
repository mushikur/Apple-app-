import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;
import 'package:samir_pet/animation/animated_pet_widget.dart';
import 'package:samir_pet/pet/pet_behaviour_engine.dart';

/// Rive integration wrapper for Samir Pet.
///
/// Designed to load and control `assets/rive/samir_pet.riv`.
/// If the file is missing or fails to decode, it seamlessly falls back to the high-fidelity
/// native [AnimatedPetWidget] without crashing or throwing unhandled errors.
class RivePetWidget extends StatefulWidget {
  final PetBehaviourEngine engine;
  final double size;
  final bool interactive;

  const RivePetWidget({
    super.key,
    required this.engine,
    this.size = 240,
    this.interactive = true,
  });

  @override
  State<RivePetWidget> createState() => _RivePetWidgetState();
}

class _RivePetWidgetState extends State<RivePetWidget> {
  bool _assetExists = false;
  bool _checkedAsset = false;
  rive.FileLoader? _fileLoader;

  @override
  void initState() {
    super.initState();
    _checkAssetPresence();
  }

  Future<void> _checkAssetPresence() async {
    try {
      final ByteData data = await rootBundle.load('assets/rive/samir_pet.riv');
      if (data.lengthInBytes > 0 && mounted) {
        setState(() {
          _assetExists = true;
          _checkedAsset = true;
          _fileLoader = rive.FileLoader.fromAsset(
            'assets/rive/samir_pet.riv',
            riveFactory: rive.Factory.flutter,
          );
        });
        return;
      }
    } catch (_) {
      // Asset does not exist in bundle, fallback cleanly
    }

    if (mounted) {
      setState(() {
        _assetExists = false;
        _checkedAsset = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_checkedAsset) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const Center(
          child: SizedBox(
            width: 28,
            height: 28,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (!_assetExists || _fileLoader == null) {
      return AnimatedPetWidget(
        engine: widget.engine,
        size: widget.size,
        interactive: widget.interactive,
      );
    }

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: rive.RiveWidgetBuilder(
        fileLoader: _fileLoader!,
        builder: (context, state) {
          if (state is rive.RiveLoaded) {
            return rive.RiveWidget(
              controller: state.controller,
              fit: rive.Fit.contain,
            );
          }
          if (state is rive.RiveFailed) {
            return AnimatedPetWidget(
              engine: widget.engine,
              size: widget.size,
              interactive: widget.interactive,
            );
          }
          return const Center(
            child: SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
      ),
    );
  }
}

# Rive Animation Specification: Samir Pet

## 1. Overview & File Location

- **File Path**: `assets/rive/samir_pet.riv`
- **Fallback Architecture**: When this file is absent or incomplete, the application automatically mounts `AnimatedPetWidget` (built using `PetCharacterPainter`). The application will **never crash** if the Rive file is missing.
- **Renderer Target**: Flutter Rive Runtime (`package:rive 0.14.11+`).
- **Artboard Name**: `SamirPet`
- **State Machine Name**: `PetStateMachine`

---

## 2. Character Anatomy & Original Design Requirements

To ensure complete commercial originality and avoid copyright issues with Pokémon, Disney, Sanrio, or other franchises, Samir Pet is designed as a soft, spherical companion sprite:

1. **Body**: Rounded soft bean/circle contour. Soft sky blue to periwinkle gradient `#7B9EF7` to `#5B7FD7` with a light gloss cap.
2. **Belly**: Semi-transparent cream oval `#FFFFFF` with 24% opacity.
3. **Ears**: Slanted rounded teardrop ears with inner pastel blush `#FFB8C6`.
4. **Tail**: Short curled tail with a fluffy lighter tip `#9AB7FA`.
5. **Arms & Feet**: Chubby stubby paws. Left and right arms rigged independently for waving, stretching, and gestures.
6. **Face**:
   - **Eyes**: Large expressive oval sockets with white sclera.
   - **Pupils**: Dark slate `#2D3436` with dual circular white specular highlights.
   - **Eyebrows**: Separate floating arcs capable of rotation and Y-offset (sad droop, curious cock, angry/worried pinch, happy lift).
   - **Cheeks**: Soft radial blush discs `#FFB8C6`.
   - **Mouth**: Multi-path shape capable of morphing between subtle curve, wide open laughing/yawning oval with visible tongue `#FF6B8B`, and downcast frown.

---

## 3. State Machine: `PetStateMachine`

### Inputs Specification

#### Triggers (`SMITrigger`)
| Trigger Name | Description | Corresponding `PetMood` |
|:---|:---|:---|
| `trigHello` | One-shot wave with right paw, cheerful smile, and eye blink | `PetMood.hello` |
| `trigHappy` | Joyful hop, closed-eye crescent smile, sparkle stars | `PetMood.happy` |
| `trigSad` | Drooped ears, downcast pupils, sad mouth | `PetMood.sad` |
| `trigCurious` | Head tilted 15 degrees, one eyebrow cocked, pupils shifted right | `PetMood.curious` |
| `trigSurprised`| Sudden slight bounce back, wide eyes, circular open mouth | `PetMood.surprised` |
| `trigThinking` | Eye gaze directed upper-left, subtle chin tap | `PetMood.thinking` |
| `trigWake` | Full body stretch, arms raised, wide mouth yawn, eye flutter open | `PetMood.waking` |
| `trigCharging` | Cheerful reaction, electric spark particles, energized bounce | `PetMood.charging` |
| `trigLowBatt` | Heavy eyelids, sweat droplet on temple, slight head droop | `PetMood.lowBattery` |
| `trigLove` | Eyes morph into beating pink hearts `#FF4081`, floating heart particles | `PetMood.love` |
| `trigBored` | Heavy sideways glance, small sigh | `PetMood.bored` |
| `trigConfused` | Asymmetric eyebrows, head tilted opposite direction, sweat drop | `PetMood.confused` |
| `trigPlayful` | Excited bouncy stance, star pupils, fast tail wag | `PetMood.playful` |
| `trigGoodMorning`| Sunny awakening, bright open eyes, stretch | `PetMood.goodMorning` |
| `trigGoodNight`| Heavy droopy eyes, gentle yawns, slow breath | `PetMood.goodNight` |
| `trigBlink` | Micro-blink animation (fired during idle simulation) | `IdleBehaviour.blink` |

#### Booleans (`SMIBool`)
| Boolean Name | Default | Active Purpose |
|:---|:---|:---|
| `isSleeping` | `false` | Loops peaceful closed-eye breathing, floating Zzz text, dimmed body |
| `isListening`| `false` | Slides overhead headphones onto ears, attentive listening posture |
| `isDancing` | `false` | Loops rhythmic side-to-side head bobbing and paw groove |

#### Numbers (`SMINumber`)
| Number Name | Range | Description |
|:---|:---|:---|
| `energy` | `0.0` to `1.0` | Controls baseline breathing speed and alertness |
| `lookX` | `-1.0` to `1.0` | Horizontal pupil tracking offset |
| `lookY` | `-1.0` to `1.0` | Vertical pupil tracking offset |
| `headTilt` | `-1.0` to `1.0` | Rotational tilt of the head |

---

## 4. Expected State Machine Transitions

```
[Entry] ──> (idle loop)
               │
               ├── (trigHello) ──────────> [anim_hello] ──────> (idle loop)
               ├── (trigHappy) ──────────> [anim_happy] ──────> (idle loop)
               ├── (trigSad) ────────────> [anim_sad] ────────> (idle loop)
               ├── (trigCurious) ────────> [anim_curious] ────> (idle loop)
               ├── (trigSurprised) ──────> [anim_surprised] ──> (idle loop)
               ├── (trigThinking) ───────> [anim_thinking] ───> (idle loop)
               ├── (trigLove) ───────────> [anim_love] ───────> (idle loop)
               ├── (trigPlayful) ────────> [anim_playful] ────> (idle loop)
               ├── (trigCharging) ───────> [anim_charging] ───> (idle loop)
               ├── (trigLowBatt) ────────> [anim_low_battery] > (idle loop)
               ├── (isSleeping == true) ─> [anim_sleep_loop] ─> (isSleeping == false) ─> [anim_wake] ─> (idle loop)
               └── (isDancing == true) ──> [anim_dance_loop] ─> (isDancing == false) ─> (idle loop)
```

---

## 5. Summary of Asset Preparation

1. Open **Rive Studio** (Web or Desktop).
2. Create an artboard named `SamirPet` with dimensions `500x500`.
3. Build the character layers according to Section 2.
4. Create the State Machine named `PetStateMachine`.
5. Add all inputs listed in Section 3 with exact case-sensitive naming.
6. Export the `.riv` file and save it to `D:\samir_pet\assets\rive\samir_pet.riv`.
7. Once copied into the directory, `RivePetWidget` will automatically detect and mount it without modifying Dart code.

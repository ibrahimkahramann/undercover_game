# Undercover - Flutter Tech Task

This is a Flutter-based mobile party game, created as a technical task. It's a social deduction game where players must uncover the 'Undercover' among them through word descriptions and voting.

The project not only fulfills all the core requirements but also includes a polished UI/UX with a custom theme, animations, an onboarding tutorial for new players, and custom-generated visuals.

## Screenshots

<div align="center">
  <img src="screenshots/tutorial1.png" width="200" alt="Tutorial Screen">
  <img src="screenshots/tutorial2.png" width="200" alt="Tutorial Screen 2">
  <img src="screenshots/playersetupscreen.png" width="200" alt="Player Setup Screen">
</div>

<div align="center">
  <img src="screenshots/rolerevealscreen.png" width="200" alt="Role Reveal Screen">
  <img src="screenshots/votingscreen.png" width="200" alt="Voting Screen">
  <img src="screenshots/gameoverscreen.png" width="200" alt="Game Over Screen">
</div>

<div align= "center">
Tutorial Screen • Player Setup • Role Reveal • Voting • Game Over
</div>

## Features

- **Dynamic Player Setup**: Supports 3 to 12 players with custom names.

- **Private Role Distribution**: A "pass-the-phone" mechanic ensures each player's role and secret word remain private.

- **Custom Theming**: A unique, dark-themed UI with a custom color palette and typography (Poppins & Lato from Google Fonts).

- **Onboarding Tutorial**: A one-time tutorial for new users explaining the game rules, powered by shared_preferences.

- **Engaging Visuals**: Custom AI-generated images for 'Citizen' and 'Undercover' roles, enhancing the theme.

- **Robust Voting System**: A tally-based voting screen that correctly handles ties (no elimination) as per the rules.

- **Vote Limit**: The system prevents casting more votes than the number of active players, avoiding user error.

- **Polished Experience**: Custom animations, an adaptive app icon, and a clear game-over screen create a finished-product feel.

## How to Run the App

To run this project locally, follow these steps:

### Prerequisites:
- Ensure you have the Flutter SDK installed.
- An emulator or a physical device to run the app.

### Clone the Repository:
```bash
git clone https://github.com/ibrahimkahramann/undercover_game
```

### Navigate to the Project Directory:
```bash
cd your_project_folder
```

### Install Dependencies:
```bash
flutter pub get
```

### Run the App:
```bash
flutter run
```

## App Structure

The project follows a clean and scalable directory structure to separate concerns:

- **lib/main.dart**: The entry point of the application. It initializes the GameService provider and handles the one-time tutorial logic.

- **lib/models/**: Contains the core data models.
  - `player_model.dart`: Defines the Player object and PlayerRole enum.

- **lib/screens/**: Contains all major UI screens for the application (e.g., player_setup_screen, role_reveal_screen, voting_screen, etc.).

- **lib/services/**: Holds the core business logic and state management.
  - `game_service.dart`: The brain of the application. It's a ChangeNotifier that manages the entire game state, including player setup, role assignment, vote tallying, and win conditions.

- **assets/**: Contains all static assets like images and the app icon.

## Known Issues & Debugging Journey

During final testing on physical devices, a highly specific, device-dependent rendering bug was identified where character images appear inverted. This section documents the bug and the extensive debugging process undertaken to isolate its root cause.

### Bug Behavior

-   **Description:** The primary visuals for the 'Citizen' and 'Undercover' roles render upside-down.
-   **Occurrence:** The issue was consistently reproduced on several Xiaomi devices (running Android 13) and one older Samsung model.
-   **Non-Occurrence:** The bug is **not present** on a Samsung device running Android 14, nor is it reproducible on Android emulators or in the web build. This confirms the issue is not with the core application logic but with a specific platform/hardware configuration.

### Investigation & Attempted Solutions

A multi-step investigation was conducted to resolve the issue:

1.  **Asset-Level Analysis:** The initial hypothesis was a problem with the image assets themselves. The PNG files were re-processed using multiple methods to strip any potentially corrupt EXIF metadata and to standardize their encoding ("Save for Web"). This had no effect.

2.  **Code-Level Workaround (`Image.memory`):** To bypass the native platform's image decoding layer, the implementation was refactored. Instead of using the standard `Image.asset` widget, the image data was loaded as raw bytes via `rootBundle` and rendered directly with `Image.memory`. This advanced technique also failed to resolve the issue on the affected devices.

3.  **Native Configuration Override (`hardwareAccelerated`):** As a final step, hardware acceleration was disabled for the entire application at the native level via `AndroidManifest.xml`. Surprisingly, this did not fix the issue on the affected Xiaomi devices, suggesting that the device's OS (MIUI) may be overriding this application-level setting.

### Conclusion

The root cause has been isolated to a platform-specific rendering bug, likely related to an incompatibility between the Flutter graphics engine and the specific GPU/drivers used in certain devices (notably some Xiaomi models).

The application is submitted with this known, non-critical visual issue, as it does not affect the gameplay logic and has been proven to be confined to a narrow and specific set of hardware, rather than being a general flaw in the application's architecture. This debugging journey has been documented as proof of a thorough testing and problem-solving process.
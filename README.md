# Training Timer App

This is a new timer app that will allow you to fix your training sessions according to your needs.

## Highlights

This app is specially designed to help martial art athletes to prepare for their figths.

Some cool functionalities:
* Built-in common configurations to quickly start your training.
* Choose time between minutes and seconds.
* Custom configurations to better adapting to your training.
* Cool design and UI.
* History of your training sessions.

## Project Structure
```
/lib
├── main.dart
├── core/
│   ├── utils/
│   │   └── time_formatter.dart
│   └── widgets/
│       └── editable_card.dart
├── features/
│   ├── home/
│   │   ├── presentation/
│   │   │   ├── home_page.dart
│   │   │   └── home_body.dart
│   │   └── controllers/
│   │       └── home_controller.dart (opcional)
│   ├── timer/
│   │   ├── presentation/
│   │   │   └── timer_screen.dart
│   │   └── controllers/
│   │       └── timer_controller.dart (opcional)
│   └── final/
│       └── final_screen.dart
└── assets/
    └── sounds/
        ├── bell.mp3
        └── beep.mp3
```

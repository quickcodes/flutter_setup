# Flutter Project Template README

This project is a Flutter application setup template that includes authentication (login and signup) functionality and a basic home page feature.

## Features

- **Authentication:**
  - Login and Signup functionality with API integration.
  - Custom text fields and buttons for UI components.

- **Home Feature:**
  - Basic home page setup.

## Getting Started

Follow these instructions to get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- Flutter SDK installed ([installation guide](https://flutter.dev/docs/get-started/install)).
- IDE with Flutter support (e.g., Android Studio, VS Code).

### Installation

1. Clone the repository:

   ```bash
   git clone <repository-url>
   cd <project-directory>
   ```

2. Clone the repository:
   ```
   flutter pub get
   ```
3. Update API Base URL:
  - Open lib/di.dart and replace 'https://your-api-base-url.com' with your actual API base URL.




# Project Structure

This document provides an overview of the project structure for the Flutter Authentication and Home Page Template.

## Table of Contents

- [Overview](#overview)
- [Main Files](#main-files)
- [Features](#features)
  - [Authentication Feature](#authentication-feature)
  - [Home Feature](#home-feature)
- [Libraries and Dependencies](#libraries-and-dependencies)

## Overview

The project is structured to maintain clear separation of concerns and facilitate scalability and maintainability. Each major feature (Authentication and Home) is organized within its respective directory under `lib/features/`. Key functionality, such as API interactions and dependency injection, is centralized in `lib/di.dart` and `lib/repositories/`.

## Main Files

- **`lib/main.dart`**: Entry point of the application.
- **`lib/di.dart`**: Dependency injection setup using `get_it` for managing singletons.
- **`lib/repositories/api_repository.dart`**: Centralizes API interactions using `Dio` for HTTP requests.
- **`lib/utils/validators.dart`**: Contains validators for form input validation.

## Features

### Authentication Feature

- **`lib/features/auth/`**: Directory containing authentication-related functionality.
  - **`controllers/`**: Business logic controllers (`AuthController`) for managing authentication state.
  - **`repos/`**: Data repositories (`AuthRepo`) for handling API calls related to authentication.
  - **`models/`**: Data models (`UserModel`) used throughout the authentication process.
  - **`screens/`**: User interface screens for authentication:
    - **`login_page.dart`**: Screen for user login.
    - **`signup_page.dart`**: Screen for user signup.
    - **`widgets/`**: Reusable UI components:
      - **`custom_text_field.dart`**: Custom text field widget.
      - **`custom_button.dart`**: Custom button widget.

### Home Feature

- **`lib/features/home/`**: Directory containing the basic home page feature.
  - **`home_page.dart`**: Basic screen for displaying home page content.

## Libraries and Dependencies

- **Flutter Packages:**
  - `provider`: For state management.
  - `dio`: For making HTTP requests.
  - `get_storage`: For local storage management.
  - `get_it`: For dependency injection.
  - `either_dart`: For handling asynchronous operations.

This structured approach helps in maintaining a clear separation of concerns, making it easier to navigate and extend the application as it grows.

# Contributing

Contributions are welcome! If you want to contribute to this project, feel free to fork the repository and submit a pull request.

# Authors
- Dhruv Soni


## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.



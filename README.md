# ToDo-List-25

A modern iOS To-Do List app built with SwiftUI and Core Data.

## Features

- Create, edit, and delete tasks
- Mark tasks as completed
- Search and filter tasks
- Persistent storage using Core Data
- Fetches initial tasks from a remote API (`https://dummyjson.com/todos`) on first launch
- Responsive and intuitive UI with SwiftUI
- Dark mode support
- Unit tests for Core Data, networking, and logic

## Project Structure

ToDo-List/
├── ToDo-List/
│ ├── Assets.xcassets/ # App assets
│ ├── Extensions/ # Swift extensions (e.g., Date formatting)
│ ├── Model/ # Core Data entities and mocks
│ ├── Screens/ # UI screens (MainScreen, RedactorScreen)
│ ├── ToDoModels.xcdatamodeld/ # Core Data model
│ └── ToDo_ListApp.swift # App entry point
├── ToDo-ListTests/ # Unit tests
└── ToDo-List.xcodeproj/ # Xcode project files

## Getting Started

1. **Clone the repository:**
   ```sh
   git clone https://github.com/Sawolfer/ToDo-List-25.git
   ```

2 **Open in Xcode:**

- Open `ToDo-List/ToDo-List.xcodeproj` in Xcode.

3 **Build and Run:**

- Select a simulator or device and press `Run`.

## Testing

- Unit tests are located in the ToDo-ListTests folder.
- To run tests, select the ToDo-List scheme and press Cmd+U in Xcode.

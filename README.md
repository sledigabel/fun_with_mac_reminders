# macOS Swift Utilities

This repository contains two Swift utilities:

1. **TODO Finder** - A simple tool that parses text files and prints lines containing "TODO"
2. **Work Reminders** - A tool that exports reminders from the "work" category in macOS Reminders app to JSON

## TODO Finder

A simple Swift tool that parses a text file and prints all lines containing the word "TODO".

### Features

- Reads any text file specified as a command-line argument
- Searches for lines containing "TODO" (case-sensitive)
- Displays the line number and content of each matching line
- Provides a summary of how many TODO items were found

### Usage

```
./todo_finder path/to/your/file.txt
```

Example output:
```
Line 42: // TODO: Fix this logic to handle edge cases
Line 87: // TODO: Implement error handling
Line 134: /* TODO: This function needs optimization */

Found 3 TODO item(s) in path/to/your/file.txt
```

## Work Reminders

A Swift utility that exports tasks from the "work" category in macOS Reminders app to JSON format.

### Features

- Accesses the macOS Reminders app using EventKit framework
- Filters reminders to only show those in the "work" category
- Exports reminder data to JSON format including:
  - Title, completion status, due dates
  - Notes, priority level
  - Creation and completion timestamps
- Supports both modern (macOS 14+) and legacy reminder access APIs

### Usage

```
./work_reminders
```

Example output:
```json
{
  "count": 3,
  "category": "work",
  "exportDate": "2025-08-14T12:34:56Z",
  "reminders": [
    {
      "id": "x-apple-reminder://12345",
      "title": "Complete quarterly report",
      "isCompleted": false,
      "dueDate": "2025-08-16T17:00:00Z",
      "completionDate": null,
      "notes": "Include the new sales figures",
      "priority": 1
    },
    ...
  ]
}
```

**Note:** This tool requires permission to access your Reminders. You will be prompted for permission on first run.

## Installation

### Building from source

1. Clone this repository:
   ```
   git clone https://github.com/yourusername/fun_with_mac_reminders.git
   cd fun_with_mac_reminders
   ```

2. Build the projects:

   **Using the Makefile (for TODO Finder):**
   ```
   make
   ```

   **Manually building each tool:**
   ```
   # Build TODO Finder
   swiftc -o todo_finder main.swift
   
   # Build Work Reminders
   swiftc -o work_reminders work_reminders.swift -framework Foundation -framework EventKit
   ```

3. Optionally, install the binaries to make them globally available:
   ```
   make install  # For TODO Finder
   ```
   Note: This may require sudo permissions

## Requirements

- macOS (10.15 or later recommended)
- Swift 5.0 or later
- For Work Reminders: Access to macOS Reminders app

## License

See the [LICENSE](LICENSE) file for details.
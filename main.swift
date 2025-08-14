import Foundation

// Check if the file path is provided as a command line argument
guard CommandLine.arguments.count > 1 else {
    print("Error: Please provide a file path as a command line argument.")
    print("Usage: todo_finder <file_path>")
    exit(1)
}

// Get the file path from command line arguments
let filePath = CommandLine.arguments[1]

// Check if the file exists
guard FileManager.default.fileExists(atPath: filePath) else {
    print("Error: File does not exist at path: \(filePath)")
    exit(1)
}

do {
    // Read the content of the file
    let fileContent = try String(contentsOfFile: filePath, encoding: .utf8)
    
    // Split the content into lines
    let lines = fileContent.components(separatedBy: .newlines)
    
    // Counter for found TODOs
    var todoCount = 0
    
    // Process each line
    for (index, line) in lines.enumerated() {
        // Check if the line contains "TODO"
        if line.contains("TODO") {
            // Print the line number and the line content
            print("Line \(index + 1): \(line)")
            todoCount += 1
        }
    }
    
    // Print summary
    if todoCount > 0 {
        print("\nFound \(todoCount) TODO item(s) in \(filePath)")
    } else {
        print("No TODO items found in \(filePath)")
    }
    
} catch {
    print("Error reading file: \(error)")
    exit(1)
}
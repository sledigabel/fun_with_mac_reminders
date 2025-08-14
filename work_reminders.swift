import Foundation
import EventKit

// Request access to reminders
let eventStore = EKEventStore()

// Structure to represent a reminder for JSON serialization
struct ReminderJSON: Codable {
    let id: String
    let title: String
    let isCompleted: Bool
    let dueDate: String?
    let completionDate: String?
    let notes: String?
    let priority: Int
}

// Function to request access to reminders
func requestAccess() {
    // Check if we're on macOS 14 or later
    if #available(macOS 14.0, *) {
        // Use the new API
        eventStore.requestFullAccessToReminders { (granted, error) in
            if granted {
                fetchWorkReminders()
            } else {
                let errorData: [String: String] = ["error": "Access to reminders was denied or restricted: \(String(describing: error))"]
                outputJSON(errorData)
                exit(1)
            }
        }
    } else {
        // Use the deprecated API for older macOS versions
        eventStore.requestAccess(to: .reminder) { (granted, error) in
            if granted {
                fetchWorkReminders()
            } else {
                let errorData: [String: String] = ["error": "Access to reminders was denied or restricted: \(String(describing: error))"]
                outputJSON(errorData)
                exit(1)
            }
        }
    }
}

// Function to fetch reminders from the "work" category
func fetchWorkReminders() {
    // Create a predicate to fetch all reminders
    let predicate = eventStore.predicateForReminders(in: nil)
    
    // Fetch reminders asynchronously
    eventStore.fetchReminders(matching: predicate) { reminders in
        guard let reminders = reminders else {
            let errorData: [String: String] = ["error": "Error fetching reminders"]
            outputJSON(errorData)
            exit(1)
        }
        
        // Filter reminders to only include those in the "work" category
        let workReminders = reminders.filter { reminder in
            guard let calendar = reminder.calendar else { return false }
            return calendar.title.lowercased() == "work"
        }
        
        // Convert reminders to JSON-friendly format
        let reminderJSONArray = workReminders.map { reminder -> ReminderJSON in
            let dueDateString = reminder.dueDateComponents != nil ?
                formatDate(reminder.dueDateComponents!) : nil
            
            let completionDateString: String?
            if reminder.isCompleted, let completionDate = reminder.completionDate {
                completionDateString = formatDate(completionDate)
            } else {
                completionDateString = nil
            }
            
            return ReminderJSON(
                id: reminder.calendarItemIdentifier,
                title: reminder.title,
                isCompleted: reminder.isCompleted,
                dueDate: dueDateString,
                completionDate: completionDateString,
                notes: reminder.notes,
                priority: reminder.priority
            )
        }
        
        // Create JSON output structure
        struct OutputJSON: Codable {
            let count: Int
            let category: String
            let exportDate: String
            let reminders: [ReminderJSON]
        }
        
        let output = OutputJSON(
            count: workReminders.count,
            category: "work",
            exportDate: formatDate(Date()),
            reminders: reminderJSONArray
        )
        
        // Output the JSON data
        outputJSON(output)
        exit(0)
    }
}

// Helper function to format a Date object
func formatDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    return formatter.string(from: date)
}

// Helper function to format date components
func formatDate(_ dateComponents: DateComponents) -> String {
    guard let date = Calendar.current.date(from: dateComponents) else {
        return "Invalid date"
    }
    
    return formatDate(date)
}

// Helper function to output JSON data
func outputJSON<T: Encodable>(_ data: T) {
    do {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]
        let jsonData = try encoder.encode(data)
        if let jsonString = String(data: jsonData, encoding: .utf8) {
            print(jsonString)
        }
    } catch {
        print("Error creating JSON: \(error)")
        exit(1)
    }
}

// Run the application
requestAccess()

// Keep the program running until the async callbacks complete
RunLoop.main.run(until: Date(timeIntervalSinceNow: 60))
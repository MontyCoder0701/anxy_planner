import WidgetKit
import SwiftUI

// MARK: - TodoItem Model

struct TodoItem: Hashable, Codable {
    let title: String
    let isComplete: Bool
    let forDate: Date
}

// MARK: - Timeline Entry

struct TodoEntry: TimelineEntry {
    let date: Date
    let todos: [TodoItem]
}

// MARK: - Provider

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TodoEntry {
        TodoEntry(date: Date(), todos: [TodoItem(title: "Sample Todo", isComplete: false, forDate: Date())])
    }

    func getSnapshot(in context: Context, completion: @escaping (TodoEntry) -> ()) {
        let todos = fetchCachedTodos(for: Date())
        completion(TodoEntry(date: Date(), todos: todos))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TodoEntry>) -> ()) {
        let currentDate = Date()
        let tomorrowDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate.addingTimeInterval(86400)
        
        let todayTodos = fetchCachedTodos(for: currentDate)
        let tomorrowTodos = fetchCachedTodos(for: tomorrowDate)

        let entryToday = TodoEntry(date: currentDate, todos: todayTodos)
        let entryTomorrow = TodoEntry(date: tomorrowDate, todos: tomorrowTodos)

        var nextUpdateComponents = Calendar.current.dateComponents([.year, .month, .day], from: currentDate)
        nextUpdateComponents.day! += 1
        nextUpdateComponents.hour = 0
        nextUpdateComponents.minute = 1
        nextUpdateComponents.second = 0

        let nextUpdateDate = Calendar.current.date(from: nextUpdateComponents) ?? currentDate.addingTimeInterval(86460)

        let timeline = Timeline(entries: [entryToday, entryTomorrow], policy: .after(nextUpdateDate))
        completion(timeline)
    }

    func fetchCachedTodos(for day: Date) -> [TodoItem] {
        guard let userDefaults = UserDefaults(suiteName: "group.onemoonwidgets"),
              let todosJson = userDefaults.string(forKey: "daily_todos"),
              let data = todosJson.data(using: .utf8),
              let todos = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            return [TodoItem(title: "No todos", isComplete: false, forDate: day)]
        }

        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        return todos.compactMap { dict in
            let title = dict["title"] as! String
            let dateString = dict["forDate"] as! String
            let todoDate = formatter.date(from: dateString)!
            let isComplete = dict["isComplete"] as? Bool ?? false
            let match = Calendar.current.isDate(todoDate, inSameDayAs: day)
            return match ? TodoItem(title: title, isComplete: isComplete, forDate: todoDate) : nil
        }
    }
}

// MARK: - Widget View

struct TodoWidgetsEntryView: View {
    let LAVENDER_PURPLE = Color(red: 159/255, green: 90/255, blue: 253/255);
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                smallView
            case .systemMedium:
                mediumView
            case .systemLarge:
                largeView
            default:
                smallView
            }
        }
        .widgetURL(URL(string: "app-launch://")!)
    }
    
    // MARK: - Small View

    private var smallView: some View {
        let totalCount = entry.todos.count
        let completeCount = entry.todos.count { $0.isComplete }
        let incompleteTodos = entry.todos.filter { !$0.isComplete }

        return VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                Text("할 일")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(LAVENDER_PURPLE)
                
                if totalCount > 0 {
                    Text("(\(completeCount)/\(totalCount))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            .padding(.bottom, 6)
            
            if incompleteTodos.isEmpty {
                Text("• 없음")
                    .font(.caption)
                    .foregroundColor(.secondary)
            } else {
                ForEach(incompleteTodos.prefix(3), id: \.self) { todo in
                    HStack(alignment: .top, spacing: 6) {
                        Text("•").foregroundColor(.secondary)
                        Text(todo.title)
                            .font(.caption)
                            .lineLimit(2)
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Medium View

    private var mediumView: some View {
        let totalCount = entry.todos.count
        let completeCount = entry.todos.count { $0.isComplete }
        let incompleteTodos = entry.todos.filter { !$0.isComplete }
        let ratio = totalCount == 0 ? 0 : Float(completeCount) / Float(totalCount)
        
        return VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text("할 일")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(LAVENDER_PURPLE)
                if totalCount > 0 {
                    Text("(\(completeCount)/\(totalCount))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
            
            HStack(alignment: .top, spacing: 20) {
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                    Circle()
                        .trim(from: 0, to: CGFloat(ratio))
                        .stroke(LAVENDER_PURPLE, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Text("\(Int(ratio * 100))%")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                .frame(width: 60, height: 100)
                .padding(.horizontal, 6)
                                
                VStack(alignment: .leading, spacing: 6) {
                    if entry.todos.isEmpty {
                        Text("할 일이 없습니다.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(incompleteTodos.prefix(4), id: \.self) { todo in
                                HStack(alignment: .top, spacing: 4) {
                                    Text("•").font(.caption).foregroundColor(.secondary)
                                    Text(todo.title)
                                        .font(.subheadline)
                                        .lineLimit(1)
                                }
                            }
                        }
                    }
                }
            }
            
            Spacer(minLength: 0)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 6)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Large View

    private var largeView: some View {
        let totalCount = entry.todos.count
        let completeCount = entry.todos.count { $0.isComplete };
        let ratio = totalCount == 0 ? 0 : Float(completeCount) / Float(totalCount)

        return VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 4) {
                Text("오늘 할 일")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(LAVENDER_PURPLE)
                if totalCount > 0 {
                    Text("(\(completeCount)/\(totalCount))")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }

            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    if entry.todos.isEmpty {
                        Text("할 일이 없습니다.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(entry.todos.prefix(10), id: \.self) { todo in
                            HStack(alignment: .top, spacing: 6) {
                                Text("•").foregroundColor(.secondary)
                                Text(todo.title)
                                    .font(.subheadline)
                                    .lineLimit(2)
                                    .strikethrough(todo.isComplete, color: .secondary)
                                    .foregroundColor(todo.isComplete ? .secondary : .primary)
                            }
                        }
                    }
                }

                Spacer()

                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                    Circle()
                        .trim(from: 0, to: CGFloat(ratio))
                        .stroke(LAVENDER_PURPLE, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                    Text("\(Int(ratio * 100))%")
                        .font(.title3)
                        .fontWeight(.medium)
                }
                .frame(width: 80, height: 80)
            }

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Widget Declaration

struct TodoWidgets: Widget {
    let kind: String = "TodoWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TodoWidgetsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TodoWidgetsEntryView(entry: entry)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(UIColor.systemBackground))
                            .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 1)
                    )
                    .padding()
            }
        }
        .configurationDisplayName("오늘의 할 일")
        .description("오늘의 해야 할 일을 빠르게 확인하세요.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}

// MARK: - Previews using @Preview

@available(iOS 17.0, *)
#Preview("Small Widget", as: .systemSmall) {
    TodoWidgets()
} timeline: {
    TodoEntry(
        date: Date(),
        todos: [
            TodoItem(title: "커피 사기", isComplete: false, forDate: Date()),
            TodoItem(title: "코드 정리", isComplete: true, forDate: Date()),
            TodoItem(title: "아주아주아주아주아주 긴 이름입니다 12345 12345 12345 12345 12345 12345 12345 12345 12345", isComplete: false, forDate: Date()),
            TodoItem(title: "아주아주아주아주아주 긴 이름입니다 12345 12345 12345 12345 12345 12345 12345 12345 12345", isComplete: true, forDate: Date()),
            TodoItem(title: "아주아주아주아주아주 긴 이름입니다 12345 12345 12345 12345 12345 12345 12345 12345 12345", isComplete: true, forDate: Date()),
        ],
    )
}

@available(iOS 17.0, *)
#Preview("Medium Widget", as: .systemMedium) {
    TodoWidgets()
} timeline: {
    TodoEntry(
        date: Date(),
        todos: [
            TodoItem(title: "커피 사기", isComplete: false, forDate: Date()),
            TodoItem(title: "코드 정리", isComplete: true, forDate: Date()),
            TodoItem(title: "산책하기", isComplete: false, forDate: Date()),
            TodoItem(title: "책 읽기", isComplete: false, forDate: Date()),
            TodoItem(title: "아주아주아주아주아주 긴 이름입니다 12345 12345 12345 12345 12345 12345 12345 12345 12345", isComplete: false, forDate: Date()),
            TodoItem(title: "아주아주아주아주아주 긴 이름입니다 12345 12345 12345 12345 12345 12345 12345 12345 12345", isComplete: false, forDate: Date()),
            TodoItem(title: "아주아주아주아주아주 긴 이름입니다 12345 12345 12345 12345 12345 12345 12345 12345 12345", isComplete: false, forDate: Date()),
        ],
    )
}

@available(iOS 17.0, *)
#Preview("Large Widget", as: .systemLarge) {
    TodoWidgets()
} timeline: {
    TodoEntry(
        date: Date(),
        todos: [
            TodoItem(title: "커피 사기", isComplete: false,forDate: Date() ),
            TodoItem(title: "코드 정리", isComplete: true, forDate: Date()),
            TodoItem(title: "산책하기", isComplete: true, forDate: Date()),
            TodoItem(title: "책 읽기", isComplete: false, forDate: Date()),
            TodoItem(title: "앱 출시하기", isComplete: true, forDate: Date()),
            TodoItem(title: "운동하기", isComplete: false, forDate: Date()),
            TodoItem(title: "아주아주아주아주아주 긴 이름입니다 12345 12345 12345 12345 12345 12345 12345 12345 12345", isComplete: false, forDate: Date()),
            TodoItem(title: "아주아주아주아주아주 긴 이름입니다 12345 12345 12345 12345 12345 12345 12345 12345 12345", isComplete: false, forDate: Date()),
            TodoItem(title: "아주아주아주아주아주 긴 이름입니다 12345 12345 12345 12345 12345 12345 12345 12345 12345", isComplete: false, forDate: Date()),
            TodoItem(title: "아주아주아주아주아주 긴 이름입니다 12345 12345 12345 12345 12345 12345 12345 12345 12345", isComplete: true, forDate: Date()),

        ],
    )
}

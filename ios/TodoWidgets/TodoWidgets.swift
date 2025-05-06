import WidgetKit
import SwiftUI

// MARK: - TodoItem Model

struct TodoItem: Hashable {
    let title: String
    let isComplete: Bool
}

// MARK: - Timeline Entry

struct TodoEntry: TimelineEntry {
    let date: Date
    let todos: [TodoItem]
    let completedCount: Int
}

// MARK: - Provider

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TodoEntry {
        TodoEntry(date: Date(), todos: [TodoItem(title: "Sample Todo", isComplete: false)], completedCount: 0)
    }

    func getSnapshot(in context: Context, completion: @escaping (TodoEntry) -> ()) {
        let (todos, completed) = fetchTodos()
        completion(TodoEntry(date: Date(), todos: todos, completedCount: completed))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<TodoEntry>) -> ()) {
        let (todos, completed) = fetchTodos()
        let entry = TodoEntry(date: Date(), todos: todos, completedCount: completed)
        completion(Timeline(entries: [entry], policy: .atEnd))
    }

    func fetchTodos() -> ([TodoItem], Int) {
        if let userDefaults = UserDefaults(suiteName: "group.onemoonwidgets"),
           let todosJson = userDefaults.string(forKey: "daily_todos"),
           let data = todosJson.data(using: .utf8),
           let todos = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {

            let items = todos.compactMap { dict -> TodoItem? in
                guard let title = dict["title"] as? String else { return nil }
                let isComplete = dict["isComplete"] as? Bool ?? false
                return TodoItem(title: title, isComplete: isComplete)
            }

            let completedCount = items.filter { $0.isComplete }.count
            return (items, completedCount)
        }

        return ([TodoItem(title: "No todos", isComplete: false)], 0)
    }
}

// MARK: - Widget View

struct TodoWidgetsEntryView: View {
    let LAVENDER_PURPLE = Color(red: 216/255, green: 180/255, blue: 248/255)
    var entry: Provider.Entry

    @Environment(\.widgetFamily) var family

    var body: some View {
        Group {
            switch family {
            case .systemSmall:
                compactView
            case .systemMedium:
                mediumView
            case .systemLarge:
                largeView
            default:
                compactView
            }
        }
        .widgetURL(URL(string: "app-launch://")!)
    }

    private var progressText: some View {
        let total = entry.todos.count
        let complete = entry.completedCount

        return Group {
            if total > 0 {
                Text("(\(complete)/\(total))")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }

    // MARK: - Small View

    private var compactView: some View {
        let incompleteTodos = entry.todos.filter { !$0.isComplete }

        return VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text("할 일")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(LAVENDER_PURPLE)
                progressText
            }

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
                            .foregroundColor(.primary)
                    }
                }
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Medium View

    private var mediumView: some View {
        let incompleteTodos = entry.todos.filter { !$0.isComplete }

        return VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text("할 일")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(LAVENDER_PURPLE)
                progressText
            }

            if incompleteTodos.isEmpty {
                Text("할 일이 없습니다.")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(incompleteTodos.prefix(4), id: \.self) { todo in
                        HStack(alignment: .top, spacing: 2) {
                            Text("•").font(.caption).foregroundColor(.secondary)
                            Text(todo.title)
                                .font(.caption)
                                .lineLimit(1)
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
        let total = entry.todos.count
        let complete = entry.completedCount
        let ratio = total == 0 ? 0 : Float(complete) / Float(total)

        return VStack(alignment: .leading, spacing: 12) {
            Text("오늘 할 일")
                .font(.title2)
                .fontWeight(.bold)

            HStack(alignment: .top, spacing: 20) {
                VStack(alignment: .leading, spacing: 6) {
                    if entry.todos.isEmpty {
                        Text("할 일이 없습니다.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        ForEach(entry.todos.prefix(6), id: \.self) { todo in
                            HStack(alignment: .top, spacing: 6) {
                                Text("•").foregroundColor(.secondary)
                                Text(todo.title)
                                    .font(.subheadline)
                                    .lineLimit(1)
                                    .strikethrough(todo.isComplete, color: .gray)
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

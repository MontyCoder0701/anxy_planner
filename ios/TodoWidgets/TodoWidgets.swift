//
//  TodoWidgets.swift
//  TodoWidgets
//
//  Created by Soojeong Lee on 5/6/25.
//

import WidgetKit
import SwiftUI

struct TodoEntry: TimelineEntry {
    let date: Date
    let todos: [String]
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> TodoEntry {
            TodoEntry(date: Date(), todos: ["Sample Todo"])
        }

        func getSnapshot(in context: Context, completion: @escaping (TodoEntry) -> ()) {
            let entry = TodoEntry(date: Date(), todos: fetchTodos())
            completion(entry)
        }

        func getTimeline(in context: Context, completion: @escaping (Timeline<TodoEntry>) -> ()) {
            let entry = TodoEntry(date: Date(), todos: fetchTodos())
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }

        func fetchTodos() -> [String] {
            if let userDefaults = UserDefaults(suiteName: "group.onemoonwidgets") {
                if let todosJson = userDefaults.string(forKey: "daily_todos"),
                   let data = todosJson.data(using: .utf8),
                   let todos = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] {
                    return todos.map { $0["title"] as? String ?? "No title" }
                }
            }
            return ["No todos"]
        }
}

struct TodoWidgetsEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading) {
            Text("오늘 할 일").bold()
            ForEach(entry.todos.prefix(3), id: \.self) { todo in
                Text("• \(todo)")
                    .font(.caption)
            }
        }
        .padding()
    }
}

struct TodoWidgets: Widget {
    let kind: String = "TodoWidgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                TodoWidgetsEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                TodoWidgetsEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

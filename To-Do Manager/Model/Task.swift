//
//  Task.swift
//  To-Do Manager
//
//  Created by 1234 on 04.08.2023.
//

import Foundation

enum TaskPriority {
    // Обычная
    case normal
    // Важная
    case important
}

enum TaskStatus {
    // Запланированная
    case planned
    // Выполненная
    case completed
}

protocol TaskProtocol {
    var title: String { get set }
    var type: TaskPriority { get set }
    var status: TaskStatus { get set }
}

// Сущность "Задача"

struct Task: TaskProtocol {
    var title: String
    var type: TaskPriority
    var status: TaskStatus
}

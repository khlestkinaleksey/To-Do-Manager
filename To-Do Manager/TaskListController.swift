//
//  TaskListController.swift
//  To-Do Manager
//
//  Created by 1234 on 04.08.2023.
//

import UIKit

class TaskListController: UITableViewController {
    
    // Хренилище задач
    var taskStorage: TaskStorageProtocol = TaskStorage()
    // Коллекция задач
    var tasks: [TaskPriority:[TaskProtocol]] = [:] {
        didSet {
            for (taskGroupPriority, taskGroup) in tasks {
                tasks[taskGroupPriority] = taskGroup.sorted(by: { task1, task2 in
                    let task1Position = taskStatusPosition.firstIndex(of: task1.status) ?? 0
                    let task2Position = taskStatusPosition.firstIndex(of: task2.status) ?? 0
                    
                    return task1Position < task2Position
                })
            }
        }
    }
    // Порядок отображения в массиве
    var sectionTypesPosition: [TaskPriority] = [.important, .normal]
    var taskStatusPosition: [TaskStatus] = [.planned, .completed]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTasks()
        navigationItem.leftBarButtonItem = editButtonItem
    }
    
    
    private func loadTasks() {
        // Инициализируем пустым массивом каждый из приоритетов-типов задач
        sectionTypesPosition.forEach { taskType in
            tasks[taskType] = []
        }
        // Загрузка и разбор задач из хранилища
        taskStorage.loadTask().forEach { task in
            tasks[task.type]?.append(task)
        }
    }

    // MARK: - Table view data source
    


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return tasks.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let taskType = sectionTypesPosition[section]
        guard let currentTaskType = tasks[taskType] else { return 0 }
        return currentTaskType.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //getConfigurateTaskCell_constraints(for: indexPath)
        getConfigurateTaskCell_stack(for: indexPath)
    }
    
    private func getConfigurateTaskCell_stack(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellStack", for: indexPath) as! TaskCell
        // Получаем данные о задаче, которую нужно вывести в ячейку
        let taskType = sectionTypesPosition[indexPath.section]
        guard let currenTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        cell.title.text = currenTask.title
        cell.symbol.text = getSymbolForTask(with: currenTask.status)
        
        if currenTask.status == .planned {
            cell.title.textColor = .black
            cell.symbol.textColor = .black
        } else {
            cell.title.textColor = .lightGray
            cell.symbol.textColor = .lightGray
        }
        
        return cell
    }
    
    private func getConfigurateTaskCell_constraints(for indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCellConstraints", for: indexPath)
        
        // Получаем данные о задаче, которую необходимо вывести в ячейке
        let taskType = sectionTypesPosition[indexPath.section]
        guard let currentTask = tasks[taskType]?[indexPath.row] else {
            return cell
        }
        let symbolLabel = cell.viewWithTag(1) as? UILabel
        let titleLabel = cell.viewWithTag(2) as? UILabel
        
        // TODO: symbolLabel
        symbolLabel?.text = getSymbolForTask(with: currentTask.status)
        titleLabel?.text = currentTask.title
        
        if currentTask.status == .planned {
            symbolLabel?.textColor = .black
            titleLabel?.textColor = .black
        } else {
            symbolLabel?.textColor = .lightGray
            titleLabel?.textColor = .lightGray
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title: String?
        let taskType = sectionTypesPosition[section]
        if taskType == .important {
            title = "Важные"
        } else if taskType == .normal {
            title = "Текущие"
        }
        return title
    }
    
    private func getSymbolForTask(with status: TaskStatus) -> String {
        var resultSymbol: String
        
        if status == .planned {
            resultSymbol = "\u{25CB}"
        } else if status == .completed {
            resultSymbol = "\u{25C9}"
        } else {
            resultSymbol = ""
        }
        
        return resultSymbol
    }
    
    // Метод для изменения статуса задачи
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Проверяем существование задачи
        let taskType = sectionTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return
        }
        if tasks[taskType]?[indexPath.row].status == .planned {
            tasks[taskType]?[indexPath.row].status = .completed
            // перезагружаем секцию таблицы
            tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        } else {
            // снимаем выделение со строки
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Проверяем существование задачи
        let taskType = sectionTypesPosition[indexPath.section]
        guard let _ = tasks[taskType]?[indexPath.row] else {
            return nil
        }
        guard tasks[taskType]?[indexPath.row].status == .completed else {
            return nil
        }
        
        let action = UIContextualAction(style: .normal, title: "Не выполнена") { _, _, _ in
            self.tasks[taskType]?[indexPath.row].status = .planned
            self.tableView.reloadSections(IndexSet(arrayLiteral: indexPath.section), with: .automatic)
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
}

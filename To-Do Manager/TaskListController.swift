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
    var tasks: [TaskPriority:[TaskProtocol]] = [:]
    // Порядок отображения в массиве
    var sectionTypesPosition: [TaskPriority] = [.important, .normal]
    var taskStatusPosition: [TaskStatus] = [.planned, .completed]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadTasks()
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
        // Сортировка списка задач
        for (taskGroupPriority, taskGroup) in tasks {
            tasks[taskGroupPriority] = taskGroup.sorted(by: { task1, task2 in
                let task1Position = taskStatusPosition.firstIndex(of: task1.status) ?? 0
                let task2Position = taskStatusPosition.firstIndex(of: task2.status) ?? 0
                
                return task1Position < task2Position
            })
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

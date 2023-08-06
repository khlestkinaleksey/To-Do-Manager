//
//  TaskListControllerExtensionDS.swift
//  To-Do Manager
//
//  Created by 1234 on 06.08.2023.
//

import UIKit
// MARK: - Data Source Methods
extension TaskListController {
// MARK: Метод режима удаления
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let taskType = sectionTypesPosition[indexPath.section]
        if editingStyle == .delete {
            tasks[taskType]?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        } else if editingStyle == .insert {
            // TODO:  Добавить релаизацию добавления нового элекмента
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    // MARK: - Указание возможности редактирования ячейки
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 {
            return false
        }
        return true
    }
    // MARK: - Указание типа-варианта редактирования ячейки
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if indexPath.row == 0 {
            return .insert
        }
        return .delete
    }
    // MARK: - Определение возможности изменения позиции строки в табличном представлении
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 && indexPath.row == 0 {
            return false
        }
        return true
    }
    // MARK: - Метод, вызываемый при изменении позиции строки с moveRowAt на to
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let taskTypeFrom = sectionTypesPosition[sourceIndexPath.section]
        let taskTypeTo = sectionTypesPosition[destinationIndexPath.section]
        guard let movedTask = tasks[taskTypeFrom]?[sourceIndexPath.row] else {
            return
        }
        tasks[taskTypeFrom]!.remove(at: sourceIndexPath.row)
        tasks[taskTypeTo]?.insert(movedTask, at: destinationIndexPath.row)
        
        if taskTypeTo != taskTypeFrom {
            tasks[taskTypeTo]![destinationIndexPath.row].type = taskTypeTo
        }
        // reloadData позволяет заново сформировать и отобразить tableView
        tableView.reloadData()
    }
}

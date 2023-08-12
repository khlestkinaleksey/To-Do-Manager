//
//  TaskTypeController.swift
//  To-Do Manager
//
//  Created by 1234 on 12.08.2023.
//

import UIKit

class TaskTypeController: UITableViewController {
    
    // Кортеж, описывающий тип задачи
    typealias TypeCellDescription = (type: TaskPriority, title: String, description: String)
    // Коллекция доступных типов задач с их описанием
    private var taskTypeInformation: [TypeCellDescription] = [
        (type: .important,
         title: "Важная",
         description: "Такой тип задач является наиболее приоритетным для выполнения. Все важные задачи выводятся в самом верху списка задач"),
        (type: .normal,
         title: "Текущая",
         description: "Задача с обычным приоритетом")
    ]
    var selectedType: TaskPriority = .normal
    
    var doAfterTypeSelected: ((TaskPriority) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Регистрируем кастомную ячейку
        let cellTypeNib = UINib(nibName: "TaskTypeCell", bundle: nil)
        tableView.register(cellTypeNib, forCellReuseIdentifier: "TaskTypeCell")

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskTypeInformation.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTypeCell", for: indexPath) as! TaskTypeCell
        let typeDescription = taskTypeInformation[indexPath.row]
        
        cell.typeTitle.text = typeDescription.title
        cell.typeDescription.text = typeDescription.description
        
        if selectedType == typeDescription.type {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedType = taskTypeInformation[indexPath.row].type
        doAfterTypeSelected?(selectedType)
        navigationController?.popViewController(animated: true)
    }

}

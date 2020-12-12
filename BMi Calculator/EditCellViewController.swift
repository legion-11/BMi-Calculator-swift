//
//  EditCellViewController.swift
//  BMi Calculator
//
//  Created by Dmytro Andriichuk 301132978 on 12.12.2020.
//  Copyright © 2020 legion-11. All rights reserved.
//

import UIKit

class EditCellViewController: UIViewController {
    
    @IBOutlet weak var weightUnitLable: UILabel!
    @IBOutlet weak var weightEdit: UITextField!
    @IBOutlet weak var weightSlider: UISlider!
    @IBOutlet weak var datePicker: UIDatePicker!
    var height: Float!
    
    
    var tableViewControler: TableViewController!
    // cell that was pressed  and its index
    var cell: UITableViewCell!
    var index: IndexPath!
    
    //initialize with data from cell
    override func viewDidLoad() {
        super.viewDidLoad()
        weightEdit.text = String(tableViewControler.viewControler.weights[index.row])
        datePicker.date = tableViewControler.viewControler.dates[index.row]
        weightSlider.value = (weightEdit.text! as NSString).floatValue
    }
    
    @IBAction func switchMetricSystem(_ sender: UISwitch) {
        weightUnitLable.text = sender.isOn ? "kg": "ib"
    }
    
    // change text field so it will correspond to slider
    @IBAction func changeWeightWithSlider(_ sender: UISlider) {
        weightEdit.text = String(format: "%.2f", sender.value)
    }
    
    // change slider so it will correspond to  text field
    @IBAction func changeWeightWithEditField(_ sender: UITextField) {
        if (sender.text?.isEmpty == true) {sender.text = "30"}
        let valueInFloat = (sender.text! as NSString).floatValue
        weightSlider.value = valueInFloat
    }
    
    //calculate bmi and save it in plist and update table
    @IBAction func confirmButtonPressed(_ sender: UIButton) {
        let scalerWeight: Float = (weightUnitLable.text == "kg" ) ? 1.0 : 703.0
        let scalerHeigh: Float = (weightUnitLable.text == "kg" ) ? 100.0 : 1.0
        let weight = (weightEdit.text! as NSString).floatValue
        
        let height = (tableViewControler.viewControler.HeighEdit.text! as NSString).floatValue
        
        let bmi = (weight * scalerWeight)/(height/scalerHeigh * height/scalerHeigh)
        tableViewControler.viewControler.bmis[index.row] = bmi
        
        tableViewControler.viewControler.weights[index.row] = weight
        
        tableViewControler.viewControler.dates[index.row] = datePicker.date
        tableViewControler.viewControler.saveTableData()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm EEEE, d MMMM y"
        cell.textLabel?.text = "BMI - \(bmi)  Weight - \(weight)"
        cell.detailTextLabel?.text = formatter.string(from: datePicker.date)

        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

    }
    
    // do not alow to input two dots in field
    @IBAction func checkDot(_ sender: UITextField) {
        let occurrenciesOfDot = sender.text?.filter { $0 == "." }.count
        if (occurrenciesOfDot ?? 1 > 1) {
            var text = sender.text
            let indexOfDot = text!.lastIndex(of: ".")
            text?.remove(at: indexOfDot!)
            sender.text = text
        }
        if (sender.text?.first == ".") {
            sender.text = "0" + sender.text!
        }
        
    }
    
    // cehck if we saved bmi, if not delete cell, since it is useles
    override func viewDidDisappear(_ animated: Bool) {
        if (tableViewControler.viewControler.bmis[index.row] == 0.0) {
            tableViewControler.tableView.beginUpdates()
            tableViewControler.viewControler.weights.remove(at: index.row)
            tableViewControler.viewControler.bmis.remove(at: index.row)
            tableViewControler.viewControler.dates.remove(at: index.row)
            tableViewControler.tableView.deleteRows(at: [index], with: .fade)
            tableViewControler.tableView.endUpdates()
        }
    }
    
    //hide keyboard when press outside text field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

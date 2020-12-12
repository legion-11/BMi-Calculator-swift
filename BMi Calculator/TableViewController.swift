//
//  TableViewController.swift
//  BMi Calculator
//
//  Created by Dmytro Andriichuk 301132978 on 11.12.2020.
//  Copyright © 2020 legion-11. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController  {

    var viewControler: ViewController!
    let formatter = DateFormatter()
    
    // cell that was pressed and its indexpath
    var cell: UITableViewCell!
    var cellIndex: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "HH:mm EEEE, d MMMM y"
    }


    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // all data will be taken from viewControler since it has already loaded it
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return viewControler.weights.count
    }

    // create dafault cell and change its data
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        cell.textLabel?.text = "BMI - \(viewControler.bmis[indexPath.row])  Weight - \(viewControler.weights[indexPath.row])"
        cell.detailTextLabel?.text = formatter.string(from: viewControler.dates[indexPath.row])

        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.beginUpdates()
            viewControler.weights.remove(at: indexPath.row)
            viewControler.bmis.remove(at: indexPath.row)
            viewControler.dates.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
            
            viewControler.saveTableData()
            if (viewControler.weights.count == 0){
                navigationController?.popViewController(animated: true)
            }
        }
    }

    // click on cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            cell = tableView.cellForRow(at: indexPath)
            cellIndex = indexPath
            performSegue(withIdentifier: "editCell", sender: nil)
        }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewControler = segue.destination as? EditCellViewController {
            viewControler.tableViewControler = self
            viewControler.cell = cell
            viewControler.index = cellIndex
        }
    }
    
    // add cell
    @IBAction func addCell(_ sender: Any) {
        tableView.beginUpdates()
        viewControler.weights.append(50.0)
        viewControler.bmis.append(0.0)
        viewControler.dates.append(Date())
        let index = IndexPath(row: viewControler.weights.count-1, section: 0)
        tableView.insertRows(at: [index], with: .automatic)
        tableView.endUpdates()
        
        cell = tableView.cellForRow(at: index)
        cellIndex = index
        performSegue(withIdentifier: "editCell", sender: nil)
    }
    
}

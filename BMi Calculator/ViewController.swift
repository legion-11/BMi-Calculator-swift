//
//  ViewController.swift
//  BMi Calculator
//
//  Created by Dmytro Andriichuk 301132978 on 09.12.2020.
//  Copyright © 2020 legion-11. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    var sex: String = "male"
    
    //get path to plist
    func dataFileURL() -> NSURL {
        let urls = FileManager.default.urls(for:
            .documentDirectory, in: .userDomainMask)
        var url:NSURL?
        // create a blank path
        url = URL(fileURLWithPath: "") as NSURL?
        do {
            url = urls.first?.appendingPathComponent("bmiUserCommonData.plist") as NSURL?
        }
        
        return url!
    }
    
    // arrays with data for table cells
    var weights: [Float] = []
    var bmis: [Float] = []
    var dates: [Date] = []
    
    // path to save data for table cells
    func tableDataURL() -> NSURL {
        let urls = FileManager.default.urls(for:
            .documentDirectory, in: .userDomainMask)
        var url:NSURL?
        // create a blank path
        url = URL(fileURLWithPath: "") as NSURL?
        do {
            url = urls.first?.appendingPathComponent("bmiTableData.plist") as NSURL?
        }
        
        return url!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load data from plist
        let fileURL = dataFileURL()
        if (FileManager.default.fileExists(atPath: fileURL.path!)) {
            let loadedDictionary = NSDictionary(contentsOf: fileURL as URL)

            if let dictionary = loadedDictionary {
                nameEdit.text = dictionary["name"] as? String
                ageEdit.text = dictionary["age"] as? String
                weightEdit.text = dictionary["weight"] as? String
                HeighEdit.text = dictionary["heigh"] as? String
                sex = dictionary["sex"] as? String ?? "male"
                
                weightSlider.value = (dictionary["weight"] as! NSString).floatValue
                heightSlider.value = (dictionary["heigh"] as! NSString).floatValue
                ageSlider.value = (dictionary["age"]as! NSString).floatValue
                
                
                maleButton.isSelected = sex == "male"
                maleButton.backgroundColor = sex == "male" ? UIColor.link : UIColor.clear
                femaleButton.isSelected = sex != "male"
                femaleButton.backgroundColor = sex != "male" ? UIColor.link : UIColor.clear
                
                print("load1")
            }
        }
        //load data from plist for table cells
        let tableFileURL = tableDataURL()
        if (FileManager.default.fileExists(atPath: tableFileURL.path!)) {
            let loadedDictionary = NSDictionary(contentsOf: tableFileURL as URL)
            
            if let dictionary = loadedDictionary {
                print(dictionary)
                weights = dictionary["weights"] as! [Float]
                bmis = dictionary["bmis"] as! [Float]
                dates = dictionary["dates"] as! [Date]

                print("load2")
            }
        }
        
    }
    
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBAction func sexButtonPress(_ sender: UIButton) {
        sex = sender == maleButton ? "male" : "female"
        maleButton.isSelected = sender == maleButton
        femaleButton.isSelected = sender == femaleButton
        maleButton.backgroundColor = sender == maleButton ? UIColor.link : UIColor.clear
        femaleButton.backgroundColor = sender == femaleButton ? UIColor.link : UIColor.clear
    }
    
    
    @IBOutlet weak var systemTypeLable: UILabel!
    @IBOutlet weak var weightUnitLable: UILabel!
    @IBOutlet weak var heightUnitLable: UILabel!
    // changes labels that shows common unt system
    @IBAction func switchMetricSystem(_ sender: UISwitch) {
        weightUnitLable.text = sender.isOn ? "kg": "ib"
        heightUnitLable.text = sender.isOn ? "cm": "in"
        systemTypeLable.text = sender.isOn ? "Metric System" : "Imperial System"
    }
    
    
    @IBOutlet weak var HeighEdit: UITextField!
    @IBOutlet weak var heightSlider: UISlider!
    
    // change text field when you specify heigh with slider
    @IBAction func changeHeighWithSlider(_ sender: UISlider) {
        HeighEdit.text = String(format: "%.2f", sender.value)
    }
    
    // change slider to correspond text field
    @IBAction func changeHeighWithEditField(_ sender: UITextField) {
        if (sender.text?.isEmpty == true) {sender.text = "30"}
        let valueInFloat = (sender.text! as NSString).floatValue
    
        heightSlider.value = valueInFloat
    }
    
    
    @IBOutlet weak var weightEdit: UITextField!
    @IBOutlet weak var weightSlider: UISlider!
    // change text field when you specify heigh with slider
    @IBAction func changeWeightWithSlider(_ sender: UISlider) {
        weightEdit.text = String(format: "%.2f", sender.value)
    }
    // change slider to correspond text field
    @IBAction func changeWeightWithEditField(_ sender: UITextField) {
        if (sender.text?.isEmpty == true) {sender.text = "30"}
        let valueInFloat = (sender.text! as NSString).floatValue
        weightSlider.value = valueInFloat
    }
    
    
    @IBOutlet weak var ageEdit: UITextField!
    @IBOutlet weak var ageSlider: UISlider!
    // change text field when you specify heigh with slider
    @IBAction func changeAgeWithSlider(_ sender: UISlider) {
        ageEdit.text = String(Int(sender.value))
    }
    
    // change slider to correspond text field
    @IBAction func changeAgeWithEditField(_ sender: UITextField) {
        if (sender.text?.isEmpty == true) {sender.text = "30"}
        let valueInFloat = (sender.text! as NSString).floatValue
        weightSlider.value = valueInFloat
    }
    
    @IBOutlet weak var nameEdit: UITextField!
    
    // not allowing input of two dots
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
    
    //hide keyboard on click on empty area of view controller
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    //save input to plist that will add a cell to table view
    @IBAction func confirmButton(_ sender: UIButton) {
        let weight = weightEdit.text!
        let tmpdata = ["name": nameEdit.text!,
                       "age": ageEdit.text!,
                       "weight": weight,
                       "heigh": HeighEdit.text!,
                       "sex": sex
                       ] as NSDictionary
        
        tmpdata.write(to: dataFileURL() as URL, atomically: true)
        print("saved")
        
        let bmi = calculateBMI()
        let category = getCategory(f: bmi)
        weights.append((weight as NSString).floatValue)
        bmis.append(bmi)
        dates.append(Date())
        saveTableData()
        
        let alert = UIAlertController(title: String(bmi), message: category, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
    //calculate bmi depending on system
    func calculateBMI() -> Float {
        let scalerWeight: Float = (weightUnitLable.text == "kg" ) ? 1.0 : 703.0
        let scalerHeigh: Float = (weightUnitLable.text == "kg" ) ? 100.0 : 1.0
        let weight = (weightEdit.text! as NSString).floatValue
        let height = (HeighEdit.text! as NSString).floatValue
        
        return (weight * scalerWeight)/(height/scalerHeigh * height/scalerHeigh)
    }
    
    //get bmi category from bmi
    func getCategory(f: Float) -> String {
        if (f < 16) { return "Severe Thinnes"
        } else if (f < 17) { return "Moderate Thinnes"
        } else if (f < 18.5) { return "Mild Thinnes"
        } else if (f < 25) { return "Normal"
        } else if (f < 30) { return "Overweight"
        } else if (f < 35) { return "Obese class I"
        } else if (f < 40) { return "Obese class II"
        } else { return "Obese class III"
        }
    }
    
    
    @IBAction func SegueToTableView(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "mainToTable", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tableControler = segue.destination as? TableViewController {
            tableControler.viewControler = self
        }
    }
    
    // save table data to plist
    func saveTableData() {
        let tmpData = ["weights": weights,
                       "bmis": bmis,
                       "dates": dates
        ] as NSDictionary
        tmpData.write(to: tableDataURL() as URL, atomically: true)
        print("saved2")
        print(tmpData)
    }
}


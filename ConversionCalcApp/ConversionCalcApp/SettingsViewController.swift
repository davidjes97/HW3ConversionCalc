//
//  SettingsViewController.swift
//  ConversionCalcApp
//
//  Created by Xcode User on 9/23/19.
//  Copyright © 2019 DavidAndHildebrand. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate {
    func settingsChanged(fromUnits: LengthUnit, toUnits: LengthUnit)
    func settingsChanged(fromUnits: VolumeUnit, toUnits: VolumeUnit)
}


class SettingsViewController: UIViewController {

    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    
    var pickerData: [String] = [String]()
    var selection: String?
    var pickerSpot : String?
    var delegate: SettingsViewControllerDelegate?
    
    var mode : CalculatorMode?
    
    var fromLength: LengthUnit?
    var toLength: LengthUnit?
    var fromVolume: VolumeUnit?
    var toVolume: VolumeUnit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.picker.delegate = self
        self.picker.isHidden = true
        if mode == .Length{
            LengthUnit.allCases.forEach{
                pickerData.append($0.rawValue)
            }
            self.fromLabel.text? = self.fromLength!.rawValue
            self.toLabel.text? = self.toLength!.rawValue
            }
        else{
            VolumeUnit.allCases.forEach{
                    pickerData.append($0.rawValue)
            }
            self.fromLabel.text? = self.fromVolume!.rawValue
            self.toLabel.text? = self.toVolume!.rawValue
        }
        
    
        self.picker.dataSource = self
        
        self.fromLabel.isUserInteractionEnabled = true
        self.toLabel.isUserInteractionEnabled = true
        
       let fromTap = UITapGestureRecognizer(target: self, action: #selector(fromLaunchPicker))
        let toTap = UITapGestureRecognizer(target: self, action: #selector(toLaunchPicker))
        fromLabel.addGestureRecognizer(fromTap)
        toLabel.addGestureRecognizer(toTap)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.picker.isHidden = true
        
        if pickerSpot == "from"{
            self.fromLabel.text = self.selection
        }
        else if pickerSpot == "to"{
            self.toLabel.text = self.selection
        }
        pickerSpot = ""
    }
    
    @objc private func fromLaunchPicker(){
        self.picker.isHidden = false
        becomeFirstResponder()
        self.pickerSpot = "from"
    }
    
    @objc private func toLaunchPicker(){
        self.picker.isHidden = false
        becomeFirstResponder()
        self.pickerSpot = "to"
    }
    
    @IBAction func saveButtonClicked(_ sender: Any) {
        self.picker.isHidden = true
        
        if let d = self.delegate{
            if mode == .Length{
                d.settingsChanged(fromUnits: LengthUnit(rawValue: fromLabel.text!)!, toUnits: LengthUnit(rawValue: toLabel.text!)!)
            }
            else{
                 d.settingsChanged(fromUnits: VolumeUnit(rawValue: fromLabel.text!)!, toUnits: VolumeUnit(rawValue: toLabel.text!)!)
            }
        }
        self.dismiss(animated:true, completion: nil)
    }
    
    @IBAction func cancelButtonClicked(_ sender: Any) {
        self.picker.isHidden = true
        self.dismiss(animated:true, completion: nil)
        
    }
    
}

extension SettingsViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selection = self.pickerData[row]
    }
    
}

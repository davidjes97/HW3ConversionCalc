//
//  ViewController.swift
//  ConversionCalcApp
//
//  Created by Xcode User on 9/21/19.
//  Copyright © 2019 DavidAndHildebrand. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SettingsViewControllerDelegate {
    
    var nameText = ""
    
    
    var mode = CalculatorMode.Length
    
    var tLengthUnits = LengthUnit.Meters
    var fLengthUnits = LengthUnit.Yards
    
    var tVolumeUnits = VolumeUnit.Liters
    var fVolumeUnits = VolumeUnit.Gallons

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tUnitLabel: UILabel!
    @IBOutlet weak var fUnitLabel: UILabel!
    
    @IBOutlet weak var tTextField: DecimalMinusTextField!
    @IBOutlet weak var fTextField: DecimalMinusTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func clearButtonClicked(_ sender: UIButton) {
        tTextField.text = nil
        fTextField.text = nil
        view.endEditing(true)
    }
    
    @IBAction func tTextField(_ sender: UITextField) {
        fTextField.text = nil
    }
    
    @IBAction func fTextField(_ sender: UITextField) {
        tTextField.text = nil
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        view.endEditing(true)
    }
    
    @IBAction func modeButtonClicked(_ sender: UIButton) {
        view.endEditing(true)
        fTextField.text = nil
        tTextField.text = nil
        if mode == .Length {
            mode = CalculatorMode.Volume
            titleLabel.text = "Volume Conversion Calculator"
            fTextField.placeholder = "Enter volume in \(fVolumeUnits)"
            tTextField.placeholder = "Enter volume in \(tVolumeUnits)"
            tUnitLabel.text = "\(tVolumeUnits)"
            fUnitLabel.text = "\(fVolumeUnits)"
        }
        else{
            mode = CalculatorMode.Length
            titleLabel.text = "Length Conversion Calculator"
            fTextField.placeholder = "Enter length in \(fLengthUnits)"
            tTextField.placeholder = "Enter length in \(tLengthUnits)"
            tUnitLabel.text = "\(tLengthUnits)"
            fUnitLabel.text = "\(fLengthUnits)"
        }
    }
    
    
    @IBAction func caculateButtonClicked(_ sender: UIButton) {
        view.endEditing(true)
        if(mode == .Length){
            if(self.fTextField.text! != ""){
                let fromVal = Double(self.fTextField.text!)
                let convKey = LengthConversionKey(toUnits: tLengthUnits, fromUnits: fLengthUnits)
                self.tTextField.text = String(fromVal! * lengthConversionTable[convKey]!)
            } else if(self.tTextField.text! != ""){
                let fromVal = Double(self.tTextField.text!)
                let convKey = LengthConversionKey(toUnits: tLengthUnits, fromUnits: fLengthUnits)
                self.fTextField.text = String(fromVal! * lengthConversionTable[convKey]!)
            } else{
                self.fTextField.text = String(0)
                self.tTextField.text = String(0)
            }
        }
        else{
            if(self.fTextField.text! != ""){
                let fromVal = Double(self.fTextField.text!)
                let convKey = VolumeConversionKey(toUnits: tVolumeUnits, fromUnits: fVolumeUnits)
                self.tTextField.text = String(fromVal! * volumeConversionTable[convKey]!)
            } else if(self.tTextField.text! != ""){
                let fromVal = Double(self.tTextField.text!)
                let convKey = VolumeConversionKey(toUnits: tVolumeUnits, fromUnits: fVolumeUnits)
                self.fTextField.text = String(fromVal! * volumeConversionTable[convKey]!)
            } else{
                self.fTextField.text = String(0)
                self.tTextField.text = String(0)
            }
        }
       
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func settingsChanged(fromUnits: LengthUnit, toUnits: LengthUnit){
        self.fLengthUnits = fromUnits
        self.tLengthUnits = toUnits
        fTextField.placeholder = "Enter length in \(fLengthUnits)"
        tTextField.placeholder = "Enter length in \(tLengthUnits)"
        tUnitLabel.text = "\(tLengthUnits)"
        fUnitLabel.text = "\(fLengthUnits)"
    }
    func settingsChanged(fromUnits: VolumeUnit, toUnits: VolumeUnit){
        self.fVolumeUnits = fromUnits
        self.tVolumeUnits = toUnits
        fTextField.placeholder = "Enter volume in \(fVolumeUnits)"
        tTextField.placeholder = "Enter volume in \(tVolumeUnits)"
        tUnitLabel.text = "\(tVolumeUnits)"
        fUnitLabel.text = "\(fVolumeUnits)"
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "chooseSettings"{
            if let dest = segue.destination as? UINavigationController{
                if let test = dest.viewControllers[0] as? SettingsViewController{
                    test.delegate = self
                    test.mode = self.mode
                    test.fromLength = self.fLengthUnits
                    test.toLength = self.tLengthUnits
                    test.fromVolume = self.fVolumeUnits
                    test.toVolume = self.tVolumeUnits
                }
            }
        }
    }
}

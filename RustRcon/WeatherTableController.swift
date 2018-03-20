//
//  WeatherTableController.swift
//  RustRcon
//
//  Created by Louis Gornall on 24/10/2017.
//  Copyright © 2017 ShantyShackApps. All rights reserved.
//

import UIKit

class WeatherTableController: UITableViewController, weatherView{
    func didReceiveWeather(value: String, type: String) {
        var relevantUISlider: UISlider
        var relevantUIToggle: UISwitch
        print("type is \(type) and value is \(value)")
        if type == "weather.wind"{
            relevantUISlider = windSlider
            relevantUIToggle = windAutoToggle
        }else if type == "weather.fog"{
            relevantUISlider = fogSlider
            relevantUIToggle = fogAutoToggle
        }else if type == "weather.clouds"{
            relevantUISlider = cloudSlider
            relevantUIToggle = cloudAutoToggle
        }else{
            relevantUISlider = rainSlider
            relevantUIToggle = rainAutoToggle
        }
        
        if value == "automatic" {
            relevantUIToggle.isOn = true
            relevantUISlider.isEnabled = false
        } else {
            relevantUIToggle.isOn = false
            relevantUISlider.value = Float(value)!
        }
        
        self.title = "Weather"
    }
    
    @IBOutlet weak var rainAutoToggle: UISwitch!
    @IBOutlet weak var windAutoToggle: UISwitch!
    @IBOutlet weak var cloudAutoToggle: UISwitch!
    @IBOutlet weak var fogAutoToggle: UISwitch!
    @IBOutlet weak var rainSlider: UISlider!
    @IBOutlet weak var windSlider: UISlider!
    @IBOutlet weak var cloudSlider: UISlider!
    @IBOutlet weak var fogSlider: UISlider!
    @IBOutlet weak var rainLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var cloudLabel: UILabel!
    @IBOutlet weak var fogLabel: UILabel!
    
    @IBAction func saveWasPressed(_ sender: Any) {
        setWeather(type: "weather.rain", slider: rainSlider, toggle: rainAutoToggle)
        setWeather(type: "weather.wind", slider: windSlider, toggle: windAutoToggle)
        setWeather(type: "weather.clouds", slider: cloudSlider, toggle: cloudAutoToggle)
        setWeather(type: "weather.fog", slider: fogSlider, toggle: fogAutoToggle)
        let alertViewController = self.storyboard?.instantiateViewController(withIdentifier: "confirmationViewController") as! confirmationViewController
        
        self.present(alertViewController, animated: true, completion: nil)
    }
    
    func setWeather(type: String, slider: UISlider, toggle: UISwitch){
        let myNavBar = self.navigationController as! ServerNavViewController
        if toggle.isOn{
            myNavBar.rconnection?.send(message: "\(type) automatic", identifier: 99)
        } else {
            myNavBar.rconnection?.send(message: "\(type) \(slider.value)", identifier: 99)
        }
    }
    
    @IBAction func rainToggled(_ sender: Any) {
        if rainAutoToggle.isOn{
            rainSlider.isEnabled = false
            rainLabel.text = "Auto"
        } else {
            rainSlider.isEnabled = true
            rainLabel.text = "%\(Int(rainSlider.value * 100))"
        }
    }
    @IBAction func windToggled(_ sender: Any) {
        if windAutoToggle.isOn{
            windSlider.isEnabled = false
            windLabel.text = "Auto"
        }else {
            windSlider.isEnabled = true
            windLabel.text = "%\(Int(windSlider.value * 100))"
        }
    }
    @IBAction func cloudToggled(_ sender: Any) {
        if cloudAutoToggle.isOn{
            cloudSlider.isEnabled = false
            cloudLabel.text = "Auto"
        }else {
            cloudSlider.isEnabled = true
            cloudLabel.text = "%\(Int(cloudSlider.value * 100))"
        }
    }
    @IBAction func fogToggled(_ sender: Any) {
        if fogAutoToggle.isOn{
            fogSlider.isEnabled = false
            fogLabel.text = "Auto"
        }else {
            fogSlider.isEnabled = true
            fogLabel.text = "%\(Int(fogSlider.value * 100))"
        }
    }
    @IBAction func rainSliderChanged(_ sender: UISlider) {
        rainLabel.text = "%\(Int(rainSlider.value * 100))"
    }
    @IBAction func windSliderChanged(_ sender: Any) {
        windLabel.text = "%\(Int(windSlider.value * 100))"
    }
    @IBAction func cloudSliderChanged(_ sender: Any) {
        cloudLabel.text = "%\(Int(cloudSlider.value * 100))"
    }
    @IBAction func fogSliderChanged(_ sender: Any) {
        fogLabel.text = "%\(Int(fogSlider.value * 100))"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let myNavBar = self.navigationController as! ServerNavViewController
        myNavBar.weatherViewDelegate = self
        self.title = "Loading..."
        myNavBar.rconnection?.requestFog()
        myNavBar.rconnection?.requestRain()
        myNavBar.rconnection?.requestWind()
        myNavBar.rconnection?.requestClouds()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

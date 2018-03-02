//
//  PopUpViewController.swift
//  TestBASquare
//
//  Created by Petro Novosad on 3/2/18.
//  Copyright © 2018 Petro Novosad. All rights reserved.
//
//=============================================================================================

import UIKit

//=============================================================================================
//
//     class WeatherViewController
//
//=============================================================================================

class WeatherViewController: UIViewController
{
    //---------------------------------------------------------------------------------------------
    
    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temparatureLabel: UILabel!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var citiesDataSource: CitiesDataSource?
    
    //---------------------------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherViewController.weatherDateNotification(_:)), name: NSNotification.Name(rawValue: WeatherDateNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherViewController.weatherDateNotAvailableNotification(_:)), name: NSNotification.Name(rawValue: WeatherDateNotAvailableNotification), object: nil)
        
        if self.citiesDataSource != nil,
            let selectedCityName = self.citiesDataSource!.getSelectedCityName()
        {
            WeatherDataManager.instance.receiveWeather(for: selectedCityName)
        }
    }
    
    //---------------------------------------------------------------------------------------------
    
    @IBAction func tapOutside(_ sender: Any)
    {
        
        if let tapGesture = sender as? UITapGestureRecognizer
        {
            let touchLocation = tapGesture.location(in: self.view)
            
            if weatherView != nil &&
                !self.weatherView.frame.contains(touchLocation)
            {
                debugPrint("tap outside")
                self.view.removeFromSuperview()
            }
        }
    }
    
    //---------------------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------------------------------------------------------------------
    
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    //---------------------------------------------------------------------------------------------
    
    @IBAction func prevButtonPressed(_ sender: Any)
    {
        if let prevCityName = citiesDataSource?.getPrevCityName()
        {
            citiesDataSource?.selectCityByName(prevCityName)
            
            self.cityNameLabel.text = prevCityName
            self.temparatureLabel.text = ""
            WeatherDataManager.instance.receiveWeather(for: prevCityName)
        }
    }
    
    //---------------------------------------------------------------------------------------------
    
    @IBAction func nextButtonPressed(_ sender: Any)
    {
        if let nextCityName = citiesDataSource?.getNextCityName()
        {
            citiesDataSource?.selectCityByName(nextCityName)
            
            self.cityNameLabel.text = nextCityName
            self.temparatureLabel.text = ""
            WeatherDataManager.instance.receiveWeather(for: nextCityName)
        }
    }
    
    //---------------------------------------------------------------------------------------------
    
    @objc func weatherDateNotification(_ notification: Notification)
    {
        if let validCity = notification.userInfo!["city"] as? String,
            let temparature = notification.userInfo!["temperatureCelsius"] as? String
        {
            if validCity == cityNameLabel.text
            {
                temparatureLabel.text = temparature
            }
        }
    }
    
    //---------------------------------------------------------------------------------------------
    
    @objc func weatherDateNotAvailableNotification(_ notification: Notification)
    {
        temparatureLabel.text = "Data aren't available"
    }
    
    //---------------------------------------------------------------------------------------------
}

//==== class WeatherViewController ============================================================



//
//  ViewController.swift
//  TestBASquare
//
//  Created by Petro Novosad on 3/2/18.
//  Copyright © 2018 Petro Novosad. All rights reserved.
//
//=============================================================================================

import UIKit

//=============================================================================================
//
//     class ViewController
//
//=============================================================================================

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CitiesDataSource
{
    //---------------------------------------------------------------------------------------------
    // MARK: ViewController
    //---------------------------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        tableView?.register(UITableViewCell.self, forCellReuseIdentifier: "cellReuseIdentifier")
    }
    
    //---------------------------------------------------------------------------------------------
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //---------------------------------------------------------------------------------------------
    // MARK: Information about internet reachability for GUI
    //---------------------------------------------------------------------------------------------
    
    static var internetIsReachableInUI: Bool?
    
    //---------------------------------------------------------------------------------------------
    // MARK: Table View code
    //---------------------------------------------------------------------------------------------
    
    @IBOutlet var tableView: UITableView?
    
    //---------------------------------------------------------------------------------------------
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1    // there is only one section
    }
    
    //---------------------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return cities.count
    }
    
    //---------------------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")
        {
            let text = cities[indexPath.row]
            
            cell.textLabel?.text = text
            
            return cell
        }
        else
        {
            return UITableViewCell()
        }
    }
    
    //---------------------------------------------------------------------------------------------
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath?
    {
        //debugPrint("city: \(cities[indexPath.row])")
        
        self.selectedCityNumber = indexPath.row
        
        
        let weatherVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "weatherMainViewID") as! WeatherViewController
        self.addChildViewController(weatherVC)
        
        weatherVC.citiesDataSource = self
        weatherVC.view.frame = self.view.frame
        
        self.view.addSubview(weatherVC.view)
        weatherVC.didMove(toParentViewController: self)
        
        return indexPath
    }
    
    //---------------------------------------------------------------------------------------------
    // MARK: CitiesDataSource
    //---------------------------------------------------------------------------------------------
    
    var selectedCityNumber: Int?
    
    let cities = ["Lviv",
                  "London",
                  "Paris",
                  "New York",
                  "Sydney",
                  "Rio de Janeiro",
                  "Stockholm",
                  "Tokyo",
                  "Beijing",
                  "Cape Town"]
    
    //---------------------------------------------------------------------------------------------
    
    func getSelectedCityName() -> String?
    {
        if selectedCityNumber != nil
        {
            return cities[selectedCityNumber!]
        }
        
        return nil
    }
    
    //---------------------------------------------------------------------------------------------
    
    func getSelectedCityNumber() -> Int?
    {
        return selectedCityNumber
    }
    
    //---------------------------------------------------------------------------------------------
    
    func getPrevCityName() -> String?
    {
        if selectedCityNumber != nil &&
            selectedCityNumber! > 0
        {
            return cities[selectedCityNumber! - 1]
        }
        
        return nil
    }
    
    //---------------------------------------------------------------------------------------------
    
    func getNextCityName() -> String?
    {
        if selectedCityNumber != nil &&
            selectedCityNumber! < cities.count - 1
        {
            return cities[selectedCityNumber! + 1]
        }
        
        return nil
    }
    
    //---------------------------------------------------------------------------------------------
    
    func selectCityByName(_ cityName: String)
    {
        for (index, city) in cities.enumerated() where city == cityName
        {
            self.selectedCityNumber = index
            self.tableView?.selectRow(at: IndexPath(row: index, section: 0), animated: true, scrollPosition: UITableViewScrollPosition.middle)
        }
    }
    
    //---------------------------------------------------------------------------------------------
    
    func getCitiesCount() -> Int
    {
        return cities.count
    }
    
    //---------------------------------------------------------------------------------------------
    
    func getCityName(for index: Int) -> String?
    {
        if index >= 0 && index < cities.count
        {
            return cities[index]
        }
        
        return nil
    }
    
    //---------------------------------------------------------------------------------------------
}

//==== class ViewController ===================================================================


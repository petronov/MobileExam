//
//  ViewController.swift
//  TestBASquare
//
//  Created by Petro Novosad on 3/2/18.
//  Copyright © 2018 Petro Novosad. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let reachability = Reachability()!
    
    @IBOutlet var tableView: UITableView?
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView?.register(TableViewCell.self, forCellReuseIdentifier: "cellReuseIdentifier")
        
        
        reachability.whenReachable = { _ in
            DispatchQueue.main.async {
                debugPrint("we haven't access to internet")
            }
        }
        
        reachability.whenUnreachable = { _ in
            DispatchQueue.main.async {
                debugPrint("no internet connection")
            }
        }
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(internetChanged),
                                               name: Notification.Name.reachabilityChanged,
                                               object: reachability)
        
        do {
            try reachability.startNotifier()
        }
        catch
        {
            print("Could not startnotifier")
        }
        
        OpenWeatherMapKit.initialize(withAppId: "d2bd923726d8850b7677856f80cb52cd")
        
        OpenWeatherMapKit.instance.currentWeather(forCity: "Lviv") { (weatherItem, error) in
            debugPrint("weather in Lviv")
        }
    }
    
    @objc func internetChanged(note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.isReachable
        {
            DispatchQueue.main.async {
                debugPrint("we have access to internet")
            }
        }
        else
        {
            DispatchQueue.main.async {
                debugPrint("no internet connection")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Table View code
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier") as! TableViewCell
        
        let text = cities[indexPath.row]
        
        cell.textLabel?.text = text
        
        cell.cityName = text
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        debugPrint("city: \(cities[indexPath.row])")
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "sbPopUpID") as! PopUpViewController
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        
        popOverVC.cityName?.text = cities[indexPath.row]
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        return indexPath
    }
    
}


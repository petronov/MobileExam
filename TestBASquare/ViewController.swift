//
//  ViewController.swift
//  TestBASquare
//
//  Created by Petro Novosad on 3/2/18.
//  Copyright © 2018 Petro Novosad. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView?.register(TableViewCell.self, forCellReuseIdentifier: "cellReuseIdentifier")
        //tableView?.allowsSelection = false
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

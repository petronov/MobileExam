//
//  PopUpViewController.swift
//  TestBASquare
//
//  Created by Petro Novosad on 3/2/18.
//  Copyright © 2018 Petro Novosad. All rights reserved.
//

import UIKit

class PopUpViewController: UIViewController {

    @IBOutlet weak var weatherView: UIView!
    @IBOutlet weak var cityName: UILabel!
    @IBOutlet weak var temparatureValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    @IBAction func tapOutside(_ sender: Any) {
        
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
}

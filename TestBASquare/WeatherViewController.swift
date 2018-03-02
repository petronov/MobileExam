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
//     class ContentViewController
//
//=============================================================================================

class ContentViewController: UIViewController
{
    //---------------------------------------------------------------------------------------------
    
    var cityName: String?
    var lbTemperature: UILabel?
    
    //---------------------------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        
        let lbCityName = UILabel()
        lbCityName.textAlignment = .center
        lbCityName.text = self.cityName ?? ""
        
        assert(self.cityName != nil)
        
        self.lbTemperature = UILabel()
        lbTemperature?.textAlignment = .center
        lbTemperature?.text = ""
        
        assert(self.lbTemperature != nil)
        
        let views = ["lbTemperature": lbTemperature!,
                     "lbCityName": lbCityName]
        
        for (_, v) in views
        {
            v.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(v)
        }
        
        NSLayoutConstraint.activate(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[lbCityName]-|",                          options: .alignAllCenterX, metrics: [:], views: views) +
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-[lbTemperature]-|",                       options: .alignAllCenterX, metrics: [:], views: views) +
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[lbCityName]-10-[lbTemperature]-40-|", options: .alignAllCenterX, metrics: [:], views: views)
        )
    }
    
    //---------------------------------------------------------------------------------------------
}

//==== class ContentViewController ============================================================


//=============================================================================================
//
//     class WeatherViewController
//
//=============================================================================================

class WeatherViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate
{
    //---------------------------------------------------------------------------------------------
    
    @IBOutlet weak var weatherView: UIView!
    
    @IBOutlet var tapGesture: UITapGestureRecognizer!
    
    var citiesDataSource: CitiesDataSource?
    
    var pageViewController: UIPageViewController!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var contentPagesVC = [ContentViewController]()
    
    // Track the current index
    private var currentIndex: Int?
    private var pendingIndex: Int?
    
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
        
        //------------------------------------------------------------------------------
        
        for i in 0 ..< self.citiesDataSource!.getCitiesCount()
        {
            let page = ContentViewController()
            page.cityName = self.citiesDataSource!.getCityName(for: i) ?? ""
            
            contentPagesVC.append(page)
        }
        
        
        // create the pageViewController
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        if let selectedCityNumber = self.citiesDataSource!.getSelectedCityNumber(),
            selectedCityNumber >= 0 && selectedCityNumber < contentPagesVC.count
        {
            pageViewController.setViewControllers([contentPagesVC[selectedCityNumber]], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        }
        
        // add it to the view
        weatherView.addSubview(pageViewController.view)
        
        let views = ["pageViewControllerView": self.pageViewController.view]
        
        for (_, v) in views {
            v?.translatesAutoresizingMaskIntoConstraints = false
            self.weatherView.addSubview(v!)
        }
        
        NSLayoutConstraint.activate(
                NSLayoutConstraint.constraints(withVisualFormat: "H:|[pageViewControllerView]|",        options: .alignAllCenterX, metrics: [:], views: views) +
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[pageViewControllerView]-37-|", options: .alignAllCenterX, metrics: [:], views: views)
        )
        
        // configure pageControl
        weatherView.bringSubview(toFront: pageControl)
        pageControl.numberOfPages = contentPagesVC.count
        
        if let selectedCityNumber = self.citiesDataSource!.getSelectedCityNumber(),
            selectedCityNumber >= 0 && selectedCityNumber < contentPagesVC.count
        {
            pageControl.currentPage = selectedCityNumber
        }
 
        //------------------------------------------------------------------------------
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
    
    @objc func weatherDateNotification(_ notification: Notification)
    {
        if let validCity = notification.userInfo!["city"] as? String,
            let temperature = notification.userInfo!["temperatureCelsius"] as? String
        {
            for pageContentController in self.contentPagesVC
                    where pageContentController.cityName != nil &&
                          pageContentController.cityName! == validCity
            {
                pageContentController.lbTemperature?.text = temperature
            }
        }
    }
    
    //---------------------------------------------------------------------------------------------
    
    @objc func weatherDateNotAvailableNotification(_ notification: Notification)
    {
        // TODO: ...
        //.text = "Data aren't available"
    }
    
    //---------------------------------------------------------------------------------------------
    // MARK: UIPageViewControllerDataSource, UIPageViewControllerDelegate
    //---------------------------------------------------------------------------------------------
    
    func viewControllerAtIndex(index: Int) -> ContentViewController
    {
        return contentPagesVC[index]// as! ContentViewController
    }
    
    //---------------------------------------------------------------------------------------------
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController?
    {
        let currentIndex = contentPagesVC.index(of: viewController as! ContentViewController)!
        if currentIndex == contentPagesVC.count - 1
        {
            return nil
        }
        let nextIndex = abs((currentIndex + 1) % contentPagesVC.count)
        return contentPagesVC[nextIndex]
    }
    
    //---------------------------------------------------------------------------------------------
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController?
    {
        let currentIndex = contentPagesVC.index(of: viewController as! ContentViewController)!
        if currentIndex == 0 {
            return nil
        }
        let previousIndex = abs((currentIndex - 1) % contentPagesVC.count)
        return contentPagesVC[previousIndex]
    }
    
    //---------------------------------------------------------------------------------------------
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int
    {
        return contentPagesVC.count
    }
    
    //---------------------------------------------------------------------------------------------
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController])
    {
        pendingIndex = contentPagesVC.index(of: pendingViewControllers.first! as! ContentViewController)
        
        if let index = pendingIndex
        {
            if self.citiesDataSource != nil
            {
                if let selectedCityName = self.citiesDataSource!.getCityName(for: index)
                {
                    citiesDataSource?.selectCityByName(selectedCityName)
                    
                    for pageContentController in self.contentPagesVC
                        where pageContentController.cityName != nil &&
                              pageContentController.cityName! == selectedCityName
                    {
                        pageContentController.lbTemperature?.text = ""
                    }
                    
                    WeatherDataManager.instance.receiveWeather(for: selectedCityName)
                }
            }
        }
    }
    
    //---------------------------------------------------------------------------------------------
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool)
    {
        if completed
        {
            currentIndex = pendingIndex
            if let index = currentIndex {
                pageControl.currentPage = index
            }
        }
    }
    
    //---------------------------------------------------------------------------------------------
}

//==== class WeatherViewController ============================================================



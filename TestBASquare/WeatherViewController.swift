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
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherDescriptionImageView: UIImageView!
    
    //---------------------------------------------------------------------------------------------
    
    init()
    {
        super.init(nibName: "WeatherContentPage", bundle: nil)
    }
    
    //---------------------------------------------------------------------------------------------
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    //---------------------------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.cityNameLabel.text = self.cityName ?? ""
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
    
    private var pageViewController: UIPageViewController!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var contentPagesVC = [ContentViewController]()
    
    // Track the current index
    private var currentIndex: Int?
    private var pendingIndex: Int?
    
    @IBOutlet weak var noInternetLabel: UILabel!
    @IBOutlet weak var dataArentAvailableLabel: UILabel!
    
    //---------------------------------------------------------------------------------------------
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherViewController.weatherDateNotification(_:)), name: NSNotification.Name(rawValue: WeatherDateNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherViewController.weatherDateNotAvailableNotification(_:)), name: NSNotification.Name(rawValue: WeatherDateNotAvailableNotification), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherViewController.noInternetNotification(_:)), name: NSNotification.Name(rawValue: NoInternetNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(WeatherViewController.internetIsAvailableNotification(_:)), name: NSNotification.Name(rawValue: InternetIsAvailableNotification), object: nil)
        
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
                //debugPrint("tap outside")
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
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
            let temperatureStr = notification.userInfo!["temperatureCelsiusStr"] as? String,
              let temperatureValue = notification.userInfo!["temperatureCelsiusValue"] as? Int,
                let _ = notification.userInfo!["cloudinessValue"] as? Int,
                  let weatherDescription = notification.userInfo!["weatherDescription"] as? String
        {
            for pageContentController in self.contentPagesVC
                    where pageContentController.cityName != nil &&
                          pageContentController.cityName! == validCity
            {
                pageContentController.temperatureLabel?.text = temperatureStr
                
                if temperatureValue >= 0
                {
                    pageContentController.temperatureLabel?.textColor = #colorLiteral(red: 0.9254902005, green: 0.4099576596, blue: 0.4245134169, alpha: 1)
                }
                else
                {
                    pageContentController.temperatureLabel?.textColor = #colorLiteral(red: 0.3454634147, green: 0.5658850321, blue: 1, alpha: 1)
                }
                
                switch weatherDescription
                {
                    case "blowing-snow":    pageContentController.weatherDescriptionImageView?.image = UIImage(named: "ios11-weather-blowing-snow-icon.png")
                    case "cloudy":          pageContentController.weatherDescriptionImageView?.image = UIImage(named: "ios11-weather-cloudy-icon.png")
                    case "dust":            pageContentController.weatherDescriptionImageView?.image = UIImage(named: "ios11-weather-dust-icon.png")
                    case "fog":             pageContentController.weatherDescriptionImageView?.image = UIImage(named: "ios11-weather-fog-icon.png")
                    case "hail":            pageContentController.weatherDescriptionImageView?.image = UIImage(named: "ios11-weather-hail-icon.png")
                    case "heavy-rain":      pageContentController.weatherDescriptionImageView?.image = UIImage(named: "ios11-weather-heavy-rain-icon.png")
                    case "partly-sunny":    pageContentController.weatherDescriptionImageView?.image = UIImage(named: "ios11-weather-partly-sunny-icon.png")
                    case "rain":            pageContentController.weatherDescriptionImageView?.image = UIImage(named: "ios11-weather-rain-icon.png")
                    case "scattered-snow":  pageContentController.weatherDescriptionImageView?.image = UIImage(named: "ios11-weather-scattered-snow-icon.png")
                    case "smoke":           pageContentController.weatherDescriptionImageView?.image = UIImage(named: "ios11-weather-smoke-icon.png")
                    case "snow":            pageContentController.weatherDescriptionImageView?.image = UIImage(named: "ios11-weather-snow-icon.png")
                    case "snow-sleet":      pageContentController.weatherDescriptionImageView?.image = UIImage(named: "ios11-weather-snow-sleet-icon.png")
                    case "sunny":           pageContentController.weatherDescriptionImageView?.image = UIImage(named: "ios11-weather-sunny-icon.png")
                    case "thunderstorm":    pageContentController.weatherDescriptionImageView?.image = UIImage(named: "ios11-weather-thunderstorm-icon.png")
                    default:                pageContentController.weatherDescriptionImageView?.image = UIImage(named: "no_icon.png")
                }
                
                pageContentController.weatherDescriptionImageView?.isHidden = false
                
                pageContentController.view.setNeedsDisplay()
            }
        }
        
        self.dataArentAvailableLabel.isHidden = true
        self.noInternetLabel.isHidden = true
    }
    
    //---------------------------------------------------------------------------------------------
    
    @objc func weatherDateNotAvailableNotification(_ notification: Notification)
    {
        for pageContentController in self.contentPagesVC
        {
            pageContentController.temperatureLabel?.text = " "
            pageContentController.weatherDescriptionImageView?.isHidden = true
            pageContentController.view.setNeedsDisplay()
        }
        
        self.weatherView?.bringSubview(toFront: self.dataArentAvailableLabel)
        self.dataArentAvailableLabel.isHidden = false
        
        
        if ViewController.internetIsReachableInUI != nil &&
           !(ViewController.internetIsReachableInUI!)
        {
            self.weatherView?.bringSubview(toFront: self.noInternetLabel)
            self.noInternetLabel.isHidden = false
        }
    }
    
    //---------------------------------------------------------------------------------------------
    
    @objc func noInternetNotification(_ notification: Notification)
    {
        // nothing
    }
    
    //---------------------------------------------------------------------------------------------
    
    @objc func internetIsAvailableNotification(_ notification: Notification)
    {
        if let cityName = self.citiesDataSource?.getSelectedCityName()
        {
            WeatherDataManager.instance.receiveWeather(for: cityName)
        }
    }
    
    //---------------------------------------------------------------------------------------------
    // MARK: UIPageViewControllerDataSource, UIPageViewControllerDelegate
    //---------------------------------------------------------------------------------------------
    
    func viewControllerAtIndex(index: Int) -> ContentViewController
    {
        return contentPagesVC[index]
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
                    for pageContentController in self.contentPagesVC
                        where pageContentController.cityName != nil &&
                              pageContentController.cityName! == selectedCityName
                    {
                        pageContentController.temperatureLabel?.text = " "
                        pageContentController.weatherDescriptionImageView?.isHidden = true
                        pageContentController.view.setNeedsDisplay()
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
            if let index = currentIndex
            {
                if let selectedCityName = self.citiesDataSource!.getCityName(for: index)
                {
                    citiesDataSource?.selectCityByName(selectedCityName)
                }
                
                pageControl.currentPage = index
            }
        }
    }
    
    //---------------------------------------------------------------------------------------------
}

//==== class WeatherViewController ============================================================



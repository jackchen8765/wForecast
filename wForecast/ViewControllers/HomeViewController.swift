//
//  HomeViewController.swift
//  wForecast
//
//  Created by Jack Chen on 12/14/17.
//  Copyright © 2017 Jack Chen. All rights reserved.
//

import UIKit
import CoreLocation
import CZWeatherKit

protocol PlaceMarkChangeDelegate: class {
    func didAddPlaceMark(_ placeMark: CLPlacemark)
    func didRemovePlaceMark(at: Int)
}

class HomeViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate,  PlaceMarkChangeDelegate{
    typealias CompletionHandler = (_ data: CZWeatherData?, _ error: Error?) -> Void
    
    //MARK: Properties
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    
    weak var delegate: PlaceMarkChangeDelegate?
    
    var placeMarks : [CLPlacemark]!
    var pageViewControllers:[WeatherViewController] = []
    var pageViewController: UIPageViewController?
    var currPlaceMarkIndex = 0
    
    var downloader: WeatherDownloader?
    
    
    //MARK: lifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if self.placeMarks.count == 0 {
            self.containerView.isHidden = true
            self.backgroundView.isHidden = false
        }
        else {
            self.containerView.isHidden = false
            self.backgroundView.isHidden = true
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Helper
    
    func indexOfViewController(_ viewController: WeatherViewController) -> Int {
        return self.pageViewControllers.index(of: viewController) ?? NSNotFound
    }
    
    func setupPageViewControllers() {
        if self.placeMarks.count > 0 {
            for place in placeMarks {
                let weatherVC = UIStoryboard(name: StoryboardName.WEATHER, bundle: nil).instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
                weatherVC.placeMark = place
                self.pageViewControllers.append(weatherVC)
            }
        }
        else {
            let weatherVC = UIStoryboard(name: StoryboardName.WEATHER, bundle: nil).instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
            self.pageViewControllers.append(weatherVC)
        }
    }
    
    func syncCurrPlaceMarkIndex() {
        let app = UIApplication.shared.delegate as! AppDelegate
        app.updateCurrentPlaceMarkIndex(self.currPlaceMarkIndex)
    }
    
    
    //MARK: UIPageViewControllerDataSource
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! WeatherViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.pageViewControllers[index]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! WeatherViewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == self.pageViewControllers.count {
            return nil
        }
        return self.pageViewControllers[index]
    }
    
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageViewControllers.count
    }

    
    //MARK: PlaceMarkChangeDelegate
    
    func didAddPlaceMark(_ placeMark: CLPlacemark) {
        if self.placeMarks.count == 0 {
            //update the WeatherViewController with the new place mark
            if self.pageViewControllers.count == 1 {
                let weatherVC = self.pageViewControllers[0]
                weatherVC.placeMark = placeMark
            }
        }
        
        else {
            let weatherVC = UIStoryboard(name: StoryboardName.WEATHER, bundle: nil).instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
            weatherVC.placeMark = placeMark
            self.pageViewControllers.append(weatherVC)
        }
        
        self.placeMarks.append(placeMark)
        self.delegate?.didAddPlaceMark(placeMark)
    }
    
    func didRemovePlaceMark(at: Int) {
        self.placeMarks.remove(at: at)
        self.delegate?.didRemovePlaceMark(at: at)
        if self.pageViewControllers.count == 1 {
            //instead of removing the only  WeatherViewController
            //we remove its placeMark
            let weatherVC = self.pageViewControllers[0]
            weatherVC.placeMark = nil
        }
    }
    
    //MARK: Action
    @IBAction func goWeatherUnderground(_ sender: UIButton) {
        guard let url = URL(string: "https://api.wunderground.com") else {
            return
        }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    @IBAction func  unwindToHome(_ sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CityListViewController{
            if currPlaceMarkIndex != sourceViewController.selected {
                self.currPlaceMarkIndex = sourceViewController.selected
                self.syncCurrPlaceMarkIndex()
            }
        }
    }
    
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToWeather", let pageViewController = segue.destination as? UIPageViewController {
            
            self.setupPageViewControllers()
            
            pageViewController.setViewControllers([self.pageViewControllers[currPlaceMarkIndex]], direction: .forward, animated: true, completion: nil)
            pageViewController.delegate = self
            pageViewController.dataSource = self
            for subview in pageViewController.view.subviews{
                if let scrollView = subview as? UIScrollView{
                    scrollView.isPagingEnabled = true
                }
                if let pageControl = subview as? UIPageControl{
                    pageControl.backgroundColor = UIColor.white
                    pageControl.currentPageIndicatorTintColor = UIColor.black
                    pageControl.pageIndicatorTintColor = UIColor.gray
                    pageControl.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
                    
                }
            }
        }
        
        else if segue.identifier == "SegueToCityList", let navigationController = segue.destination as? UINavigationController {
            if let cityListViewController = navigationController.viewControllers[0] as? CityListViewController {
                cityListViewController.placeMarks = self.placeMarks
                cityListViewController.delegate = self
            }
            
        }
    }

}


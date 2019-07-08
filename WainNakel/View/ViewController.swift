//
//  ViewController.swift
//  WainNakol
//
//  Created by mac on 7/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import MapKit
import  CoreLocation
class ViewController: UIViewController {
    @IBOutlet weak var constImgCenterY: NSLayoutConstraint!
    
    @IBOutlet weak var constLblTitleTopToImage: NSLayoutConstraint!
    @IBOutlet weak var constLblTitleBottomToBoarder: NSLayoutConstraint!
    
    @IBOutlet weak var constBtnSuggestTrailingToBoarder: NSLayoutConstraint!
    @IBOutlet weak var constBtnSuggestBottomToBoarder: NSLayoutConstraint!
    
    @IBOutlet weak var constBtnSuggestTopToLblTitle: NSLayoutConstraint!
    @IBOutlet weak var constBtnSuggestTrailingToLblTitle: NSLayoutConstraint!
    
    @IBOutlet weak var constIndicatorViewLeading: NSLayoutConstraint!
    
    
    @IBOutlet weak var constBtnSettingsLeadingToBoarder: NSLayoutConstraint!
    @IBOutlet weak var constBtnSettingsBottomToBoarder: NSLayoutConstraint!
    
    @IBOutlet weak var constBtnSettingsTopToLblTitle: NSLayoutConstraint!
    @IBOutlet weak var constBtnSettingsLeadingToLblTitle: NSLayoutConstraint!
    
    
    
    @IBOutlet weak var constMainViewHeight: NSLayoutConstraint!
    
    
    @IBOutlet weak var constvMainViewBottom: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorContainerView: UIView!
    
    @IBOutlet weak var activityIndicatorView: NVActivityIndicatorView!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imageSideMenu: UIImageView!
    @IBOutlet weak var lblTabBarTitle: UILabel!
    @IBOutlet weak var imageTabBarLogo: UIImageView!
    @IBOutlet weak var btnMenu: UIButton!
    @IBOutlet weak var BtnSuggest: UIButton!
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    var locationManager: CLLocationManager!
    var lat :Double = 0.0
    var lang :Double = 0.0
    var loadingForFirstTime : Bool =  true
    override func viewDidLoad() {
        super.viewDidLoad()
        addMenuRecognizer ()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        btnMenu.imageView?.contentMode = .scaleAspectFit
        activityIndicatorContainerView.isHidden = true
        activityIndicatorContainerView.layer.cornerRadius = 8
        activityIndicatorView.layer.cornerRadius =  8
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        setUpView()
        startUpdateLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
        
    }
    func animate() {
        self.constImgCenterY.constant = -80
        animateTitle()
        animateBtnSettings()
        animateBtnSuggest()
        UIView.animate(withDuration: 1.5) { [weak self] in
            self?.view.layoutIfNeeded() ?? ()
        }
    }
    func animateTitle() {
        constLblTitleBottomToBoarder.isActive = false
        constLblTitleTopToImage.isActive = true
    }
    
    func animateBtnSuggest() {
        constBtnSuggestTrailingToBoarder.isActive = false
        constBtnSuggestBottomToBoarder.isActive = false
        
        constBtnSuggestTopToLblTitle.isActive = true
        constBtnSuggestTrailingToLblTitle.isActive = true
    }
    
    func animateBtnSettings() {
        constBtnSettingsLeadingToBoarder.isActive = false
        constBtnSettingsBottomToBoarder.isActive = false
        
        constBtnSettingsTopToLblTitle.isActive = true
        constBtnSettingsLeadingToLblTitle.isActive = true
    }
    
    func changeTitleAlpha() {
        for i in 51...100 {
            lblTitle.textColor = UIColor.white.withAlphaComponent(CGFloat(i))
            UIView.animate(withDuration: 0.5) { [weak self] in
                self?.lblTitle.layoutIfNeeded() ?? ()
            }
        }
    }
    
    func setUpView()  {
        self.imageSideMenu.isHidden =  true
        self.imageTabBarLogo.isHidden =  true
        self.lblTabBarTitle.isHidden =  true
    }
    
    func startUpdateLocation() {
        locationManager.startUpdatingLocation()
    }
    func addMenuRecognizer (){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.toggleMenu(recognizer:)))
        imageSideMenu?.addGestureRecognizer(tapRecognizer)
        imageSideMenu.isUserInteractionEnabled =  true
    }
    @objc func toggleMenu (recognizer:UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.5, animations: {
            self.imageSideMenu.transform = self.imageSideMenu.transform.rotated(by: CGFloat(M_PI_2))
            if self.imageSideMenu.image == UIImage(named: "close") {
                self.imageSideMenu.image = UIImage(named: "menu")
            }
            else {
                self.imageSideMenu.image = UIImage(named: "close")
            }
        })
    }
    
    
    @IBAction func btnSugesstClicked(_ sender: Any) {
        self.loadingForFirstTime =  false
        activityIndicatorContainerView.isHidden = false
        self.btnMenu.isHidden =  true
        self.BtnSuggest.isHidden =  true
        self.constIndicatorViewLeading.constant = 0
        startUpdateLocation()
        UIView.animate(withDuration: 0.5) { [weak self] in
            self!.view.layoutIfNeeded()
            self!.activityIndicatorView.startAnimating()
        }
    }
    func getResturant() {
        let  url = "\(ServiceBaseN.baseUrl.rawValue)\(String(self.lat))\(",")\(String(self.lang))"
        let config = NetworkManager.Configuration(url: url, method: .get)
        NetworkManager.getResturant(configuration: config) {
            resturant in
            DispatchQueue.main.async {
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "ResturantDetailsVC") as! ResturantDetailsVC
                newViewController.resturantDetails =  resturant
                self.navigationController?.pushViewController(newViewController, animated: false)
            }
        }
    }
}

extension ViewController : CLLocationManagerDelegate , MKMapViewDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
        let location = locations.last! as CLLocation
        print(location.coordinate)
        
        UIView.animate(withDuration: 1.0) { [weak self] in
            self!.view.layoutIfNeeded()
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            self?.lat = location.coordinate.latitude
            self?.lang = location.coordinate.longitude
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            self!.mapView.setRegion(region, animated: true)
        }
        if !loadingForFirstTime {
            getResturant()
            self.locationManager =  nil
        }
    }
}



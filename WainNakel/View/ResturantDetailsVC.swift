//
//  ResturantDetailsVC.swift
//  WainNakol
//
//  Created by mac on 7/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Lottie
import  NVActivityIndicatorView
import  Lottie
class ResturantDetailsVC: UIViewController  {
    
    @IBOutlet weak var mainMenuView: UIView!
    @IBOutlet weak var constHeaderViewHieght: NSLayoutConstraint!
    @IBOutlet weak var constHeaderViewBottom: NSLayoutConstraint!
    @IBOutlet weak var consLeadingindicatorView: NSLayoutConstraint?
    @IBOutlet weak var constSuggestButtonDefaultBottom: NSLayoutConstraint!
    @IBOutlet weak var constSuggestBtnBottom: NSLayoutConstraint!
    @IBOutlet weak var constIndecatorDefaultLeading: NSLayoutConstraint!
    var barView: HeaderView!
     var sideMenuView: SideMenuView!
    var locationManager: CLLocationManager!
    @IBOutlet weak var sideMenuImage: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var menuview: UIView!
    @IBOutlet weak var btnSideMenu: UIButton!
    @IBOutlet weak var btnSugesst: UIButton!
    var hamburgerMenuButton:AnimationView?
    @IBOutlet weak var activityIndecatorView: NVActivityIndicatorView!
    @IBOutlet weak var activityIndesatorMainView: UIView!
        @IBOutlet weak var lblCatAndRate: UILabel!
    @IBOutlet weak var resturantName: UILabel!
    @IBOutlet weak var detailsStackView: UIStackView!
    @IBOutlet weak var imageShareIcon: UIImageView!
    @IBOutlet weak var imageHeartIcon: UIImageView!
    @IBOutlet weak var imageGallaryIcon: UIImageView!
    @IBOutlet weak var imageGoogleIcon: UIImageView!
    var resturantDetails : ResturantVM!
    override func viewDidLoad() {
     super.viewDidLoad()
     print(resturantDetails.image)
    }
    override func viewWillAppear(_ animated: Bool) {
        locationManager = CLLocationManager()
        mainMenuView.isHidden = true
        self.activityIndecatorView.isHidden = true
        self.activityIndesatorMainView.isHidden = true
        configureNibViews()
        configureView()
        addMenuRecognizer ()
        barView.sideMenuDelegate = self
        barView.titleuDelegate =  self
        barView.suggestDelegate =  self
        bindData() 
    }
    
    func configureView() {
        btnSugesst.layer.cornerRadius =  8
    activityIndesatorMainView.layer.cornerRadius = 8
            self.view.layoutSubviews()
         barView.minimizeView()
        self.barView.frame =  self.view.frame
        self.view.addSubview(barView)
        UIView.animate(withDuration: 1.0) { [weak self] in
            self!.view.layoutIfNeeded()
            self!.barView.frame.size.height = 90
            self!.mainMenuView.isHidden = false
        }
    }
    
    func bindData() {
        if self.resturantDetails != nil {
            self.resturantName.text =  self.resturantDetails.name
            self.lblCatAndRate.text =  self.resturantDetails.cat + " " + self.resturantDetails.rating + "/ 10"
            updateLocationOnMap(lat: resturantDetails.lat , lang: resturantDetails.lon)
        }
        else {
               self.resturantName.text =  "Failed"
             }
    }
    func updateLocationOnMap(lat :String , lang :String)  {
        let center = CLLocationCoordinate2D(latitude: Double(lat) as! CLLocationDegrees, longitude: Double(lang) as! CLLocationDegrees)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.delegate = self
      mapView.setRegion(region, animated: true)
          let myAnnotation: MKPointAnnotation = MKPointAnnotation()
        myAnnotation.coordinate = CLLocationCoordinate2DMake(Double(lat)as! CLLocationDegrees, Double(lang) as! CLLocationDegrees)
        mapView.addAnnotation(myAnnotation)
        UIView.animate(withDuration: 1.0) { [weak self] in
            self!.view.layoutIfNeeded()
        }

    }
    func configureNibViews() {
    self.barView = (Bundle.main.loadNibNamed("HeaderView", owner: self, options: nil)![0] as! HeaderView)
    self.sideMenuView = (Bundle.main.loadNibNamed("SideMenuView", owner: self, options: nil)![0] as! SideMenuView)
        
    }
    func configureSuggesttButton() {
     self.btnSugesst.backgroundColor =  UIColor.white
        self.btnSugesst.setTitleColor(barView.backgroundColor, for: .normal)
        constSuggestBtnBottom.isActive =  true
        constSuggestButtonDefaultBottom.isActive = false

    }
   
    @IBAction func btnSuggestClicked(_ sender: Any) {
        self.activityIndesatorMainView.isHidden = false
        self.activityIndecatorView.isHidden = false
          self.activityIndecatorView.startAnimating()
        self.constIndecatorDefaultLeading.isActive = true
        self.consLeadingindicatorView?.isActive = false
        self.btnSugesst.isHidden = true
        self.barView.lblTitle.shake()
        self.getResturant()
        UIView.animate(withDuration: 1.0) { [weak self] in
            self!.view.layoutIfNeeded()
        }
        
    }
    
    func getResturant() {
        let  url = "\(ServiceBaseN.baseUrl.rawValue)\(self.resturantDetails.lat)\(",")\(self.resturantDetails.lon)"
        let config = NetworkManager.Configuration(url: url, method: .get)
        NetworkManager.getResturant(configuration: config) {
            resturant in
            for annotation in self.mapView.annotations {
                self.mapView.removeAnnotation(annotation)
            }
            if resturant != nil {
                self.resturantName.text =  resturant!.name
                self.lblCatAndRate.text =  resturant!.cat + " " + self.resturantDetails.rating + "/ 10"
                self.updateLocationOnMap(lat: resturant!.lat , lang: resturant!.lon)
            }
            else {
                self.resturantName.text =  "Failed"
            }
            self.activityIndesatorMainView.isHidden = true
            self.activityIndecatorView.isHidden = true
            self.btnSugesst.isHidden =  false
            self.activityIndecatorView.stopAnimating()
        }
    }
    
    
    func addHamburgerMenuButton () {
        let animation = "1192-like"
        hamburgerMenuButton = AnimationView(name: animation)
        hamburgerMenuButton?.isUserInteractionEnabled = true
        self.hamburgerMenuButton?.frame.size.height =  50
        self.hamburgerMenuButton?.frame.size.width =  50
        self.imageHeartIcon.removeFromSuperview()
        detailsStackView.insertArrangedSubview(hamburgerMenuButton!, at: 2)
        hamburgerMenuButton?.backgroundColor =  UIColor.clear
        hamburgerMenuButton?.play()
        }
}
extension ResturantDetailsVC :  MKMapViewDelegate{
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if !(annotation is MKPointAnnotation) {
            return nil
        }
        
        let annotationIdentifier = "AnnotationIdentifier"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier)
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            annotationView!.canShowCallout = true
        }
        else {
            annotationView!.annotation = annotation
        }
        
        let pinImage = UIImage(named: "pin2")
        annotationView!.image = pinImage
        return annotationView
    }
}

extension ResturantDetailsVC :sideMenuProtocole{
  
    
    func sideMenuTapped(isExpanded : Bool) {
        switch isExpanded {
        case true:
            self.barView.frame =  (self.view.frame)
            sideMenuView.frame.size.height = self.barView.frame.size.height / 2
            sideMenuView.center =  self.barView.center
            self.barView.addSubview(sideMenuView)
            UIView.animate(withDuration: 1.0) { [weak self] in
                self!.view.layoutIfNeeded()
                self!.barView.addSubview(self!.sideMenuView)
            }
            break
        case false:
            sideMenuView.removeFromSuperview()
            self.barView.frame.size.height = 90
            UIView.animate(withDuration: 1.0) { [weak self] in
                self!.view.layoutIfNeeded()
            }
            break
          default:
            break
        }
    }

}
extension ResturantDetailsVC : pageTitleProtocole {
    func titleTapped() {
        self.barView.frame =  (self.view.frame)
        self.btnSugesst.isHidden = true
        self.activityIndesatorMainView.isHidden = true
        self.activityIndecatorView.isHidden =  true
        //self.view.bringSubviewToFront(self.btnSugesst)
        //configureSuggesttButton()
        UIView.animate(withDuration: 1.0) { [weak self] in
            self!.view.layoutIfNeeded()
        }
    }
}
extension ResturantDetailsVC : btnSuggestProtocole{
    func btnSuggestTappedProtocole(){
        configureView()
        self.activityIndesatorMainView.isHidden = false
        self.activityIndecatorView.isHidden = false
        self.activityIndecatorView.startAnimating()
        self.constIndecatorDefaultLeading.isActive = true
        self.consLeadingindicatorView?.isActive = false
        self.btnSugesst.isHidden = true
        self.barView.lblTitle.shake()
        self.getResturant()
        UIView.animate(withDuration: 1.0) { [weak self] in
            self!.view.layoutIfNeeded()
        }
    }
    
}

extension ResturantDetailsVC {
    func addMenuRecognizer (){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ResturantDetailsVC.toggleMenu(recognizer:)))
        self.imageHeartIcon.addGestureRecognizer(tapRecognizer)
        self.imageHeartIcon.isUserInteractionEnabled =  true
        
        let googleRecognizer = UITapGestureRecognizer(target: self, action: #selector(ResturantDetailsVC.openGoogle(recognizer:)))
        self.imageGoogleIcon.addGestureRecognizer(googleRecognizer)
        self.imageGoogleIcon.isUserInteractionEnabled =  true
        
        let sharerecognizer = UITapGestureRecognizer(target: self, action: #selector(ResturantDetailsVC.shaerTapped(recognizer:)))
        self.imageShareIcon.addGestureRecognizer(sharerecognizer)
        self.imageShareIcon.isUserInteractionEnabled =  true
        
        
    }
    @objc func toggleMenu (recognizer:UITapGestureRecognizer) {
        self.addHamburgerMenuButton()
    }
    @objc func openGoogle (recognizer:UITapGestureRecognizer) {
        
    }
    @objc func shaerTapped (recognizer:UITapGestureRecognizer) {
    }
}
    
public extension UIView {
    
    func shake(count : Float = 3,for duration : TimeInterval = 0.3,withTranslation translation : Float = 3) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.values = [translation, -translation]
        layer.add(animation, forKey: "shake")
    }
}

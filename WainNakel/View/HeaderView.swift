//
//  HeaderView.swift
//  WainNakol
//
//  Created by mac on 7/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit
import SceneKit
protocol sideMenuProtocole: class {
    func sideMenuTapped(isExpanded : Bool)
}
protocol pageTitleProtocole: class {
    func titleTapped()
    
}
protocol btnSuggestProtocole: class {
    func btnSuggestTappedProtocole()
    
}
class HeaderView: UIView {
    var view:UIView!
    
    @IBOutlet weak var topLogoConst: NSLayoutConstraint?
    
    @IBOutlet weak var topLogo: UIImageView!
    @IBOutlet weak var centerVerticalLogoConst: NSLayoutConstraint?
    @IBOutlet weak var imageLogo: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imageSideMenu: UIImageView!
    @IBOutlet  var constBottomOFtitle: NSLayoutConstraint!
    @IBOutlet  var constVerticalOfTtile: NSLayoutConstraint!
    
    
    @IBOutlet weak var constBtnSettingsLeadingToLblTitle: NSLayoutConstraint?
    @IBOutlet weak var constBtnSettingsTopToLblTitle: NSLayoutConstraint?
    
    @IBOutlet weak var constBtnSettingsLeadingToSuperview: NSLayoutConstraint?
    @IBOutlet weak var constBtnSettingsBottomToSuperview: NSLayoutConstraint?
    
    @IBOutlet weak var constBtnSuggestTrailingToLblTitle: NSLayoutConstraint?
    @IBOutlet weak var constBtnSuggestTopToLblTitle: NSLayoutConstraint?
    
    @IBOutlet weak var constBtnSuggestTrailingToSuperview: NSLayoutConstraint?
    @IBOutlet weak var constBtnSuggestBottomToSuperview: NSLayoutConstraint?
    
    @IBOutlet weak var imageLogoLeadingConst: NSLayoutConstraint!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnSuggest: UIButton!
    weak var sideMenuDelegate : sideMenuProtocole?
    weak var titleuDelegate : pageTitleProtocole?
    weak var suggestDelegate : btnSuggestProtocole?
    @IBOutlet weak var lblLargeTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        addMenuRecognizer ()
        btnSetting.isHidden = true
        btnSuggest.isHidden = true
        lblLargeTitle.isHidden = true
        topLogo.isHidden = true
    }
    func minimizeView() {
        constBottomOFtitle.isActive =  false
        constVerticalOfTtile.isActive =  true
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.layoutIfNeeded()
            
        }
    }
    
    func addMenuRecognizer (){
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(HeaderView.toggleMenu(recognizer:)))
        self.imageSideMenu.addGestureRecognizer(tapRecognizer)
        self.imageSideMenu.isUserInteractionEnabled =  true
        
        let titletapRecognizer = UITapGestureRecognizer(target: self, action: #selector(HeaderView.titleTapped(recognizer:)))
        self.lblTitle.addGestureRecognizer(titletapRecognizer)
        self.lblTitle.isUserInteractionEnabled =  true
        
    }
    @objc func titleTapped (recognizer:UITapGestureRecognizer) {
        self.titleuDelegate?.titleTapped()
        self.lblTitle.isHidden =  true
        self.topLogoConst?.isActive = false
        self.imageLogo.isHidden = true
        self.imageSideMenu.isHidden =  true
        self.centerVerticalLogoConst?.isActive =  true
        topLogo.isHidden = false
        btnSetting.isHidden = false
        btnSuggest.isHidden = false
        lblLargeTitle.isHidden = false
        topLogo.isHidden = false
        animateBtnSuggest()
        animateBtnSettings()
        UIView.animate(withDuration: 1.0) { [weak self] in
            self?.layoutIfNeeded()
        }
        
    }
    @objc func toggleMenu (recognizer:UITapGestureRecognizer) {
        self.imageSideMenu.isUserInteractionEnabled =  true
        UIView.animate(withDuration: 0.5, animations: {
            self.imageSideMenu.transform =  (self.imageSideMenu.transform.rotated(by: CGFloat(M_PI_2)))
            if  self.imageSideMenu.image == UIImage(named: "close") {
                self.imageSideMenu.image = UIImage(named: "menu")
                self.sideMenuDelegate?.sideMenuTapped(isExpanded: false)
            }
            else {
                self.imageSideMenu.image = UIImage(named: "close")
                self.sideMenuDelegate?.sideMenuTapped(isExpanded: true)
                
            }
        })
    }
    
    @IBAction func btnSuggestClicked(_ sender: Any) {
        self.lblLargeTitle.isHidden =  true
         self.btnSetting.isHidden =  true
        self.btnSuggest.isHidden =  true
        self.topLogo.isHidden = true
        self.imageSideMenu.isHidden = false
        self.lblTitle.isHidden = false
        self.imageLogo.isHidden = false
        self.suggestDelegate!.btnSuggestTappedProtocole()
    }
    
    func animateBtnSuggest() {
        constBtnSuggestTrailingToSuperview?.isActive = false
        constBtnSuggestBottomToSuperview?.isActive = false
        
        constBtnSuggestTopToLblTitle?.isActive = true
        constBtnSuggestTrailingToLblTitle?.isActive = true
    }
    
    func animateBtnSettings() {
        constBtnSettingsLeadingToSuperview?.isActive = false
        constBtnSettingsBottomToSuperview?.isActive = false
        
        constBtnSettingsTopToLblTitle?.isActive = true
        constBtnSettingsLeadingToLblTitle?.isActive = true
    }
}

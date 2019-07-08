//
//  ResturantVM.swift
//  WainNakol
//
//  Created by mac on 7/6/19.
//  Copyright © 2019 mac. All rights reserved.
//

import UIKit

struct  ResturantVM {
    var resturant : Resturant
    var id: String {
        return resturant.id ?? ""
    }
    
    var link: String {
        return resturant.link ?? ""
    }
    var error : String {
        return resturant.error ?? ""
    }
    
    var name: String {
        return resturant.name ?? ""
    }
    var cat: String {
        return resturant.cat ?? ""
    }
    var rating: String {
        return resturant.rating ?? ""
    }
    var lat: String {
        return resturant.lat ?? ""
    }
    var lon: String {
    return resturant.lon ?? ""
    }
    var Ulat: String {
        return resturant.Ulat ?? ""
    }
    var Ulon: String {
        return resturant.Ulon ?? ""
    }
    var open: String {
        return resturant.open ?? ""
    }
    var image: [String] {
        return resturant.image ?? []
    }
    
    
//    init(returantobj: Resturant) {
//        self.resturant = returantobj
//      
//    }
    
    
}

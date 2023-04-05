//
//  Photos.swift
//  Navigation
//
//  Created by Александр Востриков on 05.02.2022.
//

import UIKit

struct Photos {
    static let rhinoceros = UIImage(named: "2013-10-23 13-48-35")!
    static let ostrich = UIImage(named: "2013-10-23 14-01-16")!
    static let winter = UIImage(named: "2014-12-07 13-02-44")!
    static let heart = UIImage(named: "2015-02-13 12-33-26")!
    static let park = UIImage(named: "2015-05-23 12-06-28")!
    static let backsmith = UIImage(named: "2015-05-23 12-35-18")!
    static let musicians = UIImage(named: "2015-05-23 13-32-16")!
    static let biplan = UIImage(named: "2015-05-23 13-44-5")!
    static let a20 = UIImage(named: "2015-05-23 14-29-56")!
    static let atomium = UIImage(named: "2015-05-23 17-07-33")!
    static let circleFromOnHigh = UIImage(named: "2015-05-23 17-12-38")!
    static let church = UIImage(named: "2015-05-23 19-05-57")!
    static let hill = UIImage(named: "2015-08-05 10-10-44")!
    static let mountains = UIImage(named: "2015-08-08 18-22-34")!
    static let dog = UIImage(named: "2016-02-22 20-14-16")!
    static let skiDownhill = UIImage(named: "2016-09-10 14-12-57")!
    static let valley = UIImage(named: "2016-09-11 13-00-40")!
    static let bridge = UIImage(named: "2016-09-11 14-02-59")!
    static let samovar = UIImage(named: "IMG_3844")!
    static let lilyOfTheValley = UIImage(named: "IMG_4019")!
    
}

extension Photos {
    static func fetchPhotos()->[UIImage] {
        return [Photos.rhinoceros, Photos.ostrich, Photos.winter, Photos.heart, Photos.park,
         Photos.backsmith, Photos.musicians, Photos.biplan, Photos.a20, Photos.atomium,
         Photos.circleFromOnHigh, Photos.church, Photos.hill, Photos.mountains, Photos.dog,
         Photos.skiDownhill,Photos.valley,Photos.bridge, Photos.samovar, Photos.lilyOfTheValley]
    }
    static func fetchPhotos(countPhoto: Int, startIndex: Int = 0)->[UIImage] {
        
        if (startIndex < Photos.fetchPhotos().count && startIndex >= 0)  &&  startIndex + countPhoto < Photos.fetchPhotos().count {
            return Array(Photos.fetchPhotos()[startIndex...countPhoto + startIndex])
        }
        print("startIndex + countPhoto = \(startIndex + countPhoto) >= Photos.fetchPhotos().count = \(Photos.fetchPhotos().count)")
        return Photos.fetchPhotos()
    }
}

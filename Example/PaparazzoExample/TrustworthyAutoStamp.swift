//
//  TrustworthyAutoStamp.swift
//  PaparazzoExample
//
//  Created by Толстой Егор on 20/05/2017.
//  Copyright © 2017 Avito. All rights reserved.
//

import Foundation
import Paparazzo

class TrustworthyAutoStamp: Filter {
    public var preview: UIImage = UIImage()
    
    public var title: String = "Trustworthy Stamp"
    
    public func apply(_ sourceImage: UIImage, completion: ((_ resultImage: UIImage) -> Void)){
        let stamp = UIImage.init(named: "transparent-stamp")
        
        let size = sourceImage.size
        let stampSize = stamp!.size
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let backgroundRect = CGRect.init(x: 0,
                                         y: 0,
                                         width: size.width,
                                         height: size.height)
        sourceImage.draw(in: backgroundRect)
        
        let offset = backgroundRect.width / 32
        let stampWidth = stampSize.width / 2
        let stampHeight = stampSize.height / 2
        let stampRect = CGRect.init(x: backgroundRect.width - stampWidth - offset,
                                    y: backgroundRect.height - stampHeight - offset,
                                    width: stampWidth,
                                    height: stampHeight)
        stamp?.draw(in: stampRect)
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        completion(newImage)
    }
}

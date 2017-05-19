//
//  LicensePlateDetectionFilter.swift
//  PaparazzoExample
//
//  Created by Смаль Вадим on 19/05/2017.
//  Copyright © 2017 Avito. All rights reserved.
//

import Foundation
import Paparazzo

public class LicensePlateDetectionFilter: Filter {
    
    public var preview: UIImage = UIImage()
    
    public var title: String = "LicensePlateDetection"
    
    public func apply(_ sourceImage: UIImage, completion: ((_ resultImage: UIImage) -> Void)){
        
        if #available(iOS 9.0, *) {
            let context = CIContext()
            let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
            let ciDetector = CIDetector(ofType: CIDetectorTypeText, context: context, options: options)
            
            guard let cgImage = sourceImage.cgImage else {
                completion(sourceImage)
                return
            }
            let ciImage = CIImage(cgImage: cgImage)
            
            let features = ciDetector?.features(in: ciImage)
            let ciImageSize = ciImage.extent.size
            let transform = CGAffineTransform(scaleX: 1, y: -1).translatedBy(x: 0, y: -ciImageSize.height)
            
            UIGraphicsBeginImageContext(sourceImage.size)
            
            sourceImage.draw(at: CGPoint.zero)
            
            features?.forEach { feature in
                
                var faceRect = feature.bounds.applying(transform)
                
                let viewSize = sourceImage.size
                let scale = min(viewSize.width / ciImageSize.width, (viewSize.height / ciImageSize.height))
                let offsetX = (viewSize.width - ciImageSize.width * scale) / 2.0
                let offsetY = (viewSize.height - ciImageSize.height * scale) / 2.0
                
                faceRect = faceRect.applying(CGAffineTransform(scaleX: scale, y: scale))
                faceRect.origin.x += offsetX
                faceRect.origin.y += offsetY
                
                let image = sourceImage.cropImage(rect: faceRect)
                image.applyBlurWithRadius(20, tintColor: UIColor(white: 0.11, alpha: 0.73), saturationDeltaFactor: 1.8)?.draw(in: faceRect)
            }
            
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            completion(resultImage!)
        } else {
            completion(sourceImage)
        }
        
    }
    
}

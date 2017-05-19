//
//  FaceDetectionFilter.swift
//  PaparazzoExample
//
//  Created by Щукин Алексей on 19/05/2017.
//  Copyright © 2017 Avito. All rights reserved.
//

import Foundation
import Paparazzo

public class FaceDetectionFilter: Filter {
    
    public var preview: UIImage = UIImage()
    
    public var title: String = "FaceDetection"
    
    public func apply(_ sourceImage: UIImage, completion: ((_ resultImage: UIImage) -> Void)){
        
        let context = CIContext()
        let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        let ciDetector = CIDetector(ofType: CIDetectorTypeFace, context: context, options: options)
        
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
        
        features?.forEach { [weak self]  feature in
            
            var faceRect = feature.bounds.applying(transform)
            
            let viewSize = sourceImage.size
            let scale = min(viewSize.width / ciImageSize.width, (viewSize.height / ciImageSize.height))
            let offsetX = (viewSize.width - ciImageSize.width * scale) / 2.0
            let offsetY = (viewSize.height - ciImageSize.height * scale) / 2.0
            
            faceRect = faceRect.applying(CGAffineTransform(scaleX: scale, y: scale))
            faceRect.origin.x += offsetX
            faceRect.origin.y += offsetY
            
            let image = sourceImage.cropImage(rect: faceRect)
            image.blurImage(intensity: 6.0).draw(in: faceRect)
        }
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        completion(resultImage!)
    }
    
}

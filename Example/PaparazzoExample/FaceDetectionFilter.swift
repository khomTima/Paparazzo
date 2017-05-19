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
        
        let ciImage = CIImage(cgImage: sourceImage.cgImage!)
        
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
            
            let image = self?.cropImage(sourceImage: sourceImage, rect: faceRect)
            self?.blurImage(image: image!).draw(in: faceRect)
        }
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        completion(resultImage!)
    }
    
    private func cropImage(sourceImage: UIImage, rect: CGRect) -> UIImage {
        
        var rect = rect
        rect.origin.x *= sourceImage.scale
        rect.origin.y *= sourceImage.scale
        rect.size.width *= sourceImage.scale
        rect.size.height *= sourceImage.scale
        
        let image = sourceImage.cgImage?.cropping(to: rect)
        return UIImage(cgImage: image!, scale: sourceImage.scale, orientation: sourceImage.imageOrientation)
    }
    
    private func blurImage(image: UIImage) -> UIImage {
        
        let context = CIContext()
        let inputImage = CIImage(cgImage: image.cgImage!)
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(6.0, forKey: "inputRadius")
        let outputImage = filter?.value(forKey: kCIOutputImageKey)
        
        return UIImage(cgImage: context.createCGImage(outputImage as! CIImage, from: inputImage.extent)!)
    }
}

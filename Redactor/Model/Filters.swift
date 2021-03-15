import Foundation
import GPUImage

//любой из группы Color adjustments
//комбинация из любых трех фильтров
//любой из группы Visual effects
//комбинация любых двух из группы Visual effects

class Filters {
    
    static private let filterNames = ["Яркость","Контраст","Размытие","Сетка"]
    
    static subscript(_ i:Int) -> String {
        return filterNames[i]
    }
    
    static var count: Int { filterNames.count }
    
    static func handle(_ image:UIImage,at index:Int,completion:@escaping ((UIImage) -> Void)) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            //1
            let exposureFilter = GPUImageExposureFilter()
            exposureFilter.exposure = 1
            
            guard let picture = GPUImagePicture(image: image) else { fatalError() }
            //2
            let f1 = GPUImageGammaFilter()
            f1.gamma = 1.5

            let f2 = GPUImageEmbossFilter()
            f2.intensity = 1.2

            let f3 = GPUImageSaturationFilter()
            f3.saturation = 1
            
            picture.addTarget(f1)
            f1.addTarget(f2)
            f2.addTarget(f3)
            
            //3
            let pixelFilter = GPUImagePixellateFilter()
            pixelFilter.fractionalWidthOfAPixel = 0.02
            
            //4
            let f4 = GPUImagePolkaDotFilter()
            f4.fractionalWidthOfAPixel = 0.01
            
            let f5 = GPUImageHalftoneFilter()
            f5.fractionalWidthOfAPixel = 0.01
            
            picture.addTarget(f4)
            f4.addTarget(f5)
            
                DispatchQueue.main.async {
                switch index {
                    case 0: completion(exposureFilter.image(byFilteringImage: image))
                    case 1:
                        f3.useNextFrameForImageCapture()
                        picture.processImage()
                        completion(f3.imageFromCurrentFramebuffer())
                    case 2: completion(pixelFilter.image(byFilteringImage: image))
                    case 3:
                        f5.useNextFrameForImageCapture()
                        picture.processImage()
                        completion(f5.imageFromCurrentFramebuffer())
                    default: completion(UIImage(named: "Template")!)
                }
            }
            
        }
   }
   
    
}

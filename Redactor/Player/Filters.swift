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
    
    
    static var all: [GPUImageFilterGroup] = {
        var filters = [GPUImageFilterGroup]()
        //1
        let f1 = GPUImageExposureFilter()
        f1.exposure = 1.5
        let g1 = GPUImageFilterGroup()
        g1.addFilter(f1)
        g1.initialFilters = [f1]
        g1.terminalFilter = f1
        filters.append(g1)
        
        //2
        let f2 = GPUImageGammaFilter()
        f2.gamma = 1.5

        let f3 = GPUImageEmbossFilter()
        f3.intensity = 1.2

        let f4 = GPUImageSaturationFilter()
        f4.saturation = 1
        
        let g2 = GPUImageFilterGroup()
        g2.addFilter(f2)
        g2.addFilter(f3)
        g2.addFilter(f4)
        f2.addTarget(f3)
        f3.addTarget(f4)
        
        g2.initialFilters = [f2]
        g2.terminalFilter = f4
        filters.append(g2)
        
        //3
        let f5 = GPUImagePixellateFilter()
        f5.fractionalWidthOfAPixel = 0.02
        let g3 = GPUImageFilterGroup()
        g3.addFilter(f5)
        g3.initialFilters = [f5]
        g3.terminalFilter = f5
        filters.append(g3)
        
        //4
        let f6 = GPUImagePolkaDotFilter()
        f6.fractionalWidthOfAPixel = 0.01
        
        let f7 = GPUImageHalftoneFilter()
        f7.fractionalWidthOfAPixel = 0.01
        
        let g4 = GPUImageFilterGroup()
        g4.addFilter(f6)
        g4.addFilter(f7)
        f6.addTarget(f7)
        g4.initialFilters = [f6]
        g4.terminalFilter = f7
        filters.append(g4)
        
        return filters
    }()
    
    static func handle(_ image:UIImage,at index:Int,completion:@escaping ((UIImage) -> Void)) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            guard let picture = GPUImagePicture(image: image) else { fatalError() }
            let filter = all[index]
            picture.addTarget(filter)
            
                DispatchQueue.main.async {
                switch index {
                    case 0: completion(filter.image(byFilteringImage: image))
                    case 1:
                        filter.useNextFrameForImageCapture()
                        picture.processImage()
                        completion(filter.imageFromCurrentFramebuffer())
                    case 2: completion(filter.image(byFilteringImage: image))
                    case 3:
                        filter.useNextFrameForImageCapture()
                        picture.processImage()
                        completion(filter.imageFromCurrentFramebuffer())
                    default: completion(UIImage(named: "Template")!)
                }
            }
            
        }
   }
   
    
}

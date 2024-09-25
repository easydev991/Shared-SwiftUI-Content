import SwiftUI

extension View {
    /// Делает `UIImage` из `SwiftUI`-вьюхи
    ///
    /// За основу взята статья по [ссылке](https://www.hackingwithswift.com/quick-start/swiftui/how-to-convert-a-swiftui-view-to-an-image)
    @MainActor
    public var asUIImage: UIImage? {
        if #available(iOS 16.0, *) {
            return ImageRenderer(content: self).uiImage
        } else {
            let controller = UIHostingController(rootView: self)
            let view = controller.view
            
            let targetSize = controller.view.intrinsicContentSize
            view?.bounds = CGRect(origin: .zero, size: targetSize)
            view?.backgroundColor = .clear
            
            let renderer = UIGraphicsImageRenderer(size: targetSize)
            return renderer.image { _ in
                view?.drawHierarchy(in: controller.view.bounds, afterScreenUpdates: true)
            }
        }
    }
}

extension UIImage {
//    /// Средний цвет для картинки или `nil`, если цвет не определяется
//    ///
//    /// За основу взята статья по [ссылке](https://medium.com/@maxwellios/dynamic-gradient-using-the-average-image-color-in-swiftui-d3e8d9df4786)
//    public var averageColor: UIColor? {
//        guard let cgImage = self.cgImage else { return nil }
//        /*
//         Сначала изменяем размер картинки, чтобы было:
//         1) меньше пикселей для вычислений
//         2) проще работать с форматом цвета
//         40*40 - это хороший размер, который все еще сохраняет достаточное количество деталей, но без избыточного
//         количества пикселей.
//         Соотношение сторон не имеет значения для поиска среднего цвета
//         */
//        let size = CGSize(width: 40, height: 40)
//        
//        let width = Int(size.width)
//        let height = Int(size.height)
//        let totalPixels = width * height
//        
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        
//        // Формат ARGB
//        let bitmapInfo = CGBitmapInfo.byteOrder32Little.rawValue | CGImageAlphaInfo.premultipliedFirst.rawValue
//        
//        /*
//         8 бит для каждого цветового канала, мы используем ARGB, поэтому всего 32 бита (4 байта),
//         таким образом, если изображение имеет ширину `n` пикселей и имеет 4 байта на пиксель,
//         общее количество байтов в строке равно 4n.
//         Это дает нам 2^8 = 256 вариантов цвета для каждого канала RGB или 256 * 256 * 256 = всего ~16,7 млн ​​вариантов цвета.
//         */
//        guard let context = CGContext(
//            data: nil,
//            width: width,
//            height: height,
//            bitsPerComponent: 8,
//            bytesPerRow: width * 4,
//            space: colorSpace,
//            bitmapInfo: bitmapInfo
//        ) else { return nil }
//        
//        // Рисуем нашу картинку с измененным размером
//        context.draw(cgImage, in: CGRect(origin: .zero, size: size))
//        
//        guard let pixelBuffer = context.data else { return nil }
//        
//        // Связываем ячейку памяти пиксельного буфера с указателем, который мы можем использовать/получить к нему доступ
//        let pointer = pixelBuffer.bindMemory(to: UInt32.self, capacity: width * height)
//        
//        /* Отслеживаем общее количество цветов. Нас не волнует прозрачность (alpha),
//         и мы всегда предполагаем, что альфа равна 1, то есть непрозрачный */
//        var totalRed = 0
//        var totalBlue = 0
//        var totalGreen = 0
//        
//        // Столбец пикселей изображения
//        for xPoint in 0 ..< width {
//            // Ряд пикселей изображения
//            for yPoint in 0 ..< height {
//                /*
//                 Чтобы получить местоположение пикселя, представляем изображение как сетку пикселей,
//                 но сохраненную в виде одной длинной строки, а не столбцов и строк.
//                 Например, чтобы сопоставить пиксель из сетки в 15-й строке и трех столбцах с нашим «длинным рядом»,
//                 мы сместимся в 15 раз по ширине изображения в пикселях, а затем сместимся на количество столбцов
//                 */
//                let pixel = pointer[(yPoint * width) + xPoint]
//                
//                let rPixel = red(for: pixel)
//                let gPixel = green(for: pixel)
//                let bPixel = blue(for: pixel)
//                
//                totalRed += Int(rPixel)
//                totalBlue += Int(bPixel)
//                totalGreen += Int(gPixel)
//            }
//        }
//        
//        let averageRed = CGFloat(totalRed) / CGFloat(totalPixels)
//        let averageGreen = CGFloat(totalGreen) / CGFloat(totalPixels)
//        let averageBlue = CGFloat(totalBlue) / CGFloat(totalPixels)
//        
//        // Преобразуем формат [0 ... 255] в формат [0 ... 1.0], который требует `UIColor`.
//        let color = UIColor(
//            red: averageRed / 255.0,
//            green: averageGreen / 255.0,
//            blue: averageBlue / 255.0,
//            alpha: 1.0
//        )
//        
//        return color
//    }
//    
//    private func red(for pixelData: UInt32) -> UInt8 {
//        UInt8((pixelData >> 16) & 255)
//    }
//    
//    private func green(for pixelData: UInt32) -> UInt8 {
//        UInt8((pixelData >> 8) & 255)
//    }
//    
//    private func blue(for pixelData: UInt32) -> UInt8 {
//        UInt8((pixelData >> 0) & 255)
//    }
}

extension UIImage {
    var averageColor: UIColor? {
        guard let inputImage = CIImage(image: self) else { return nil }
        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)
        
        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [kCIInputImageKey: inputImage, kCIInputExtentKey: extentVector]) else { return nil }
        guard let outputImage = filter.outputImage else { return nil }
        
        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull ?? CGColorSpace.sRGB])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: CGRect(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        
        return UIColor(red: CGFloat(bitmap[0]) / 255, green: CGFloat(bitmap[1]) / 255, blue: CGFloat(bitmap[2]) / 255, alpha: CGFloat(bitmap[3]) / 255)
    }
}

extension Text {
    /// В зависимости от цвета фона возвращает текст с другим `EnvironmentKey` для `colorScheme`,
    /// чтобы текст был контрастным и лучше виден на фоне переданного цвета
    public func makeContrastText(for backgroundColor: Color) -> some View {
        var r, g, b, a: CGFloat
        (r, g, b, a) = (0, 0, 0, 0)
        UIColor(backgroundColor).getRed(&r, green: &g, blue: &b, alpha: &a)
        let luminance = 0.2126 * r + 0.7152 * g + 0.0722 * b
        return luminance < 0.4
        ? environment(\.colorScheme, .dark)
        : environment(\.colorScheme, .light)
    }
}

private struct PreviewWithUIImage: View {
    private let uiImages: [UIImage] = [.swift, .swiftBird, .swiftDark]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(Array(zip(uiImages.indices, uiImages)), id: \.0) { _, uiImage in
                    let color = Color(uiImage.averageColor ?? .clear)
                    HStack {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                        color
                            .overlay {
                                Text("Контрастный текст")
                                    .font(.title2.bold())
                                    .makeContrastText(for: color)
                            }
                    }
                }
            }
        }
    }
}

private struct PreviewWithImage: View {
    private let imageResources: [ImageResource] = [.swift, .swiftBird, .swiftDark]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(Array(zip(imageResources.indices, imageResources)), id: \.0) { _, resource in
                    let image = Image(resource)
                    let color = Color(image.asUIImage?.averageColor ?? .clear)
                    HStack {
                        image
                            .resizable()
                            .scaledToFit()
                        color
                            .overlay {
                                Text("Контрастный текст")
                                    .font(.title2.bold())
                                    .makeContrastText(for: color)
                            }
                    }
                }
            }
        }
    }
}

private struct ContrastTextExample: View {
    private let imageResources: [ImageResource] = [.swift, .swiftBird, .swiftDark]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                ForEach(Array(zip(imageResources.indices, imageResources)), id: \.0) { _, resource in
                    let image = Image(resource)
                    let color = Color(image.asUIImage?.averageColor ?? .clear)
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                        .background(color)
                        .overlay(alignment: .bottomTrailing) {
                            Text("Контрастный текст")
                                .font(.title2.bold())
                                .makeContrastText(for: color)
                                .padding([.trailing, .bottom], 4)
                        }
                }
            }
        }
    }
}

#Preview("UIImage") {
    PreviewWithUIImage()
}

#Preview("Image") {
    PreviewWithImage()
}

#Preview("Final") {
    ContrastTextExample()
}

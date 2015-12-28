import Foundation

public struct ProgressGenerator<G: GeneratorType>: GeneratorType {
    var source: G
    var index = 0
    let startTime = CFAbsoluteTimeGetCurrent()
    let barLength = 30
    let count: Int
    
    init(source: G, count: Int) {
        self.source = source
        self.count = count
        
        print("\u{1B}7")
    }
    
    public mutating func next() -> G.Element? {
        let totalTime = CFAbsoluteTimeGetCurrent() - startTime
        
        var itemsPerSecond = 0.0
        var estimatedTimeRemaining = 0.0
        if index > 0 {
            itemsPerSecond = totalTime / Double(index)
            estimatedTimeRemaining = itemsPerSecond * Double(count - index)
        }
        
        let completed = Int(Double(barLength) * (Double(index) / Double(count)))
        var barArray = [String](count: completed, repeatedValue: "-")
        barArray += [String](count: barLength - completed, repeatedValue: " ")
        
        var string = "\(index) of \(count)"
        string += "[" + barArray.joinWithSeparator("") + "]"
        string += "ETA: \(format(estimatedTimeRemaining)) (at \(format(itemsPerSecond, ".2")) it/s)"
        
        print("\u{1B}8\u{1B}[K\(string)")
        
        index += 1
        return source.next()
    }
    
    func format(value: Double, _ format: String) -> String {
        return String(format: "%\(format)f", value)
    }
    
    func format(duration: NSTimeInterval) -> String {
        let duration = Int(duration)
        let seconds = duration % 60
        let minutes = (duration / 60) % 60
        let hours = (duration / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

public struct Progress<G: SequenceType>: SequenceType {
    let generator: G
    
    public init(_ generator: G) {
        self.generator = generator
    }
    
    public func generate() -> ProgressGenerator<G.Generator> {
        let count = generator.underestimateCount()
        return ProgressGenerator(source: generator.generate(), count: count)
    }   
}

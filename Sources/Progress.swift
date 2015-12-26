import Foundation

public final class ProgressGenerator<G: GeneratorType>: GeneratorType {
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
    
    public func next() -> G.Element? {
        let totalTime = CFAbsoluteTimeGetCurrent() - startTime
        
        var its = 0.0
        var eta = 0.0
        if index > 0 {
            its = totalTime / Double(index)
            eta = its * Double(count - index)
        }
        
        let completed = Int(Double(barLength) * (Double(index) / Double(count)))
        var barArray = [String](count: completed, repeatedValue: "-")
        barArray += [String](count: barLength - completed, repeatedValue: " ")
        let barString = barArray.joinWithSeparator("")
        
        let string = "\(index) of \(count) [\(barString)] ETA: \(format(eta)) (at \(format(its, ".2")) it/s)"
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
    var generator: G
    
    init(_ generator: G) {
        self.generator = generator
    }
    
    public func generate() -> ProgressGenerator<G.Generator> {
        let count = generator.underestimateCount()
        return ProgressGenerator(source: generator.generate(), count: count)
    }   
}

import Foundation

public struct SpectrogramData {
    public let rawMatrix: [[Double]] // Shape: [timeSteps][frequencyBins]
    public let logMatrix: [[Double]] // Shape: [timeSteps][frequencyBins]
    public let normalizedMatrix: [[Double]] // Shape: [timeSteps][frequencyBins]
    public let timeSteps: Int
    public let frequencyBins: Int
    public let pLow: Double
    public let pHigh: Double
    public let epsilon: Double
    public let fileNames: [String]
}

public struct DataProcessor {
    public static func processDirectory(url: URL) throws -> SpectrogramData {
        let fileManager = FileManager.default
        let contents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        
        let csvFiles = contents.filter { u in
            let name = u.lastPathComponent.lowercased()
            return name.hasPrefix("data") && name.hasSuffix(".csv")
        }.sorted { u1, u2 in
            let name1 = u1.lastPathComponent
            let name2 = u2.lastPathComponent
            
            let getNum = { (s: String) -> Int? in
                // Remove non-digit characters to isolate number
                let digits = s.filter { "0"..."9" ~= $0 }
                return Int(digits)
            }
            
            let num1 = getNum(name1) ?? -1
            let num2 = getNum(name2) ?? -1
            if num1 != num2 {
                return num1 < num2
            }
            return name1.compare(name2, options: .numeric) == .orderedAscending
        }
        
        guard !csvFiles.isEmpty else {
            throw NSError(domain: "SpectrogramApp", code: 4, userInfo: [NSLocalizedDescriptionKey: "No files matching 'data*.csv' found in \(url.lastPathComponent)."])
        }
        
        var rawMatrix: [[Double]] = []
        var expectedRows: Int?
        var fileNames: [String] = []
        
        for fileURL in csvFiles {
            let content = try String(contentsOf: fileURL, encoding: .utf8)
            let lines = content.components(separatedBy: .newlines)
            var vals: [Double] = []
            for line in lines {
                let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.isEmpty { continue }
                guard let val = Double(trimmed) else {
                    throw NSError(domain: "SpectrogramApp", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid numeric value '\(trimmed)' in file \(fileURL.lastPathComponent)"])
                }
                vals.append(val)
            }
            
            if vals.isEmpty {
                throw NSError(domain: "SpectrogramApp", code: 5, userInfo: [NSLocalizedDescriptionKey: "File \(fileURL.lastPathComponent) is empty or contains no numeric data."])
            }
            
            if let expected = expectedRows {
                if vals.count != expected {
                    throw NSError(domain: "SpectrogramApp", code: 3, userInfo: [NSLocalizedDescriptionKey: "Inconsistent row count: \(fileURL.lastPathComponent) has \(vals.count) rows, but previous files had \(expected)."])
                }
            } else {
                expectedRows = vals.count
            }
            
            rawMatrix.append(vals)
            fileNames.append(fileURL.lastPathComponent)
        }
        
        let timeSteps = rawMatrix.count
        let frequencyBins = expectedRows ?? 0
        
        // Find epsilon (min positive value in the matrix)
        var minPositive = Double.greatestFiniteMagnitude
        var foundPositive = false
        for col in rawMatrix {
            for val in col {
                if val > 0 && val < minPositive {
                    minPositive = val
                    foundPositive = true
                }
            }
        }
        let epsilon = foundPositive ? minPositive : 1e-9
        
        // Apply log10 scaling: log10(magnitude + epsilon)
        var logMatrix: [[Double]] = []
        var flatLogs: [Double] = []
        flatLogs.reserveCapacity(timeSteps * frequencyBins)
        
        for col in rawMatrix {
            var logCol: [Double] = []
            logCol.reserveCapacity(frequencyBins)
            for val in col {
                let lv = log10(val + epsilon)
                logCol.append(lv)
                flatLogs.append(lv)
            }
            logMatrix.append(logCol)
        }
        
        // Sort flat logs to calculate percentiles
        let sortedLogs = flatLogs.sorted()
        
        func percentile(_ sortedArray: [Double], _ p: Double) -> Double {
            guard !sortedArray.isEmpty else { return 0.0 }
            let count = sortedArray.count
            if count == 1 { return sortedArray[0] }
            let idxDouble = p * Double(count - 1)
            let idx = Int(floor(idxDouble))
            let fract = idxDouble - Double(idx)
            if idx >= count - 1 {
                return sortedArray[count - 1]
            }
            return sortedArray[idx] + fract * (sortedArray[idx + 1] - sortedArray[idx])
        }
        
        let pLow = percentile(sortedLogs, 0.01)
        let pHigh = percentile(sortedLogs, 0.995)
        let den = (pHigh - pLow) > 1e-9 ? (pHigh - pLow) : 1.0
        
        // Normalize
        var normalizedMatrix: [[Double]] = []
        for col in logMatrix {
            var normCol: [Double] = []
            normCol.reserveCapacity(frequencyBins)
            for lv in col {
                let norm = max(0.0, min(1.0, (lv - pLow) / den))
                normCol.append(norm)
            }
            normalizedMatrix.append(normCol)
        }
        
        return SpectrogramData(
            rawMatrix: rawMatrix,
            logMatrix: logMatrix,
            normalizedMatrix: normalizedMatrix,
            timeSteps: timeSteps,
            frequencyBins: frequencyBins,
            pLow: pLow,
            pHigh: pHigh,
            epsilon: epsilon,
            fileNames: fileNames
        )
    }
}

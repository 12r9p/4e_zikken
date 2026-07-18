import AppKit
import Foundation

public struct SpectrogramRenderer {
    
    private struct ColorAnchor {
        let val: Double
        let r: Double
        let g: Double
        let b: Double
    }
    
    private static let anchors = [
        ColorAnchor(val: 0.0, r: 0, g: 0, b: 0),
        ColorAnchor(val: 0.15, r: 30, g: 0, b: 80),
        ColorAnchor(val: 0.4, r: 0, g: 0, b: 200),
        ColorAnchor(val: 0.65, r: 0, g: 200, b: 200),
        ColorAnchor(val: 0.85, r: 230, g: 230, b: 0),
        ColorAnchor(val: 1.0, r: 255, g: 255, b: 255)
    ]
    
    public static func getColor(for val: Double) -> NSColor {
        let rgb = getRGB(for: val)
        return NSColor(red: CGFloat(rgb.r) / 255.0, green: CGFloat(rgb.g) / 255.0, blue: CGFloat(rgb.b) / 255.0, alpha: 1.0)
    }
    
    private static func getRGB(for val: Double) -> (r: UInt8, g: UInt8, b: UInt8) {
        let v = max(0.0, min(1.0, val))
        for i in 0..<(anchors.count - 1) {
            let a0 = anchors[i]
            let a1 = anchors[i+1]
            if v >= a0.val && v <= a1.val {
                let t = (v - a0.val) / (a1.val - a0.val)
                let r = a0.r + (a1.r - a0.r) * t
                let g = a0.g + (a1.g - a0.g) * t
                let b = a0.b + (a1.b - a0.b) * t
                return (UInt8(r), UInt8(g), UInt8(b))
            }
        }
        let last = anchors.last!
        return (UInt8(last.r), UInt8(last.g), UInt8(last.b))
    }
    
    private static func formatCompact(_ v: Double) -> String {
        if v == floor(v) {
            return String(format: "%.0f", v)
        } else if v * 10 == floor(v * 10) {
            return String(format: "%.1f", v)
        } else {
            return String(format: "%.2f", v)
        }
    }
    
    private static func calculateTicks(minVal: Double, maxVal: Double, targetCount: Int = 6) -> [Double] {
        let range = maxVal - minVal
        guard range > 0 else { return [minVal] }
        let rawStep = range / Double(targetCount)
        let logStep = log10(rawStep)
        let power = floor(logStep)
        let base = pow(10.0, power)
        let normalizedStep = rawStep / base
        
        let step: Double
        if normalizedStep < 1.5 {
            step = 1.0 * base
        } else if normalizedStep < 3.0 {
            step = 2.0 * base
        } else if normalizedStep < 7.0 {
            step = 5.0 * base
        } else {
            step = 10.0 * base
        }
        
        var firstTick = ceil(minVal / step) * step
        if firstTick < minVal {
            firstTick += step
        }
        
        var ticks: [Double] = []
        var val = firstTick
        while val <= maxVal + 1e-5 {
            ticks.append(val)
            val += step
        }
        return ticks
    }
    
    private static func calculateTicks(maxVal: Double, targetCount: Int = 6) -> [Double] {
        return calculateTicks(minVal: 0.0, maxVal: maxVal, targetCount: targetCount)
    }
    
    private static func formatTick(_ v: Double) -> String {
        if v == floor(v) {
            return String(format: "%.0f", v)
        } else if v * 10 == floor(v * 10) {
            return String(format: "%.1f", v)
        } else {
            return String(format: "%.2f", v)
        }
    }
    
    private static func drawCenteredText(_ text: String, at center: NSPoint, attrs: [NSAttributedString.Key: Any]) {
        let nsStr = text as NSString
        let size = nsStr.size(withAttributes: attrs)
        let rect = NSRect(x: center.x - size.width / 2, y: center.y - size.height / 2, width: size.width, height: size.height)
        nsStr.draw(in: rect, withAttributes: attrs)
    }
    
    private static func drawRightAlignedWord(_ text: String, rightX: CGFloat, centerY: CGFloat, attrs: [NSAttributedString.Key: Any]) {
        let nsStr = text as NSString
        let size = nsStr.size(withAttributes: attrs)
        let rect = NSRect(x: rightX - size.width, y: centerY - size.height / 2, width: size.width, height: size.height)
        nsStr.draw(in: rect, withAttributes: attrs)
    }
    
    private static func drawLeftAlignedWord(_ text: String, leftX: CGFloat, centerY: CGFloat, attrs: [NSAttributedString.Key: Any]) {
        let nsStr = text as NSString
        let size = nsStr.size(withAttributes: attrs)
        let rect = NSRect(x: leftX, y: centerY - size.height / 2, width: size.width, height: size.height)
        nsStr.draw(in: rect, withAttributes: attrs)
    }
    
    public static func render(
        data: SpectrogramData,
        samplingRate: Double,
        sampleCount: Double,
        minFrequency: Double? = nil,
        maxFrequency: Double? = nil
    ) -> NSImage? {
        let width = 800
        let height = 632
        
        let maxFreqAvailable = Double(data.frequencyBins - 1) * samplingRate / sampleCount
        let minFrequency = minFrequency ?? 0.0
        let maxFrequency = maxFrequency ?? maxFreqAvailable
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: nil,
            width: width,
            height: height,
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return nil
        }
        
        let nsContext = NSGraphicsContext(cgContext: context, flipped: false)
        NSGraphicsContext.saveGraphicsState()
        NSGraphicsContext.current = nsContext
        
        // 1. Fill Background (20, 20, 20)
        let bg = NSColor(red: 20/255, green: 20/255, blue: 20/255, alpha: 1.0)
        bg.setFill()
        context.fill(CGRect(x: 0, y: 0, width: width, height: height))
        
        // Define dimensions
        let plotWidth: CGFloat = 640.0
        let plotHeight: CGFloat = 512.0
        let plotX: CGFloat = 80.0
        let plotY: CGFloat = 60.0
        
        // 2. Draw Heatmap (disable anti-aliasing to avoid cell gaps)
        context.setShouldAntialias(false)
        let colWidth = plotWidth / CGFloat(data.timeSteps)
        let numRows = data.frequencyBins
        let rowHeight = plotHeight / CGFloat(numRows)
        
        for t in 0..<data.timeSteps {
            let xStart = plotX + CGFloat(t) * colWidth
            for r in 0..<numRows {
                let yStart = plotY + CGFloat(r) * rowHeight
                
                let tFreq: Double
                if numRows > 1 {
                    tFreq = minFrequency + (Double(r) / Double(numRows - 1)) * (maxFrequency - minFrequency)
                } else {
                    tFreq = minFrequency
                }
                
                let binDouble = tFreq * sampleCount / samplingRate
                let bin = Int(round(binDouble))
                let clampedBin = max(0, min(data.frequencyBins - 1, bin))
                
                let val = data.normalizedMatrix[t][clampedBin]
                let color = getColor(for: val)
                color.setFill()
                let cellRect = NSRect(x: xStart, y: yStart, width: colWidth, height: rowHeight)
                cellRect.fill()
            }
        }
        context.setShouldAntialias(true)
        
        // 3. Draw Grid Lines
        let gridColor = NSColor(red: 60/255, green: 60/255, blue: 60/255, alpha: 1.0)
        gridColor.setStroke()
        let gridPath = NSBezierPath()
        gridPath.lineWidth = 1.0
        
        // Vertical grid lines (time in seconds)
        let timeTicks = calculateTicks(maxVal: Double(data.timeSteps))
        for tVal in timeTicks {
            if tVal > 0 && tVal < Double(data.timeSteps) {
                let x = plotX + CGFloat(tVal / Double(data.timeSteps)) * plotWidth
                gridPath.move(to: NSPoint(x: x, y: plotY))
                gridPath.line(to: NSPoint(x: x, y: plotY + plotHeight))
            }
        }
        
        // Horizontal grid lines (frequency in Hz)
        let freqTicks = calculateTicks(minVal: minFrequency, maxVal: maxFrequency)
        for fVal in freqTicks {
            if fVal > minFrequency && fVal < maxFrequency {
                let y = plotY + CGFloat((fVal - minFrequency) / (maxFrequency - minFrequency)) * plotHeight
                gridPath.move(to: NSPoint(x: plotX, y: y))
                gridPath.line(to: NSPoint(x: plotX + plotWidth, y: y))
            }
        }
        gridPath.stroke()
        
        // 4. Draw Axis Ticks and Borders
        let axisColor = NSColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0)
        axisColor.setStroke()
        
        let borderPath = NSBezierPath()
        borderPath.lineWidth = 1.0
        
        // Border around plot area
        borderPath.move(to: NSPoint(x: plotX - 0.5, y: plotY - 0.5))
        borderPath.line(to: NSPoint(x: plotX + plotWidth + 0.5, y: plotY - 0.5))
        borderPath.line(to: NSPoint(x: plotX + plotWidth + 0.5, y: plotY + plotHeight + 0.5))
        borderPath.line(to: NSPoint(x: plotX - 0.5, y: plotY + plotHeight + 0.5))
        borderPath.close()
        
        // X-axis ticks
        for tVal in timeTicks {
            let x = plotX + CGFloat(tVal / Double(data.timeSteps)) * plotWidth
            borderPath.move(to: NSPoint(x: x, y: plotY))
            borderPath.line(to: NSPoint(x: x, y: plotY - 5.0))
        }
        
        // Y-axis ticks
        for fVal in freqTicks {
            if fVal >= minFrequency && fVal <= maxFrequency {
                let y = plotY + CGFloat((fVal - minFrequency) / (maxFrequency - minFrequency)) * plotHeight
                borderPath.move(to: NSPoint(x: plotX, y: y))
                borderPath.line(to: NSPoint(x: plotX - 5.0, y: y))
            }
        }
        borderPath.stroke()
        
        // 5. Draw Colorbar Gradient (740 to 756 in X, 60 to 572 in Y)
        context.setShouldAntialias(false)
        for yOffset in 0..<512 {
            let y = plotY + CGFloat(yOffset)
            let normVal = Double(yOffset) / 511.0
            let color = getColor(for: normVal)
            color.setStroke()
            let linePath = NSBezierPath()
            linePath.move(to: NSPoint(x: 740, y: y))
            linePath.line(to: NSPoint(x: 756, y: y))
            linePath.stroke()
        }
        context.setShouldAntialias(true)
        
        // Colorbar borders & ticks
        let cbBorder = NSBezierPath()
        cbBorder.lineWidth = 1.0
        cbBorder.move(to: NSPoint(x: 740 - 0.5, y: plotY - 0.5))
        cbBorder.line(to: NSPoint(x: 756 + 0.5, y: plotY - 0.5))
        cbBorder.line(to: NSPoint(x: 756 + 0.5, y: plotY + plotHeight + 0.5))
        cbBorder.line(to: NSPoint(x: 740 - 0.5, y: plotY + plotHeight + 0.5))
        cbBorder.close()
        
        let cbTicks = [0.0, 0.2, 0.4, 0.6, 0.8, 1.0]
        for val in cbTicks {
            let y = plotY + CGFloat(val) * plotHeight
            cbBorder.move(to: NSPoint(x: 756.0, y: y))
            cbBorder.line(to: NSPoint(x: 761.0, y: y))
        }
        cbBorder.stroke()
        
        // 6. Draw Text and Annotations
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = .center
        
        let titleAttrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 18, weight: .bold),
            .foregroundColor: axisColor,
            .paragraphStyle: textStyle
        ]
        
        let labelAttrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 13, weight: .semibold),
            .foregroundColor: axisColor,
            .paragraphStyle: textStyle
        ]
        
        let tickAttrs: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 11, weight: .regular),
            .foregroundColor: axisColor,
            .paragraphStyle: textStyle
        ]
        
        // Main Title
        drawCenteredText("Fourier Transform Spectrogram", at: NSPoint(x: 400, y: 605), attrs: titleAttrs)
        
        // Metadata text
        let srStr = formatCompact(samplingRate)
        let scStr = formatCompact(sampleCount)
        let minFStr = formatCompact(minFrequency)
        let maxFStr = formatCompact(maxFrequency)
        let metadataText = "Sampling Rate: \(srStr) Hz   Sample Count: \(scStr)   Frequency Range: \(minFStr)-\(maxFStr) Hz"
        drawCenteredText(metadataText, at: NSPoint(x: 400, y: 585), attrs: tickAttrs)
        
        // X-axis label
        drawCenteredText("Time [s]", at: NSPoint(x: 400, y: 20), attrs: labelAttrs)
        
        // X-axis tick labels
        for tVal in timeTicks {
            let x = plotX + CGFloat(tVal / Double(data.timeSteps)) * plotWidth
            drawCenteredText(String(format: "%.0f", tVal), at: NSPoint(x: x, y: 45), attrs: tickAttrs)
        }
        
        // Y-axis label rotated 90 degrees CCW
        context.saveGState()
        context.translateBy(x: 22, y: 316)
        context.rotate(by: .pi / 2)
        let yLabel = "Frequency [Hz]" as NSString
        let yLabelSize = yLabel.size(withAttributes: labelAttrs)
        yLabel.draw(in: NSRect(x: -yLabelSize.width / 2, y: -yLabelSize.height / 2, width: yLabelSize.width, height: yLabelSize.height), withAttributes: labelAttrs)
        context.restoreGState()
        
        // Y-axis tick labels
        for fVal in freqTicks {
            if fVal >= minFrequency && fVal <= maxFrequency {
                let y = plotY + CGFloat((fVal - minFrequency) / (maxFrequency - minFrequency)) * plotHeight
                drawRightAlignedWord(formatTick(fVal), rightX: 72, centerY: y, attrs: tickAttrs)
            }
        }
        
        // Colorbar title
        drawCenteredText("log10(Mag)", at: NSPoint(x: 748, y: 590), attrs: tickAttrs)
        
        // Colorbar tick labels
        for val in cbTicks {
            let y = plotY + CGFloat(val) * plotHeight
            let actualVal = data.pLow + val * (data.pHigh - data.pLow)
            drawLeftAlignedWord(String(format: "%.1f", actualVal), leftX: 765, centerY: y, attrs: tickAttrs)
        }
        
        NSGraphicsContext.restoreGraphicsState()
        
        guard let cgImage = context.makeImage() else { return nil }
        return NSImage(cgImage: cgImage, size: NSSize(width: width, height: height))
    }
}

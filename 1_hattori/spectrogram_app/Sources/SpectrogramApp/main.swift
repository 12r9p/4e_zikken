import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var window: NSWindow?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let windowWidth: CGFloat = 1100
        let windowHeight: CGFloat = 800
        let rect = NSRect(x: 0, y: 0, width: windowWidth, height: windowHeight)
        
        let window = NSWindow(
            contentRect: rect,
            styleMask: [.titled, .closable, .miniaturizable, .resizable],
            backing: .buffered,
            defer: false
        )
        window.title = "Fourier Transform Spectrogram App"
        window.center()
        
        let viewController = ViewController()
        window.contentViewController = viewController
        window.makeKeyAndOrderFront(nil)
        
        self.window = window
        
        // Bring app to front and show Dock icon even if run as standalone executable
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

// CLI check
if CommandLine.arguments.count > 1 {
    runCommandLineMode()
    exit(0)
}

// GUI Mode
let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
app.run()

func runCommandLineMode() {
    let args = CommandLine.arguments
    // Expected: <binary> <csv_dir> <output_png> [sampling_rate] [sample_count] [min_freq] [max_freq]
    if args.contains("-h") || args.contains("--help") || args.count < 3 {
        print("Spectrogram App Command Line Interface")
        print("Usage:")
        print("  GUI Mode: Run with no arguments")
        print("  CLI Mode: \(args[0]) <csv_dir> <output_png> [sampling_rate] [sample_count] [min_freq] [max_freq]")
        return
    }
    
    let csvDir = URL(fileURLWithPath: args[1])
    let outPNG = URL(fileURLWithPath: args[2])
    
    let samplingRate = args.count >= 4 ? (Double(args[3]) ?? 256.0) : 256.0
    let sampleCount = args.count >= 5 ? (Double(args[4]) ?? 256.0) : 256.0
    let minFreqArg = args.count >= 6 ? Double(args[5]) : nil
    let maxFreqArg = args.count >= 7 ? Double(args[6]) : nil
    
    print("Starting Headless Spectrogram Smoke Test:")
    print("  CSV Source: \(csvDir.path)")
    print("  Target PNG: \(outPNG.path)")
    print("  Sampling Rate: \(samplingRate) Hz")
    print("  Sample Count: \(sampleCount)")
    if let minF = minFreqArg {
        print("  Requested Min Frequency: \(minF) Hz")
    }
    if let maxF = maxFreqArg {
        print("  Requested Max Frequency: \(maxF) Hz")
    }
    
    do {
        let data = try DataProcessor.processDirectory(url: csvDir)
        print("  [SUCCESS] Parsed \(data.timeSteps) columns, \(data.frequencyBins) frequency bins.")
        
        let maxFreqAvailable = Double(data.frequencyBins - 1) * samplingRate / sampleCount
        let minFrequency = minFreqArg ?? 0.0
        let maxFrequency = maxFreqArg ?? maxFreqAvailable
        
        if minFrequency < 0 {
            print("  [ERROR] min_freq must be >= 0")
            exit(1)
        }
        if maxFrequency <= minFrequency {
            print("  [ERROR] max_freq must be > min_freq")
            exit(1)
        }
        if maxFrequency > maxFreqAvailable {
            print("  [ERROR] max_freq cannot exceed available limit (\(maxFreqAvailable) Hz)")
            exit(1)
        }
        
        guard let img = SpectrogramRenderer.render(
            data: data,
            samplingRate: samplingRate,
            sampleCount: sampleCount,
            minFrequency: minFrequency,
            maxFrequency: maxFrequency
        ) else {
            print("  [ERROR] Rendering returned nil image.")
            exit(1)
        }
        
        guard let tiffData = img.tiffRepresentation,
              let bitmapRep = NSBitmapImageRep(data: tiffData),
              let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
            print("  [ERROR] Failed to convert image to PNG representation.")
            exit(1)
        }
        
        try pngData.write(to: outPNG)
        print("  [SUCCESS] Labeled spectrogram saved to \(outPNG.path)")
        
        // Basic PNG verification: check image size using AppKit
        if let savedImage = NSImage(contentsOf: outPNG) {
            print("  [SUCCESS] PNG is valid. Dimensions: \(Int(savedImage.size.width))x\(Int(savedImage.size.height)) pixels.")
        } else {
            print("  [ERROR] Saved PNG could not be loaded as valid NSImage.")
            exit(1)
        }
        
    } catch {
        print("  [ERROR] Execution failed: \(error.localizedDescription)")
        exit(1)
    }
}

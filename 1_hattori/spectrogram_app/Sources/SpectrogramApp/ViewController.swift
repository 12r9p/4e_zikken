import AppKit
import Foundation

class ViewController: NSViewController, NSTextFieldDelegate {
    
    // UI Elements
    private var selectFolderButton: NSButton!
    private var pathLabel: NSTextField!
    private var samplingRateField: NSTextField!
    private var sampleCountField: NSTextField!
    private var minFrequencyField: NSTextField!
    private var minFrequencySlider: NSSlider!
    private var maxFrequencyField: NSTextField!
    private var maxFrequencySlider: NSSlider!
    private var generateButton: NSButton!
    private var saveButton: NSButton!
    private var statusLabel: NSTextField!
    
    private var imageView: NSImageView!
    private var placeholderContainer: NSView!
    private var placeholderLabel: NSTextField!
    private var progressIndicator: NSProgressIndicator!
    
    // State
    private var folderURL: URL?
    private var spectrogramData: SpectrogramData?
    private var spectrogramImage: NSImage?
    private var isProcessing: Bool = false
    private var minFrequency: Double = 0.0
    private var maxFrequency: Double = 128.0
    private var availableMaxFrequency: Double = 128.0
    
    override func loadView() {
        let mainView = NSView()
        mainView.wantsLayer = true
        mainView.layer?.backgroundColor = NSColor.windowBackgroundColor.cgColor
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        // 1. Sidebar Setup (Visual Effect View for glassmorphism look)
        let sidebar = NSVisualEffectView()
        sidebar.translatesAutoresizingMaskIntoConstraints = false
        sidebar.material = .sidebar
        sidebar.blendingMode = .behindWindow
        sidebar.state = .active
        view.addSubview(sidebar)
        
        // 2. Sidebar Stack View
        let sidebarStack = NSStackView()
        sidebarStack.translatesAutoresizingMaskIntoConstraints = false
        sidebarStack.orientation = .vertical
        sidebarStack.alignment = .leading
        sidebarStack.distribution = .fill
        sidebarStack.spacing = 12
        sidebarStack.edgeInsets = NSEdgeInsets(top: 24, left: 16, bottom: 24, right: 16)
        sidebar.addSubview(sidebarStack)
        
        // 3. Preview Container Setup
        let previewContainer = NSView()
        previewContainer.translatesAutoresizingMaskIntoConstraints = false
        previewContainer.wantsLayer = true
        previewContainer.layer?.backgroundColor = NSColor(red: 25/255, green: 25/255, blue: 30/255, alpha: 1.0).cgColor
        view.addSubview(previewContainer)
        
        // 4. Layout Constraints for Top-Level Views
        NSLayoutConstraint.activate([
            // Sidebar Constraints
            sidebar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            sidebar.topAnchor.constraint(equalTo: view.topAnchor),
            sidebar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sidebar.widthAnchor.constraint(equalToConstant: 280),
            
            // Sidebar Stack Constraints
            sidebarStack.leadingAnchor.constraint(equalTo: sidebar.leadingAnchor),
            sidebarStack.trailingAnchor.constraint(equalTo: sidebar.trailingAnchor),
            sidebarStack.topAnchor.constraint(equalTo: sidebar.topAnchor),
            sidebarStack.bottomAnchor.constraint(equalTo: sidebar.bottomAnchor),
            
            // Preview Container Constraints
            previewContainer.leadingAnchor.constraint(equalTo: sidebar.trailingAnchor),
            previewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            previewContainer.topAnchor.constraint(equalTo: view.topAnchor),
            previewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            previewContainer.widthAnchor.constraint(greaterThanOrEqualToConstant: 800),
            previewContainer.heightAnchor.constraint(greaterThanOrEqualToConstant: 632)
        ])
        
        // --- Populate Sidebar Stack ---
        
        // App Title
        let titleLabel = NSTextField(labelWithString: "Spectrogram Config")
        titleLabel.font = NSFont.systemFont(ofSize: 16, weight: .bold)
        titleLabel.alignment = .left
        sidebarStack.addArrangedSubview(titleLabel)
        
        // Folder selection section header
        let folderHeader = NSTextField(labelWithString: "DATA DIRECTORY")
        folderHeader.font = NSFont.systemFont(ofSize: 10, weight: .bold)
        folderHeader.textColor = .secondaryLabelColor
        sidebarStack.addArrangedSubview(folderHeader)
        
        selectFolderButton = NSButton(title: "Select Folder...", target: self, action: #selector(selectFolder))
        selectFolderButton.bezelStyle = .rounded
        selectFolderButton.keyEquivalent = "o"
        selectFolderButton.keyEquivalentModifierMask = .command
        selectFolderButton.translatesAutoresizingMaskIntoConstraints = false
        selectFolderButton.widthAnchor.constraint(equalToConstant: 248).isActive = true
        sidebarStack.addArrangedSubview(selectFolderButton)
        
        pathLabel = NSTextField(labelWithString: "No folder selected")
        pathLabel.font = NSFont.monospacedSystemFont(ofSize: 10, weight: .regular)
        pathLabel.textColor = .secondaryLabelColor
        pathLabel.cell?.wraps = true
        pathLabel.cell?.isScrollable = false
        pathLabel.lineBreakMode = .byTruncatingMiddle
        pathLabel.translatesAutoresizingMaskIntoConstraints = false
        pathLabel.widthAnchor.constraint(equalToConstant: 248).isActive = true
        sidebarStack.addArrangedSubview(pathLabel)
        
        // Parameters section header
        let paramsHeader = NSTextField(labelWithString: "PARAMETERS")
        paramsHeader.font = NSFont.systemFont(ofSize: 10, weight: .bold)
        paramsHeader.textColor = .secondaryLabelColor
        sidebarStack.addArrangedSubview(paramsHeader)
        
        // Sampling Rate
        let rateLabel = NSTextField(labelWithString: "Sampling Rate (Hz)")
        rateLabel.font = NSFont.systemFont(ofSize: 11, weight: .medium)
        rateLabel.textColor = .labelColor
        sidebarStack.addArrangedSubview(rateLabel)
        
        samplingRateField = NSTextField()
        samplingRateField.stringValue = "256"
        samplingRateField.bezelStyle = .roundedBezel
        samplingRateField.delegate = self
        samplingRateField.translatesAutoresizingMaskIntoConstraints = false
        samplingRateField.widthAnchor.constraint(equalToConstant: 248).isActive = true
        sidebarStack.addArrangedSubview(samplingRateField)
        
        // Sample Count
        let countLabel = NSTextField(labelWithString: "Sample Count")
        countLabel.font = NSFont.systemFont(ofSize: 11, weight: .medium)
        countLabel.textColor = .labelColor
        sidebarStack.addArrangedSubview(countLabel)
        
        sampleCountField = NSTextField()
        sampleCountField.stringValue = "256"
        sampleCountField.bezelStyle = .roundedBezel
        sampleCountField.delegate = self
        sampleCountField.translatesAutoresizingMaskIntoConstraints = false
        sampleCountField.widthAnchor.constraint(equalToConstant: 248).isActive = true
        sidebarStack.addArrangedSubview(sampleCountField)
        
        // Min Frequency (Hz)
        let minFreqLabel = NSTextField(labelWithString: "Min Frequency (Hz)")
        minFreqLabel.font = NSFont.systemFont(ofSize: 11, weight: .medium)
        minFreqLabel.textColor = .labelColor
        sidebarStack.addArrangedSubview(minFreqLabel)
        
        minFrequencyField = NSTextField()
        minFrequencyField.stringValue = "0"
        minFrequencyField.bezelStyle = .roundedBezel
        minFrequencyField.delegate = self
        minFrequencyField.translatesAutoresizingMaskIntoConstraints = false
        minFrequencyField.widthAnchor.constraint(equalToConstant: 248).isActive = true
        sidebarStack.addArrangedSubview(minFrequencyField)
        
        minFrequencySlider = NSSlider()
        minFrequencySlider.minValue = 0.0
        minFrequencySlider.maxValue = 128.0
        minFrequencySlider.doubleValue = 0.0
        minFrequencySlider.target = self
        minFrequencySlider.action = #selector(minFrequencySliderChanged(_:))
        minFrequencySlider.translatesAutoresizingMaskIntoConstraints = false
        minFrequencySlider.widthAnchor.constraint(equalToConstant: 248).isActive = true
        sidebarStack.addArrangedSubview(minFrequencySlider)
        
        // Max Frequency (Hz)
        let maxFreqLabel = NSTextField(labelWithString: "Max Frequency (Hz)")
        maxFreqLabel.font = NSFont.systemFont(ofSize: 11, weight: .medium)
        maxFreqLabel.textColor = .labelColor
        sidebarStack.addArrangedSubview(maxFreqLabel)
        
        maxFrequencyField = NSTextField()
        maxFrequencyField.stringValue = "128"
        maxFrequencyField.bezelStyle = .roundedBezel
        maxFrequencyField.delegate = self
        maxFrequencyField.translatesAutoresizingMaskIntoConstraints = false
        maxFrequencyField.widthAnchor.constraint(equalToConstant: 248).isActive = true
        sidebarStack.addArrangedSubview(maxFrequencyField)
        
        maxFrequencySlider = NSSlider()
        maxFrequencySlider.minValue = 0.0
        maxFrequencySlider.maxValue = 128.0
        maxFrequencySlider.doubleValue = 128.0
        maxFrequencySlider.target = self
        maxFrequencySlider.action = #selector(maxFrequencySliderChanged(_:))
        maxFrequencySlider.translatesAutoresizingMaskIntoConstraints = false
        maxFrequencySlider.widthAnchor.constraint(equalToConstant: 248).isActive = true
        sidebarStack.addArrangedSubview(maxFrequencySlider)
        
        // Formula label
        let formulaLabel = NSTextField(labelWithString: "Formula:\nfrequency_hz = bin_index * sampling_rate_hz / sample_count")
        formulaLabel.font = NSFont.monospacedSystemFont(ofSize: 9, weight: .regular)
        formulaLabel.textColor = .systemBlue
        formulaLabel.cell?.wraps = true
        formulaLabel.cell?.isScrollable = false
        formulaLabel.translatesAutoresizingMaskIntoConstraints = false
        formulaLabel.widthAnchor.constraint(equalToConstant: 248).isActive = true
        sidebarStack.addArrangedSubview(formulaLabel)
        
        // Spacing before buttons
        let buttonSpacer = NSView()
        buttonSpacer.translatesAutoresizingMaskIntoConstraints = false
        buttonSpacer.heightAnchor.constraint(equalToConstant: 8).isActive = true
        sidebarStack.addArrangedSubview(buttonSpacer)
        
        // Generate/Update button
        generateButton = NSButton(title: "Generate / Update", target: self, action: #selector(generateButtonClicked))
        generateButton.bezelStyle = .rounded
        generateButton.keyEquivalent = "\r" // Enter key to commit/trigger
        generateButton.translatesAutoresizingMaskIntoConstraints = false
        generateButton.widthAnchor.constraint(equalToConstant: 248).isActive = true
        sidebarStack.addArrangedSubview(generateButton)
        
        // Save PNG button
        saveButton = NSButton(title: "Save PNG...", target: self, action: #selector(savePNG))
        saveButton.bezelStyle = .rounded
        saveButton.keyEquivalent = "s"
        saveButton.keyEquivalentModifierMask = .command
        saveButton.isEnabled = false
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.widthAnchor.constraint(equalToConstant: 248).isActive = true
        sidebarStack.addArrangedSubview(saveButton)
        
        // Flexible spacer to push status label to the bottom
        let flexSpacer = NSView()
        flexSpacer.setContentHuggingPriority(.defaultLow, for: .vertical)
        sidebarStack.addArrangedSubview(flexSpacer)
        
        // Status indicator/error label
        statusLabel = NSTextField(labelWithString: "Please select a folder containing data*.csv files.")
        statusLabel.font = NSFont.systemFont(ofSize: 11, weight: .medium)
        statusLabel.textColor = .secondaryLabelColor
        statusLabel.cell?.wraps = true
        statusLabel.cell?.isScrollable = false
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.widthAnchor.constraint(equalToConstant: 248).isActive = true
        sidebarStack.addArrangedSubview(statusLabel)
        
        // --- Populate Preview Container ---
        
        // Image View
        imageView = NSImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.imageScaling = .scaleProportionallyUpOrDown
        previewContainer.addSubview(imageView)
        
        // Placeholder Container
        placeholderContainer = NSView()
        placeholderContainer.translatesAutoresizingMaskIntoConstraints = false
        previewContainer.addSubview(placeholderContainer)
        
        let placeholderIcon = NSImageView()
        placeholderIcon.translatesAutoresizingMaskIntoConstraints = false
        if #available(macOS 11.0, *) {
            placeholderIcon.image = NSImage(systemSymbolName: "waveform.path.ecg", accessibilityDescription: "waveform")
            placeholderIcon.contentTintColor = .secondaryLabelColor
        }
        placeholderContainer.addSubview(placeholderIcon)
        
        placeholderLabel = NSTextField(labelWithString: "Select a valid Fourier-transform CSV directory to generate preview.")
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        placeholderLabel.alignment = .center
        placeholderLabel.textColor = .secondaryLabelColor
        placeholderLabel.font = NSFont.systemFont(ofSize: 13, weight: .medium)
        placeholderLabel.cell?.wraps = true
        placeholderLabel.cell?.isScrollable = false
        placeholderContainer.addSubview(placeholderLabel)
        
        // Progress Indicator
        progressIndicator = NSProgressIndicator()
        progressIndicator.translatesAutoresizingMaskIntoConstraints = false
        progressIndicator.style = .spinning
        progressIndicator.isIndeterminate = true
        progressIndicator.controlSize = .large
        progressIndicator.isHidden = true
        previewContainer.addSubview(progressIndicator)
        
        // Constraints for Preview Subviews
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: previewContainer.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: previewContainer.trailingAnchor, constant: -20),
            imageView.topAnchor.constraint(equalTo: previewContainer.topAnchor, constant: 20),
            imageView.bottomAnchor.constraint(equalTo: previewContainer.bottomAnchor, constant: -20),
            
            placeholderContainer.centerXAnchor.constraint(equalTo: previewContainer.centerXAnchor),
            placeholderContainer.centerYAnchor.constraint(equalTo: previewContainer.centerYAnchor),
            placeholderContainer.widthAnchor.constraint(equalToConstant: 450),
            
            placeholderIcon.centerXAnchor.constraint(equalTo: placeholderContainer.centerXAnchor),
            placeholderIcon.topAnchor.constraint(equalTo: placeholderContainer.topAnchor),
            placeholderIcon.widthAnchor.constraint(equalToConstant: 64),
            placeholderIcon.heightAnchor.constraint(equalToConstant: 64),
            
            placeholderLabel.topAnchor.constraint(equalTo: placeholderIcon.bottomAnchor, constant: 16),
            placeholderLabel.leadingAnchor.constraint(equalTo: placeholderContainer.leadingAnchor),
            placeholderLabel.trailingAnchor.constraint(equalTo: placeholderContainer.trailingAnchor),
            placeholderLabel.bottomAnchor.constraint(equalTo: placeholderContainer.bottomAnchor),
            
            progressIndicator.centerXAnchor.constraint(equalTo: previewContainer.centerXAnchor),
            progressIndicator.centerYAnchor.constraint(equalTo: previewContainer.centerYAnchor)
        ])
    }
    
    // --- Actions ---
    
    @objc private func selectFolder() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        panel.canChooseFiles = false
        panel.allowsMultipleSelection = false
        panel.message = "Choose folder containing data*.csv files"
        
        if panel.runModal() == .OK, let url = panel.url {
            self.folderURL = url
            self.pathLabel.stringValue = url.path
            self.loadDirectory(url: url)
        }
    }
    
    private func loadDirectory(url: URL) {
        self.isProcessing = true
        self.statusLabel.textColor = .labelColor
        self.statusLabel.stringValue = "Loading..."
        self.progressIndicator.isHidden = false
        self.progressIndicator.startAnimation(nil)
        self.placeholderContainer.isHidden = true
        self.imageView.image = nil
        self.saveButton.isEnabled = false
        self.updateUIState()
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            do {
                let data = try DataProcessor.processDirectory(url: url)
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.spectrogramData = data
                    self.isProcessing = false
                    self.statusLabel.textColor = .labelColor
                    self.statusLabel.stringValue = "Parsed \(data.timeSteps) columns, \(data.frequencyBins) frequency bins."
                    self.progressIndicator.stopAnimation(nil)
                    self.progressIndicator.isHidden = true
                    self.updateUIState()
                    self.resetFrequencyRange(data: data)
                    self.regenerateImage()
                }
            } catch {
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.spectrogramData = nil
                    self.spectrogramImage = nil
                    self.isProcessing = false
                    self.statusLabel.textColor = .systemRed
                    self.statusLabel.stringValue = error.localizedDescription
                    self.placeholderLabel.stringValue = error.localizedDescription
                    self.placeholderLabel.textColor = .systemRed
                    self.placeholderContainer.isHidden = false
                    self.progressIndicator.stopAnimation(nil)
                    self.progressIndicator.isHidden = true
                    self.updateUIState()
                }
            }
        }
    }
    
    @objc private func generateButtonClicked() {
        if folderURL != nil {
            regenerateImage()
        } else {
            selectFolder()
        }
    }
    
    private func regenerateImage() {
        guard let data = spectrogramData else { return }
        
        let samplingRateStr = samplingRateField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let sampleCountStr = sampleCountField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let samplingRate = Double(samplingRateStr), samplingRate > 0 else {
            self.statusLabel.textColor = .systemRed
            self.statusLabel.stringValue = "Sampling Rate must be a valid positive number."
            self.placeholderLabel.stringValue = "Sampling Rate must be a valid positive number."
            self.placeholderLabel.textColor = .systemRed
            self.placeholderContainer.isHidden = false
            self.imageView.image = nil
            self.saveButton.isEnabled = false
            return
        }
        
        guard let sampleCount = Double(sampleCountStr), sampleCount > 0 else {
            self.statusLabel.textColor = .systemRed
            self.statusLabel.stringValue = "Sample Count must be a valid positive number."
            self.placeholderLabel.stringValue = "Sample Count must be a valid positive number."
            self.placeholderLabel.textColor = .systemRed
            self.placeholderContainer.isHidden = false
            self.imageView.image = nil
            self.saveButton.isEnabled = false
            return
        }
        
        let newAvailableMax = Double(data.frequencyBins - 1) * samplingRate / sampleCount
        self.availableMaxFrequency = newAvailableMax
        
        let minFrequencyStr = minFrequencyField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let maxFrequencyStr = maxFrequencyField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let minFreq = Double(minFrequencyStr) else {
            self.statusLabel.textColor = .systemRed
            self.statusLabel.stringValue = "Min Frequency must be a valid number."
            self.placeholderLabel.stringValue = "Min Frequency must be a valid number."
            self.placeholderLabel.textColor = .systemRed
            self.placeholderContainer.isHidden = false
            self.imageView.image = nil
            self.saveButton.isEnabled = false
            return
        }
        
        guard let maxFreq = Double(maxFrequencyStr) else {
            self.statusLabel.textColor = .systemRed
            self.statusLabel.stringValue = "Max Frequency must be a valid number."
            self.placeholderLabel.stringValue = "Max Frequency must be a valid number."
            self.placeholderLabel.textColor = .systemRed
            self.placeholderContainer.isHidden = false
            self.imageView.image = nil
            self.saveButton.isEnabled = false
            return
        }
        
        guard minFreq >= 0 else {
            self.statusLabel.textColor = .systemRed
            self.statusLabel.stringValue = "Min Frequency must be greater than or equal to 0 Hz."
            self.placeholderLabel.stringValue = "Min Frequency must be greater than or equal to 0 Hz."
            self.placeholderLabel.textColor = .systemRed
            self.placeholderContainer.isHidden = false
            self.imageView.image = nil
            self.saveButton.isEnabled = false
            return
        }
        
        guard maxFreq > minFreq else {
            self.statusLabel.textColor = .systemRed
            self.statusLabel.stringValue = "Max Frequency must be greater than Min Frequency."
            self.placeholderLabel.stringValue = "Max Frequency must be greater than Min Frequency."
            self.placeholderLabel.textColor = .systemRed
            self.placeholderContainer.isHidden = false
            self.imageView.image = nil
            self.saveButton.isEnabled = false
            return
        }
        
        guard maxFreq <= availableMaxFrequency else {
            self.statusLabel.textColor = .systemRed
            self.statusLabel.stringValue = "Max Frequency (\(formatCompact(maxFreq)) Hz) cannot exceed available limit (\(formatCompact(availableMaxFrequency)) Hz)."
            self.placeholderLabel.stringValue = "Max Frequency (\(formatCompact(maxFreq)) Hz) cannot exceed available limit (\(formatCompact(availableMaxFrequency)) Hz)."
            self.placeholderLabel.textColor = .systemRed
            self.placeholderContainer.isHidden = false
            self.imageView.image = nil
            self.saveButton.isEnabled = false
            return
        }
        
        self.minFrequency = minFreq
        self.maxFrequency = maxFreq
        self.updateFrequencyUI(updateSliders: true, updateTextFields: false)
        
        self.statusLabel.textColor = .labelColor
        
        if let img = SpectrogramRenderer.render(data: data, samplingRate: samplingRate, sampleCount: sampleCount, minFrequency: minFrequency, maxFrequency: maxFrequency) {
            self.spectrogramImage = img
            self.imageView.image = img
            self.placeholderContainer.isHidden = true
            self.saveButton.isEnabled = true
        } else {
            self.statusLabel.textColor = .systemRed
            self.statusLabel.stringValue = "Failed to render spectrogram image."
            self.placeholderLabel.stringValue = "Failed to render spectrogram image."
            self.placeholderLabel.textColor = .systemRed
            self.placeholderContainer.isHidden = false
            self.imageView.image = nil
            self.saveButton.isEnabled = false
        }
    }
    
    @objc private func savePNG() {
        guard let img = spectrogramImage else { return }
        
        let panel = NSSavePanel()
        if #available(macOS 11.0, *) {
            panel.allowedContentTypes = [.png]
        } else {
            panel.allowedFileTypes = ["png"]
        }
        panel.nameFieldStringValue = "spectrogram.png"
        panel.message = "Save Spectrogram Image"
        
        if panel.runModal() == .OK, let url = panel.url {
            do {
                guard let tiffData = img.tiffRepresentation,
                      let bitmapRep = NSBitmapImageRep(data: tiffData),
                      let pngData = bitmapRep.representation(using: .png, properties: [:]) else {
                    throw NSError(domain: "SpectrogramApp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to generate PNG data"])
                }
                try pngData.write(to: url)
                self.statusLabel.textColor = .labelColor
                self.statusLabel.stringValue = "Spectrogram saved to \(url.lastPathComponent)."
            } catch {
                self.statusLabel.textColor = .systemRed
                self.statusLabel.stringValue = "Failed to save PNG: \(error.localizedDescription)"
            }
        }
    }
    
    private func updateUIState() {
        let enabled = !isProcessing
        selectFolderButton.isEnabled = enabled
        samplingRateField.isEnabled = enabled
        sampleCountField.isEnabled = enabled
        minFrequencyField.isEnabled = enabled
        minFrequencySlider.isEnabled = enabled
        maxFrequencyField.isEnabled = enabled
        maxFrequencySlider.isEnabled = enabled
        generateButton.isEnabled = enabled
    }
    
    private func resetFrequencyRange(data: SpectrogramData) {
        let samplingRateStr = samplingRateField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let sampleCountStr = sampleCountField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let samplingRate = Double(samplingRateStr) ?? 256.0
        let sampleCount = Double(sampleCountStr) ?? 256.0
        
        self.availableMaxFrequency = Double(data.frequencyBins - 1) * samplingRate / sampleCount
        self.minFrequency = 0.0
        self.maxFrequency = self.availableMaxFrequency
        
        self.updateFrequencyUI(updateSliders: true, updateTextFields: true)
    }
    
    private func updateFrequencyBoundsFromConfig() {
        guard let data = spectrogramData else { return }
        
        let samplingRateStr = samplingRateField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        let sampleCountStr = sampleCountField.stringValue.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard let samplingRate = Double(samplingRateStr), samplingRate > 0,
              let sampleCount = Double(sampleCountStr), sampleCount > 0 else {
            return
        }
        
        let newAvailableMax = Double(data.frequencyBins - 1) * samplingRate / sampleCount
        self.availableMaxFrequency = newAvailableMax
        
        // Keep/clip current min/max into valid bounds [0, availableMaxFrequency]
        self.minFrequency = max(0.0, min(self.minFrequency, newAvailableMax))
        self.maxFrequency = max(0.0, min(self.maxFrequency, newAvailableMax))
        
        if self.maxFrequency <= self.minFrequency {
            self.minFrequency = 0.0
            self.maxFrequency = newAvailableMax
        }
        
        self.updateFrequencyUI(updateSliders: true, updateTextFields: true)
    }
    
    private func formatCompact(_ v: Double) -> String {
        if v == floor(v) {
            return String(format: "%.0f", v)
        } else if v * 10 == floor(v * 10) {
            return String(format: "%.1f", v)
        } else {
            return String(format: "%.2f", v)
        }
    }
    
    private func updateFrequencyUI(updateSliders: Bool, updateTextFields: Bool) {
        if updateSliders {
            minFrequencySlider.doubleValue = minFrequency
            maxFrequencySlider.doubleValue = maxFrequency
            
            minFrequencySlider.minValue = 0.0
            minFrequencySlider.maxValue = availableMaxFrequency
            
            maxFrequencySlider.minValue = 0.0
            maxFrequencySlider.maxValue = availableMaxFrequency
        }
        
        if updateTextFields {
            minFrequencyField.stringValue = formatCompact(minFrequency)
            maxFrequencyField.stringValue = formatCompact(maxFrequency)
        }
    }
    
    @objc private func minFrequencySliderChanged(_ sender: NSSlider) {
        self.minFrequency = sender.doubleValue
        minFrequencyField.stringValue = formatCompact(self.minFrequency)
        regenerateImage()
    }
    
    @objc private func maxFrequencySliderChanged(_ sender: NSSlider) {
        self.maxFrequency = sender.doubleValue
        maxFrequencyField.stringValue = formatCompact(self.maxFrequency)
        regenerateImage()
    }
    
    // --- NSTextFieldDelegate ---
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            generateButtonClicked()
            return true
        }
        return false
    }
    
    func controlTextDidEndEditing(_ obj: Notification) {
        guard let textField = obj.object as? NSTextField else { return }
        if textField === minFrequencyField || textField === maxFrequencyField {
            regenerateImage()
        } else if textField === samplingRateField || textField === sampleCountField {
            updateFrequencyBoundsFromConfig()
            regenerateImage()
        }
    }
}

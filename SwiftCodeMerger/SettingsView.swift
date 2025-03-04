//
//  SettingsView.swift
//  Geryon
//
//  Created by Zachary Bonner on 3/2/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @AppStorage("sourceDirectory") private var sourceDirectory: String = ""
    @AppStorage("destinationFile") private var destinationFile: String = ""

    var body: some View {
        VStack {
            Text("Swift Code Merger Settings")
                .font(.headline)
                .padding()

            HStack {
                Text("Source Directory:")
                TextField("Select a directory", text: $sourceDirectory)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Browse") { selectSourceDirectory() }
            }
            .padding()

            HStack {
                Text("Master File:")
                TextField("Select a file", text: $destinationFile)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button("Browse") { selectDestinationFile() }
            }
            .padding()

            Button("Save & Start Monitoring") {
                print("🟢 Button pressed! Attempting to start monitoring...")
                FileMonitor.shared.startMonitoring()
            }
            .padding()
        }
        .padding()
    }

    func selectSourceDirectory() {
        DispatchQueue.main.async {
            let panel = NSOpenPanel()
            panel.canChooseDirectories = true
            panel.canChooseFiles = false
            panel.allowsMultipleSelection = false

            if panel.runModal() == .OK, let url = panel.url {
                sourceDirectory = url.path
                print("📂 Selected source directory: \(sourceDirectory)")
                fflush(stdout)

                // ✅ Automatically set a default master file name
                let monitoredDirectoryName = (sourceDirectory as NSString).lastPathComponent
                let downloadsPath = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!.path
                destinationFile = (downloadsPath as NSString).appendingPathComponent("Combined_\(monitoredDirectoryName).swift")
                UserDefaults.standard.set(destinationFile, forKey: "destinationFile") // Persist across restarts

                print("📄 Default master file set to: \(destinationFile)")
                fflush(stdout)
            }
        }
    }
    

    func selectDestinationFile() {
        Task { @MainActor in // ✅ Ensures it runs on the main thread
            let panel = NSSavePanel()
            panel.title = "Select Master Swift File"
            panel.canCreateDirectories = true
            panel.showsTagField = false
            panel.nameFieldStringValue = "Master.swift"

            if #available(macOS 12.0, *) {
                panel.allowedContentTypes = [UTType.swiftSource]
            } else {
                panel.allowedFileTypes = ["swift"]
            }

            let response = panel.runModal()
            if response == .OK, let url = panel.url {
                destinationFile = url.path // ✅ Store selected file path
                print("Selected destination file: \(destinationFile)")
            } else {
                print("No file selected or user canceled.")
            }
        }
    }
}

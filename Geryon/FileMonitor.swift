//
//  FileMonitor.swift
//  Geryon
//
//  Created by Zachary Bonner on 3/2/25.
//

import Foundation

class FileMonitor {
    static let shared = FileMonitor()
    
    private var sourceDirectory: String {
        UserDefaults.standard.string(forKey: "sourceDirectory") ?? ""
    }
    
    private var destinationFile: String {
        UserDefaults.standard.string(forKey: "destinationFile") ?? ""
    }
    
    private var source: DispatchSourceFileSystemObject?
    
    func startMonitoring() {
        guard !sourceDirectory.isEmpty else {
            print("Error: Source directory is empty.")
            fflush(stdout)
            return
        }

        // Extract the last folder name (monitoredDirectoryName)
        let monitoredDirectoryName = (sourceDirectory as NSString).lastPathComponent
        let defaultFileName = "Combined_\(monitoredDirectoryName).swift"

        // Ensure the destination file has a default name if not set
        if destinationFile.isEmpty {
            let downloadsPath = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask).first!.path
            let newDestinationFile = (downloadsPath as NSString).appendingPathComponent(defaultFileName)
            UserDefaults.standard.set(newDestinationFile, forKey: "destinationFile") 
            print("Default master file set to: \(destinationFile)")
        }

        print("Starting directory monitoring for: \(sourceDirectory)")
        fflush(stdout)

        let fileDescriptor = open(sourceDirectory, O_EVTONLY)
        if fileDescriptor == -1 {
            print("Error: Failed to open directory \(sourceDirectory)")
            fflush(stdout)
            return
        }

        let queue = DispatchQueue.global(qos: .background)
        source = DispatchSource.makeFileSystemObjectSource(fileDescriptor: fileDescriptor, eventMask: .write, queue: queue)

        source?.setEventHandler {
            print("Detected a change in \(self.sourceDirectory)! Updating master file...")
            fflush(stdout)
            self.updateMasterFile()
        }

        source?.setCancelHandler {
            close(fileDescriptor)
        }

        source?.resume()
        print("Successfully started monitoring \(sourceDirectory)")

        // Ensure master file is created on launch
        updateMasterFile()
    }

    func updateMasterFile() {
        print("Checking if master file needs an update...")
        fflush(stdout)

        let fileManager = FileManager.default
        guard let files = try? fileManager.contentsOfDirectory(atPath: sourceDirectory) else {
            print("Error: Could not list files in \(sourceDirectory)")
            fflush(stdout)
            return
        }

        var combinedContent = ""
        for file in files.sorted() where file.hasSuffix(".swift") {
            let filePath = (sourceDirectory as NSString).appendingPathComponent(file)
            if let content = try? String(contentsOfFile: filePath, encoding: .utf8) {
                combinedContent += "\n// File: \(file)\n" + content + "\n"
            }
        }

        // Ensure file exists before writing
        if !fileManager.fileExists(atPath: destinationFile) {
            print("Creating master file at: \(destinationFile)")
            fflush(stdout)
            fileManager.createFile(atPath: destinationFile, contents: nil, attributes: nil)
        }

        // Check if the master file already contains the same content
        if let existingContent = try? String(contentsOfFile: destinationFile, encoding: .utf8),
           existingContent == combinedContent {
            print("No changes detected. Skipping update.")
            fflush(stdout)
            return
        }

        // Only write if there is a real change
        do {
            try combinedContent.write(toFile: destinationFile, atomically: true, encoding: .utf8)
            print("Master file updated: \(destinationFile)")
            fflush(stdout)
        } catch {
            print("Error writing to master file: \(error)")
            fflush(stdout)
        }
    }
}

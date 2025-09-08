import Foundation
import CallKit

class CallDirectoryExtension: CXCallDirectoryExtension {
    
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self
        
        // Check whether this is an "incremental" data request. If so, only provide the set of changes.
        if context.isIncremental {
            addOrRemoveIncrementalBlockingPhoneNumbers(to: context)
        } else {
            addAllBlockingPhoneNumbers(to: context)
        }
        
        context.completeRequest()
    }
    
    private func addAllBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve phone numbers to block from your data source
        let phoneNumbersToBlock: [CXCallDirectoryPhoneNumber] = [
            // Add phone numbers here that should be blocked
            // For example: 1771000000, 1771000001, etc.
        ]
        
        for phoneNumber in phoneNumbersToBlock {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }
    }
    
    private func addOrRemoveIncrementalBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve any changes to the set of phone numbers to block from your data source
        let phoneNumbersToAdd: [CXCallDirectoryPhoneNumber] = []
        let phoneNumbersToRemove: [CXCallDirectoryPhoneNumber] = []
        
        for phoneNumber in phoneNumbersToAdd {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }
        
        for phoneNumber in phoneNumbersToRemove {
            context.removeBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }
    }
}

extension CallDirectoryExtension: CXCallDirectoryExtensionContextDelegate {
    
    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // An error occurred while adding blocking or identification entries.
        print("Call directory extension request failed with error: \(error)")
    }
    
}

import Foundation
import CoreData

@objc(AreaCode)
public class AreaCode: NSManagedObject {
    
}

extension AreaCode {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AreaCode> {
        return NSFetchRequest<AreaCode>(entityName: "AreaCode")
    }
    
    @NSManaged public var code: String?
    @NSManaged public var isBlocked: Bool
    @NSManaged public var dateAdded: Date?
    @NSManaged public var callLogs: NSSet?
}

// MARK: Generated accessors for callLogs
extension AreaCode {
    @objc(addCallLogsObject:)
    @NSManaged public func addToCallLogs(_ value: CallLog)
    
    @objc(removeCallLogsObject:)
    @NSManaged public func removeFromCallLogs(_ value: CallLog)
    
    @objc(addCallLogs:)
    @NSManaged public func addToCallLogs(_ values: NSSet)
    
    @objc(removeCallLogs:)
    @NSManaged public func removeFromCallLogs(_ values: NSSet)
}

extension AreaCode: Identifiable {
    
}

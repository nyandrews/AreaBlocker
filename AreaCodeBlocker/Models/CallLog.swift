import Foundation
import CoreData

@objc(CallLog)
public class CallLog: NSManagedObject {
    
}

extension CallLog {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<CallLog> {
        return NSFetchRequest<CallLog>(entityName: "CallLog")
    }
    
    @NSManaged public var phoneNumber: String?
    @NSManaged public var areaCode: String?
    @NSManaged public var isBlocked: Bool
    @NSManaged public var timestamp: Date?
    @NSManaged public var areaCodeEntity: AreaCode?
}

extension CallLog: Identifiable {
    
}

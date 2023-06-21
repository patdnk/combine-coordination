import Foundation

public final class PropertyStoring {
    public static func getAssociatedObject<T>(for object: AnyObject, key: UnsafeRawPointer) -> T? {
        objc_getAssociatedObject(object, key) as? T
    }

    public static func setAssociatedObject<T>(for object: AnyObject, key: UnsafeRawPointer, newValue: T?) {
        objc_setAssociatedObject(object,
                                 key,
                                 newValue,
                                 .OBJC_ASSOCIATION_RETAIN)
    }
}

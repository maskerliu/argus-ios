//
//  AGRefresh.swift
//  Argus
//
//  Created by chris on 11/3/20.
//

public struct AGRefreshOption: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static var none: AGRefreshOption { return AGRefreshOption(rawValue: 0) }
    public static var header: AGRefreshOption { return AGRefreshOption(rawValue: 1<<0) }
    public static var footer: AGRefreshOption { return AGRefreshOption(rawValue: 1<<1) }
    public static var autoHeader: AGRefreshOption { return AGRefreshOption(rawValue: 1<<2) }
    public static var autoFooter: AGRefreshOption { return AGRefreshOption(rawValue: 1<<3) }
    public static var defaultHidden: AGRefreshOption { return AGRefreshOption(rawValue: 1<<4) }
    public static var defaults: AGRefreshOption { return AGRefreshOption(rawValue: header.rawValue | autoHeader.rawValue | footer.rawValue | autoFooter.rawValue | defaultHidden.rawValue ) }
    
}

@objc public protocol AGRefreshDataSource: NSObjectProtocol {
    var refreshHeaderData: [UIImage] { get }
    var refreshFooterData: [UIImage] { get }
    var refreshLoadData: [UIImage] { get }
    var refreshEmptyData: UIImage { get }
    var refreshErrorData: UIImage { get }
    
    @objc optional var refreshLoadToast: String { get }
    @objc optional var refreshErrorToast: String { get }
    @objc optional var refreshEmptyToast: String { get }
}

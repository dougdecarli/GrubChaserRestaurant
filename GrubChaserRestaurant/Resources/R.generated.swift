//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap { Locale(identifier: $0) } ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)

  /// Find first language and bundle for which the table exists
  fileprivate static func localeBundle(tableName: String, preferredLanguages: [String]) -> (Foundation.Locale, Foundation.Bundle)? {
    // Filter preferredLanguages to localizations, use first locale
    var languages = preferredLanguages
      .map { Locale(identifier: $0) }
      .prefix(1)
      .flatMap { locale -> [String] in
        if hostingBundle.localizations.contains(locale.identifier) {
          if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
            return [locale.identifier, language]
          } else {
            return [locale.identifier]
          }
        } else if let language = locale.languageCode, hostingBundle.localizations.contains(language) {
          return [language]
        } else {
          return []
        }
      }

    // If there's no languages, use development language as backstop
    if languages.isEmpty {
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages = [developmentLocalization]
      }
    } else {
      // Insert Base as second item (between locale identifier and languageCode)
      languages.insert("Base", at: 1)

      // Add development language as backstop
      if let developmentLocalization = hostingBundle.developmentLocalization {
        languages.append(developmentLocalization)
      }
    }

    // Find first language for which table exists
    // Note: key might not exist in chosen language (in that case, key will be shown)
    for language in languages {
      if let lproj = hostingBundle.url(forResource: language, withExtension: "lproj"),
         let lbundle = Bundle(url: lproj)
      {
        let strings = lbundle.url(forResource: tableName, withExtension: "strings")
        let stringsdict = lbundle.url(forResource: tableName, withExtension: "stringsdict")

        if strings != nil || stringsdict != nil {
          return (Locale(identifier: language), lbundle)
        }
      }
    }

    // If table is available in main bundle, don't look for localized resources
    let strings = hostingBundle.url(forResource: tableName, withExtension: "strings", subdirectory: nil, localization: nil)
    let stringsdict = hostingBundle.url(forResource: tableName, withExtension: "stringsdict", subdirectory: nil, localization: nil)

    if strings != nil || stringsdict != nil {
      return (applicationLocale, hostingBundle)
    }

    // If table is not found for requested languages, key will be shown
    return nil
  }

  /// Load string from Info.plist file
  fileprivate static func infoPlistString(path: [String], key: String) -> String? {
    var dict = hostingBundle.infoDictionary
    for step in path {
      guard let obj = dict?[step] as? [String: Any] else { return nil }
      dict = obj
    }
    return dict?[key] as? String
  }

  static func validate() throws {
    try font.validate()
    try intern.validate()
  }

  #if os(iOS) || os(tvOS)
  /// This `R.storyboard` struct is generated, and contains static references to 5 storyboards.
  struct storyboard {
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Login`.
    static let login = _R.storyboard.login()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    /// Storyboard `Orders`.
    static let orders = _R.storyboard.orders()
    /// Storyboard `Tables`.
    static let tables = _R.storyboard.tables()

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "Login", bundle: ...)`
    static func login(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.login)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "Orders", bundle: ...)`
    static func orders(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.orders)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIStoryboard(name: "Tables", bundle: ...)`
    static func tables(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.tables)
    }
    #endif

    fileprivate init() {}
  }
  #endif

  /// This `R.color` struct is generated, and contains static references to 1 colors.
  struct color {
    /// Color `AccentColor`.
    static let accentColor = Rswift.ColorResource(bundle: R.hostingBundle, name: "AccentColor")

    #if os(iOS) || os(tvOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(tvOS 11.0, *)
    @available(iOS 11.0, *)
    static func accentColor(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIColor? {
      return UIKit.UIColor(resource: R.color.accentColor, compatibleWith: traitCollection)
    }
    #endif

    #if os(watchOS)
    /// `UIColor(named: "AccentColor", bundle: ..., traitCollection: ...)`
    @available(watchOSApplicationExtension 4.0, *)
    static func accentColor(_: Void = ()) -> UIKit.UIColor? {
      return UIKit.UIColor(named: R.color.accentColor.name)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.file` struct is generated, and contains static references to 2 files.
  struct file {
    /// Resource file `GoogleService-Info.plist`.
    static let googleServiceInfoPlist = Rswift.FileResource(bundle: R.hostingBundle, name: "GoogleService-Info", pathExtension: "plist")
    /// Resource file `chau-philomene-one.regular.ttf`.
    static let chauPhilomeneOneRegularTtf = Rswift.FileResource(bundle: R.hostingBundle, name: "chau-philomene-one.regular", pathExtension: "ttf")

    /// `bundle.url(forResource: "GoogleService-Info", withExtension: "plist")`
    static func googleServiceInfoPlist(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.googleServiceInfoPlist
      return fileResource.bundle.url(forResource: fileResource)
    }

    /// `bundle.url(forResource: "chau-philomene-one.regular", withExtension: "ttf")`
    static func chauPhilomeneOneRegularTtf(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.chauPhilomeneOneRegularTtf
      return fileResource.bundle.url(forResource: fileResource)
    }

    fileprivate init() {}
  }

  /// This `R.font` struct is generated, and contains static references to 1 fonts.
  struct font: Rswift.Validatable {
    /// Font `ChauPhilomeneOne-Regular`.
    static let chauPhilomeneOneRegular = Rswift.FontResource(fontName: "ChauPhilomeneOne-Regular")

    /// `UIFont(name: "ChauPhilomeneOne-Regular", size: ...)`
    static func chauPhilomeneOneRegular(size: CGFloat) -> UIKit.UIFont? {
      return UIKit.UIFont(resource: chauPhilomeneOneRegular, size: size)
    }

    static func validate() throws {
      if R.font.chauPhilomeneOneRegular(size: 42) == nil { throw Rswift.ValidationError(description:"[R.swift] Font 'ChauPhilomeneOne-Regular' could not be loaded, is 'chau-philomene-one.regular.ttf' added to the UIAppFonts array in this targets Info.plist?") }
    }

    fileprivate init() {}
  }

  /// This `R.image` struct is generated, and contains static references to 8 images.
  struct image {
    /// Image `check`.
    static let check = Rswift.ImageResource(bundle: R.hostingBundle, name: "check")
    /// Image `generic-food`.
    static let genericFood = Rswift.ImageResource(bundle: R.hostingBundle, name: "generic-food")
    /// Image `generic-logo`.
    static let genericLogo = Rswift.ImageResource(bundle: R.hostingBundle, name: "generic-logo")
    /// Image `grub-chaser-parceiro`.
    static let grubChaserParceiro = Rswift.ImageResource(bundle: R.hostingBundle, name: "grub-chaser-parceiro")
    /// Image `order`.
    static let order = Rswift.ImageResource(bundle: R.hostingBundle, name: "order")
    /// Image `table-default`.
    static let tableDefault = Rswift.ImageResource(bundle: R.hostingBundle, name: "table-default")
    /// Image `user-background`.
    static let userBackground = Rswift.ImageResource(bundle: R.hostingBundle, name: "user-background")
    /// Image `user`.
    static let user = Rswift.ImageResource(bundle: R.hostingBundle, name: "user")

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "check", bundle: ..., traitCollection: ...)`
    static func check(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.check, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "generic-food", bundle: ..., traitCollection: ...)`
    static func genericFood(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.genericFood, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "generic-logo", bundle: ..., traitCollection: ...)`
    static func genericLogo(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.genericLogo, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "grub-chaser-parceiro", bundle: ..., traitCollection: ...)`
    static func grubChaserParceiro(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.grubChaserParceiro, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "order", bundle: ..., traitCollection: ...)`
    static func order(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.order, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "table-default", bundle: ..., traitCollection: ...)`
    static func tableDefault(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.tableDefault, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "user", bundle: ..., traitCollection: ...)`
    static func user(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.user, compatibleWith: traitCollection)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UIImage(named: "user-background", bundle: ..., traitCollection: ...)`
    static func userBackground(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.userBackground, compatibleWith: traitCollection)
    }
    #endif

    fileprivate init() {}
  }

  /// This `R.info` struct is generated, and contains static references to 1 properties.
  struct info {
    struct uiApplicationSceneManifest {
      static let _key = "UIApplicationSceneManifest"
      static let uiApplicationSupportsMultipleScenes = false

      fileprivate init() {}
    }

    fileprivate init() {}
  }

  /// This `R.nib` struct is generated, and contains static references to 4 nibs.
  struct nib {
    /// Nib `GBROrderProductsTableViewCell`.
    static let gbrOrderProductsTableViewCell = _R.nib._GBROrderProductsTableViewCell()
    /// Nib `GBROrdersTableViewCell`.
    static let gbrOrdersTableViewCell = _R.nib._GBROrdersTableViewCell()
    /// Nib `GBRTableClientTableViewCell`.
    static let gbrTableClientTableViewCell = _R.nib._GBRTableClientTableViewCell()
    /// Nib `GBRTablesCollectionViewCell`.
    static let gbrTablesCollectionViewCell = _R.nib._GBRTablesCollectionViewCell()

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "GBROrderProductsTableViewCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.gbrOrderProductsTableViewCell) instead")
    static func gbrOrderProductsTableViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.gbrOrderProductsTableViewCell)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "GBROrdersTableViewCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.gbrOrdersTableViewCell) instead")
    static func gbrOrdersTableViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.gbrOrdersTableViewCell)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "GBRTableClientTableViewCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.gbrTableClientTableViewCell) instead")
    static func gbrTableClientTableViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.gbrTableClientTableViewCell)
    }
    #endif

    #if os(iOS) || os(tvOS)
    /// `UINib(name: "GBRTablesCollectionViewCell", in: bundle)`
    @available(*, deprecated, message: "Use UINib(resource: R.nib.gbrTablesCollectionViewCell) instead")
    static func gbrTablesCollectionViewCell(_: Void = ()) -> UIKit.UINib {
      return UIKit.UINib(resource: R.nib.gbrTablesCollectionViewCell)
    }
    #endif

    static func gbrOrderProductsTableViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> GBROrderProductsTableViewCell? {
      return R.nib.gbrOrderProductsTableViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? GBROrderProductsTableViewCell
    }

    static func gbrOrdersTableViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> GBROrdersTableViewCell? {
      return R.nib.gbrOrdersTableViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? GBROrdersTableViewCell
    }

    static func gbrTableClientTableViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> GBRTableClientTableViewCell? {
      return R.nib.gbrTableClientTableViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? GBRTableClientTableViewCell
    }

    static func gbrTablesCollectionViewCell(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> GBRTablesCollectionViewCell? {
      return R.nib.gbrTablesCollectionViewCell.instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? GBRTablesCollectionViewCell
    }

    fileprivate init() {}
  }

  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }

    fileprivate init() {}
  }

  fileprivate class Class {}

  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    #if os(iOS) || os(tvOS)
    try nib.validate()
    #endif
    #if os(iOS) || os(tvOS)
    try storyboard.validate()
    #endif
  }

  #if os(iOS) || os(tvOS)
  struct nib: Rswift.Validatable {
    static func validate() throws {
      try _GBRTableClientTableViewCell.validate()
    }

    struct _GBROrderProductsTableViewCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "GBROrderProductsTableViewCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> GBROrderProductsTableViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? GBROrderProductsTableViewCell
      }

      fileprivate init() {}
    }

    struct _GBROrdersTableViewCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "GBROrdersTableViewCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> GBROrdersTableViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? GBROrdersTableViewCell
      }

      fileprivate init() {}
    }

    struct _GBRTableClientTableViewCell: Rswift.NibResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let name = "GBRTableClientTableViewCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> GBRTableClientTableViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? GBRTableClientTableViewCell
      }

      static func validate() throws {
        if UIKit.UIImage(named: "user-background", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'user-background' is used in nib 'GBRTableClientTableViewCell', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }

    struct _GBRTablesCollectionViewCell: Rswift.NibResourceType {
      let bundle = R.hostingBundle
      let name = "GBRTablesCollectionViewCell"

      func firstView(owner ownerOrNil: AnyObject?, options optionsOrNil: [UINib.OptionsKey : Any]? = nil) -> GBRTablesCollectionViewCell? {
        return instantiate(withOwner: ownerOrNil, options: optionsOrNil)[0] as? GBRTablesCollectionViewCell
      }

      fileprivate init() {}
    }

    fileprivate init() {}
  }
  #endif

  #if os(iOS) || os(tvOS)
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      #if os(iOS) || os(tvOS)
      try launchScreen.validate()
      #endif
      #if os(iOS) || os(tvOS)
      try login.validate()
      #endif
      #if os(iOS) || os(tvOS)
      try main.validate()
      #endif
      #if os(iOS) || os(tvOS)
      try orders.validate()
      #endif
      #if os(iOS) || os(tvOS)
      try tables.validate()
      #endif
    }

    #if os(iOS) || os(tvOS)
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController

      let bundle = R.hostingBundle
      let name = "LaunchScreen"

      static func validate() throws {
        if UIKit.UIImage(named: "grub-chaser-parceiro", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'grub-chaser-parceiro' is used in storyboard 'LaunchScreen', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
      }

      fileprivate init() {}
    }
    #endif

    #if os(iOS) || os(tvOS)
    struct login: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = GBRLoginViewController

      let bundle = R.hostingBundle
      let loginVC = StoryboardViewControllerResource<GBRLoginViewController>(identifier: "loginVC")
      let name = "Login"

      func loginVC(_: Void = ()) -> GBRLoginViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: loginVC)
      }

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
        if _R.storyboard.login().loginVC() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'loginVC' could not be loaded from storyboard 'Login' as 'GBRLoginViewController'.") }
      }

      fileprivate init() {}
    }
    #endif

    #if os(iOS) || os(tvOS)
    struct main: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UITabBarController

      let bundle = R.hostingBundle
      let mainTabBarVC = StoryboardViewControllerResource<UIKit.UITabBarController>(identifier: "mainTabBarVC")
      let name = "Main"

      func mainTabBarVC(_: Void = ()) -> UIKit.UITabBarController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: mainTabBarVC)
      }

      static func validate() throws {
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
        if _R.storyboard.main().mainTabBarVC() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'mainTabBarVC' could not be loaded from storyboard 'Main' as 'UIKit.UITabBarController'.") }
      }

      fileprivate init() {}
    }
    #endif

    #if os(iOS) || os(tvOS)
    struct orders: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController

      let bundle = R.hostingBundle
      let name = "Orders"
      let orderDetailVC = StoryboardViewControllerResource<GBROrderDetailViewController>(identifier: "orderDetailVC")

      func orderDetailVC(_: Void = ()) -> GBROrderDetailViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: orderDetailVC)
      }

      static func validate() throws {
        if UIKit.UIImage(named: "order", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'order' is used in storyboard 'Orders', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
        if _R.storyboard.orders().orderDetailVC() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'orderDetailVC' could not be loaded from storyboard 'Orders' as 'GBROrderDetailViewController'.") }
      }

      fileprivate init() {}
    }
    #endif

    #if os(iOS) || os(tvOS)
    struct tables: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UINavigationController

      let bundle = R.hostingBundle
      let clientsTableVC = StoryboardViewControllerResource<GBRTableClientsViewController>(identifier: "clientsTableVC")
      let name = "Tables"

      func clientsTableVC(_: Void = ()) -> GBRTableClientsViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: clientsTableVC)
      }

      static func validate() throws {
        if UIKit.UIImage(named: "table-default", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'table-default' is used in storyboard 'Tables', but couldn't be loaded.") }
        if #available(iOS 11.0, tvOS 11.0, *) {
        }
        if _R.storyboard.tables().clientsTableVC() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'clientsTableVC' could not be loaded from storyboard 'Tables' as 'GBRTableClientsViewController'.") }
      }

      fileprivate init() {}
    }
    #endif

    fileprivate init() {}
  }
  #endif

  fileprivate init() {}
}

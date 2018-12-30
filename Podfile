platform:ios,'11.0'
use_frameworks!

target 'V2EX' do
    pod 'Fabric'
    pod 'Crashlytics'
    pod 'Alamofire'
    pod 'GenericNetworking'
    pod 'SnapKit'
    pod 'SwiftSoup'
    pod 'Kingfisher'
    pod 'MJRefresh'
    pod 'SideMenu'
    pod 'WCDB.swift'
    pod 'MBProgressHUD'
    pod 'FDFullscreenPopGesture'
    pod 'WXActionSheet'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            config.build_settings['CLANG_WARN_DOCUMENTATION_COMMENTS'] = 'NO'
            config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'NO'
            config.build_settings['VALID_ARCHS'] = 'arm64'
        end
    end
end

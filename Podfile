source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/artsy/Specs.git'

platform :ios, '9.0'

inhibit_all_warnings!
use_frameworks!

def shared_pods
    pod 'pop'#, '~> 1.0.9'
    pod 'R.swift'#, '~> 3.0.0-beta.1'
end

target 'AnimationManagerExample' do
    shared_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |configuration|
            configuration.build_settings['SWIFT_VERSION'] = "3.0"

            if target.name == "Appboy-iOS-SDK"
                configuration.build_settings["OTHER_LDFLAGS"] = '$(inherited) "-ObjC"'
            end
        end
    end
end

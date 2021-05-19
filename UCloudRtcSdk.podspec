#
#  Be sure to run `pod spec lint UCloudRtcSdk.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|


  spec.name         = "UCloudRtcSdk"
  spec.version      = "1.8.2"
  spec.summary      = "Real-time audio and video calling with UCloudRtcSdk"

  spec.description  = <<-DESC
                    By installing the URTC SDK, you can quickly build multi-person audio and video calls, one-to-many or many-to-many real-time interaction
                   DESC

  spec.homepage     = "https://github.com/ucloud/urtc-ios-demo"
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }  
  spec.author             = { "ucloudyj" => "yj.wang@ucloud.cn" }
  spec.platform     = :ios
  spec.ios.deployment_target = "9.0"
  spec.source       = { "http://urtcsdk.cn-bj.ufileos.com/UCloudRtcSdk_iOS-1.8.2.zip" }


   
  spec.xcconfig = {
    'VALID_ARCHS' =>  'arm64 armv7 x86_64',
   }
  spec.frameworks = "CFNetwork", "Security", "OpenGLES", "GLKit", "VideoToolbox", "Metal", "MetalKit"
  spec.libraries = "icucore", "c++", "bz2", "z", "iconv"
  spec.vendored_frameworks = 'UCloudRtcSdk_iOS-1.8.2/*.framework'

end

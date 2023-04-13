#
# Be sure to run `pod lib lint JXCommonTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JXCommonTools'
  s.version          = '0.1.0'
  s.summary          = 'swift工具'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/woaiyouxi0803/JXCommonTools'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'woaiyouxi' => 'woaiyouxi0803@163.com' }
  s.source           = { :git => 'https://github.com/woaiyouxi0803/JXCommonTools', :tag => s.version.to_s }
   s.social_media_url = 'https://www.jianshu.com/u/2db8fe439069'

  s.ios.deployment_target = '12.0'

  s.source_files = 'JXCommonTools/Classes/**/*'
  
  s.dependency 'SnapKit'
  s.dependency 'Hue'
  
end

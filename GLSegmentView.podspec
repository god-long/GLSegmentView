
Pod::Spec.new do |s|

  s.name         = "GLSegmentView"
  s.version      = "0.0.1"
  s.summary      = "A segment view for title"

  s.description  = <<-DESC
segment A segment view for title
                   DESC

  s.homepage     = "https://github.com/god-long/GLSegmentView"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }

  s.author             = { "god-long" => "xulongios@126.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/god-long/GLSegmentView.git", :tag => s.version }
  s.source_files  = "GLSegmentView/*.{swift}"
#  s.resources = ['GLSegmentView/*.{xib}'] 
  s.resource_bundles = {'GLSegmentView' => ['GLSegmentView/*.{xib}']}
  s.framework  = "UIKit"
  s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "JSONKit", "~> 1.4"

end

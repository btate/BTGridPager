#
# Be sure to run `pod lib lint NAME.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = "BTGridPager"
  s.version          = "0.1.6"
  s.summary          = "BTGridLayout is a subclass of UIScrollView that allows horizontal and vertical view pagin for iOS."
  s.description      = <<-DESC
                       BTGridLayout is a subclass of UIScrollView that allows horizontal and vertical view pagin for iOS.  It
                       allows for unlimited number of views to be paged through both vertically and horizontally.  

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/btate/BTGridPager"
  s.license          = 'MIT'
  s.author           = { "Brandon Tate" => "brandonntate@gmail.com" }
  s.source           = { :git => "https://github.com/btate/BTGridPager.git", :tag => s.version.to_s }
  s.source_files = 'BTGridPager'

  s.platform = :ios, '6.0'
  s.requires_arc = true
end

Pod::Spec.new do |s|
  s.name             = "C4iOS"
  s.version          = "0.1.0"
  s.summary          = "Code, Creatively. An open-source API for iOS."
  s.description      = "C4 is a brand new creative-coding framework lets you build expressive user experiences and create works of art. C4 gives you the power of the native iOS programming environment with a simplified API that lets you get down to working with media right away. Build artworks, design interfaces, explore new possibilities of working with media and interaction."
  s.homepage         = 'http://www.c4ios.com'
  s.license          = 'MIT'
  s.author           = { "Travis Kirton" => "travis@postfl.com" }
  s.source           = { :git => "https://github.com/kitschpatrol/C4iOS.git" }
  s.social_media_url = 'https://twitter.com/CocoaFor'
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'C4/**/*.{h,m}', 'C4iOS/C4WorkSpace.{h,m}'
  s.prefix_header_contents = '#import "C4.h"'
end

Pod::Spec.new do |s|
  s.name         = "CatalogByConvention"
  s.version      = "2.0.1"
  s.authors      = "Google Inc."
  s.summary      = "Tools for building a Catalog by Convention."
  s.homepage     = "https://github.com/material-foundation/cocoapods-catalog-by-convention"
  s.license      = 'Apache 2.0'
  s.source       = { :git => "https://github.com/material-foundation/cocoapods-catalog-by-convention.git", :tag => "v#{s.version}" }
  s.platform     = :ios,:tvos
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true

  s.public_header_files = "src/*.h"
  s.source_files = "src/*.{h,m,swift}", "src/private/*.{h,m,swift}"
  s.header_mappings_dir = "src"
end

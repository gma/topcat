if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  load_dependency 'merb-slices'
  Merb::Plugins.add_rakefiles "topcat/merbtasks", "topcat/slicetasks", "topcat/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :topcat
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:topcat][:layout] ||= :topcat
  
  # All Slice code is expected to be namespaced inside a module
  module Topcat
    
    # Slice metadata
    self.description = "Topcat is a CMS for plugging into your app"
    self.version = "0.0.1"
    self.author = "Graham Ashton"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(Topcat)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :topcat_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      # example of a named route
      scope.match('/index(.:format)').to(:controller => 'main', :action => 'index').name(:index)
      # the slice is mounted at /topcat - note that it comes before default_routes
      scope.match('/').to(:controller => 'pages', :action => 'index').name(:home)
      scope.resources :pages
    end
    
  end
  
  # Setup the slice layout for Topcat
  #
  # Use Topcat.push_path and Topcat.push_app_path
  # to set paths to topcat-level and app-level paths. Example:
  #
  # Topcat.push_path(:application, Topcat.root)
  # Topcat.push_app_path(:application, Merb.root / 'slices' / 'topcat')
  # ...
  #
  # Any component path that hasn't been set will default to Topcat.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  Topcat.setup_default_structure!
  
  # Add dependencies for other Topcat classes below. Example:
  # dependency "topcat/other"
  
end
require File.dirname(__FILE__) + '/../spec_helper'

describe "Topcat::Main (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { add_slice(:Topcat) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(Topcat::Main, :index)
    controller.slice.should == Topcat
    controller.slice.should == Topcat::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(Topcat::Main, :index)
    controller.status.should == 200
    controller.body.should contain('Topcat')
  end
  
  it "should work with the default route" do
    controller = get("/topcat/main/index")
    controller.should be_kind_of(Topcat::Main)
    controller.action_name.should == 'index'
  end
  
  it "should work with the example named route" do
    controller = get("/topcat/index.html")
    controller.should be_kind_of(Topcat::Main)
    controller.action_name.should == 'index'
  end
    
  it "should have a slice_url helper method for slice-specific routes" do
    controller = dispatch_to(Topcat::Main, 'index')
    
    url = controller.url(:topcat_default, :controller => 'main', :action => 'show', :format => 'html')
    url.should == "/topcat/main/show.html"
    controller.slice_url(:controller => 'main', :action => 'show', :format => 'html').should == url
    
    url = controller.url(:topcat_index, :format => 'html')
    url.should == "/topcat/index.html"
    controller.slice_url(:index, :format => 'html').should == url
    
    url = controller.url(:topcat_home)
    url.should == "/topcat"
    controller.slice_url(:home).should == url
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(Topcat::Main, :index)
    controller.public_path_for(:image).should == "/slices/topcat/images"
    controller.public_path_for(:javascript).should == "/slices/topcat/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/topcat/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    Topcat::Main._template_root.should == Topcat.dir_for(:view)
    Topcat::Main._template_root.should == Topcat::Application._template_root
  end

end
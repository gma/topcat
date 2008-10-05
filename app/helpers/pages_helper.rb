module Merb
  module Topcat
    module PagesHelper

      def page_title
        @title ? h(@title) : "Topcat"
      end
    
    end
  end
end # Merb
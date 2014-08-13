module ActiveAdmin
  module Views
    class Header < Component

      def build(namespace, menu)
        super(id: "header")

        @namespace = namespace
        @menu = menu
        @utility_menu = @namespace.fetch_menu(:utility_navigation)

        build_site_title
        build_global_navigation
        build_utility_navigation
      end


      def build_site_title
        insert_tag view_factory.site_title, @namespace
        @custom_menu = Menu.new

	@custom_menu.add label: get_product.name do |dropdown|
	  current_school.flavors.where('flavors.id <> ?', current_flavor.id).each do |f|
	    dropdown.add label: f.product.name, url: switch_product_sessions_path(id: f.id)
	  end
	end
        
        insert_tag view_tag.site_title, @custom_menu
      end

      def build_global_navigation
        insert_tag view_factory.global_navigation, @menu, class: 'header-item tabs'
      end

      def build_utility_navigation
        @custom_menu = Menu.new

        if session[:ghost]
          @custom_menu.add label: current_user.name, id: 'current_user', url: admin_user_path(current_user) do |dropdown|
            User.where(id: session[:uids]).where('id != ?', current_user.id).order('first_name ASC, last_name ASC').each do |user|
              dropdown.add label: user.name, url: ghost_session_path(user, current: request.fullpath)
            end
          end
        else
          @namespace.add_current_user_to_menu(@custom_menu)
        end
        @namespace.add_logout_button_to_menu(@custom_menu)

        insert_tag view_factory.utility_navigation, @custom_menu, id: 'utility_nav', class: 'header-item tabs'
      end
    end
  end
end

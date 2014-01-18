module ActiveAdmin
  module Generators
    class Error < Rails::Generators::Error
    end

    class DeviseGenerator < Rails::Generators::NamedBase
      desc "Creates an admin user and uses Devise for authentication"
      argument :name, :type => :string, :default => "AdminUser"

      RESERVED_NAMES = [:active_admin_user]

      def install_devise
        require 'devise'
        if File.exists?(File.join(destination_root, "config", "initializers", "devise.rb"))
          log :generate, "No need to install devise, already done."
        else
          log :generate, "devise:install"
          invoke "devise:install"
        end
      end

      def create_admin_user
        if RESERVED_NAMES.include?(name.underscore)
          raise Error, "The name #{name} is reserved by Active Admin"
        end
        invoke "devise", [name]
      end

      def set_namespace_for_path
        routes_file = File.join(destination_root, "config", "routes.rb")
        gsub_file routes_file, /devise_for :#{plural_table_name}$/, "devise_for :#{plural_table_name}, ActiveAdmin::Devise.config"
      end
    end
  end
end

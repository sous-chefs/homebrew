# Chef package provider for Homebrew

require 'chef/provider/package'
require 'chef/resource/package'
require 'chef/platform'

class Chef
  class Exceptions
    class Homebrew
      class NoRunAsUser < RuntimeError
        def initialize(message="You must set the attribute node['homebrew']['run_as'] before installing with brew")
          super(message)
        end
      end
    end
  end
end

class Chef
  class Provider
    class Package
      class Homebrew < Package
        def load_current_resource
          @current_resource = Chef::Resource::Package.new(@new_resource.name)
          @current_resource.package_name(@new_resource.package_name)
          @current_resource.version(current_installed_version)
          @current_resource
        end

        def install_package(name, version)
          brew_as_user('install', @new_resource.options, name)
        end

        def upgrade_package(name, version)
          brew('upgrade', name)
        end

        def remove_package(name, version)
          brew('uninstall', @new_resource.options, name)
        end

        # Homebrew doesn't really have a notion of purging, so just remove.
        def purge_package(name, version)
          @new_resource.options = ((@new_resource.options || "") << " --force").strip
          remove_package(name, version)
        end

        protected
	def run_as
          user_name = node["homebrew"]["run_as"] || raise(Chef::Exceptions::Homebrew::NoRunAsUser)
	end

	def brew_as_user(*args)
          get_response_from_command("sudo -u #{run_as} brew #{args.join(' ')}")
	end
	
        def brew(*args)
          get_response_from_command("brew #{args.join(' ')}")
        end

        def current_installed_version
          get_version_from_command("brew list --versions | awk '/^#{@new_resource.package_name} / { print $2 }'")
        end

        def candidate_version
          get_version_from_command("brew info #{@new_resource.package_name} | awk '/^#{@new_resource.package_name}[ :]/ { print $2 }'")
        end

        def get_version_from_command(command)
          version = get_response_from_command(command).chomp
          version.empty? ? nil : version
        end

        # Nicked from lib/chef/package/provider/macports.rb and tweaked
        # slightly.
        def get_response_from_command(command)
          output = nil
          status = popen4(command) do |pid, stdin, stdout, stderr|
            begin
              output = stdout.read
            rescue Exception => e
              raise Chef::Exceptions::Package, "Could not read from STDOUT on command: #{command}\nException: #{e.inspect}"
            end
          end
          unless (0..1).include? status.exitstatus
            raise Chef::Exceptions::Package, "#{command} failed - #{status.inspect}"
          end
          output
        end
      end
    end
  end
end

Chef::Platform.set :platform => :mac_os_x, :resource => :package, :provider => Chef::Provider::Package::Homebrew

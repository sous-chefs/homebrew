# Chef package provider for Homebrew

require 'chef/provider/package'
require 'chef/resource/package'
require 'chef/platform'

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
          if head_only?
            brew 'install', @new_resource.options, '--HEAD', name
          else
            brew 'install', @new_resource.options, name
          end
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
        def brew(*args)
          get_response_from_command("brew #{args.join(' ')}")
        end

        def current_installed_version
          version = get_response_from_command("brew list --versions | awk '/^#{@new_resource.package_name} / { print $2 }'")
          version.empty? ? nil : version
        end

        def head_only?
          candidate_version == 'HEAD'
        end

        def candidate_version
          info = get_response_from_command("brew info #{@new_resource.package_name} | grep ^#{@new_resource.package_name}:")

          stable = info.match(/stable (.+?),?/)
          devel  = info.match(/devel (.+?),?/)

          # we need the group so the map below works correctly
          head = info.match(/(HEAD)/)

          return [stable, devel, head].compact.map {|md| md[1] }.first
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

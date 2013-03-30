# Chef package provider for Homebrew

require 'chef/provider/package'
require 'chef/resource/package'
require 'chef/platform'
require 'chef/mixin/shell_out'

class Chef
  class Provider
    class Package
      class Homebrew < Package

        include Chef::Mixin::ShellOut

        def load_current_resource
          @current_resource = Chef::Resource::Package.new(@new_resource.name)
          @current_resource.package_name(@new_resource.package_name)
          @current_resource.version(current_installed_version)

          @current_resource
        end

        def install_package(name, version)
          versions = formula.to_hash['installed'].map {|v| v['version']}
          if versions.include?(version)
            brew('switch', name, version)
          else
            checkout(version)
            brew('install', @new_resource.options, name)
            reset_repo
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
          formula.to_hash['linked_keg']
        end

        def candidate_version
          pkg = formula
          pkg.stable.version.to_s || pkg.version.to_s
        end

        def formula
          @formula ||= get_formula
        end

        def get_formula
          brew_cmd = shell_out!("brew --prefix")
          libpath = ::File.join(brew_cmd.stdout.chomp, "Library", "Homebrew")
          $:.unshift(libpath)

          require 'global'
          require 'cmd/info'
          require 'cmd/versions'

          Formula.factory new_resource.package_name
        end

        def sha_for(version)
          pkg = formula
          sha_for_version = false
          pkg.versions do |v, sha|
            if v.to_s == version
              sha_for_version = sha
            end
          end
          sha_for_version
        end

        def get_response_from_command(command)
          output = shell_out!(command)
          output.stdout
        end

        def checkout(version)
          shell_out!("cd `brew --prefix` && git checkout #{sha_for(version)} #{formula.pretty_relative_path}")
        end

        def reset_repo
          shell_out!("cd `brew --prefix && git reset . || git checkout .`")
        end
      end
    end
  end
end

Chef::Platform.set :platform => :mac_os_x, :resource => :package, :provider => Chef::Provider::Package::Homebrew

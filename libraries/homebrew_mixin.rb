module Homebrew
  module Mixin

    def homebrew_owner
      @homebrew_owner ||= calculate_owner
    end

    private

    def calculate_owner
      owner = homebrew_owner_attr || sudo_user || current_user
      if owner == "root"
        raise Chef::Exceptions::User,
          "Homebrew owner is 'root' which is not supported. " +
          "To set an explicit owner, please set node['homebrew']['owner']."
      end
      owner
    end

    def homebrew_owner_attr
      node['homebrew']['owner']
    end

    def sudo_user
      ENV['SUDO_USER']
    end

    def current_user
      ENV['USER']
    end
  end
end

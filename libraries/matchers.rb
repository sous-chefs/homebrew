if defined?(ChefSpec)

  def tap_homebrew_tap(tap)
    ChefSpec::Matchers::ResourceMatcher.new(:homebrew_tap, :tap, tap)
  end

  def untap_homebrew_tap(tap)
    ChefSpec::Matchers::ResourceMatcher.new(:homebrew_tap, :tap, tap)
  end

end

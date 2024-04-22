class OmniauthError < StandardError
  def initialize(message = t("login_or_register.error.defaultOmniauthErrorMessage"))
    super
  end
end
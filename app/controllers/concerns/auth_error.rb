class AuthError < StandardError
  def initialize(message = t("login_or_register.error.defaultAuthErrorMessage"))
    super
  end
end
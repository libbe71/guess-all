class UsersError < StandardError
  def initialize(message = t("login_or_register.error.defaultUsersErrorMessage"))
    super
  end
end
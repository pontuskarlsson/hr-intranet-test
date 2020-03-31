module ControllerMacros

  #def login_admin
  #  before(:each) do
  #    @request.env['devise.mapping'] = Devise.mappings[:admin]
  #    sign_in FactoryBot.create(:admin)
  #  end
  #end

  def login_user(factory = :authentication_devise_user)
    let!(:logged_in_user) { FactoryBot.create(factory) }

    before(:each) do
      @request.env['devise.mapping'] = Devise.mappings[:authentication_devise_user]
      sign_in logged_in_user
    end
  end

end

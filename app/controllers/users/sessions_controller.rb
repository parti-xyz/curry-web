class Users::SessionsController < Devise::SessionsController
  def create
    super do |user|
      if !user.has_agreed_terms?
        return render "devise/sessions/terms"
      end
    end
  end
end
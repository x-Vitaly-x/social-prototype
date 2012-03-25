Rails.application.config.middleware.use OmniAuth::Builder do
  provider :vkontakte, '2871986', '7MYWZqHOOVGn0AHsOcGU'
  provider :identity, :fields => [:name], on_failed_registration: lambda { |env|
    IdentitiesController.action(:new).call(env)
  }
end

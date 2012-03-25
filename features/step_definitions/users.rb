# coding: utf-8;

То /^пользователь с именем "([^"]*)" и аккаунтом "([^"]*)" должен быть создан$/ do |name, provider|
  User.find_by_name(name).provider.should == provider
end

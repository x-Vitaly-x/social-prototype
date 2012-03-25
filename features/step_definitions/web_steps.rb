# coding: utf-8;

Допустим /^я являюсь гостем$/ do
  expire_cookies
  visit root_path
end

Если /^нажимаю на кнопку "([^"]*)"$/ do |button|
  click_button(button)
end

Если /^ввожу в поле "([^"]*)" значение "([^"]*)"$/ do |field_name, field_value|
  fill_in(field_name, :with => field_value)
end

Если /^я перехожу по ссылке "([^"]*)"$/ do |link|
  click_link(link)
end

То /^я должен оказаться на странице "([^"]*)"$/ do |text|
  page.should have_content(text)
end


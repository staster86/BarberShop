require 'rubygems'
require 'sinatra'
require 'sinatra/reloader'

get '/' do
	erb "Привет! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Оригинальный Twitter Botstrap</a> скопировали и чуть изменили его <a href=\"http://rubyschool.us/\">Ruby School</a>"
end

get '/about' do
	erb :about
end

get '/visit' do
	erb :visit
end

get '/contacts' do
	erb :contacts
end

post '/visit' do
	color = params[:color]
	barber = params[:barber]
	username = params[:username]
	phone = params[:phone]
	datetime = params[:datetime]

	f = File.open "./public/user.txt", "a"
	f.write "Парикхмахер: #{barber}, Клиент: #{username}, Телефон #{phone}, Дата и время: #{datetime}, Цвет: #{color}\n"
	f.close

	erb "Хорошо уважаемый #{username}! Ваш парикхмахер: #{barber}, телефон для связи с Вами #{phone}. Ждём Вас #{datetime} и покрасим ваши волосы в #{color} цвет."
end

post '/contacts' do
	email = params[:email]
	message = params[:message]

	f = File.open "./public/contacts.txt", "a"
	f.write "Почта: #{email}, Сообщение: #{message}\n"
	f.close

	erb "Спасибо за отзыв! Мы учтём Ваши пожелания."
end

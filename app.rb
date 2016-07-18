require 'rubygems'
require 'sinatra'          #Библиотека для поднятия вебсервера на основе Sinatra
require 'sinatra/reloader' #Автоматическая перезагрузка приложения без перезапуска сервера
require 'sqlite3'          #Подключение библиотеки для работы с sqlite3

#Обращение к SQLite3 для создания базы данных
configure do
	db = SQLite3::Database.new 'barbershop.db'
	db.execute 'CREATE TABLE IF NOT EXISTS
				`Users`
				(
				`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
				`name` TEXT,
				`phone` TEXT,
				`date_stamp` TEXT,
				`color` TEXT,
				`barber` TEXT
				);'
end

get '/' do
	erb "Hello! <a href=\"https://github.com/bootstrap-ruby/sinatra-bootstrap\">Original</a> pattern has been modified for <a href=\"http://rubyschool.us/\">Ruby School</a>"
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
	@color = params[:color]
	@barber = params[:barber]
	@username = params[:username]
	@phone = params[:phone]
	@datetime = params[:datetime]

	hh = { 	:username => 'Введите имя',
			:phone => 'Введите телефон',
		 	:datetime => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	db = get_db
	db.execute 'INSERT INTO Users (name, phone, date_stamp, barber, color)
				VALUES (?, ?, ?, ?, ?)', [@username, @phone, @datetime, @barber, @color]

	erb "Хорошо уважаемый #{@username}! Ваш парикхмахер: #{@barber}, телефон для связи с Вами #{@phone}. Ждём Вас #{@datetime} и покрасим ваши волосы в #{@color} цвет."
end

post '/contacts' do
	@email = params[:email]
	@message = params[:message]

	erb "Спасибо за отзыв! Мы учтём Ваши пожелания."
end

def get_db
	return SQLite3::Database.new 'barbershop.db'
end

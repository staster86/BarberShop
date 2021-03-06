require 'rubygems'
require 'sinatra'          #Библиотека для поднятия вебсервера на основе Sinatra
require 'sinatra/reloader' #Автоматическая перезагрузка приложения без перезапуска сервера
require 'sqlite3'          #Подключение библиотеки для работы с sqlite3

def is_barber_exists? db, name
	db.execute('select * from Barbers where name=?', [name]).length > 0
end

def seed_db db, barbers
	barbers.each do |barber|
		if !is_barber_exists? db, barber
			db.execute 'INSERT into Barbers (name) values (?)', [barber]
		end
	end
end

def get_db
	db = SQLite3::Database.new 'barbershop.db'
	db.results_as_hash = true
	return db
end

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

	db.execute 'CREATE TABLE IF NOT EXISTS
	`Barbers`
	(
	`id`	INTEGER PRIMARY KEY AUTOINCREMENT,
	`name` TEXT
	);'

	seed_db db, ['Тони Масколо', 'Видал Сассун', 'Лара Лейто', 'Мариэл Хенн', 'Кейт Янг', 'Лесли Фримар']
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
	@date_stamp = params[:date_stamp]

	hh = { 	:username => 'Введите имя',
			:phone => 'Введите телефон',
		 	:date_stamp => 'Введите дату и время' }

	@error = hh.select {|key,_| params[key] == ""}.values.join(", ")

	if @error != ''
		return erb :visit
	end

	db = get_db
	db.execute 'INSERT INTO Users (name, phone, date_stamp, barber, color)
				VALUES (?, ?, ?, ?, ?)', [@username, @phone, @date_stamp, @barber, @color]

	erb "Хорошо уважаемый #{@username}! Ваш парикхмахер: #{@barber}, телефон для связи с Вами #{@phone}. Ждём Вас #{@date_stamp} и покрасим ваши волосы в #{@color} цвет."
end

get '/showusers' do
	db = get_db
	@results = db.execute 'select * from Users order by id desc'
	erb :showusers
end

post '/contacts' do
	@email = params[:email]
	@message = params[:message]
	erb "Спасибо за отзыв! Мы учтём Ваши пожелания."
end

require "gtk3"
require "json"

	window = Gtk::Window.new("CDR")
	window.set_size_request(1000, 5000)
	window.set_border_width(10)

	fixed = Gtk::Fixed.new

	label = Gtk::Label.new("Welcome Laura Miralles")
	fixed.put(label, 0, 0)

	file = File.read("taula.json")
	data_hash = JSON.parse(file)
	label2 = Gtk::Label.new("")
	fixed.put(label2, 490, 100)
	
	entry = Gtk::Entry.new
	entry.set_size_request(1000,10)
	entry.signal_connect "activate" do |_widget|
		if entry.text == "timetables"
			label2.set_label(entry.text)
		end
		if entry.text == "tasks"
			label2.set_label(entry.text)
		end
		if entry.text == "marks"
			label2.set_label(entry.text)
		end
	end	
	fixed.put(entry, 0, 60)
	entry.show

	label2 = Gtk::Label.new(entry.text)
	fixed.put(label2, 0, 150)

	table = Gtk::Table.new(data_hash.size, data_hash[0].keys.size, false)

	table.row_spacing = 3
	table.column_spacing = 10
	table.margin = 20	

	#table.set_size_request(1000,2500)
	fixed.put(table, 0, 400)
	
	for i in 0..data_hash[0].keys.size do
		col = Gtk::Label.new(data_hash[i].keys[i].to_s)
		col.set_size_request(2,2)
		table.attach col, i, i+1, 0, 1
		col.show

	end

	for j in 0..data_hash.size-1 do
	for i in 0..data_hash[0].keys.size-1 do
		col = Gtk::Label.new(data_hash[j].values[i].to_s)
		col.set_size_request(2,2)
		table.attach col, i, i+1, j+1, j+2
		col.show

	end
	end

	button2 = Gtk::Button.new
	button = Gtk::Button.new(:label => "Logout")
	button.signal_connect "clicked" do |_widget|
		button.hide
		label.hide
		label2.hide
		entry.hide
		table.hide	
		fixed.put(button2, 500, 500)
		button2.show
	end
	button2.signal_connect "clicked" do |_widget|
		table.show
		button2.hide
	end
	button.set_size_request(50,10)
	fixed.put(button, 950, 0)
	
	#table.set_size_request(990,3000)
	#fixed.put(table, 30, 50)
	window.add(fixed)

	window.show_all

window.signal_connect("delete-event") { 
	Gtk.main_quit 
}

Gtk.main
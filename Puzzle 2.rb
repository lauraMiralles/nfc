require "gtk3"
require "./puzzle1"
require "thread"

	@rf = Rfid.new
	@uid = ""

	window = Gtk::Window.new("Puzzle 2")
	window.set_size_request(600, 150)
	window.set_border_width(10)

	test_entry = Gtk::Entry.new

	@blue = Gdk::RGBA::new(0,0,1.0,1.0)
	@white = Gdk::RGBA::new(1.0,1.0,1.0,1.0)
	@red = Gdk::RGBA::new(1.0,0,0,1.0)
	
	@window_label = Gtk::Button.new(:label => "Please, login with your university card")
	@window_label.override_background_color(:normal, @blue)

	@button = Gtk::Button.new(:label => "Clear")
	@button.signal_connect "clicked" do |_widget|
		if @uid != ""
			@window_label.set_label("Please, login with your univeristy card")
			@window_label.override_background_color(:normal, @blue)
			@uid = ""
			thread
		end
	end

	fixed = Gtk::Fixed.new
	@button.set_size_request(540,40)
	@window_label.set_size_request(540,100)
	fixed.put(@window_label, 30, 0)
	fixed.put(@button, 30, 110)
	window.add(fixed)

	window.show_all
	
	def thread
		t = Thread.new {
			read
			t.exit
		}
	end

	def read
		@uid = @rf.read_uid
		GLib::Idle.add{label}
	end

	def label
		if @uid != ""
			@window_label.set_label("uid: " + @uid)
			@window_label.override_background_color(:normal, @red)	
		end
	end
	thread

window.signal_connect("delete-event") { 
	Gtk.main_quit 
}

Gtk.main
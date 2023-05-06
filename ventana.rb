require "gtk3"

	@css_provider = Gtk::CssProvider.new
	@css_provider.load_from_path('personalizacion.css')
	@style_prov = Gtk::StyleProvider::PRIORITY_USER
	fixed = Gtk::Fixed.new

	window = Gtk::Window.new("ventana")
	window.set_default_size(600, 150)
	window.set_border_width(10)

	@window_label = Gtk::Label.new("Please, login with your university card")
	@window_label.style_context.add_provider(@css_provider, @style_prov)
	@window_label.set_size_request(115, 50) 
	@window_label.set_name("label")
	fixed.put(@window_label, 130, 40)


	window.add(fixed)
	window.show_all


window.signal_connect("delete-event") { 
	Gtk.main_quit 
}


Gtk.main
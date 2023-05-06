require "gtk3"
require "thread"
require "glib2"
require_relative 'rfid'
#require_relative 'app'
require 'gtk3'
require 'json'
require 'uri'
require 'net/http'
#require 'facets/timer'
#require_relative 'lcd' recuerda cambiar los nombres de tu archivo

class App <Gtk::Window
	def initialize
	
			@ventanaAppExportada
            @host='localhost'
            @port='8080'
		super
		set_title "Example"
		set_resizable false
		
		@ventanaAppExportada 
		@grid = Gtk::Grid.new
		add(@grid)
		@grid.set_hexpand true
		@grid.set_vexpand true
		@grid.set_column_homogeneous true

		@buttonsGrid = Gtk::Grid.new
                @grid.add(@buttonsGrid)
		@buttonsGrid.set_hexpand true
		@buttonsGrid.set_vexpand true
		@buttonsGrid.set_column_homogeneous true

		@welcome=Gtk::Label.new
		@welcome.set_text "Welcome alumne"	
		@buttonsGrid.attach(@welcome,0,0,1,1)
		
		
		
		#----variable control

		

		@button=Gtk::Button.new :label=>"Logout"
		@button.signal_connect("clicked") { 
		
		
		
		@ventanaAppExportada  = Main.new
        @ventanaAppExportada.inicioVentanaPrincipal
		
		
		destroy }
		@buttonsGrid.attach(@button,2,0,1,1)

		@search=Gtk::Entry.new
		@search.set_placeholder_text "Insert your request"
		@search.signal_connect "activate" do
			searchEvent
		end
		@buttonsGrid.attach(@search,0,1,3,1)

		@tableName=Gtk::Label.new
		@tableName.set_text "Table name"	
		@buttonsGrid.attach(@tableName,1,2,1,1)

		#signal_connect("delete-event") { |_widget| Gtk.main_quit }
		#show_all
		#Gtk.main
	end

	def searchEvent
		request=@search.text	
		@search.text=""
                        puts "Hola"
			json=sendRequest(request)
			@tableName.set_text json["table"] 
			createTable json
			show_all
	end

	def sendRequest(url)
                uri = URI('http://'+@host+':'+@port+'/'+url)
                puts uri
                response=Net::HTTP.get(uri)
                puts response
		return JSON.parse(response)
	end

	def createTable(data)
                begin
                        @grid.remove @table
                rescue
                end

		@table = Gtk::Grid.new

		@table.set_row_spacing 5
		@table.set_column_spacing 5

		@table.set_vexpand true
		@table.set_hexpand true

                data=data["contents"]

                if data.size==0
                        return
                end

		rows=data.size
		cols=data[0].size

		for i in 0..cols-1 do
			@table.attach(Gtk::Label.new(data[0].keys[i]),i,0,1,1)
		end

		for i in 0..rows-1 do
			for j in 0..cols-1 do
				@table.attach(Gtk::Label.new(data[i].values[j]),j,i+1,1,1)
			end
		end
		@grid.attach(@table,0,1,1,1)
	end
	
	def Inicioapp
	
		signal_connect("delete-event") { |_widget| Gtk.main_quit }
		show_all
	
	end
	
	def destruirVentana
	
		destroy
	
	end
	
end


class Main

attr_accessor :label, :ventanaInicio, :ventanaAppExportada, :fixed, :uid, :timer


             def initialize
             
                @rf=Rfid.new
                @timer
                @css_provider = Gtk::CssProvider.new
                @css_provider.load_from_path('personalizacion.css')
                @style_prov = Gtk::StyleProvider::PRIORITY_USER
                #@display = I2C::Drivers::LCD::Display.new('/dev/i2c-1', 0x27, rows=20, cols=4)
                #@lcd = lcd.new(display)
                
             
                @ventanaInicio = Gtk::Window.new("Critical Design")
                @ventanaInicio.set_title("course_manager")
                @ventanaInicio.set_default_size(600,150)
                @ventanaInicio.set_border_width(10)
                @ventanaInicio.set_window_position(:CENTER)
                @host='localhost'
                @port='8080'
                @existeUsuario = ""
                
                
                @ventanaAppExportada = App.new
                #----
                #se tiene que inicializar la ventana expotada de horario -> ventanaAppExportada
                #---
               
               
             end
             
             
             def inicializarDeNuevo
                @ventanaInicio = Gtk::Window.new("Critical Design")
                @ventanaInicio.set_title("course_manager")
                @ventanaInicio.set_default_size(600,150)
                @ventanaInicio.set_border_width(10)
                @ventanaInicio.set_window_position(:CENTER)
                
                #@ventanaAppExportada.initialize
             end
             
        
             def login(resposta)

                puts "esto es lo que me ha devuelto el servidor"
                puts resposta
                resposta = " "

                if resposta.eql? ''   #aqui dependiendo de lo que devuelva, inicia otra ves el programa, si envia algo vacio no hay ese usuario
                        puts "No se ha econtrado el usuario"
                        @ventanaInicio.destroy
                        inicializarDeNuevo
                        inicioVentanaPrincipal #vuelvo a iniciar la pantalla
                        put "se ha reiniciado la ventana"

                else    #aqui ha encontrado un usuario, por ello destruye la ventana en la que estabamos y inicia la externa con las columnas
                        #@lcd.read_uid("Saludos " + @uid)
                        puts "Saludos " + @uid  
                        @ventanaInicio.destroy
                        puts "destruyo la pantalla anterior"
						@ventanaAppExportada.Inicioapp
						puts "variable control"
							
							

                end
				return false

             end 
               
             def inicioVentanaPrincipal
                
                #@lcd.read_uid("Please put your card on the reader")
                @label=Gtk::Label.new("Please put your card on the reader")
                @label.style_context.add_provider(@css_provider, @style_prov)
                @label.set_size_request(115, 50)
                @label.set_name("label")
                @fixed= Gtk::Fixed.new
                @fixed.put(@label, 130 , 40)
                @ventanaInicio.add(@fixed)
               
                @ventanaInicio.show_all
                puts "Finestra creada"
               
                tr=Thread.new {
                
                @uid=@rf.read_uid
                   
				puts @uid
				@existeUsuario = sendRequest('/students?id='+@uid)
						puts @existeUsuario
                                                                        
				 GLib::Idle.add { login(@existeUsuario) }
                    
                }
                
                
             end
               
				
			 def sendRequest(url)
                uri = URI('http://'+@host+':'+@port+url)
                puts uri
                response=Net::HTTP.get(uri)
                puts response
			 return JSON.parse(response)
			 end
			 
      

      end



fin = Main.new
fin.inicioVentanaPrincipal

Gtk.main

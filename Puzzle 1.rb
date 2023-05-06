require 'io/console'
class Rfid

	def read_uid
		uid = STDIN.noecho(&:gets)
		uid = uid.to_i.to_s(16).upcase
		return uid
	end
end

if __FILE__ == $0
	rf = Rfid.new
	puts "Esperant lectura..."
	uid = rf.read_uid
	puts uid
end
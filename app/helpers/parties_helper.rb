module PartiesHelper
  def get_style_jeton(jeton)
    if jeton[-2,1] == "N"
      style = "background-color:black; color:white; text-decoration:none"
    else
      style = "background-color:white; color:black; text-decoration:none"
    end
    style
  end
  
  
  
  def get_numero_jeton(jeton)
    jeton[/[0-9]*/]
  end
	
	
	def get_chat_messages(chat_messages)
		message_full = ""
		chat_messages.each do |m|
			message_full = message_full + "<div id=\"chat_line_" + m.id.to_s + "\" class=\"chat_line\">" + m.message + "</div>\n"
		end
		message_full
	end
end

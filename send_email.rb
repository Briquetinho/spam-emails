require "google_drive"
require "gmail"

#Cette fonction sert à envoyer un mail à l'adresse "email", avec un message personalisé pour la ville "ville"
def send_email_to_line(email,ville)
	gmail = Gmail.connect("penduleee@gmail.com",password)
	gmail.deliver do
 		to email
   		subject "Formation The Hacking Project"
	    body get_the_email_html(ville)
	end
	gmail.logout
end

#Cette fonction récupère toutes les adresses dans le fichier google spreadsheet et utilise la fontion précédente pour leur envoyer un mail
def go_through_all_the_lines
	session = GoogleDrive::Session.from_config("config.json")
	ws = session.spreadsheet_by_key("1mjV3-Zh7U0uK3WRTt4O_AQyD_b2tRWoZa_QQoqLt6ck").worksheets[0]
	longueur = ws.num_rows
	i=1
	while i<=longueur
		send_email_to_line(ws[i,2],ws[i,1])
		i+=1
	end
end

#Cette fonction permet de choisir le texte et de le personnalsier en fonction de la ville. Cette fonction est utile dans la fonction send_email_to_line(email,ville)
def get_the_email_html(ville)
	return "Bonjour,
Je m'appelle Adrien, je suis élève à une formation de code gratuite, ouverte à tous, sans restriction géographique, ni restriction de niveau. La formation s'appelle The Hacking Project (http://thehackingproject.org/). Nous apprenons l'informatique via la méthode du peer-learning : nous faisons des projets concrets qui nous sont assignés tous les jours, sur lesquel nous planchons en petites équipes autonomes. Le projet du jour est d'envoyer des emails à nos élus locaux pour qu'ils nous aident à faire de The Hacking Project un nouveau format d'éducation gratuite.

Nous vous contactons pour vous parler du projet, et vous dire que vous pouvez ouvrir une cellule à #{ville}, où vous pouvez former gratuitement 6 personnes (ou plus), qu'elles soient débutantes, ou confirmées. Le modèle d'éducation de The Hacking Project n'a pas de limite en terme de nombre de moussaillons (c'est comme cela que l'on appelle les élèves), donc nous serions ravis de travailler avec #{ville} !

Charles, co-fondateur de The Hacking Project pourra répondre à toutes vos questions : 06.95.46.60.80"
end

go_through_all_the_lines

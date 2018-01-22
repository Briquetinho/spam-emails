
require 'nokogiri'
require 'open-uri'
require "google_drive"
   

page_url = "http://annuaire-des-mairies.com/95/vaureal.html"
page_url2 = "http://annuaire-des-mairies.com/var.html"

#On récupère l'adresse email de la ville à partir de sa page spécifique
def get_the_email_of_a_townhal_from_its_webpage(page_url)
   page = Nokogiri::HTML(open(page_url))
   email = page.css("table[8] tr[4] td[2] p").text
   email[0] = ''
   return email
end

#On récupère le nom de chaque ville
def get_the_name(page_url)
   page = Nokogiri::HTML(open(page_url))
   links = page.css("a[class = lientxt]")
   names = []
   links.each do |link|
      names << link.text
   end
   return names
end

#On se sert des méthodes précédents pour récupérer les emails de toutes les mairies d'un département
def get_all_the_urls_of_val_doise_townhalls(page_url)
   page = Nokogiri::HTML(open(page_url))
   links = page.css("a[class = lientxt]")
   emails = []
   links.each do |link| 
      link[0] = ''
      emails << get_the_email_of_a_townhal_from_its_webpage("http://annuaire-des-mairies.com" + link["href"])
   end
   return emails
end

#Bonus: on les range dans un hash

def get_and_put_in_hash(page_url)
   names = get_the_name(page_url)
   emails = get_all_the_urls_of_val_doise_townhalls(page_url)
   taille = names.length
   indice = 0
   result = []
   while indice < taille
      mairie = Hash.new
      mairie[:name] = names[indice]
      mairie[:email] = emails[indice]
      indice += 1
      result << mairie
   end
   return result
end
result = get_and_put_in_hash(page_url2)


#On place ces données dans un fichier google spreadsheet
session = GoogleDrive::Session.from_config("config.json")
ws = session.spreadsheet_by_key("1mjV3-Zh7U0uK3WRTt4O_AQyD_b2tRWoZa_QQoqLt6ck").worksheets[0]
i=1
result.each do |r|
   ws[i,1]=r[:name]
   ws[i, 2]=r[:email]
   i += 1
end
ws.save
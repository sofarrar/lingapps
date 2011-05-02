require 'nokogiri'
require 'open-uri'

=begin
#output params
word_list_name = "Swadesh-207"
extension = "wordlist"
#=begin
#two parallel arrays
urls = [
				"http://en.wiktionary.org/wiki/Appendix:German_Swadesh_list",
				"http://en.wiktionary.org/wiki/Appendix:French_Swadesh_list",
				"http://en.wiktionary.org/wiki/Appendix:Spanish_Swadesh_list",
				"http://en.wiktionary.org/wiki/Appendix:Portuguese_Swadesh_list"]
language_codes = ["deu","spa","fra","por"]

if (urls.length!=language_codes.length)
	puts "no language code for matching url"
	exit
end

#otherwise proceed
(0..urls.length-1).each do |index|
	puts "processing "+urls[index]	
	doc = Nokogiri::HTML(open(urls[index]))
	
	outfile = File.open(word_list_name+"."+language_codes[index]+"."+extension,"w")

	nodeset = doc.xpath("//tr/td[3]")

	nodeset.each do |node|
  	outfile.puts('"'+node.text+'"')	
	end
outfile.close
end


#special languages

#english (template version)
english_url = "http://en.wiktionary.org/wiki/Wiktionary:Swadesh_template"
puts "processing "+english_url	
doc = Nokogiri::HTML(open(english_url))
outfile = File.open(word_list_name+"."+"eng"+"."+extension,"w")
nodeset = doc.xpath("//tr/td[2]")

nodeset.each do |node|
	outfile.puts('"'+node.text+'"')	
end


#chinese
mandarin_url = "http://en.wiktionary.org/wiki/Appendix:Mandarin_Swadesh_list"
puts "processing "+mandarin_url	
doc = Nokogiri::HTML(open(mandarin_url))
outfile = File.open(word_list_name+"."+"cmn"+"."+extension,"w")
nodeset = doc.xpath("//tr/td[8]")

nodeset.each do |node|
	outfile.puts('"'+node.text+'"')	
end


=end


=begin
#hindi -- issues with parens
hindi_url = "http://en.wiktionary.org/wiki/Appendix:Hindi_Swadesh_list"
puts "processing "+hindi_url	
doc = Nokogiri::HTML(open(hindi_url))
outfile = File.open(word_list_name+"."+"hin"+"."+extension,"w")
nodeset = doc.xpath("//tr/td[3]")

nodeset.each do |node|
	data = node.text
  pattern =  /\(\p{Ll}*\)/u
	hindi_word = data.gsub(pattern,'')

	pattern =  /\(\p{Lo}*\)/u
	hindi_word = hindi_word.gsub(pattern,'') 
	pattern =  /\(\p{Lu}*\)/u
	hindi_word = hindi_word.gsub(pattern,'') 
	pattern =  /\(\p{Pc}*\)/u
	hindi_word = hindi_word.gsub(pattern,'') 




	outfile.puts('"'+hindi_word+'"')	
end

=end


#animals

=begin
#output params
word_list_name = "AfricanAnimals"
extension = "wordlist"

puts "processing "+word_list_name
doc = Nokogiri::HTML(open("http://www.buzzle.com/articles/african-animals-list.html"))
	
outfile = File.open(word_list_name+"."+"eng"+"."+extension,"w")

	nodeset = doc.xpath("//tr/td[2]")

	nodeset.each do |node|
  	outfile.puts('"'+node.text+'"')	
	end
outfile.close
=end

#output params
word_list_name = "SouthAmericanAnimals"
extension = "wordlist"

puts "processing "+word_list_name
doc = Nokogiri::HTML(open("http://en.wikipedia.org/wiki/List_of_South_American_mammals"))
	
outfile = File.open(word_list_name+"."+"eng"+"."+extension,"w")


	nodeset = doc.xpath("//li/a")

	nodeset.each do |node|
  	outfile.puts('"'+node.text+'"')	
	end
outfile.close





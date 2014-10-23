# encoding: utf-8

require 'open-uri'
require 'nokogiri'
require 'fileutils'

# エントリーナンバー 辞退とかあったらずれる
$num = 1

# 画像の保存を行うメソッド
# current/dir/
# 以下に画像を保存する
def save_file(url, dir)
	FileUtils.mkdir(dir) unless FileTest.exist?(dir)
	filename = File.basename($num.to_s + ".jpg")
	open(dir + filename,'wb') do |file|
		open(url) do |data|
			file.write(data.read)
			$num = $num + 1
		end
	end
end

# main

base = "http://misscolle.com"
linklist = Array.new()

# トップページから全ページへのリンクを取得
top = Nokogiri::HTML(open(base))
top.css('ul#gfoot_links > li > a').each do |node|
	linklist.push(node.values[0])
end

# 画像取得
linklist.each do |page|
	# page = "/xxxx" の形
	$num = 1;
	doc = Nokogiri::HTML(open(base+page))
	doc.css('div.entry_photo > img').each do |node|
		imgurl = node.values[0].split("?")[0]
		save_file(base + imgurl, page.slice(1..-1) + "/")
	end
end

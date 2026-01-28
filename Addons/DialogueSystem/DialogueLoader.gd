extends Node

class_name DialogueLoader

var dialogues = {}
var characters = {}
var translations = {}

func load_all():
	load_characters("res://Data/characters.json")
	load_dialogues("res://Data/dialogues.json")
	load_translations("res://Data/translations.csv")

func load_characters(path):
	var data = JSON.parse_string(FileAccess.get_file_as_string(path))
	characters = data["characters"]

func load_translations(path: String) -> void:
	var f = FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_error("No se pudo abrir: %s" % path)
		return
		
	var header = f.get_csv_line() # ["KEY", "en", "es", ...]
	if header.empty():
		f.close()
		return
		
	# Crear Translation por cada idioma (skip header[0])
	var translations := {}
	for i in range(1, header.size()):
		var lang = header[i].strip_edges()
		if lang == "":
			continue
		var tr = Translation.new()
		tr.set_locale(lang)        # asigna locale (p.e. "es", "en")
		translations[lang] = tr
	
	# Leer filas
	while not f.eof_reached():
		var row = f.get_csv_line()
		if row.empty():
			continue
		var key = row[0]
		for i in range(1, header.size()):
			var lang = header[i].strip_edges()
			if not translations.has(lang):
				continue
			var txt = ""
			if i < row.size():
				txt = row[i]
			translations[lang].add_message(key, txt)
	
	f.close()
	
	# Registrar todas las traducciones en TranslationServer
	for lang in translations.keys():
		TranslationServer.add_translation(translations[lang])
	
	# (Opcional) establecer locale por defecto del juego
	TranslationServer.set_locale("es")

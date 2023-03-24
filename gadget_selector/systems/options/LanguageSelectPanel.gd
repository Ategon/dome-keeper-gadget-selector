extends Control

signal quit

var flag_de = preload("res://systems/localization/flags/de_DE.png")
var flag_dk = preload("res://systems/localization/flags/dk.png")
var flag_en = preload("res://systems/localization/flags/en_US.png")
var flag_ja = preload("res://systems/localization/flags/ja_JA.png")
var flag_zh = preload("res://systems/localization/flags/zh_CN.png")
var flag_es = preload("res://systems/localization/flags/es_ES.png")
var flag_es_LAT = preload("res://systems/localization/flags/es_LAT2.png")
var flag_fi = preload("res://systems/localization/flags/fi_FI.png")
var flag_fr = preload("res://systems/localization/flags/fr_FR.png")
var flag_it = preload("res://systems/localization/flags/it_IT.png")
var flag_ko = preload("res://systems/localization/flags/pepsi.png")
var flag_nl = preload("res://systems/localization/flags/nl_NL.png")
var flag_no = preload("res://systems/localization/flags/no_NO.png")
var flag_pl = preload("res://systems/localization/flags/pl_PL.png")
var flag_pt_BR = preload("res://systems/localization/flags/pt_BR.png")
var flag_pt_PT = preload("res://systems/localization/flags/pt_PT.png")
var flag_ro = preload("res://systems/localization/flags/ro_RO.png")
var flag_ru = preload("res://systems/localization/flags/ru_RU.png")
var flag_sv = preload("res://systems/localization/flags/sv_SE.png")
var flag_th = preload("res://systems/localization/flags/th_TH.png")
var flag_tr = preload("res://systems/localization/flags/tr_TR.png")
var flag_vi = preload("res://systems/localization/flags/vi_VN.png")
var flag_fo_FO = preload("res://systems/localization/flags/fo_FO.png")
var flag_bg = preload("res://systems/localization/flags/bg_BG.png")
var flag_zh_TW = preload("res://systems/localization/flags/zh_TW.png")
var flag_uk = preload("res://systems/localization/flags/uk_UA.png")
var flag_he = preload("res://systems/localization/flags/he_IL.png")
var flag_cs = preload("res://systems/localization/flags/cs_CZ.png")
var flag_id = preload("res://systems/localization/flags/id_ID.png")
var flag_ar = preload("res://systems/localization/flags/ar_SA.png")
var flag_sr_Latn = preload("res://systems/localization/flags/latin.png")
var flag_hu = preload("res://systems/localization/flags/hu_HU.png")

const translationDesc: = {
	"ar_SA":[true], 
	"bg_BG":[false, 91], 
	"cs_CZ":[true], 
	"da_DK":[true], 
	"de_DE":[true], 
	"en_US":[true], 
	"es_ES":[true], 
	"es_AR":[true], 
	"fr_FR":[true], 
	"fi_FI":[true], 
	"he_IL":[false, 0], 

	"hu_HU":[true], 
	"id_ID":[false, 30], 
	"it_IT":[true], 
	"ja_JP":[true], 
	"ko_KR":[true], 
	"nb_NO":[true], 
	"nl_NL":[true], 
	"pl_PL":[true], 
	"pt_BR":[true], 
	"pt_PT":[true], 
	"ro_RO":[false, 100], 
	"ru_RU":[true], 
	"sv_SE":[true], 
	"th_TH":[false, 82], 
	"tr_TR":[true], 
	"uk_UA":[true], 
	"vi_VN":[false, 40], 
	"zh_CN":[true], 
	"zh_TW":[true]
}

var lastFocusButton

func _ready():
	buildBindingUi()
	Style.init(self)

func buildBindingUi():
	var CommunityTranslations = find_node("CommunityTranslations")
	var ProfessionalTranslations = find_node("ProfessionalTranslations")
	for c in CommunityTranslations.get_children():
		c.queue_free()
	for c in ProfessionalTranslations.get_children():
		c.queue_free()

	var englishOption
	var gotFocus: = false
	for code in TranslationServer.get_loaded_locales():
		var language = Data.LanguageNamesByCode.get(code, code)
		var flag = set_keeper_language_flag(code)
		var details = translationDesc.get(code)
		var description:String
		# GSM
		if (!details): continue
		# End GSM
		if details[0]:
			description = ""
		else :
			var percentage = details[1]
			if percentage < 15:
				continue
			description = tr("options.translation.community").format({"completion":percentage})

		var translationEntry = preload("res://systems/options/LanguageOption.tscn").instance()
		translationEntry.init(flag, language, description)
		translationEntry.connect("request_change", self, "set_local_lang", [code])
		if flag == flag_en:
			englishOption = translationEntry
		
		if details[0]:
			ProfessionalTranslations.add_child(translationEntry)
		else :
			CommunityTranslations.add_child(translationEntry)
		
		if code == TranslationServer.get_locale():
			InputSystem.grabFocus(translationEntry)
			gotFocus = true
	
	if not gotFocus:
		InputSystem.grabFocus(englishOption)
	
func set_local_lang(languageCode):
	TranslationServer.set_locale(languageCode)
	Audio.sound("gui_select")
	var languageSection = get_tree().get_nodes_in_group("lang").front()
	languageSection.set_keeper_language_flag()
	languageSection.set_Language_button_text(languageCode)
	Options.updateFontSizes()
	emit_signal("quit")

func set_keeper_language_flag(code):
	match code:
		"ar_SA":
			return flag_ar
		"bg_BG":
			return flag_bg
		"cs_CZ":
			return flag_cs
		"da_DK":
			return flag_dk
		"de_DE":
			return flag_de
		"en_US":
			return flag_en
		"es_ES":
			return flag_es
		"es_AR":
			return flag_es_LAT
		"fi_FI":
			return flag_fi
		"fr_FR":
			return flag_fr
		"he_IL":
			return flag_he
		"hu_HU":
			return flag_hu
		"id_ID":
			return flag_id
		"it_IT":
			return flag_it
		"ja_JP":
			return flag_ja
		"ko_KR":
			return flag_ko
		"nl_NL":
			return flag_nl
		"nb_NO":
			return flag_no
		"pl_PL":
			return flag_pl
		"pt_BR":
			return flag_pt_BR
		"pt_PT":
			return flag_pt_PT
		"ro_RO":
			return flag_ro
		"ru_RU":
			return flag_ru
		"sv_SE":
			return flag_sv
		"th_TH":
			return flag_th
		"tr_TR":
			return flag_tr
		"uk_UA":
			return flag_uk
		"vi_VN":
			return flag_vi
		"zh_CN":
			return flag_zh
		"zh_TW":
			return flag_zh_TW
	return code

func _on_CrowdinButton_pressed():
	OS.shell_open("https://crowdin.com/project/dome-keeper")

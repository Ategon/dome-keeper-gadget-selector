extends PanelContainer

signal selected

export (bool) var selectable: = true

var id:String
var disabled: = false
var titleText:String

func _ready():
	Style.init(self)

func init(id:String, unlockable:bool = true, isPet: = false, isSkin: = false, isGizmo = false):
	self.id = id
	# GSM
	var iconRect = find_node("IconRect")
	
	if isGizmo and iconRect.is_in_group("unstyled"):
		iconRect.remove_from_group("unstyled")
	elif not isGizmo and not iconRect.is_in_group("unstyled"):
		iconRect.add_to_group("unstyled")
	# End GSM
	
	if isSkin:
		find_node("IconRect").texture = load("res://content/icons/loadout_" + GameWorld.loadoutStageConfig.keeperId + "-" + id + ".png")
	# GSM
	elif isGizmo:
		find_node("IconRect").texture = load("res://content/icons/" + id + ".png")
	# End GSM
	else :
		find_node("IconRect").texture = load("res://content/icons/loadout_" + id + ".png")
	
	if isPet or isSkin:
		find_node("DescriptionLabel").visible = false
		find_node("TitleLabel").visible = false
	else :
		titleText = tr("upgrades." + id + ".title")
		find_node("TitleLabel").text = titleText
		
		if not unlockable:
			find_node("DescriptionLabel").bbcode_text = tr("loadout.choices.comingsoon")
		elif disabled:
			find_node("DescriptionLabel").bbcode_text = tr("loadout.choices.locked")
		else :
			find_node("DescriptionLabel").bbcode_text = tr("upgrades." + id + ".desc")
	
	if disabled:
		set("custom_styles/panel", preload("res://gui/buttons/button_disabled.tres"))
	
	$SelectedPanel.visible = false
	
func _on_LoadoutOption_focus_entered():
	if not selectable:
		return 
	$SelectedPanel.visible = true

func _on_LoadoutOption_focus_exited():
	if not selectable:
		return 
	$SelectedPanel.visible = false

func _on_LoadoutOption_gui_input(event):
	if not selectable:
		return 
	if event is InputEventMouseButton and event.pressed and event.button_index == BUTTON_LEFT:
		emit_signal("selected")

func _on_LoadoutOption_mouse_entered():
	if not selectable:
		return 
	$SelectedPanel.visible = false
	find_node("TitleLabel").set("custom_colors/font_color", Style.LIVE_BRIGHT)
	if not disabled:
		set("custom_styles/panel", preload("res://gui/buttons/button_hover.tres"))

func _on_LoadoutOption_mouse_exited():
	if not selectable:
		return 
	find_node("TitleLabel").set("custom_colors/font_color", null)
	modulate = Color.white
	if not has_focus():
		if disabled:
			set("custom_styles/panel", preload("res://gui/buttons/button_disabled.tres"))
		else :
			set("custom_styles/panel", preload("res://gui/buttons/button_normal.tres"))

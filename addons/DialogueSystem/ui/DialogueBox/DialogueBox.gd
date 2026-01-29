extends Control

class_name DialogueBox

@onready var label_character = $Panel/LabelCharacter
@onready var label_text = $Panel/LabelText
@onready var continue_btn = $ButtonContinue

var on_continue: Callable

func _ready():
	hide()
	continue_btn.pressed.connect(_pressed)

func display(text, character, color, font):
	label_text.text = text
	label_character.modulate = Color(color)
	label_character.text = character
	show()

func _pressed():
	hide()
	if on_continue:
		on_continue.call()

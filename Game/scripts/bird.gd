class_name Bird
extends Node

var mAudio : AudioStreamPlayer
var mSprite : Sprite2D

func _init(iName, iAudio, iSprite):
	self.name = name
	self.mAudio = iAudio
	self.mSprite = iSprite
	return

func vocalize():
	mAudio.play(0)

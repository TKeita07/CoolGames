extends Node


enum Adjacent {	UP, DOWN, RIGHT, LEFT }

enum RoomType {	CLASSIC, CORNER, PlUS, Plus_inv, H, H_inv }

var RoomScenDict = {
	RoomType.CLASSIC : "res://Level/Map/room_1.tscn",
	RoomType.CORNER: "res://Level/Map/room_2.tscn",
	RoomType.PlUS: "res://Level/Map/room_3.tscn",
	RoomType.Plus_inv: "res://Level/Map/room_4.tscn",
	RoomType.H: "res://Level/Map/room_5.tscn",
	RoomType.H_inv: "res://Level/Map/room_6.tscn"
}

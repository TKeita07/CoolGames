extends Node


enum Adjacent {	UP = 0, DOWN = 1, RIGHT = 2, LEFT = 3 }

enum RoomType {	CLASSIC = 0, CORNER = 1, LINE = 2 }

var RoomScenDict = {
	RoomType.CLASSIC : "res://Level/Map/room_1.tscn",
	RoomType.CORNER: "res://Level/Map/room_2.tscn",
	RoomType.LINE: "res://Level/Map/room_3.tscn"
}

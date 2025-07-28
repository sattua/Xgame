const ROUTES = {
	"route_1": [
		{"line1": "rock", "line2": "trunk", "line3": ""},
		{"line1": "", "line2": "trunk", "line3": ""},
		{"line1": "", "line2": "trunk", "line3": "rock"},
		{"line1": "rock", "line2": "trunk", "line3": ""},
		{"line1": "", "line2": "", "line3": ""},
		{"line1": "", "line2": "trunk", "line3": ""},
		{"line1": "rock", "line2": "trunk", "line3": ""},
		{"line1": "", "line2": "rock", "line3": ""},
		{"line1": "rock", "line2": "trunk", "line3": ""}
	],
	"route_2": [
		{"line1": "rock", "line2": "trunk", "line3": ""},
		{"line1": "rock", "line2": "trunk", "line3": ""},
		{"line1": "", "line2": "trunk", "line3": "rock"},
		{"line1": "rock", "line2": "trunk", "line3": ""},
		{"line1": "trunk", "line2": "", "line3": ""},
		{"line1": "", "line2": "trunk", "line3": ""},
		{"line1": "rock", "line2": "trunk", "line3": ""},
		{"line1": "trunk", "line2": "", "line3": ""},
		{"line1": "", "line2": "trunk", "line3": ""}
	]
}
const BOSS_ROUTES = {
	"boss_1": [
		{"line1":true, "line2":false, "line3":true},
		{"line1":false, "line2":true, "line3":false},
		{"line1":true, "line2":true, "line3":false},
		{"line1":true, "line2":true, "line3":true},
		{"line1":true, "line2":false, "line3":true},
		{"line1":false, "line2":true, "line3":false},
		{"line1":true, "line2":true, "line3":false}
		# Each row = which lanes the boss should shoot at in that frame
	],
	"boss_2": [
		{"line1":true, "line2":false, "line3":true},
		{"line1":false, "line2":true, "line3":false},
		{"line1":true, "line2":true, "line3":false},
		{"line1":true, "line2":true, "line3":true},
		{"line1":true, "line2":false, "line3":true},
		{"line1":false, "line2":true, "line3":false},
		{"line1":true, "line2":true, "line3":false},
		{"line1":true, "line2":true, "line3":false},
		{"line1":false, "line2":true, "line3":false},
		{"line1":true, "line2":false, "line3":true},
		{"line1":true, "line2":true, "line3":false},
		{"line1":true, "line2":true, "line3":true}
		# Each row = which lanes the boss should shoot at in that frame
	]
}

# Websocket communication protocol for ISK
ISK uses websockets to communicate between the server and various clients. This is used to update the html views for users and the presentation data on displays.

## Endpoints
There are two kinds of websocket endpoints, one for the interface between the server and slideshow displays and another for users.

### Display interface
The display interface is located at url /displays/:id/websocket where :id is the numeric id of the display. This connection will send updated display serializations as needed, receives updates from the display and handles the communication between the display remote control view and the display.

#### Message format
TBD, probably just the display serialization as is?

#### Commands
Commands are sent with a json serialized message in the following format
```JSON
[
	"command",
	{"arg_1":1}
]
```
The command-string is the name of the command and the hash contains the command specific parameters.

Results are returned in the same format with the hash containing the command specific results.

The supported commands are
* get_data, replies with the display serialization, no arguments
* goto_slide, instructs the display to change to a certain slide
* current_slide, display tells what slide it is currently showing
* slide_shown, display tells that a slide has been shown (for updating the override queue mostly) 
* shutdown, display tells that it is performing a requested shutdown
* error, display informs the server that a error has occured
* start, display tells the server that it is starting

### General notification interface
The second websocket endpoint is at /websocket/general and it is used for updating all html views for users when the various objects are updated.

#### Message format
The messages are json serialized arrays. Their content is as follows:

```JSON
[
	"object",
	12,
	{"key":1}
]
```

Where first element "object" is the class of object that this message is about and it is one of the following:
* display
* display_state
* group
* master_group
* override_queue
* presentation
* slide
* ticket

The next element is the numeric id of the object. Last field is a list of the changed attributes and their new values as a hash.